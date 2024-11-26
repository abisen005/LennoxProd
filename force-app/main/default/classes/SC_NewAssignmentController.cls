public class SC_NewAssignmentController {

    @AuraEnabled
    public static Object createAssignments(SC_Assignment__c assignment, String[] userIds) {
        return CoachingUtils.createAssignments(assignment, userIds);
    }

}