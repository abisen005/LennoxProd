trigger biuOasisSalesOwner on Oasis_Sales__c (before insert, before update)
{
     if (Trigger.isBefore) {
        OasisSalesTriggerHandler.handleBeforeInsertBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
}