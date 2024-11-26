trigger VendavoDealTrigger on Vendavo__Deal__c (before insert, before update) {

    if(Trigger.isBefore) {
        if(trigger.isInsert) {
            VendavoDealTriggerHandler.findRelatedAccountOpportunity(Trigger.new);
        }
        if(trigger.isUpdate) {
            VendavoDealTriggerHandler.findRelatedAccountOpportunity(Trigger.new);
            VendavoDealTriggerHandler.updateAccountOpportunityStatus(Trigger.new, Trigger.oldMap);
        }
    }

}