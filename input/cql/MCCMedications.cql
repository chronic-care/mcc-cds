library MCCMedications version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

// View summary tuple for each MedicationRequest data element
define "Display Medication Summary": {
    ACEi: DE.DisplayNames("ACEis and ARBs"),
    ESA: DE.DisplayNames("Erythropoiesis Stimulating Agent"),
    Iron: DE.DisplayNames("Iron Supplement"),
    PhosBinders: DE.DisplayNames("Phosphate Binders"),
    VitaminD: DE.DisplayNames("Vitamin D")
}

// FHIR MedicationRequest resources with active status.

define "ACEis and ARBs":
  DE.SelectActiveMedications([MedicationRequest: Cx."ACEis and ARBs"])

define "Erythropoiesis Stimulating Agent":
  DE.SelectActiveMedications([MedicationRequest: Cx."Erythropoiesis Stimulating Agent"])

define "Iron Supplement":
  DE.SelectActiveMedications([MedicationRequest: Cx."Iron Supplement"])

define "Phosphate Binders":
  DE.SelectActiveMedications([MedicationRequest: Cx."Phosphate Binders"])

define "Vitamin D":
  DE.SelectActiveMedications([MedicationRequest: Cx."Vitamin D"])
