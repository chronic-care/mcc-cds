library MCCGoals version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

define "Conditions with Goals":
  [Condition] condition
    where exists HasGoals(condition)

define "Conditions without Goals":
  [Condition] condition
    where not exists HasGoals(condition)

define "Conditions with Evidence":
  [Condition] condition
    where exists HasEvidence(condition)

define "Display Conditions without Goals":
  DE.DisplayNames("Conditions without Goals")

define "Display Conditions with Goals":
  [Condition] condition
    let goals: HasGoals(condition),
        evidence: HasEvidence(condition)
    where exists(goals) return {
        Condition: DE.DisplayName(condition),
        HasEvidence: DE.DisplayNames(evidence),
        HasGoals: DE.DisplayNames(goals)
    }

// define "Report Conditions with Goals":
//   [Condition] condition
//     let goals: HasGoals(condition),
//         evidence: HasEvidence(condition)
//     where exists(goals) return {
//         Condition: DE.ConceptText(condition.code),
//         HasEvidence: DE.DisplayNames(evidence),
//         HasGoals: ReportGoals(goals)
//     }

// Returns a list of Conditions that this Goal addresses
define function AddressesConditions(goal Goal):
  goal.addresses GA
    return ([Condition] C where C.id = DE.GetId(GA.reference))

// Returns a list of Observations that this Goal addresses
define function AddressesObservations(goal Goal):
  goal.addresses GA
    return ([Observation] C where C.id = DE.GetId(GA.reference))

// Returns a list of Goals that address this Condition
define function HasGoals(condition Condition):
  [Goal] goal
    where exists(goal.addresses GA
      where condition.id = DE.GetId(GA.reference))

// Returns a list of resources that provide evidence for this Condition.
// TODO: expand to support CodeableConcept as evidence.
define function HasEvidence(condition Condition):
  flatten( condition.evidence.detail E
    return 
        [Observation]res where res.id = DE.GetId(E.reference)
        // TODO: can't pass this result to DE.DisplayNames()
        // ([FamilyMemberHistory] res where res.id = DE.GetId(E.reference))
        // union ([Observation]res where res.id = DE.GetId(E.reference))
        // union ([Procedure]res where res.id = DE.GetId(E.reference))
  )

// Returns Date from the first Goal target that has a due date.
define function DueDate(goal Goal):
  First(goal.target target
    // TODO if due is Duration, add that quantity to startDate
    let due: (target.due as FHIR.date).value
    where due is not null
      return due
  )

/*
 * Helper functions for reporting and display.
 */

define function ReportGoals(goals List<Goal>):
  goals goal
  return {
    ReportGoal(goal)
  }

define function ReportGoal(goal Goal):
  {
    Description: DE.ConceptText(goal.description),
    StartDate: ToString(goal.start as FHIR.date),
    DueDate: ToString(DueDate(goal))
  }
