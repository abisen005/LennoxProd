public class storeRollupSummaryKPIAggregateBatch implements Database.Batchable<sObject>, Database.Stateful{

    public class RollupResult{
        public String store{get;set;}
        public String zone{get;set;}
        public string region{get;set;}
        public Integer kPiOppScoreCards{get;set;}
        public Integer kPIContacts{get;set;}
        public Integer kPIPhoneCalls{get;set;}
    }

    Map<String, RollupResult> mapAggregate = new Map<String, RollupResult>();
    String currentYear;

    public storeRollupSummaryKPIAggregateBatch(){
        this.currentYear = String.valueOf(System.Today().year());
    }

    public storeRollupSummaryKPIAggregateBatch(String year){
        this.currentYear = year;
    }
    
    public Database.queryLocator start(Database.BatchableContext BC ) {

        deleteStorRollupSummaryRecords();

        String query = 
        'SELECT ' +
            'Id, ' +
            'LPP_Plant_Code__c, ' +
            'LPP_Zone__c, ' +
            'Store_Region__c ' +    
        'FROM Account';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {

        Set<Id> setAccountId = new Set<Id>();

        for(Account acc : scope){
            setAccountId.add(acc.Id);
        }
        Map<String, Integer> mapKPIOppScoreCards = getMapKPIOppScoreCards(setAccountId);
        Map<String, Integer> mapKPIContacts = getMapKPIContacts(setAccountId);
        Map<String, Integer> mapKPIPhoneCalls = getMapKPIPhoneCalls(setAccountId);

        for(Account acc : scope){
            String rowKey = formatBlank(acc.LPP_Plant_Code__c) + ':' + 
                            formatBlank(acc.LPP_Zone__c) + ':' + 
                            formatBlank(acc.Store_Region__c);
            RollupResult rr;
            if(mapAggregate.containsKey(rowKey)){
                rr = mapAggregate.get(rowKey);
            } else {
                rr = new RollupResult();
                rr.store = acc.LPP_Plant_Code__c;
                rr.zone = acc.LPP_Zone__c;
                rr.region = acc.Store_Region__c;
                rr.kPIOppScoreCards = 0;
                rr.kPIContacts = 0;
                rr.kPIPhoneCalls = 0;
                mapAggregate.put(rowKey, rr);
            }
            rr.kPiOppScoreCards += mapKPIOppScoreCards.containsKey(acc.Id) ? mapKPIOppScoreCards.get(acc.Id) : 0;
            rr.kPIContacts += mapKPIContacts.containsKey(acc.Id) ? mapKPIContacts.get(acc.Id) : 0;
            rr.kPIPhoneCalls += mapKPIPhoneCalls.containsKey(acc.Id) ? mapKPIPhoneCalls.get(acc.Id) : 0;
        }
    }

    public void finish(Database.BatchableContext BC){
        saveStoreRollupSummaryRecords();
        if (currentYear == String.valueOf(System.Today().year())){
            String priorYear = String.valueOf(Integer.valueOf(currentYear) - 1);
            storeRollupSummaryAggregateBatch nextBatch = new storeRollupSummaryAggregateBatch(priorYear);
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
            WHERE Type__c = 'Store Summary KPI'
                AND Year__c = :currentYear];
                //AND KPI_OppScoreCards__c != null];
        delete listDelete;
    }

    private void saveStoreRollupSummaryRecords(){
        List<ExecutiveRollUpMain__c> listInsert = new List<ExecutiveRollUpMain__c>();
        for(RollupResult rr : mapAggregate.values()){
            ExecutiveRollUpMain__c e = new ExecutiveRollUpMain__c();
            if(rr.kPIOppScoreCards != 0 || rr.kPIContacts != 0 || rr.kPIPhoneCalls != 0){
                e.Year__c =  currentYear;
                e.Store__c = rr.store;
                e.Zone__c = rr.zone;
                e.Region__c = rr.region;
                e.SortSequence__c = String.isBlank(rr.region) ? '2' : '1';
                e.CY_YTDSales__c = 0;
                e.PY_YTDSales__c = 0;
                e.YTDSalesChange__c = 0;
                e.PY_SalesHistory__c = 0;
                e.P2Y_SalesHistory__c = 0;
                e.P3Y_SalesHistory__c = 0;
                e.CY_SalesForecast__c = 0;
                e.CY_YTDResEquipment__c = 0;
                e.CY_YTDCommercial__c = 0;
                e.CY_YTDPartsAndSupplies__c = 0;
                e.CY_YTDDLSC__c = 0;
                e.CY_YTDElite__c = 0;
                e.CY_YTDMerit__c = 0;
                e.CY_YTDAireFlo__c =  0;
                e.CY_YTDOther__c = 0;
                e.PY_YTDDLSC__c = 0;
                e.PY_YTDElite__c = 0;
                e.PY_YTDMerit__c = 0;
                e.PY_YTDAireFlo__c = 0;
                e.PY_YTDOther__c = 0;                
                e.KPI_OppScorecards__c = rr.kPIOppScoreCards;
                e.KPI_Contacts__c = rr.kPIContacts;
                e.KPI_PhoneCalls__c = rr.kPIPhoneCalls;
                e.Last_Sales_History_Update__c = Date.valueOf('1900-1-1 00:00:00');
                e.Type__c = 'Store Summary KPI';
                listInsert.add(e);
            }
        }
        insert listInsert;
    }

    private Map<String, Integer> getMapKPIOppScoreCards (Set<Id> setAccountId){

        Map<String, Integer> mapReturn = new Map<String, Integer>();

        for(AggregateResult a : [SELECT Account__c c1, count(Id) c2
                                 FROM Scorecard__c
                                 WHERE CALENDAR_YEAR(Last_Changed_Date_Stores__c) = :Integer.valueOf(currentYear)
                                    AND Last_Changed_by_User_Stores__c != NULL
                                    AND Account__c IN :setAccountId
                                 GROUP BY Account__c]){
            mapReturn.put((String)a.get('c1'), (Integer)a.get('c2'));
        }
        return mapReturn;
    }

    private Map<String, Integer> getMapKPIContacts (Set<Id> setAccountId){
        
        Map<String, Integer> mapReturn = new Map<String, Integer>();

        for(AggregateResult a : [SELECT AccountId c1, count(Id) c2
                                 FROM Contact
                                 WHERE CALENDAR_YEAR(Last_Updated_by_Stores__c) = :Integer.valueOf(currentYear)
                                    AND AccountId IN :setAccountId
                                    AND Last_Changed_By_Role__c LIKE '%LPP SM%'
                                 GROUP BY AccountId]){
            mapReturn.put((String)a.get('c1'), (Integer)a.get('c2'));
        }
        return mapReturn;        
    }
    
    private Map<String, Integer> getMapKPIPhoneCalls (Set<Id> setAccountId){
        
        Map<String, Integer> mapReturn = new Map<String, Integer>();
        Date startDate = Date.valueOf(currentYear + '-01-01');
        Date endDate = Date.valueOf(String.valueOf(Integer.valueOf(currentYear) + 1) + '-01-01');

        for(AggregateResult a : [SELECT AccountId c1, count(Id) c2
                                 FROM Event
                                 WHERE ActivityDate >= :startDate AND ActivityDate < :endDate
                                    AND Event_TYpe__c ='Phone Call - Outbound'
                                    AND Owner.UserRole.Name LIKE '%Res LPP SM%'
                                    //AND WhatId IN :setAccountId
                                    AND AccountId IN :setAccountId
                                 GROUP BY AccountId]){
            mapReturn.put((String)a.get('c1'), (Integer)a.get('c2'));
        }
        return mapReturn;        
    }
}