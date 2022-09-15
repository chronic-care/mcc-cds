library MCCConditions version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

// View summary tuple for all active conditions
define ConditionSummary:
  flatten {
    ReportCategorizedConditions,
    ReportOtherConditions
  }

define ReportCategorizedConditions:
  flatten {
    ReportArthritisConditions,
    ReportChronicKidneyDiseaseConditions,
    ReportMentalHealthConditions,
    ReportSocialDeterminantsOfHealthConditions
  }

/// Returns a list of Resource.id for all categorized conditions.
define CategorizedConditionIds:
  flatten( ReportCategorizedConditions C
    return { C.id }
  )

/// Returns a list of Conditions that are not classified into CategorizedConditions.
define OtherConditions:
  AllActiveConditions C
    where not (C.id in CategorizedConditionIds)

define ReportOtherConditions:
  DE.ReportConditions(OtherConditions, 'Other Conditions', null, null)

/// All active conditions sorted in descending order by recorded or onset date.
define AllActiveConditions:
  [Condition] C
    sort by Coalesce(recordedDate.value, (onset as FHIR.dateTime).value) descending

//
// Arthritis Conditions
//

define ReportArthritisConditions: 
  flatten {
    DE.ReportConditions("Arthritis Disorders", 'Arthritis', 'Arthritis Disorders', 'Arthritis'),
    DE.ReportConditions("Infectious Arthritis", 'Arthritis', 'Infectious Arthritis', 'Arthritis from Infection'),
    DE.ReportConditions("Osteoarthritis", 'Arthritis', 'Osteoarthritis', 'Osteoarthritis'),
    DE.ReportConditions("Psoriatic Arthritis", 'Arthritis', 'Psoriatic Arthritis', 'Arthritis from Psoriasis'),
    DE.ReportConditions("Reactive Arthritis", 'Arthritis', 'Reactive Arthritis', 'Arthritis due to another condition'),
    DE.ReportConditions("Rheumatoid Arthritis", 'Arthritis', 'Rheumatoid Arthritis', 'Rheumatoid Arthritis')
  }

/// List of Condition resources classified by Arthritis value sets.
define "Arthritis Conditions":
 flatten {
  "Arthritis Disorders",
  "Infectious Arthritis",
  "Osteoarthritis",
  "Psoriatic Arthritis",
  "Reactive Arthritis",
  "Rheumatoid Arthritis"
 }

define "Arthritis Disorders":
  SelectActiveConditions([Condition: Cx."Arthritis Disorders"])

define "Infectious Arthritis":
  SelectActiveConditions([Condition: Cx."Infectious Arthritis"])

define "Osteoarthritis":
  SelectActiveConditions([Condition: Cx."Osteoarthritis"])

define "Psoriatic Arthritis":
  SelectActiveConditions([Condition: Cx."Psoriatic Arthritis"])

define "Reactive Arthritis":
  SelectActiveConditions([Condition: Cx."Reactive Arthritis"])

define "Rheumatoid Arthritis":
  SelectActiveConditions([Condition: Cx."Rheumatoid Arthritis"])

//
// Chronic Kidney Disease Conditions
//

define ReportChronicKidneyDiseaseConditions: 
  flatten {
    DE.ReportConditions("Acute Renal Failure", 'Chronic Kidney Disease', 'Acute Renal Failure', 'Kidney Attack'),
    DE.ReportConditions("Chronic Kidney Disease All Stages", 'Chronic Kidney Disease', 'Chronic Kidney Disease All Stages', 'Kidney Problem Severity'),
    DE.ReportConditions("Chronic Kidney Disease Type or Cause", 'Chronic Kidney Disease', 'Chronic Kidney Disease Type or Cause', 'Kidney Disease Type')
  }

define "Acute Renal Failure":
  SelectActiveConditions([Condition: Cx."Acute Renal Failure"])

define "Chronic Kidney Disease All Stages":
  SelectActiveConditions([Condition: Cx."Chronic Kidney Disease All Stages"])

define "Chronic Kidney Disease Type or Cause":
  SelectActiveConditions([Condition: Cx."Chronic Kidney Disease Type or Cause"])

//
// Cognitive and Neurological Conditions
//


//
// Diabetes Conditions
//


//
// Digestive System/Gastrointestinal Conditions
//


