public with sharing class SC_UserAssignmentsController {

    @AuraEnabled
    public static List<SC_Assignment__c> getAssignments(String[] userIds, String initId, String recordId, Boolean showCompleted, Boolean showAll, Integer queryLimit, Integer offset) {
        List<SC_Assignment__c> result = new List<SC_Assignment__c>();
        if(showAll) {
            result = CoachingUtils.getAssignments(userIds, initId, recordId, true, true, queryLimit, offset);
        } else {
            if(showCompleted) {
                result = CoachingUtils.getCompletedAssignments(userIds, initId, recordId, queryLimit, offset);
            } else {
                result = CoachingUtils.getIncompleteAssignments(userIds, initId, recordId, queryLimit, offset);
            }
        }
        return result;
    }
}