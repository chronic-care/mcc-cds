library MCCGoals version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include DataElementHelpers called DE
include MCCConcepts called Cx

context Patient

define "Report Conditions with Goals":
  [Condition] condition
    let goals: HasGoals(condition)
    where exists(goals) return {
        Condition: DE.ConceptText(condition.code),
        HasGoals: ReportGoals(goals)
    }

define "Conditions without Goals":
  [Condition] condition
    where not exists HasGoals(condition)

define "Report Conditions with Evidence":
  null

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

define function DueDate(goal Goal):
  First(goal.target target
    // TODO if due is Duration, add that quantity to startDate
    let due: (target.due as FHIR.date).value
    where due is not null
      return due
  )

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
