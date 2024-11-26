public class AreaManagerAggregateBatchHelper {
    
    public static List<AggregateResult> fetchAccountPlanAggregateResults (String year){
        //String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
        Integer getYear = Integer.valueOf(year);
         String forecastTotalSales;
            if(getYear == system.today().year()){
                        forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
            }
            else if((getYear == system.today().year()-1)){
                 forecastTotalSales ='Dealer__r.Prior_Year_Sales_Forecast__c';
            }else{
                forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
        }
        
        /*String queryAccountPlan = 'SELECT SUM(PY3_Sales__c),SUM(PY2_Sales__c),SUM(PY_Sales__c),'+
            'SUM('+forecastTotalSales+'),SUM(YTD_Sales__c),SUM(PY_YTD_Sales__c),'+
            'SUM(YTD_Sales_Change__c),SUM(YTD_Res_Equip_Sales__c),SUM(YTD_Commercial_Sales__c),'+
            'SUM(YTD_P_S_Sales__c),SUM(YTD_DLSC_Sales__c),AVG(YTD_DLSC_Sales_Percent__c),'+
            'SUM(PY_YTD_DLSC_Sales__c),AVG(PY_YTD_DLSC_Sales_Percent__c),SUM(YTD_DLSC_Sales_Change__c),'+
            'SUM(YTD_Elite_Sales__c),AVG(YTD_Elite_Sales_Percent__c),SUM(PY_YTD_Elite_Sales__c),'+
            'AVG(PY_YTD_Elite_Sales_Percent__c),SUM(YTD_Elite_Sales_Change__c),SUM(YTD_Merit_Sales__c),'+
            'AVG(YTD_Merit_Sales_Percent__c),SUM(PY_YTD_Merit_Sales__c),AVG(PY_YTD_Merit_Sales_Percent__c),'+
            'SUM(YTD_Merit_Sales_Change__c),SUM(YTD_Aire_Flo_Sales__c),AVG(YTD_Aire_Flo_Sales_Percent__c),'+
            'SUM(PY_YTD_Aire_Flo_Sales__c),AVG(PY_YTD_Aire_Flo_Sales_Percent__c),SUM(YTD_Aire_Flo_Sales_Change__c),'+
            'SUM(YTD_Other_Sales__c),AVG(YTD_Other_Sales_Percent__c),SUM(PY_YTD_Other_Sales__c),'+
            'AVG(PY_YTD_Other_Sales_Percent__c),SUM(YTD_Other_Sales_Change__c), '+
            'MAX(Last_Sales_History_Update__c) date1, Dealer__r.SAP_Sales_District__c '+
            'FROM Account_Planning__c '+
            'WHERE Account_Plan_Year__c =\''+string.valueOf(year)+'\' '+
            'GROUP BY Dealer__r.SAP_Sales_District__c'; */
        String queryAccountPlan = 'Select count(id), Dealer__r.SAP_Sales_District__c FROM Account_Planning__c WHERE Account_Plan_Year__c = \''+string.valueOf(year)+'\' ' + 'GROUP BY Dealer__r.SAP_Sales_District__c';
            
        System.Debug('!!! Query: ' + queryAccountPlan);
        return database.query(queryAccountPlan);        
    }
    
    public Static Set<String> findSalesAreas(List<AggregateResult> aggResutsAccountPlan){
        Set<String> salesAreas = new Set<String>();
        for(AggregateResult q:aggResutsAccountPlan)
        {
            if(q.get('SAP_Sales_District__c') != null)
            {
                salesAreas.add(String.valueOf(q.get('SAP_Sales_District__c')));
            }
        }
        return salesAreas;
    }
    
    public Static void deletExecutiveRollUpMainRecords(String year, String area){
        List<ExecutiveRollUpMain__c> previousRecords3;
        try{
            previousRecords3 = [SELECT Id 
                                FROM ExecutiveRollUpMain__c 
                                WHERE Year__c = :year 
                                AND Type__c = :area];    
        }catch(Exception exp){
            System.debug('No records found for this year');
        }
        if(previousRecords3 != NULL && !previousRecords3.isEmpty()){
            delete previousRecords3;        
        }
    }
}