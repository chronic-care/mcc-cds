library MCCConditions version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

// View summary tuple for each condition data element
define "Display Conditions Summary": 
  flatten {
    DE.ReportConditions("Anxiety Conditions", 'Anxiety'),
    DE.ReportConditions("Chronic Kidney Disease Conditions", 'Chronic Kidney Disease'),
    DE.ReportConditions("Hypertension Conditions", 'Hypertension'),
    DE.ReportConditions("Social Determinants of Health Conditions", 'Social Needs and Risks')
  }

// FHIR Condition resources for active|recurrence|relapse, confirmed conditions.

define "Anxiety Conditions":
  DE.SelectActiveConditions([Condition: Cx."Anxiety Conditions"])

define "Chronic Kidney Disease Conditions":
  DE.SelectActiveConditions([Condition: Cx."Chronic Kidney Disease Type or Cause"])

define "Hypertension Conditions":
  DE.SelectActiveConditions([Condition: Cx."Hypertension Conditions"])

// Could use Condition.category for SDOH, but using code valueset for consistency with other MCC conditions.
define "Social Determinants of Health Conditions":
  DE.SelectActiveConditions([Condition: Cx."Social Determinants of Health Conditions"])
