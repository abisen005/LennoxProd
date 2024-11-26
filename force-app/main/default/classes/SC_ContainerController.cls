public class SC_ContainerController {
    
    @AuraEnabled
    public static CoachingInfo getCoachingInfo() {
        System.debug('@@@@@@@'+CoachingUtils.getMyCoachingInfo());
        return CoachingUtils.getMyCoachingInfo();
    }

}