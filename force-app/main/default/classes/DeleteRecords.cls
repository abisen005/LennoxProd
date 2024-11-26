global class DeleteRecords implements Database.Batchable<sObject>
{
    List<Retention_History__c> retentionList = new List<Retention_History__c>();
     String str = 'select Id,X3_year_formula__c FROM Retention_History__c where X3_year_formula__c=true';
     
   global Database.queryLocator start(Database.BatchableContext ctx )
   {
          
       
        
        return Database.getQueryLocator(str);
        
   }
    
    global void execute(Database.BatchableContext ctx, List<Retention_History__c> cas)
     {
delete cas;
     }
   
   global void finish(Database.BatchableContext ctx)
    {
    }}