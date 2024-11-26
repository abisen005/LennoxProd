public with sharing class SC_CoachingSessionAttendeeTriggerHandler {

    public static void afterinsert(List<SC_Coaching_Session_Attendee__c> sessionAttendees) {
        CoachingUtils.createCoacheeSessionNotes(sessionAttendees);
        //CoachingUtils.postAttendeeAlertsToSession(sessionAttendees);
    }

}