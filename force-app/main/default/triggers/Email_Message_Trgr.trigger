trigger Email_Message_Trgr on Email_Message__c (after insert, after update) {
    if(Trigger.isAfter){  
        if(Trigger.isUpdate){
            Email_Message_TrgrHandler.sendApprovedEmailMessages(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isInsert){
            Email_Message_TrgrHandler.sendApprovedEmailMessages(Trigger.newMap, null);
        }
    }
}