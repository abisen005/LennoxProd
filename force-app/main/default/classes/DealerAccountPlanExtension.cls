public with sharing class DealerAccountPlanExtension {
    private final Account_Planning__c accPlan;
    public decimal salesForecast {get;set;}
    
    public DealerAccountPlanExtension(ApexPages.StandardController con) {
        accPlan = (Account_Planning__c)con.getRecord();
        Id accId = accPlan.Id;
        String query;
        
        Date currentDate = System.today();
        Integer currentYear = currentDate.year();
        
        if(String.valueOf(accPlan.Current_Year__c) == String.valueOf(currentYear)) {
            query = 'SELECT SUM(Dealer__r.Current_Year_Sales_Forecast__c) amt FROM Account_Planning__c WHERE Id = :accId';
        }else if (String.valueOf(accPlan.Current_Year__c) == String.valueOf(currentYear - 1)){
            query = 'SELECT SUM(Dealer__r.Prior_Year_Sales_Forecast__c ) amt FROM Account_Planning__c WHERE Id = :accId';
        }else{
            query = 'SELECT sum(X' + String.valueOf(accPlan.Current_Year__c) + '_Sales_Forecast__c) amt FROM Account_Planning__c WHERE Id = : accId';
        }
        
        List<AggregateResult> result = Database.Query(query);
        salesForecast = (Decimal)result[0].get('amt');
    }
}