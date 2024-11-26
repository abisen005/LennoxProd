public class SC_AssessmentDetailController {

    @AuraEnabled
    public static Object getAssessmentDetails(String assessmentId) {
        return CoachingUtils.getAssessmentDetails(assessmentId);
    }

}