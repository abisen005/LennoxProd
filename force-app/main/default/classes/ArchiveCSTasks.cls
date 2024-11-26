global class ArchiveCSTasks implements Database.Batchable<sObject>
{
    List<Task> taskList = new List<Task>();
     String str = 'select Id,CS_task_archive__c FROM Task where CS_task_archive__c=true';
     
   global Database.queryLocator start(Database.BatchableContext ctx )
   {
          
       
        
        return Database.getQueryLocator(str);
        
   }
    
    global void execute(Database.BatchableContext ctx, List<Task> tas)
     {
delete tas;
     }
   
   global void finish(Database.BatchableContext ctx)
    {
    }}