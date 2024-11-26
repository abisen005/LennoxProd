trigger AccountTrigger on Account (after update, before update) {
    
    if(Trigger.isAfter) {
        AccountTriggerHandler.insertCustomerSalesArea(Trigger.new);
        if(trigger.isUpdate){
            AccountTriggerHandler.afterUpdate(trigger.old, trigger.newMap);
        }
    }
    
    if(trigger.isBefore){
        AccountTriggerHandler handler = New AccountTriggerHandler();
        
        if(trigger.isUpdate){
            handler.provisionFTLUser(trigger.old, trigger.newMap);
        }
        
    }
}