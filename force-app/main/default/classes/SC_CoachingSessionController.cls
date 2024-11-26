public class SC_CoachingSessionController {

    @AuraEnabled
    public static SC_Coaching_Session__c getCoachingSession(String sessionId) {
        return CoachingUtils.getCoachingSession(sessionId);
    }



    @AuraEnabled
    public static List<SC_Initiative_Question__c> getInitiativeQuestions(String initiativeId, Boolean isCoach, Boolean isCoachee) {
        return CoachingUtils.getInitiativeQuestions(initiativeId, isCoach, isCoachee);
    }


 
    @AuraEnabled
    public static Object updateCoachingSession(SC_Coaching_Session__c session, Boolean IsReschedule) {
        return CoachingUtils.updateCoachingSession(session, IsReschedule);
    }



    @AuraEnabled
    public static Object deleteCoachingSession(String sessionId, String sessionStartDate) {
        return CoachingUtils.deleteCoachingSession(sessionId, sessionStartDate);
    }



    @AuraEnabled
    public static Object checkIfAttendeeAccepted(String sessionId, String userId) {
        return CoachingUtils.checkIfAttendeeAccepted(sessionId, userId);
    }



    @AuraEnabled
    public static Object respondToInvite(Boolean isAccepted, String relationId, String sessionId) {
        return CoachingUtils.respondToInvite(isAccepted, relationId, sessionId);
    }
    
    @AuraEnabled
    public Static Object updateAttendeeStatus(string status, string sessionId, string userId, Boolean isUpdateAll){
        return CoachingUtils.updateAttendeeStatus(status, sessionId, userId, isUpdateAll);
    }
        

}