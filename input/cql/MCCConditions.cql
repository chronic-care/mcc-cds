library MCCConditions version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

// View summary tuple for each condition data element
define ConditionSummary:
  DE.ReportConditions(
    SelectActiveConditions([Condition]), 'Active Conditions'
  )

// we currently select only 'active' conditions in the server query
define function SelectActiveConditions(conditions List<Condition>):
  [Condition] C
    sort by Coalesce(recordedDate.value, (onset as FHIR.dateTime).value) descending

// BUG: this works in VSCode but returns null in JavaScript execution.
// define function SelectActiveConditions(conditions List<Condition>):
//   conditions Cond
//     where (Cond.clinicalStatus ~ FC."active"
//           or Cond.clinicalStatus ~ FC."relapse"
//           or Cond.clinicalStatus ~ FC."recurrence")
//       and Cond.verificationStatus ~ FC."confirmed"
//     sort by recordedDate.value descending

define MCCConditionSummary: 
  flatten {
    DE.ReportConditions("Anxiety Conditions", 'Anxiety'),
    DE.ReportConditions("Chronic Kidney Disease Conditions", 'Chronic Kidney Disease'),
    DE.ReportConditions("Hypertension Conditions", 'Hypertension'),
    DE.ReportConditions("Social Determinants of Health Conditions", 'Social Needs and Risks')
  }

// FHIR Condition resources for active|recurrence|relapse, confirmed conditions.

define "Anxiety Conditions":
  SelectActiveConditions([Condition: Cx."Anxiety Conditions"])

define "Chronic Kidney Disease Conditions":
  SelectActiveConditions([Condition: Cx."Chronic Kidney Disease Type or Cause"])

define "Hypertension Conditions":
  SelectActiveConditions([Condition: Cx."Hypertension Conditions"])

// Could use Condition.category for SDOH, but using code valueset for consistency with other MCC conditions.
define "Social Determinants of Health Conditions":
  SelectActiveConditions([Condition: Cx."Social Determinants of Health Conditions"])
