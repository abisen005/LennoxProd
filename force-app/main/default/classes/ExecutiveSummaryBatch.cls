public class ExecutiveSummaryBatch implements Database.Batchable<sObject>{
    
    public Database.queryLocator start(Database.BatchableContext ctx ) {
        
        String query = 'Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive '+
            'FROM User LIMIT 1';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext ctx, List<User> amUsers) {
        Date todayDate = Date.today();
        String thisYear = String.valueOf(todayDate.year());
        
        executiveAggregateHelperClass Helper1;
        
        // Create This Year Executive Report
        try{
            Helper1 = new executiveAggregateHelperClass(thisYear);
            
            ExecutiveRollUpMain__c thisYearRollUp = Helper1.getMainRecord();
            
            // Delete previous year records
            AreaManagerAggregateBatchHelper.deletExecutiveRollUpMainRecords(thisYear, 'Executive');           
            
            insert thisYearRollUp;
            
            List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
            childRecords.addAll(Helper1.getAccountOpportunityRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getRetentionOpportunityRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getActionPlanRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getRegionRecords(thisYearRollUp.Id));
            if(childRecords.size() > 0)
                insert childRecords;
            
        } catch (Exception e) {
            //System.debug('Exception e ::' + e.getLineNumber() + '  :: ' + e.getMessage());
            ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext ctx) {
        if (!system.Test.isRunningTest()) {
            database.executeBatch(new AreaManagerAggregateBatch(String.valueOf(date.today().year())),1);
        }
    }
}