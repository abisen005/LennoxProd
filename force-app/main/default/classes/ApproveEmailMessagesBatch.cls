public class ApproveEmailMessagesBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String mailStatus = 'Sent';
        return Database.getQueryLocator('SELECT Id, inApprovalStep2__c, Rejcted_In_Step_1__c '+
                                        'FROM Email_Message__c '+
                                        'WHERE inApprovalStep2__c = true '+
                                        'AND Rejcted_In_Step_1__c = false');
    }
    
    public void execute(Database.BatchableContext BC, List<Email_Message__c> mailMessages){
        
        Approval.unlock(mailMessages, false);
        Map<Id, Email_Message__c> mailMessagesMap = new Map<Id, Email_Message__c>(mailMessages);
 
        // Fetch process Instances working
        Map<Id, ProcessInstanceWorkitem> emailMessageIdTOWorkInstance = getWorkItemId(mailMessagesMap.keySet());
        
        for(Email_Message__c emailMessage : mailMessages) {
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            
            req2.setAction('Approve');
            
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});    
            if(emailMessageIdTOWorkInstance.containsKey(emailMessage.Id)){  
                // Use the ID from the newly created item to specify the item to be worked                 
                req2.setWorkitemId(emailMessageIdTOWorkInstance.get(emailMessage.Id).Id);
                
                // Submit the request for approval                 
                Approval.ProcessResult result2 =  Approval.process(req2);                
            }
            emailMessage.inApprovalStep2__c = false;
        }
        
        update mailMessages;
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
    public Map<Id, ProcessInstanceWorkitem> getWorkItemId(Set<Id> targetObjectIds)
    {       
        Map<Id, ProcessInstanceWorkitem> targetToProcessInstance = new Map<Id, ProcessInstanceWorkitem>();
        for(ProcessInstanceWorkitem workItem  : [Select Id, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem 
                                                 where ProcessInstance.TargetObjectId IN : targetObjectIds])
        {
            targetToProcessInstance.put(workItem.ProcessInstance.TargetObjectId, workItem);
        }
        
        return targetToProcessInstance;
    }
}