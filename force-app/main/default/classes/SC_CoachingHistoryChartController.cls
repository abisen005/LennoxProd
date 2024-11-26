public class SC_CoachingHistoryChartController {

    @AuraEnabled
    public static List<SC_Assessment__c> getAssessments(String userId, String initiativeId) {
        return CoachingUtils.getAssessments(userId, initiativeId);
    }

}