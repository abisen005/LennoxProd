global class UpdateContacts implements Database.Batchable<sObject>
{
    List<Contact> contactList = new List<Contact>();
     String str = 'Select Id,Verified_plus_3__c, Contact_Verified__c FROM contact WHERE Contact_Verified__c=true AND verified_plus_3__c<=TODAY';
     
   global Database.queryLocator start(Database.BatchableContext ctx )
   {
          
       
        
        return Database.getQueryLocator(str);
        
   }
    
    global void execute(Database.BatchableContext ctx, List<Contact> cas)
     {
      
       
       for(Contact conObj : cas){
                conObj.Contact_Verified__c  = false;
            contactList.add(conObj);
          }
        
        update contactList;
     }
   
   global void finish(Database.BatchableContext ctx)
    {
    }}