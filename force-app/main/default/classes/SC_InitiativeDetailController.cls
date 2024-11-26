public class SC_InitiativeDetailController {

    @AuraEnabled
    public static SC_Initiative__c getInitiative(String initiativeId) {
        return CoachingUtils.getInitiative(initiativeId);
    }

}