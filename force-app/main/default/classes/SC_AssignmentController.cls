public class SC_AssignmentController {

    @AuraEnabled
    public static Object getAssignment(String assignmentId) {
        return CoachingUtils.getAssignment(assignmentId);
    }



    @AuraEnabled
    public static Object updateAssignmentProgress(SC_Assignment__c assignment, Boolean increment) {
        return CoachingUtils.updateAssignmentProgress(assignment, increment);
    }



    @AuraEnabled
    public static Object completeAssignment(SC_Assignment__c assignment) {
        return CoachingUtils.completeAssignment(assignment);
    }



    @AuraEnabled
    public static Boolean updateAssignment(SC_Assignment__c assignment) {
        try {
            update assignment;
            return true;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return false;
        }
    }

}