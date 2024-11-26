public class CoachingRoleAssignmentCriteriaTrgHandler {
    /**
     *   Enum representing each of before/after CRUD events on Sobjects
     */
    /*public enum Evt
    {
        afterdelete, afterinsert, afterundelete,
        afterupdate, beforedelete, beforeinsert, beforeupdate
    }*/

    public static void afterinsert(List<SC_Coaching_Role_Assignment_Criterion__c> criteria) {

        CoachingUtils.createCoachingRoleQuery(criteria);

    }

    public static void afterupdate(List<SC_Coaching_Role_Assignment_Criterion__c> criteria) {

        CoachingUtils.createCoachingRoleQuery(criteria);

    }

    public static void afterdelete(List<SC_Coaching_Role_Assignment_Criterion__c> criteria) {

        CoachingUtils.createCoachingRoleQuery(criteria);

    }

}