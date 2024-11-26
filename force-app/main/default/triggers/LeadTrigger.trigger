/*
* @ Purpose      : Lead Trigger     
* @ CreatedDate  : 10-10-2019
*/
trigger LeadTrigger on Lead ( after insert, after update, before insert, before update)
{
    
    
    LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size, trigger.New, null);
    
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            LeadTriggerHandler.OnBeforeInsert(trigger.New);
        }
        else
        {
            LeadTriggerHandler.OnAfterInsert(trigger.New);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
       {
            LeadTriggerHandler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        else
        {
            LeadTriggerHandler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
}