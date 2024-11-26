/*
* @ Purpose          : This trigger is used to Create, Update and Delete Event records.                   
* @ CreatedDate      : 12/06/2019
* @ Last Modified    :Abilash Senthilkumar @VentasConsulting
* @ Last ModifiedDate:03/15/2022
*/
trigger EventTrigger on Event (before insert, before update, before delete) {
    
    
    if(Trigger.isbefore){
        try{
            if(Trigger.isInsert){
                
                if(!EventTriggerHandler.hasExecuted){
                    
                    EventTriggerHandler.hasExecuted = true;
                    EventTriggerHandler.createEvent(trigger.New);
                }
                
            }
            
            if(Trigger.isUpdate){
                
                if(!EventTriggerHandler.hasExecuted){
                    
                    EventTriggerHandler.hasExecuted = true;
                    EventTriggerHandler.updateEvent(trigger.oldMap, trigger.newMap);
                }
                
            }
            
        /*    if(Trigger.isDelete){
                
                if(!EventTriggerHandler.hasExecuted){
                   
                    EventTriggerHandler.hasExecuted = true;
                    EventTriggerHandler.deleteEvent(trigger.old);
                }
                
            }*/
        } 
        catch(Exception ex){
            System.debug('EventTrigger Error '+ ex.getLineNumber() + ' ' +ex.getMessage());
            System.debug('EventTrigger Error '+ ex.getStackTraceString());
        }
        
    }	
}