library MCCConcepts version '1.0.0'

// ## Code Systems ##

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "Race": 'urn:oid:2.16.840.1.113883.6.238'

// ## Value sets ##

// Conditions
valueset "Social Determinants of Health Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1196.788'
valueset "Anxiety Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.52'
valueset "Chronic Kidney Disease Type or Cause": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.6'
valueset "Hypertension Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.9'


// Lab results

valueset "Total Cholesterol": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.139'
valueset "High Density Lipoprotein": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.135'
valueset "Low Density Lipoprotein": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.215'
valueset "Triglyceride Blood Serum Plasma": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.137'
valueset "Hemoglobin A1C": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.119'
valueset "Estimated Glomerular Filtration Rate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.6929.3.1000'
valueset "Serum Albumin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.151'
valueset "Serum Creatinine": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.111'
valueset "Urine Albumin Creatinine Ratio": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.6929.2.1002'


// Medication Requests
valueset "ACEis and ARBs": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1213.11'
valueset "Erythropoiesis Stimulating Agent": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1196.307'
valueset "Iron Supplement": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1196.308'
valueset "Phosphate Binders": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1196.305'
valueset "Vitamin D": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1196.306'


//Iron Supplement

// ## Individual codes ##

// list individual codes from code systems used directly in the CQL logic. Individual codes are used when there is
// a single code from a particular vocabulary standard used to represent a clinical concept. It is considered
// best-practice not to create value sets containing a single code.

code "Black or African American": '2054-5' from "Race" display 'Black or African American'
code "White": '2106-3' from "Race" display 'White'

code "Left (qualifier value)": '7771000' from "SNOMEDCT" display 'Left (qualifier value)'
code "Right (qualifier value)": '24028007' from "SNOMEDCT" display 'Right (qualifier value)'

code "Blood pressure": '85354-9' from "LOINC" display 'Blood pressure systolic and diastolic'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Heart rate": '8867-4' from "LOINC" display 'Heart rate'
code "Oxygen saturation": '2708-6' from "LOINC" display 'Oxygen saturation'
code "Pulse oximetry": '59408-5' from LOINC display 'Oxygen saturation in Arterial blood by Pulse oximetry'
code "Respiratory rate": '9279-1' from "LOINC" display 'Respiratory rate'
code "Body temperature": '8310-5' from "LOINC" display 'Body temperature'
code "Body height": '8302-2' from "LOINC" display 'Body height'
code "Body weight": '29463-7' from "LOINC" display 'Body weight'
code "Body mass index": '39156-5' from "LOINC" display 'Body mass index'
code "Inhaled oxygen flow rate": '3151-8' from "LOINC" display 'Inhaled oxygen flow rate'
