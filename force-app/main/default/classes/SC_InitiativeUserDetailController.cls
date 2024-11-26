public class SC_InitiativeUserDetailController {

    @AuraEnabled
    public static SC_Initiative__c getInitiative(String initiativeId) {
        return CoachingUtils.getInitiative(initiativeId);
    }

    @AuraEnabled
    public static Object getInitiativeSkills(String initiativeId) {
        return CoachingUtils.getInitiativeSkills(initiativeId);
    }

}