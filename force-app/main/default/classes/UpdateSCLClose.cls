global class UpdateSCLClose implements Database.Batchable<sObject>
{
    List<SupplyChain__c> SCLList = new List<SupplyChain__c>();
     String str = 'Select Id,Close_Forecast__c FROM SupplyChain__c WHERE Close_Forecast__c=true';
     
   global Database.queryLocator start(Database.BatchableContext ctx )
   {
          
       
        
        return Database.getQueryLocator(str);
        
   }
    
    global void execute(Database.BatchableContext ctx, List<SupplyChain__c> cas)
     {
      
       
       for(SupplyChain__c conObj : cas){
                conObj.status__c = 'Closed';
            SCLList.add(conObj);
          }
        
        update SCLList;
     }
   
   global void finish(Database.BatchableContext ctx)
    {
    }}