//
// Dissimilar Conditions
//


//
// Mental Health Conditions
//

define ReportMentalHealthConditions: 
  flatten {
    DE.ReportConditions("Anxiety", 'Mental Health', 'Anxiety', 'Anxiety'),
    DE.ReportConditions("Bipolar Diagnosis", 'Mental Health', 'Bipolar Diagnosis', 'Bipolar'),
    DE.ReportConditions("Depression Diagnosis", 'Mental Health', 'Depression Diagnosis', 'Depression'),
    DE.ReportConditions("Dysthymia", 'Mental Health', 'Dysthymia', 'Depression'),
    DE.ReportConditions("Experience of Traumatic Events", 'Mental Health', 'Experience of Traumatic Events', 'History of Trauma'),
    DE.ReportConditions("Grief or Loss", 'Mental Health', 'Grief or Loss', 'Grief'),
    DE.ReportConditions("Major Depression", 'Mental Health', 'Major Depression', 'Depression'),
    DE.ReportConditions("Post Partum Depression", 'Mental Health', 'Post Partum Depression', 'Depression after Pregnancy'),
    DE.ReportConditions("PostTraumatic Stress Disorder PTSD", 'Mental Health', 'PostTraumatic Stress Disorder PTSD', 'PTSD'),
    DE.ReportConditions("Psychological Trauma", 'Mental Health', 'Psychological Trauma', 'Trauma'),
    DE.ReportConditions("Psychotic Depression", 'Mental Health', 'Psychotic Depression', 'Depression with Confusion'),
    DE.ReportConditions("Seasonal Affective Disorder", 'Mental Health', 'Seasonal Affective Disorder', 'Winter Depression'),
    DE.ReportConditions("Suicide Risk", 'Mental Health', 'Suicide Risk', 'Risk of Suicide')
  }

define "Anxiety":
  SelectActiveConditions([Condition: Cx."Anxiety"])

define "Bipolar Diagnosis":
  SelectActiveConditions([Condition: Cx."Bipolar Diagnosis"])

define "Depression Diagnosis":
  SelectActiveConditions([Condition: Cx."Depression Diagnosis"])

define "Dysthymia":
  SelectActiveConditions([Condition: Cx."Dysthymia"])

define "Experience of Traumatic Events":
  SelectActiveConditions([Condition: Cx."Experience of Traumatic Events"])

define "Grief or Loss":
  SelectActiveConditions([Condition: Cx."Grief or Loss"])

define "Major Depression":
  SelectActiveConditions([Condition: Cx."Major Depression"])

define "Post Partum Depression":
  SelectActiveConditions([Condition: Cx."Post Partum Depression"])

define "PostTraumatic Stress Disorder PTSD":
  SelectActiveConditions([Condition: Cx."PostTraumatic Stress Disorder PTSD"])

define "Psychological Trauma":
  SelectActiveConditions([Condition: Cx."Psychological Trauma"])

define "Psychotic Depression":
  SelectActiveConditions([Condition: Cx."Psychotic Depression"])

define "Seasonal Affective Disorder":
  SelectActiveConditions([Condition: Cx."Seasonal Affective Disorder"])

define "Suicide Risk":
  SelectActiveConditions([Condition: Cx."Suicide Risk"])

//
// Social Determinants of Health Conditions
//

define ReportSocialDeterminantsOfHealthConditions: 
  DE.ReportConditions("Social Determinants of Health", 'Social Determinants of Health', 'Social Determinants of Health', 'Life(style) Problems')

define "Social Determinants of Health":
  SelectActiveConditions([Condition: Cx."Social Determinants of Health"])



// define "":
//   SelectActiveConditions([Condition: Cx.""])

// we currently select only 'active' conditions in the server query
define function SelectActiveConditions(conditions List<Condition>):
  conditions C
    sort by Coalesce(recordedDate.value, (onset as FHIR.dateTime).value) descending

// BUG: this works in VSCode but returns null in JavaScript execution.
// define function SelectActiveConditions(conditions List<Condition>):
//   conditions Cond
//     where (Cond.clinicalStatus ~ FC."active"
//           or Cond.clinicalStatus ~ FC."relapse"
//           or Cond.clinicalStatus ~ FC."recurrence")
//       and Cond.verificationStatus ~ FC."confirmed"
//     sort by recordedDate.value descending
