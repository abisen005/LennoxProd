public class SC_NewCoachingSessionController {

    @AuraEnabled
    public static SC_Coaching_Session__c createCoachingSession(String evt, String skills, String init, Boolean createAssessments) {
        return CoachingUtils.createCoachingSession(evt, skills, init, createAssessments);
    }



    @AuraEnabled
    public static SC_Initiative__c getInitReports(String initId) {
        return CoachingUtils.getInitiative(initId);
    }



    @AuraEnabled
    public static Object createAssessments(String skillsJSON, String sessionId) {
        return CoachingUtils.createAssessments(skillsJSON, sessionId);
    }

}