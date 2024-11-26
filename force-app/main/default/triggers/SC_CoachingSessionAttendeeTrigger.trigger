trigger SC_CoachingSessionAttendeeTrigger on SC_Coaching_Session_Attendee__c (
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

            SC_CoachingSessionAttendeeTriggerHandler.afterinsert(Trigger.new);

        }

    }
}