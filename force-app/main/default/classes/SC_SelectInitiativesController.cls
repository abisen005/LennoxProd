public class SC_SelectInitiativesController {

    @AuraEnabled
    public static List<SC_Initiative__c> getInitiatives(String type, Id parentId) {
        return CoachingUtils.getInitiatives(type, parentId);
    }

}