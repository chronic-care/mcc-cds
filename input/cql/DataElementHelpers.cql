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

 // Returns a list of display names for these resources, for simple reporting.
define function DisplayNames(resources List<FHIR.Resource>):
  resources R
    return DisplayName(R)

 // Returns a plain text display name for this FHIR resource.
define function DisplayName(resource Resource):
  Coalesce(
    ConceptText((resource as Condition).code),
    ConceptText((resource as Goal).description),
    ConceptText((resource as MedicationRequest).medication as CodeableConcept),
    ConceptText((resource as Observation).code)
  )

define function ReportConditions(conditions List<Condition>, category String):
  conditions C
    return ReportCondition(C, category)
  

define function ReportCondition(condition Condition, category String):
  {
    Category: category,
    ConceptName: ConceptText(condition.code),
    OnsetDate: ToString(FindOnsetDate(condition)),
    RecordedDate: ToString(condition.recordedDate)
  }

define function ReportMedications(medRequests List<MedicationRequest>, category String):
  medRequests M
    return ReportMedication(M, category)

define function ReportMedication(medReq MedicationRequest, category String):
  {
    // TODO: support Medication reference
    Category: category,
    ConceptName: ConceptText(medReq.medication as CodeableConcept)
  }

define function ReportMostRecentResult(observations List<Observation>, displayName String):
  ReportObservation(MostRecent(observations), displayName)

define function SelectActiveConditions(conditions List<Condition>):
  conditions Cond
    where (Cond.clinicalStatus ~ FC."active"
          or Cond.clinicalStatus ~ FC."relapse"
          or Cond.clinicalStatus ~ FC."recurrence")
      and Cond.verificationStatus ~ FC."confirmed"

define function SelectByStatus(observations List<Observation>):
  observations Obs
	where Obs.status in {'final', 'amended', 'corrected', 'preliminary'}
		and Obs.value is not null
    sort by issued

define function SelectActiveMedications(medRequests List<MedicationRequest>):
  medRequests MedReq
    where MedReq.status in {'active'}

define function MostRecent(observations List<Observation>):
  First(
    observations O
      sort by issued
  )

define function MostRecentProcedures(procedures List<Procedure>):
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

/*
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
*/

define function ReportObservation(o FHIR.Observation, displayName String):
  if (o is null or o.value is null or o.value.value is null) then null
  else
    {
      DisplayName: displayName,                                   // patient-friendly display name
      ConceptName:   ConceptText(o.code),                         // display nanme from code
      Date:   ToString(FindDate(o)),
      ResultText: QuantityText(o.value as FHIR.Quantity),         // result value with units
      ResultValue: System.Quantity { value: (o.value as FHIR.Quantity).value}.value,
      ResultUnits: (o.value as FHIR.Quantity).unit.value,
      ReferenceRange: ReferenceRange(o),
      Interpretation: Interpretation(o),
      Flag: ReferenceRangeFlag(o)   // true if value out of range, else false
    }

define function ReferenceRange(o FHIR.Observation):
  if (o is null or o.referenceRange is null) then null
  else
    Coalesce(First(o.referenceRange.text),
      ToString(ReferenceRangeLow(o)) + ' - ' + ToString(ReferenceRangeHigh(o))
    )

define function ReferenceRangeLow(o FHIR.Observation):
  First(o.referenceRange).low.value

define function ReferenceRangeHigh(o FHIR.Observation):
  First(o.referenceRange).high.value

define function ReferenceRangeFlag(o FHIR.Observation):
  if (o.value.value < ReferenceRangeLow(o)
      or o.value.value > ReferenceRangeHigh(o)) then true
  else false

define function Interpretation(o FHIR.Observation):
  if (o.interpretation is not null) then
    Coalesce(First(o.interpretation.text), First(First(o.interpretation).coding.display))
  else if o.referenceRange is not null then
    // Derive interpretation from the reference range, return null if within normal range.
    if o.value.value < ReferenceRangeLow(o) then 'L'
    else if o.value.value > ReferenceRangeHigh(o) then 'H'
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

define function FindOnsetDate(Cond Condition):
  Coalesce(
    (Cond.onset as FHIR.dateTime).value,
    (Cond.onset as FHIR.Period)."end".value,
    (Cond.onset as FHIR.Period)."start".value
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
