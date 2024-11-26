public class CoachingRoleTriggerHandler {

    public static void beforeupdate(Map<Id, SC_Coaching_Role__c> oldCoachingRolesMap, List<SC_Coaching_Role__c> coachingRoles) {

        List<SC_Coaching_Role__c> updateUsersCoachingRoles = new List<SC_Coaching_Role__c>();

        for(SC_Coaching_Role__c coachingRole :coachingRoles) {
            SC_Coaching_Role__c oldCoachingRole = oldCoachingRolesMap.get(coachingRole.Id);
            if(oldCoachingRole.Generated_SOQL__c != coachingRole.Generated_SOQL__c) {
                updateUsersCoachingRoles.add(coachingRole);
            }

        }
        CoachingUtils.updateCoachingRoleUsers(updateUsersCoachingRoles);

    }

}