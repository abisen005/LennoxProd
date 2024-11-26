trigger TRG_Scorecard on Scorecard__c (before insert, before update) {
    
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            OpportunityScoreCardHandler.onBeforeInsert(Trigger.New);
        }else if(Trigger.isUpdate){
            OpportunityScoreCardHandler.onBeforeUpdate(Trigger.New);
        }
    }
}