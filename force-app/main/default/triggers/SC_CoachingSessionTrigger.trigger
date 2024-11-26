trigger SC_CoachingSessionTrigger on SC_Coaching_Session__c (
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete) {

		if (Trigger.isBefore) {
	    	//call your handler.before method

		} else if (Trigger.isAfter) {

			if(Trigger.isInsert) {

				SC_CoachingSessionTriggerHandler.afterinsert(Trigger.new);

			}

			if(Trigger.isUpdate) {
				SC_CoachingSessionTriggerHandler.afterupdate(Trigger.newMap, Trigger.oldMap);
			}

		}
}