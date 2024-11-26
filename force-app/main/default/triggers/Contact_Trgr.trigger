/*
* @ Purpose      : Contact Trigger     
* @ CreatedDate  : 03-04-2019
*/
trigger Contact_Trgr on Contact (before insert, before update, after insert, after update) {
        
    
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            Contact_Trgr_Handler.allowNumberOfContact(trigger.new, false, null);
            
            //lead management process            
            //LeadTriggerHandler.OnContactBeforeInsert(trigger.new);   
        }
        else
        {
            
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
       {
            Contact_Trgr_Handler.allowNumberOfContact(trigger.new, true, trigger.OldMap);
            Contact_Trgr_Handler.provisionCommUsers(trigger.old, trigger.newMap); 
            
            //lead management process
            LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size, null, trigger.New);
            LeadTriggerHandler.OnContactBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);           
        }
        else
        {
           
        }
    }

    //Handle refresh of form shares when a contact is added or linked to a new dealer account
    if (trigger.isAfter) {
        if (trigger.isUpdate || trigger.isInsert) {
            set<Id> accountIds = new set<Id>();
            for(contact c : (Contact[]) trigger.new) {
                if (c.AccountId!=null) {
                    if (trigger.isInsert) {
                        accountIds.add(c.AccountId);
                    }
                    else if (trigger.isUpdate) {
                        Contact old = (Contact) trigger.oldMap.get(c.Id);
                        if (old.AccountId!=c.AccountId) {
                            if (old.AccountId!=null){
                                accountIds.add(old.AccountId);
                            }
                            if (c.AccountId!=null) {
                                accountIds.add(c.AccountId);
                            }
                        }
                        else if (old.FTL_Provisioned__c!=c.FTL_Provisioned__c) {
                            accountIds.add(c.AccountId);
                        }
                    }
                }
            }

            if (!accountIds.isEmpty()) {
                AccountTriggerHandler.processFormShares(accountIds);
            }
        }
    }
    
}