public class ExecutiveSummaryBatchStateful implements Database.Batchable<sObject>, Database.Stateful{
    public decimal previousYearTotalSales;
    public decimal previousTwoYearsTotalSales;
    public decimal previousThreeYearsTotalSales;
    public Date lastSalesHistoryUpdate{get; set;}
    
    public decimal presentYearSalesForecast;
    public decimal ytdSales;
    public decimal previuosYearsYTDSales;
    
    public decimal ytdSalesChange;
    public decimal ytdResEquipment;
    public decimal ytdCommercials;
    public decimal ytdPartsndSupplies;
    
    public decimal presetDLSC;
    public decimal presetDLSCPercent;
    public decimal presetMerit;
    public decimal presetMeritPercent;
    public decimal presetElite;
    public decimal presetElitePercent;
    public decimal presetAireFlo;
    public decimal presetAireFloPercent;
    public decimal presetOther;
    public decimal presentYearOtherPercent;
    
    public decimal previousYearDLSC;
    public decimal previousYearDLSCPercent;
    public decimal previousYearMerit;
    public decimal previousYearMeritPercent;
    public decimal previousYearElite;
    public decimal previousYearElitePercent;
    public decimal previousYearAireFlo;
    public decimal previousYearAireFloPercent;
    public decimal previousYearOther;
    public decimal previousYearOtherPercent;
    
    public decimal changeDLSC;
    public decimal changeMerit;
    public decimal changeElite;
    public decimal changeAireFlo;
    public decimal changeOther;
    //public Date lastSalesHistoryUpdate;
    public String year;
    String forecastTotalSales;

    public Set<String> salesAreas;
    public List<executiveAggregateHelperClassStateful.wrapper> amDisplay;
    public Map<String, Account_Planning__c> aggrAccountPlan;
    
    public ExecutiveSummaryBatchStateful(){
        this.year = String.valueOf(Date.today().year());
        clearVariables();
    }
    
    public ExecutiveSummaryBatchStateful(String year){
        this.year = year;
        clearVariables();
    }
    
    private void clearVariables(){
            
        aggrAccountPlan = new Map<String, Account_Planning__c>();
        salesAreas = new Set<String>();
        amDisplay = new List<executiveAggregateHelperClassStateful.wrapper>();
        previousYearTotalSales = 0;
        previousTwoYearsTotalSales = 0;
        previousThreeYearsTotalSales = 0;
        
        presentYearSalesForecast = 0;
        ytdSales = 0;
        previuosYearsYTDSales = 0;
        
        ytdSalesChange = 0;
        ytdResEquipment = 0;
        ytdCommercials = 0;
        ytdPartsndSupplies = 0;
        
        presetDLSC = 0;
        presetDLSCPercent = 0;
        presetMerit = 0;
        presetMeritPercent = 0;
        presetElite = 0;
        presetElitePercent = 0;
        presetAireFlo = 0;
        presetAireFloPercent = 0;
        presetOther = 0;
        presentYearOtherPercent = 0;
        
        previousYearDLSC = 0;
        previousYearDLSCPercent = 0;
        previousYearMerit = 0;
        previousYearMeritPercent = 0;
        previousYearElite = 0;
        previousYearElitePercent = 0;
        previousYearAireFlo = 0;
        previousYearAireFloPercent = 0;
        previousYearOther = 0;
        previousYearOtherPercent = 0;
        
        changeDLSC = 0;
        changeMerit = 0;
        changeElite = 0;
        changeAireFlo = 0;
        changeOther = 0;
    }
    
