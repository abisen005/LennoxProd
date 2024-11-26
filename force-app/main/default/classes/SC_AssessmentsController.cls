public with sharing class SC_AssessmentsController {

    @AuraEnabled
    public static Object getAssessments(String userId, String initId, String sessionId, Integer queryLimit, Integer offset) {
        return CoachingUtils.getAssessments(userId, initId, sessionId, queryLimit, offset);
    }

}