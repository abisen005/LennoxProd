/*
* @ Purpose      : This trigger is used for Create Event records for Provisioned user.                   
* @ CreatedDate  : 14/06/2019
*/
trigger UserTrigger on User (after insert) {

    if(Trigger.isAfter){
        try{
            if(Trigger.isInsert){
                
                System.debug('In UserTrigger');
                
                Set<Id> userIdSet = new Set<Id>();
                
                for(User u : trigger.New){
                    
                    userIdSet.add(u.Id);
                }
            	UserTriggerHandler.createEvent(userIdSet);
            }
        } 
        catch(Exception ex){
            System.debug('UserTrigger Error '+ ex.getLineNumber() + ' ' +ex.getMessage());
            System.debug('UserTrigger Error '+ ex.getStackTraceString());
        }
        
    }	
}