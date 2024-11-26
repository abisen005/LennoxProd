trigger FTLDealerSignupFormTrigger on FTL_Dealer_Signup_Form__c (after insert, after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
         
            FTLDealerSignupFormHandler.afterUpdate(Trigger.New,Trigger.OldMap);
        }
        if(Trigger.isInsert){
            FTLDealerSignupFormHandler.afterInsert(Trigger.New);
        }
    }

}