public with sharing class SC_SkillMasteryController {

    @AuraEnabled
    public static SC_Assessment__c getAssessment(String userId, String initId) {
        return CoachingUtils.getAssessment(userId, initId);
    }
}