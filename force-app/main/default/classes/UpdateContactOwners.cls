global class UpdateContactOwners implements Database.Batchable<sObject>
{
    List<Contact> contactList = new List<Contact>();
     String str = 'Select Id,account.ownerid, ownerid, Owner_Mismatch__c FROM contact WHERE Owner_Mismatch__c=true';
     
   global Database.queryLocator start(Database.BatchableContext ctx )
   {
          
       
        
        return Database.getQueryLocator(str);
        
   }
    
    global void execute(Database.BatchableContext ctx, List<Contact> cas)
     {
      
       
       for(Contact conObj : cas){
                conObj.ownerid = conObj.Account.OwnerId;
            contactList.add(conObj);
          }
        
        update contactList;
     }
   
   global void finish(Database.BatchableContext ctx)
    {
    }}