/*
* @ Purpose      : Trigger on FTL_Program_Form__c
* @ CreatedDate  : 03-04-2019
*/
trigger FTL_Program_Form_Trgr on FTL_Program_Form__c (after insert, before insert, after update, before update) {
    FTL_Program_Form_TrgrHandler.processTrigger();
    if(trigger.isInsert && trigger.isBefore){
        FTL_Program_Form_TrgrHandler.updateGeoLocation(trigger.new);
    }
    if(trigger.isUpdate  && trigger.isAfter){
        FTL_Program_Form_TrgrHandler.processAfterUpdateTrigger();
    }
    if( trigger.isInsert && trigger.isAfter){
        FTL_Program_Form_TrgrHandler.processAfterInsertTrigger();
    }
}