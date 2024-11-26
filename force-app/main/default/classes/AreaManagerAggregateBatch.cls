public class AreaManagerAggregateBatch implements Database.Batchable<sObject>{
    
    String thisYear;// = String.valueOf(todayDate.year());
    public AreaManagerAggregateBatch(String thisYear){
        this.thisYear = thisYear;
    }
    
    public Database.queryLocator start(Database.BatchableContext ctx ) { 
        
        List<AggregateResult> aggResutsAccountPlan = AreaManagerAggregateBatchHelper.fetchAccountPlanAggregateResults(thisYear);
        System.debug('aggResutsAccountPlan ::' + aggResutsAccountPlan);
        Set<String> salesAreasThisYear = AreaManagerAggregateBatchHelper.findSalesAreas(aggResutsAccountPlan);
        System.debug('salesAreasThisYear ::' + salesAreasThisYear);
        // Delete existing regional records for present year
        AreaManagerAggregateBatchHelper.deletExecutiveRollUpMainRecords(thisYear, 'Region');
        
        String query = 'Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive '+
            'FROM User WHERE SAP_Sales_District__c IN: salesAreasThisYear AND isActive = true';
        if(!Test.isRunningTest()){
            query = query + ' AND Profile.Name LIKE \'%AM%\'';
        }
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext ctx, List<User> amUsers) {
        //System.debug('amUsers ::' + JSON.serialize( amUsers));
        // Variables used to insert records for present year
        List<ExecutiveRollUpMain__c> regionalMainRecordsToInsert = new List<ExecutiveRollUpMain__c>();
        List<ExecutiveRollUpChild__c> regionalChildRecordsToInsert = new List<ExecutiveRollUpChild__c>();
        Map<String,String> mapUserIdToRecordId = new Map<String,String>();
        
        try{
            if(!amUsers.isEmpty())
            {
                for(User u: amUsers)
                {
                    areaManagerAggreagateHelperClass Helper3 = new areaManagerAggreagateHelperClass(thisYear,u.Id); 
                    regionalMainRecordsToInsert.add(Helper3.getMainRecord());
                    regionalChildRecordsToInsert.addAll(Helper3.getAccountOpportunityRecords(u.Id));
                    regionalChildRecordsToInsert.addAll(Helper3.getRetentionOpportunityRecords(u.Id));
                    regionalChildRecordsToInsert.addAll(Helper3.getActionPlanRecords(u.Id));
                    regionalChildRecordsToInsert.addAll(Helper3.getRegionRecords(u.Id));
                }
            }
            
            //System.debug('regionalMainRecordsToInsert:::' + regionalMainRecordsToInsert);
            if(!regionalMainRecordsToInsert.isEmpty())
            {
                insert regionalMainRecordsToInsert;
            }
            
            //System.debug('regionalMainRecordsToInsert after:::' + Database.query('SELECT Id FROM ExecutiveRollUpMain__c WHERE Year__c =\'2019\''  ));
            
            for(ExecutiveRollUpMain__c record: regionalMainRecordsToInsert)
            {
                mapUserIdToRecordId.put(record.UserId__c, record.Id);
            }
            
            if(!regionalChildRecordsToInsert.isEmpty())
            {
                for(ExecutiveRollUpChild__c record: regionalChildRecordsToInsert)
                {
                    record.ExecutiveRollUpMain__c = mapUserIdToRecordId.get(record.UserId__c);
                }
                //System.debug('regionalChildRecordsToInsert:::' + regionalChildRecordsToInsert);
                insert regionalChildRecordsToInsert;
                //System.debug('regionalChildRecordsToInsert after:::' + regionalChildRecordsToInsert);
            }
        }
        catch(Exception e)
        {
            //System.debug('Exception e ::' + e.getLineNumber() + '  :: ' + e.getMessage());
            ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
        }        
    }
    
    public void finish(Database.BatchableContext ctx) {
    }
}