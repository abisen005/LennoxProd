public class storeRollupSummaryAggregateBatch implements Database.Batchable<sObject>, Database.Stateful{

    public class RollupResult{
        public String year{get;set;}
        public String store{get;set;}
        public String zone{get;set;}
        public string region{get;set;}
        public Decimal currentYearSales{get;set;}
        public Decimal priorYTDSales{get;set;}
        public Decimal priorYearSales{get;set;}
        public Decimal priorYear2Sales{get;set;}
        public Decimal priorYear3Sales{get;set;}
        public Decimal currentYearForecast{get;set;}
        public Decimal ytdResEquipSales{get;set;}
        public Decimal ytdcCommercialSales{get;set;}
        public Decimal ytdPSSales{get;set;}
        public Decimal ytdDLSCSales{get;set;}
        public Decimal ytdEliteSales{get;set;}
        public Decimal ytdMeritSales{get;set;}
        public Decimal ytdAireFloSales{get;set;}
        public Decimal ytdOtherSales{get;set;}
        public Decimal pytdDLSCSales{get;set;}
        public Decimal pytdEliteSales{get;set;}
        public Decimal pytdMeritSales{get;set;}
        public Decimal pytdAireFloSales{get;set;}
        public Decimal pytdOtherSales{get;set;}
        public Date LastSalesHistoryUpdate{get;set;}
    }

    Map<String, RollupResult> mapAggregate = new Map<String, RollupResult>();
    String currentYear;
    String forcastField;

    public storeRollupSummaryAggregateBatch(){
        this.currentYear = String.valueOf(System.Today().year());
    }

    public storeRollupSummaryAggregateBatch(String year){
        this.currentYear = year;
    }
    
    public Database.queryLocator start(Database.BatchableContext BC ) {

        deleteStorRollupSummaryRecords();
        String strRegionList ='';
        for(Roll_Up_Regions__mdt region : [SELECT Label FROM Roll_Up_Regions__mdt]){
            strRegionList += '\'' + region.Label + '\', ';
        }
        strRegionList = strRegionList.removeEnd(', ');
        forcastField = 'X' + currentYear + '_Sales_Forecast__c';
        String query = 
        'SELECT ' +
            'Account_Plan_Year__c, ' +
            'Dealer__c, ' +
            'Dealer__r.LPP_Plant_Code__c, ' +
            'Dealer__r.LPP_Zone__c, ' +
            'Dealer__r.Store_Region__c, ' +
            'YTD_Sales__c, ' +
            'PY_YTD_Sales__c, ' +
            'PY_Sales__c, ' +
            'PY2_Sales__c, ' +
            'PY3_Sales__c, ' +
            //forcastField + ', ' +
            //(Integer.valueOf(currentYear) < 2024 ? forcastField + ', ' : 'Current_Year_Sales_Forecast__c, ') +
            'Sales_Forecast__c, ' +
            'YTD_Res_Equip_Sales__c, ' +
            'YTD_Commercial_Sales__c, ' +
            'YTD_P_S_Sales__c, ' +
            'YTD_DLSC_Sales__c, ' +
            'YTD_Elite_Sales__c, ' +
            'YTD_Merit_Sales__c, ' +
            'YTD_Aire_Flo_Sales__c, ' +
            'YTD_Other_Sales__c, ' +                    
            'PY_YTD_DLSC_Sales__c, ' +
            'PY_YTD_Elite_Sales__c, ' +
            'PY_YTD_Merit_Sales__c, ' +
            'PY_YTD_Aire_Flo_Sales__c, ' +
            'PY_YTD_Other_Sales__c, ' +    
            'Last_Sales_History_Update__c ' +    
        'FROM Account_Planning__c ' + 
        'WHERE Account_Plan_Year__c = \'' + currentYear + '\' ' +
            'AND Dealer__c != null ' +
            'AND Dealer__c != \'\'';
        IF (strRegionList != ''){
            query += ' AND Dealer__r.SAP_Sales_District__c IN (' + strRegionList + ')';
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account_Planning__c> scope) {
        for(Account_Planning__c ap : scope){
            String rowKey = formatBlank(ap.Account_Plan_Year__c) + ':' + 
                            formatBlank(ap.Dealer__r.LPP_Plant_Code__c) + ':' + 
                            formatBlank(ap.Dealer__r.LPP_Zone__c) + ':' + 
                            formatBlank(ap.Dealer__r.Store_Region__c);
            RollupResult rr;
            if(mapAggregate.containsKey(rowKey)){
                rr = mapAggregate.get(rowKey);
            } else {
                rr = new RollupResult();
                rr.year = ap.Account_Plan_Year__c;
                rr.store = ap.Dealer__r.LPP_Plant_Code__c;
                rr.zone = ap.Dealer__r.LPP_Zone__c;
                rr.region = ap.Dealer__r.Store_Region__c;
                rr.currentYearSales = 0;
                rr.priorYTDSales = 0;
                rr.priorYearSales = 0;
                rr.priorYear2Sales = 0;
                rr.priorYear3Sales = 0;
                rr.currentYearForecast = 0;
                rr.ytdResEquipSales = 0;
                rr.ytdcCommercialSales = 0;
                rr.ytdPSSales = 0;
                rr.ytdDLSCSales = 0;
                rr.ytdEliteSales = 0;
                rr.ytdMeritSales = 0;
                rr.ytdAireFloSales = 0;
                rr.ytdOtherSales = 0;
                rr.pytdDLSCSales = 0;
                rr.pytdEliteSales = 0;
                rr.pytdMeritSales = 0;
                rr.pytdAireFloSales = 0;
                rr.pytdOtherSales = 0;
                mapAggregate.put(rowKey, rr);
            }
            rr.currentYearSales += ap.YTD_Sales__c == null ? 0 : ap.YTD_Sales__c;
            rr.priorYTDSales += ap.PY_YTD_Sales__c == null ? 0 : ap.PY_YTD_Sales__c;
            rr.priorYearSales += ap.PY_Sales__c == null ? 0 : ap.PY_Sales__c;
            rr.priorYear2Sales += ap.PY2_Sales__c == null ? 0 : ap.PY2_Sales__c;
            rr.priorYear3Sales += ap.PY3_Sales__c == null ? 0 : ap.PY3_Sales__c;
            //rr.currentYearForecast += ap.get(forcastField) == null ? 0 : (Decimal)ap.get(forcastField);
            //if(Integer.valueOf(currentYear) < 2024) {
            //    rr.currentYearForecast += (ap.get(forcastField) == null ? 0 : (Decimal)ap.get(forcastField));
            //} else {
            //    rr.currentYearForecast += (ap.Current_Year_Sales_Forecast__c == null ? 0 : ap.Current_Year_Sales_Forecast__c);
            //}
            rr.currentYearForecast += (ap.Sales_Forecast__c == null ? 0 : ap.Sales_Forecast__c);
            rr.ytdResEquipSales += ap.YTD_Res_Equip_Sales__c == null ? 0 : ap.YTD_Res_Equip_Sales__c;
            rr.ytdcCommercialSales += ap.YTD_Commercial_Sales__c == null ? 0 : ap.YTD_Commercial_Sales__c;
            rr.ytdPSSales += ap.YTD_P_S_Sales__c == null ? 0 : ap.YTD_P_S_Sales__c;
            rr.ytdDLSCSales += ap.YTD_DLSC_Sales__c == null ? 0 : ap.YTD_DLSC_Sales__c;
            rr.ytdEliteSales += ap.YTD_Elite_Sales__c == null ? 0 : ap.YTD_Elite_Sales__c;
            rr.ytdMeritSales += ap.YTD_Merit_Sales__c == null ? 0 : ap.YTD_Merit_Sales__c;
            rr.ytdAireFloSales += ap.YTD_Aire_Flo_Sales__c == null ? 0 : ap.YTD_Aire_Flo_Sales__c;
            rr.ytdOtherSales += ap.YTD_Other_Sales__c == null ? 0 : ap.YTD_Other_Sales__c;
            rr.pytdDLSCSales += ap.PY_YTD_DLSC_Sales__c == null ? 0 : ap.PY_YTD_DLSC_Sales__c;
            rr.pytdEliteSales += ap.PY_YTD_Elite_Sales__c == null ? 0 : ap.PY_YTD_Elite_Sales__c;
            rr.pytdMeritSales += ap.PY_YTD_Merit_Sales__c == null ? 0 : ap.PY_YTD_Merit_Sales__c;
            rr.pytdAireFloSales += ap.PY_YTD_Aire_Flo_Sales__c == null ? 0 : ap.PY_YTD_Aire_Flo_Sales__c;
            rr.pytdOtherSales += ap.PY_YTD_Other_Sales__c == null ? 0 : ap.PY_YTD_Other_Sales__c;
            if(rr.LastSalesHistoryUpdate == null || rr.LastSalesHistoryUpdate < ap.Last_Sales_History_Update__c){
                rr.LastSalesHistoryUpdate = ap.Last_Sales_History_Update__c;
            }
        }
    }

    public void finish(Database.BatchableContext BC){
        saveStoreRollupSummaryRecords();
        if(currentYear == String.valueOf(System.Today().year())){
            storeRollupSummaryKPIAggregateBatch nextBatch = new storeRollupSummaryKPIAggregateBatch(currentYear);
            database.executeBatch(nextBatch);
        }        
    }

    private String formatBlank(String input){
        if(String.isBlank(input)){
            return '';
        } else {
            return input.trim();
        }
    }

    private void deleteStorRollupSummaryRecords(){
        List<ExecutiveRollUpMain__c> listDelete = [
            SELECT Id 
            FROM ExecutiveRollUpMain__c 
            WHERE Type__c = 'Store Summary Sales'
                AND Year__c = :currentYear];
                //AND KPI_OppScoreCards__c = null];
        delete listDelete;
    }

    private void saveStoreRollupSummaryRecords(){
        List<ExecutiveRollUpMain__c> listInsert = new List<ExecutiveRollUpMain__c>();
        for(RollupResult rr : mapAggregate.values()){
            ExecutiveRollUpMain__c e = new ExecutiveRollUpMain__c();
            e.Year__c =  rr.year;
            e.Store__c = rr.store;
            e.Zone__c = rr.zone;
            e.Region__c = rr.region;
            e.SortSequence__c = String.isBlank(rr.region) ? '2' : '1';
            e.CY_YTDSales__c = rr.currentYearSales;
            e.PY_YTDSales__c = rr.priorYTDSales;
            e.YTDSalesChange__c = rr.currentYearSales - rr.priorYTDSales;
            e.PY_SalesHistory__c = rr.priorYearSales;
            e.P2Y_SalesHistory__c = rr.priorYear2Sales;
            e.P3Y_SalesHistory__c = rr.priorYear3Sales;
            e.CY_SalesForecast__c = rr.currentYearForecast;
            e.CY_YTDResEquipment__c = rr.ytdResEquipSales;
            e.CY_YTDCommercial__c = rr.ytdcCommercialSales;
            e.CY_YTDPartsAndSupplies__c = rr.ytdPSSales;
            e.CY_YTDDLSC__c = rr.ytdDLSCSales;
            e.CY_YTDElite__c = rr.ytdEliteSales;
            e.CY_YTDMerit__c = rr.ytdMeritSales;
            e.CY_YTDAireFlo__c =  rr.ytdAireFloSales;
            e.CY_YTDOther__c = rr.ytdOtherSales;
            e.PY_YTDDLSC__c = rr.pytdDLSCSales;
            e.PY_YTDElite__c = rr.pytdEliteSales;
            e.PY_YTDMerit__c = rr.pytdMeritSales;
            e.PY_YTDAireFlo__c = rr.pytdAireFloSales;
            e.PY_YTDOther__c = rr.pytdOtherSales;
            e.KPI_OppScorecards__c = 0;
            e.KPI_Contacts__c = 0;
            e.KPI_PhoneCalls__c = 0;
            e.Last_Sales_History_Update__c = rr.LastSalesHistoryUpdate;
            e.Type__c = 'Store Summary Sales';
            listInsert.add(e);
        }
        insert listInsert;
    }
}