trigger CoachingRoleTrigger on SC_Coaching_Role__c (
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete) {

		if (Trigger.isBefore) {

			if(Trigger.isUpdate) {
				CoachingRoleTriggerHandler.beforeupdate(Trigger.oldMap, Trigger.new);
			}

		} else if (Trigger.isAfter) {



		}
}