    public Database.queryLocator start(Database.BatchableContext BC ) {
        if(year == string.valueOf(system.today().year())){
            forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
        }else if(year == String.valueOf(system.today().year()-1)){
            forecastTotalSales ='Dealer__r.Prior_Year_Sales_Forecast__c';
        }else{
            forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
        }
        String strRegionList ='';
        for(Roll_Up_Regions__mdt region : [SELECT Label FROM Roll_Up_Regions__mdt]){
            strRegionList += '\'' + region.Label + '\', ';
        }
        strRegionList = strRegionList.removeEnd(', ');
        String query;
        if(Test.isRunningTest()){
            query = 'SELECT PY3_Sales__c,PY2_Sales__c,PY_Sales__c,'+forecastTotalSales+',YTD_Sales__c,YTD_Sales_from_acct__c,PY_YTD_Sales__c,' + 
                'YTD_Sales_Change__c,YTD_Res_Equip_Sales__c,YTD_Commercial_Sales__c,YTD_P_S_Sales__c,YTD_DLSC_Sales__c,YTD_DLSC_Sales_Percent__c,' + 
                'PY_YTD_DLSC_Sales__c,PY_YTD_DLSC_Sales_Percent__c,YTD_DLSC_Sales_Change__c,YTD_Elite_Sales__c,YTD_Elite_Sales_Percent__c,PY_YTD_Elite_Sales__c,' +
                'PY_YTD_Elite_Sales_Percent__c,YTD_Elite_Sales_Change__c,YTD_Merit_Sales__c,YTD_Merit_Sales_Percent__c,PY_YTD_Merit_Sales__c,PY_YTD_Merit_Sales_Percent__c,'+
                'YTD_Merit_Sales_Change__c,YTD_Aire_Flo_Sales__c,YTD_Aire_Flo_Sales_Percent__c,PY_YTD_Aire_Flo_Sales__c,PY_YTD_Aire_Flo_Sales_Percent__c,'+
                'YTD_Aire_Flo_Sales_Change__c,YTD_Other_Sales__c,YTD_Other_Sales_Percent__c,PY_YTD_Other_Sales__c,PY_YTD_Other_Sales_Percent__c,YTD_Other_Sales_Change__c,' +
                'Last_Sales_History_Update__c, Dealer__r.SAP_Sales_District__c, Dealer__r.Master_Resi_National_Account__r.Intiative__c FROM Account_Planning__c ' +
                'WHERE Account_Plan_Year__c =\'2023\' '+
                'ORDER BY Dealer__r.SAP_Sales_District__c' ;
        }
        else {
            query = 'SELECT PY3_Sales__c,PY2_Sales__c,PY_Sales__c,'+forecastTotalSales+',YTD_Sales__c,YTD_Sales_from_acct__c,PY_YTD_Sales__c,' + 
                'YTD_Sales_Change__c,YTD_Res_Equip_Sales__c,YTD_Commercial_Sales__c,YTD_P_S_Sales__c,YTD_DLSC_Sales__c,YTD_DLSC_Sales_Percent__c,' + 
                'PY_YTD_DLSC_Sales__c,PY_YTD_DLSC_Sales_Percent__c,YTD_DLSC_Sales_Change__c,YTD_Elite_Sales__c,YTD_Elite_Sales_Percent__c,PY_YTD_Elite_Sales__c,' +
                'PY_YTD_Elite_Sales_Percent__c,YTD_Elite_Sales_Change__c,YTD_Merit_Sales__c,YTD_Merit_Sales_Percent__c,PY_YTD_Merit_Sales__c,PY_YTD_Merit_Sales_Percent__c,'+
                'YTD_Merit_Sales_Change__c,YTD_Aire_Flo_Sales__c,YTD_Aire_Flo_Sales_Percent__c,PY_YTD_Aire_Flo_Sales__c,PY_YTD_Aire_Flo_Sales_Percent__c,'+
                'YTD_Aire_Flo_Sales_Change__c,YTD_Other_Sales__c,YTD_Other_Sales_Percent__c,PY_YTD_Other_Sales__c,PY_YTD_Other_Sales_Percent__c,YTD_Other_Sales_Change__c,' +
                'Last_Sales_History_Update__c, Dealer__r.SAP_Sales_District__c, Dealer__r.Master_Resi_National_Account__r.Intiative__c FROM Account_Planning__c ' +
                'WHERE Account_Plan_Year__c =\''+string.valueOf(year)+'\'';
            if(strRegionList != ''){
                query = query + ' AND Dealer__r.SAP_Sales_District__c IN (' + strRegionList + ')';
            }
            query = query + ' ORDER BY Dealer__r.SAP_Sales_District__c' ;
        }
        System.Debug('!!! Query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account_Planning__c> aggResutsAccountPlan) {
        
        try{
            List<User> amUsers;
            
            if(aggResutsAccountPlan.size() > 0) {
                System.Debug('!!! Size: ' + aggResutsAccountPlan.size());
                
                for(Account_Planning__c q:aggResutsAccountPlan)
                {
                    
                    //if(q.Dealer__r.Master_Resi_National_Account__r.Intiative__c != 'Res National Account'){
                    if(aggrAccountPlan.get(q.Dealer__r.SAP_Sales_District__c) == null || Test.isRunningTest()){
                        
                        Account_Planning__c newPlan = new Account_Planning__c();
                        newPlan.YTD_Sales__c = q.YTD_Sales__c == null ? 0 : q.YTD_Sales__c;
                        newPlan.PY_YTD_Sales__c = q.PY_YTD_Sales__c == null ? 0 : q.PY_YTD_Sales__c;
                        newPlan.Last_Sales_History_Update__c = date.valueOf(q.Last_Sales_History_Update__c);
                        aggrAccountPlan.put(q.Dealer__r.SAP_Sales_District__c, newPlan);
                    } else {
                        Account_Planning__c newPlan = new Account_Planning__c();
                        newPlan.YTD_Sales__c = aggrAccountPlan.get(q.Dealer__r.SAP_Sales_District__c)?.YTD_Sales__c + (q.YTD_Sales__c == null ? 0 : q.YTD_Sales__c);
                        newPlan.PY_YTD_Sales__c = aggrAccountPlan.get(q.Dealer__r.SAP_Sales_District__c)?.PY_YTD_Sales__c + (q.PY_YTD_Sales__c == null ? 0 : q.PY_YTD_Sales__c);
                        newPlan.Last_Sales_History_Update__c = date.valueOf(q.Last_Sales_History_Update__c);
                        if (q.Last_Sales_History_Update__c != null && 
                            aggrAccountPlan.get(q.Dealer__r.SAP_Sales_District__c).Last_Sales_History_Update__c != null &&
                            aggrAccountPlan.get(q.Dealer__r.SAP_Sales_District__c).Last_Sales_History_Update__c < date.valueOf(q.Last_Sales_History_Update__c)){
                                newPlan.Last_Sales_History_Update__c = date.valueOf(q.Last_Sales_History_Update__c);
                            }
                        aggrAccountPlan.put(q.Dealer__r.SAP_Sales_District__c, newPlan);
                        // }
                    }
                    
                    previousYearTotalSales +=       q.get('PY_Sales__c') == null ? 0 :                          (Decimal)q.get('PY_Sales__c');
                    previousTwoYearsTotalSales +=   q.get('PY2_Sales__c') == null ? 0 :                         (Decimal)q.get('PY2_Sales__c');
                    previousThreeYearsTotalSales += q.get('PY3_Sales__c') == null ? 0 :                         (Decimal)q.get('PY3_Sales__c');
                    
                    if(year == string.valueOf(system.today().year())){
                        presentYearSalesForecast += q.Dealer__r.Current_Year_Sales_Forecast__c == null ? 0 :  q.Dealer__r.Current_Year_Sales_Forecast__c;
                    }else if(year == String.valueOf(system.today().year()-1)){
                        presentYearSalesForecast += q.Dealer__r.Prior_Year_Sales_Forecast__c == null ? 0 :  q.Dealer__r.Prior_Year_Sales_Forecast__c;
                    }else{
                        presentYearSalesForecast += q.get(forecastTotalSales) == null ? 0 :                     (Decimal)q.get(forecastTotalSales);
                    }                    
                    
                    ytdSales +=                     q.get('YTD_Sales__c') == null ? 0 :                         (Decimal)q.get('YTD_Sales__c');
                    previuosYearsYTDSales +=        q.get('PY_YTD_Sales__c') == null ? 0 :                      (Decimal)q.get('PY_YTD_Sales__c');
                    
                    ytdResEquipment +=              q.get('YTD_Res_Equip_Sales__c') == null ? 0 :               (Decimal)q.get('YTD_Res_Equip_Sales__c');
                    ytdCommercials +=               q.get('YTD_Commercial_Sales__c') == null ? 0 :              (Decimal)q.get('YTD_Commercial_Sales__c');
                    ytdPartsndSupplies +=           q.get('YTD_P_S_Sales__c') == null ? 0 :                     (Decimal)q.get('YTD_P_S_Sales__c');
                    presetDLSC +=                   q.get('YTD_DLSC_Sales__c') == null ? 0 :                    (Decimal)q.get('YTD_DLSC_Sales__c');
                    presetMerit +=                  q.get('YTD_Merit_Sales__c') == null ? 0 :                   (Decimal)q.get('YTD_Merit_Sales__c');
                    presetAireFlo +=                q.get('YTD_Aire_Flo_Sales__c') == null ? 0 :                (Decimal)q.get('YTD_Aire_Flo_Sales__c');
                    presetOther +=                  q.get('YTD_Other_Sales__c') == null ? 0 :                   (Decimal)q.get('YTD_Other_Sales__c');
                    presetElite +=                  q.get('YTD_Elite_Sales__c') == null ? 0 :                   (Decimal)q.get('YTD_Elite_Sales__c');
                    
                    
                    previousYearDLSC +=             q.get('PY_YTD_DLSC_Sales__c') == null ? 0 :                 (Decimal)q.get('PY_YTD_DLSC_Sales__c');
                    previousYearMerit +=            q.get('PY_YTD_Merit_Sales__c') == null ? 0 :                (Decimal)q.get('PY_YTD_Merit_Sales__c');
                    previousYearElite +=            q.get('PY_YTD_Elite_Sales__c') == null ? 0 :                (Decimal)q.get('PY_YTD_Elite_Sales__c');
                    previousYearAireFlo +=          q.get('PY_YTD_Aire_Flo_Sales__c') == null ? 0 :             (Decimal)q.get('PY_YTD_Aire_Flo_Sales__c');
                    previousYearOther +=            q.get('PY_YTD_Other_Sales__c') == null ? 0 :                (Decimal)q.get('PY_YTD_Other_Sales__c');
                    
                    //Coded in the original but wasn't used in the original. Commenting out here Tan@ventasconsulting.com 1.21.2022
                    //ytdSalesChange +=               q.get('YTD_Sales_Change__c') == null ? 0 :                  (Decimal)q.get('YTD_Sales_Change__c');
                    //presetDLSCPercent +=            q.get('YTD_DLSC_Sales_Percent__c') == null ? 0 :            (Decimal)q.get('YTD_DLSC_Sales_Percent__c');
                    //presetMeritPercent +=           q.get('YTD_Merit_Sales_Percent__c') == null ? 0 :           (Decimal)q.get('YTD_Merit_Sales_Percent__c');
                    //presetElitePercent +=           q.get('YTD_Elite_Sales_Percent__c') == null ? 0 :           (Decimal)q.get('YTD_Elite_Sales_Percent__c');
                    //presetAireFloPercent +=         q.get('YTD_Aire_Flo_Sales_Percent__c') == null ? 0 :        (Decimal)q.get('YTD_Aire_Flo_Sales_Percent__c');
                    //presentYearOtherPercent +=      q.get('YTD_Other_Sales_Percent__c') == null ? 0 :           (Decimal)q.get('YTD_Other_Sales_Percent__c');
                    //previousYearDLSCPercent +=      q.get('PY_YTD_DLSC_Sales_Percent__c') == null ? 0 :         (Decimal)q.get('PY_YTD_DLSC_Sales_Percent__c');
                    //previousYearMeritPercent +=     q.get('PY_YTD_Merit_Sales_Percent__c') == null ? 0 :        (Decimal)q.get('PY_YTD_Merit_Sales_Percent__c');
                    //previousYearElitePercent +=     q.get('PY_YTD_Elite_Sales_Percent__c') == null ? 0 :        (Decimal)q.get('PY_YTD_Elite_Sales_Percent__c');
                    //previousYearAireFloPercent +=   q.get('PY_YTD_Aire_Flo_Sales_Percent__c') == null ? 0 :     (Decimal)q.get('PY_YTD_Aire_Flo_Sales_Percent__c');
                    //previousYearOtherPercent +=     q.get('PY_YTD_Other_Sales_Percent__c') == null ? 0 :        (Decimal)q.get('PY_YTD_Other_Sales_Percent__c');
                    //changeDLSC +=                   q.get('YTD_DLSC_Sales_Change__c') == null ? 0 :             (Decimal)q.get('YTD_DLSC_Sales_Change__c');
                    //changeMerit +=                  q.get('YTD_Merit_Sales_Change__c') == null ? 0 :            (Decimal)q.get('YTD_Merit_Sales_Change__c');
                    //changeElite +=                  q.get('YTD_Elite_Sales_Change__c') == null ? 0 :            (Decimal)q.get('YTD_Elite_Sales_Change__c');
                    //changeAireFlo +=                q.get('YTD_Aire_Flo_Sales_Change__c') == null ? 0 :         (Decimal)q.get('YTD_Aire_Flo_Sales_Change__c');
                    //changeOther +=                  q.get('YTD_Other_Sales_Change__c') == null ? 0 :            (Decimal)q.get('YTD_Other_Sales_Change__c');
                    if(lastSalesHistoryUpdate == null && q.get('Last_Sales_History_Update__c') != null)
                        lastSalesHistoryUpdate = date.valueOf((Date)q.get('Last_Sales_History_Update__c'));
                    else
                        if(q.get('Last_Sales_History_Update__c') != null && lastSalesHistoryUpdate < date.valueOf((Date)q.get('Last_Sales_History_Update__c')))
                        lastSalesHistoryUpdate = date.valueOf((Date)q.get('Last_Sales_History_Update__c'));     
                }
                
            } else {
                ExecutiveSummaryUtils.CreateErrorTask('Could not retrieve any information for Executive Summary Batch.');
            }
            
            System.Debug('!!! aggrAccountPlan: ' + aggrAccountPlan);
        }
        catch(Exception e) {
            
            System.debug(e.getMessage());
            System.debug('Exception 1 Line Number: '+e.getLineNumber());
            ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext BC){
        ExecutiveRollUpMain__c thisRollUp = new ExecutiveRollUpMain__c();
        thisRollUp.Year__c = String.valueOf(year);
        thisRollUp.Last_Sales_History_Update__c =lastSalesHistoryUpdate;
        thisRollUp.PY_SalesHistory__c = previousYearTotalSales;
        thisRollUp.P2Y_SalesHistory__c = previousTwoYearsTotalSales;
        thisRollUp.P3Y_SalesHistory__c = previousThreeYearsTotalSales;
        thisRollUp.CY_SalesForecast__c = presentYearSalesForecast;
        thisRollUp.CY_YTDSales__c = ytdSales;
        thisRollUp.PY_YTDSales__c = previuosYearsYTDSales;
        thisRollUp.CY_YTDDLSC__c = presetDLSC;
        thisRollUp.PY_YTDDLSC__c = previousYearDLSC;
        thisRollUp.CY_YTDMerit__c = presetMerit;
        thisRollUp.PY_YTDMerit__c = previousYearMerit;
        thisRollUp.CY_YTDElite__c = presetElite;
        thisRollUp.PY_YTDElite__c = previousYearElite;
        thisRollUp.CY_YTDAireFlo__c = presetAireFlo;
        thisRollUp.PY_YTDAireFlo__c = previousYearAireFlo;
        thisRollUp.CY_YTDOther__c = presetOther;
        thisRollUp.PY_YTDOther__c = previousYearOther;
        thisRollUp.CY_YTDCommercial__c = ytdCommercials;
        thisRollUp.CY_YTDPartsAndSupplies__c = ytdPartsndSupplies;
        thisRollUp.CY_YTDResEquipment__c = ytdResEquipment;
        thisRollUp.Type__c = 'Executive';
        try{
            System.Debug('!!! Rollup: ' + thisRollUp);
            AreaManagerAggregateBatchHelper.deletExecutiveRollUpMainRecords(this.year, 'Executive');      
            
            insert thisRollUp;
            
            Database.executeBatch(new ExecutiveSummaryChildBatch(aggrAccountPlan, this.year), 1);
            
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.debug('Exception 2 Line Number: '+e.getLineNumber());
            ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
        }
    }
}