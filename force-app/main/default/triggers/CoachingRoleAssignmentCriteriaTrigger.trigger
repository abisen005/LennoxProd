trigger CoachingRoleAssignmentCriteriaTrigger on SC_Coaching_Role_Assignment_Criterion__c (
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

				CoachingRoleAssignmentCriteriaTrgHandler.afterinsert(Trigger.new);

			} else if(Trigger.isUpdate) {

				CoachingRoleAssignmentCriteriaTrgHandler.afterupdate(Trigger.new);

			} else if(Trigger.isDelete) {

				CoachingRoleAssignmentCriteriaTrgHandler.afterdelete(Trigger.old);

			}

		}
}