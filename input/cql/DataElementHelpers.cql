library DataElementHelpers version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon version '4.0.1' called FC

parameter AsOf DateTime default Now()

/*
 * Resource relationships
 */

define function GetId(uri String ):
  Last(Split(uri, '/'))


/*
 * Report summary helpers
 */
define function ReportMostRecentLabResult(observations List<Observation>, displayName String):
  ReportLabObservation(MostRecent(observations), displayName)

define function SelectByStatus(observations List<Observation>):
  observations Obs
	where Obs.status in {'final', 'amended', 'corrected', 'preliminary'}
		and Obs.value is not null
    sort by issued

define function MostRecent(observations List<Observation>):
  First(
    observations O
      sort by issued
  )

define function MostRecent(procedures List<Procedure>):
  First(
    procedures P
      sort by start of FC.ToInterval(performed)
  )

define function IssuedWithin(observations List<Observation>, lookback System.Quantity):
  observations O
    where O.issued on or after day of AsOf - lookback

define function PerformedWithin(procedures List<Procedure>, lookback System.Quantity):
  procedures P
    where end of FC.ToInterval(P.performed) on or after day of AsOf - lookback

define function ReportObservation(o FHIR.Observation, displayName String):
  if (o is null or o.value is null or o.value.value is null) then null
  else
    {   // result decimal value
      Date:   ToString(FindDate(o)),
      ConceptName:   ConceptText(o.code),                         // display nanme from code
      DisplayName: displayName,                                   // patient-friendly display name
      Result: QuantityText(o.value as FHIR.Quantity),             // result value with units
      ResultValue: ToString((o.value as FHIR.Quantity).value)
    }

define function ReportLabObservation(o FHIR.Observation, displayName String):
  if (o is null or o.value is null or o.value.value is null) then null
  else
    {
      Date:   ToString(FindDate(o)),
      ConceptName:   ConceptText(o.code),                         // display nanme from code
      DisplayName: displayName,                                   // patient-friendly display name
      ResultText: QuantityText(o.value as FHIR.Quantity),         // result value with units
      ResultValue: System.Quantity { value: (o.value as FHIR.Quantity).value}.value,
      ResultUnits: (o.value as FHIR.Quantity).unit.value,
      ReferenceRange: LabReferenceRange(o),
      Interpretation: LabInterpretation(o),
      Flag: LabReferenceRangeFlag(o)   // true if value out of range, else false
    }

define function LabReferenceRange(o FHIR.Observation):
  if (o is null or o.referenceRange is null) then null
  else
    Coalesce(First(o.referenceRange.text),
      ToString(LabReferenceRangeLow(o)) + ' - ' + ToString(LabReferenceRangeHigh(o))
    )

define function LabReferenceRangeLow(o FHIR.Observation):
  First(o.referenceRange).low.value

define function LabReferenceRangeHigh(o FHIR.Observation):
  First(o.referenceRange).high.value

define function LabReferenceRangeFlag(o FHIR.Observation):
  if (o.value.value < LabReferenceRangeLow(o)
      or o.value.value > LabReferenceRangeHigh(o)) then true
  else false

define function LabInterpretation(o FHIR.Observation):
  if (o.interpretation is not null) then
    Coalesce(First(o.interpretation.text), First(First(o.interpretation).coding.display))
  else if o.referenceRange is not null then
    // Derive interpretation from the reference range, return null if within normal range.
    if o.value.value < LabReferenceRangeLow(o) then 'L'
    else if o.value.value > LabReferenceRangeHigh(o) then 'H'
    else null
  else
    null

/**
 * Finds the first non-null meaningful date that can be associated with this Observation.  This will look through the
 * following fields in the following order: effectiveDateTime, effectiveInstant, effectivePeriod.end,
 * effectivePeriod.start, issued.
 * @param Obs - an Observation
 * @returns {System.DateTime} the first non-null meaningful date, or null if non is found
 */
define function FindDate(Obs Observation):
  Coalesce(
    (Obs.effective as FHIR.dateTime).value,
    (Obs.effective as FHIR.instant).value,
    (Obs.effective as FHIR.Period)."end".value,
    (Obs.effective as FHIR.Period)."start".value,
    Obs.issued.value
  )

// Returns the first-found display text for a CodeableConcept, looking first at the `text` attribute, then the
// `display` on each `coding` until it finds a non-null value.
// @param c - a FHIR CodeableConcept to get text from
// @returns {System.String} the display text or null if none is found
define function ConceptText(c FHIR.CodeableConcept):
  Coalesce(c.text.value, Coalesce((c.coding) c2 return c2.display.value), Coalesce((c.coding) c3 return c3.code.value))

// Returns a text representation of a Quantity with the Quantity's value and unit.
// If the unit is {score}, then omit it (as it is not useful to display)
// @param q - a FHIR Quantity to get text for
// @returns {System.String} the text representation of the Quantity
define function QuantityText(q FHIR.Quantity):
  if (q is null) then null
  else if (q.unit is not null and q.unit.value != '{score}') then ToString(q.value.value) + ' ' + q.unit.value
  else if (q.code is not null and q.code.value != '{score}') then ToString(q.value.value) + ' ' + q.code.value
  else ToString(q.value.value)
