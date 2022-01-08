library MCCLabResults version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

// View summary tuple for each lab result data element in CKD minimum data set (MDS)
define "CKD MDS Lab Result Summary": {
  DE.ReportMostRecentLabResult("eGFR Results", 'eGFR'),
  DE.ReportMostRecentLabResult("High Density Lipoprotein Results", 'HDL Cholesterol'),
  DE.ReportMostRecentLabResult("Low Density Lipoprotein Results", 'LDL Cholesterol'),
  DE.ReportMostRecentLabResult("UACR Results", 'Urine Albumin Creatinine Ratio')
}

define "CVD Lab Result Summary": {
  DE.ReportMostRecentLabResult("High Density Lipoprotein Results", 'HDL Cholesterol'),
  DE.ReportMostRecentLabResult("Low Density Lipoprotein Results", 'LDL Cholesterol'),
  DE.ReportMostRecentLabResult("Triglyceride Results", 'Triglycerides')
}

define "Diabetes Lab Result Summary": {
  DE.ReportMostRecentLabResult("Hemoglobin A1C Results", 'Hemoglobin A1c %'),
  DE.ReportMostRecentLabResult("Triglyceride Results", 'Triglycerides')
}

define "Chronic Pain Lab Result Summary": {
  
}

// Most recent FHIR Observation for each lab result data element.
define DiagnosticTests: {
  A1C: DE.MostRecent("Hemoglobin A1C Results"),
  eGFR: DE.MostRecent("eGFR Results"),
  HDL: DE.MostRecent("High Density Lipoprotein Results"),
  LDL: DE.MostRecent("Low Density Lipoprotein Results"),
  UACR: DE.MostRecent("UACR Results")
}

// Lab result FHIR Observations sorted in descending order by issue date.

define "eGFR Results":
  DE.SelectByStatus([Observation: Cx."Estimated Glomerular Filtration Rate"])

define "Hemoglobin A1C Results":
  DE.SelectByStatus([Observation: Cx."Hemoglobin A1C"])

define "High Density Lipoprotein Results":
  DE.SelectByStatus([Observation: Cx."High Density Lipoprotein"])

define "Low Density Lipoprotein Results":
  DE.SelectByStatus([Observation: Cx."Low Density Lipoprotein"])

define "Triglyceride Results":
  DE.SelectByStatus([Observation: Cx."Triglyceride Blood Serum Plasma"])

define "UACR Results":
  DE.SelectByStatus([Observation: Cx."Urine Albumin Creatinine Ratio"])
