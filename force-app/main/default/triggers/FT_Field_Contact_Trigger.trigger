trigger FT_Field_Contact_Trigger on Field_Trial_Contacts__c (after update) {
    if(Trigger.isAfter){
        /*if(Trigger.isInsert){
            Field_Trial_Contact_Trigger_Handler.onAfterInsert(trigger.new);
          }*/
        
        if(Trigger.isUpdate){
            FT_Field_Contact_Trigger_Handler.handleAfterUpdate(trigger.newMap, Trigger.oldMap);
        }
    }
}