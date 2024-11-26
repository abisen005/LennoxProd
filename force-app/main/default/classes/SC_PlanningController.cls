public class SC_PlanningController {


    @AuraEnabled
    public static User getUser(String userId) {
        if(userId.length() == 0) userId = UserInfo.getUserId();
        User u = [SELECT Id, Name FROM User WHERE Id = :userId LIMIT 1];
        return u;
    }

    @AuraEnabled
    public static Object newPlanning(String userId, Integer year) {
        if(userId.length() == 0) userId = UserInfo.getUserId();
        System.debug('year' + year);
        return CoachingUtils.newPlanning(userId, year);
    }

    @AuraEnabled
    public static Object getPlanningHistory(String userId) {
        return CoachingUtils.getPlanningHistory(userId);
    }



    @AuraEnabled
    public static Object getPlanning(String userId, String planningId) {
        return CoachingUtils.getPlanning(userId, planningId);
    }


}