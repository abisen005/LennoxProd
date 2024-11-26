public class ExecutiveSummaryChildBatch implements Database.Batchable<sObject>{

    Map<String, Account_Planning__c> aggrAccountPlan;
    public string year;

    public ExecutiveSummaryChildBatch(Map<String, Account_Planning__c> aggrAccountPlan){
        this.aggrAccountPlan = aggrAccountPlan;
        this.year = String.valueOf(Date.today().year());
    }

    public ExecutiveSummaryChildBatch(Map<String, Account_Planning__c> aggrAccountPlan, String year){
        this.aggrAccountPlan = aggrAccountPlan;
        this.year = year;
    }
    
    public Database.queryLocator start(Database.BatchableContext ctx ) {
        
        String query = 'Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive '+
            'FROM User LIMIT 1';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext ctx, List<User> amUsers) {
        String thisYear;
        Date todayDate = Date.today();
        if(Test.isRunningTest()){
            thisYear = String.valueOf(todayDate.year()-1);
        }else{
            thisYear = this.year;
        }
        executiveAggregateHelperClassStateful Helper1;
        
        // Create This Year Executive Report
        try{
            
            ExecutiveRollUpMain__c thisYearRollUp = [SELECT Id FROM ExecutiveRollUpMain__c WHERE Year__c =: thisYear AND Type__c = 'Executive'];

            Helper1 = new executiveAggregateHelperClassStateful(thisYear, aggrAccountPlan);

            List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
            childRecords.addAll(Helper1.getAccountOpportunityRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getRetentionOpportunityRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getActionPlanRecords(thisYearRollUp.Id));
            childRecords.addAll(Helper1.getRegionRecords(thisYearRollUp.Id));
            if(childRecords.size() > 0)
                insert childRecords;
        } catch (Exception e) {
            System.debug('Exception e ::' + e.getLineNumber() + '  :: ' + e.getMessage());
            ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext ctx) {
        if (!system.Test.isRunningTest()) {
            database.executeBatch(new AreaManagerAggregateBatch(this.year),1);
        }
    }
}