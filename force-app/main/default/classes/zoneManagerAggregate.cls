/********************************************************
Developer : Ganesh Mahajan DWS 27/12/2021
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class zoneManagerAggregate
{
    //variable declarations
    public Date lastSalesHistoryUpdate{get; set;}
    public List<Favorites__c> favoritesList{get; set;}
    public string currentLoggedInUser{get; set;}
    //public string currentLoggedInUserTerritory{get; set;}
    //public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    //public boolean isAmProfile{get; set;}
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
    //public string accountId{get; set;}
    public string region{get;set;}
    public string regionDisplay{get;set;}
    public string zone{get;set;}
    
    public User u{get; set;}

    //public Set<String> salesGroups{get; set;}
    
    //public Decimal year1TotalSales{get;set;}
    //public Decimal year2TotalSales{get;set;}
    //public Decimal year3TotalSales{get;set;} 
    
    //public Date todaysDate{get; set;}
    
    //variable for Dealer Sales History
    public Decimal previousYearTotalSales{get; set;}
    public Decimal previousTwoYearsTotalSales{get; set;}
    public Decimal previousThreeYearsTotalSales{get; set;}
    
    //variable for YTD Sales Comparison
    public Decimal presentYearSalesForecast{get; set;}
    public Decimal ytdSales{get; set;}
    public Decimal previousYearsYTDSales{get; set;}
    
    //variable for YTD Sales - Product Hierarchy
    public Decimal ytdSalesChange{get; set;}
    public Decimal ytdResEquipment{get; set;}
    public Decimal ytdCommercials{get; set;}
    public Decimal ytdPartsndSupplies{get; set;}
    public String managerName {get;set;}

      public String roleName{get;set;}
    
    //public decimal ytdSalesTSA{get; set;}
    //public decimal previousYearsYTDSalesTSA{get; set;}
    
    /*
    public Decimal dealerDeltAYTDSalesSum1{get;set;}
    public Decimal dealerYTDSalesLCSum1{get;set;}
    public Decimal dealerpre1TSSum1{get;set;}
    public Decimal dealerPre2TSSum1{get;set;}
    public Decimal dealerPre3TSSum1{get;set;}
    
    public Decimal dealerDeltAYTDSalesSum2{get;set;}
    public Decimal dealerYTDSalesLCSum2{get;set;}
    public Decimal dealerpre1TSSum2{get;set;}
    public Decimal dealerPre2TSSum2{get;set;}
    public Decimal dealerPre3TSSum2{get;set;}
    */
    
    //variable for YTD Sales - Product Tier Current Year
    public decimal currentYearDLSC{get; set;}
    public decimal currentYearDLSCPercent{get; set;}
    public decimal currentYearMerit{get; set;}
    public decimal currentYearMeritPercent{get; set;}
    public decimal currentYearElite{get; set;}
    public decimal currentYearElitePercent{get; set;}
    public decimal currentYearAireFlo{get; set;}
    public decimal currentYearOther{get; set;}
    public decimal currentYearOtherPercent{get; set;}

    //variable for YTD Sales - Product Tier Previous Year
    public decimal previousYearDLSC{get; set;}
    public decimal previousYearDLSCPercent{get; set;}
    public decimal previousYearMerit{get; set;}
    public decimal previousYearMeritPercent{get; set;}
    public decimal previousYearElite{get; set;}
    public decimal previousYearElitePercent{get; set;}
    public decimal previousYearAireFlo{get; set;}
    public decimal previousYearOther{get; set;}
    public decimal previousYearOtherPercent{get; set;}

    public decimal changeDLSC{get; set;}
    public decimal changeMerit{get; set;}
    public decimal changeElite{get; set;}
    public decimal changeAireFlo{get; set;}
    public decimal changeOther{get; set;}    
    
    //public string yearSelected='';
    //public Set<Id> accIdSetTerritory = new Set<Id>();
    public AggregateResult thisRecord {get; set;}
    public List<ExecutiveRollUpChildWrapper> allStoreRecords {get; set;}
    public List<storeKPI> storeKPIList {get;set;}
    public Integer totalKPIScoreCards {get;set;}
    public Integer totalKPIContacts {get;set;}
    public Integer totalKPIPhoneCalls {get;set;}    

    //public List<ExecutiveRollUpChildWrapper> allTSAStoreRecords {get; set;}
    //public List<UserScorecardWrapper> userOppScoreWrapList{get; set;}
    //public List<UserContactWrapper> userContactWrapList{get; set;}
    //public List<UserEventWrapper> userEventWrapList{get; set;}
    
    
    public Pagereference cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    public zoneManagerAggregate()
    {
        //todaysDate = Date.today();
        //favoritesList = new List<Favorites__c>();
        //for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c, External_Link__c
        //    FROM Favorites__c
        //    WHERE (Category__c != NULL 
        //        AND Favorites_URL__c != NULL 
        //        AND Type__c = 'Admin' AND RUS_Assignment__c = 'Zone Manager')
        //    ORDER BY Sequence__c ASC]){ 
        //        favoritesList.add(favoriteRecord);
        //} 
        
        
        Boolean ableToFindDataWithUserId = true; 
        currentLoggedInUser = userinfo.getUserId();
        try
        {
            if(ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().get('year') != null)
            {
                year = integer.valueOf(ApexPages.CurrentPage().getParameters().get('year'));
                preYear = year -1;
                preTwoYear = year - 2;
                preThreeYear = year - 3; 
            }else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Year Value Missing.'));
                return;
            }
        } catch(Exception e){ 
            System.debug('Error Obtaining Year -'+e.getMessage());
        }     
        try
        {
            //get the current logged in user's information            
            if(ApexPages.currentPage().getParameters().get('u') != null){
                currentLoggedInUser = ApexPages.currentPage().getParameters().get('u');
                u = [SELECT Id, Name, ProfileId, FirstName, LastName, SAP_Sales_Office__c, Qlik_LPP_Zone__c, LPP_Region_Zone__c, LPP_Zone__c
                     FROM User WHERE Id =: currentLoggedInUser LIMIT 1];
            }
            if(ApexPages.CurrentPage().getParameters() != null && 
               ApexPages.CurrentPage().getParameters().get('region') != null && 
               ApexPages.CurrentPage().getParameters().get('zone') != null){
                region = ApexPages.CurrentPage().getParameters().get('region');
                zone = ApexPages.CurrentPage().getParameters().get('zone');
            }else {
                //region = 'LPP ' + u.LPP_Region_Zone__c;
                region = u.LPP_Region_Zone__c;
                zone = u.LPP_Zone__c;
            }
            if(region != null) {
                regionDisplay = region.replace('LPP ', '');     
            }  
            if(zone != null && zone.trim() != ''){
                invalidProfile = false;
                ableToFindDataWithUserId = true; 

            } else {
                invalidProfile = true;
                ableToFindDataWithUserId = false;
            }
            //currentLoggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() LIMIT 1].Name;
            //System.debug('USer Name => '+u.Name);

            //Map<Id,User> storeUserMap = new Map<Id,User>();
            //storeUserMap = new Map<Id,User>([SELECT Id, Name,ManagerId, Title, LPP_Store__c,ProfileId,Qlik_LPP_Zone__c
            //                                 FROM USER 
            //                                 Where Title='Store Manager' 
            //                                 AND ManagerId = :u.Id AND IsActive=true
            //                                 ORDER BY NAME ASC]); 
            //System.debug('storeUserMap==>'+storeUserMap.Size());
            //Map<String,Id> storeUserIdMap = new Map<String, Id>();
            //Map<String,Set<Id>> storeUserIdListMap = new Map<String, Set<Id>>();
            
            //Map<Id,UserScorecardWrapper> UserScorecardWrapperMap = new Map<Id, UserScorecardWrapper>();
            //Map<Id,UserContactWrapper> UserContactWrapperMap = new Map<Id, UserContactWrapper>();
            //Map<Id,UserEventWrapper> UserEventWrapperMap = new Map<Id, UserEventWrapper>();
            
            //userOppScoreWrapList = new List<UserScorecardWrapper>();
            //userContactWrapList = new List<UserContactWrapper>();
            //userEventWrapList = new List<UserEventWrapper>();
            /* 
            for(String userId : storeUserMap.KeySet()){
                UserScorecardWrapper uwScorecard = new UserScorecardWrapper();
                uwScorecard.scorecardUserId = storeUserMap.get(userId).Id;
                uwScorecard.scorecardUserName = storeUserMap.get(userId).Name;
                uwScorecard.scorecardMonthUpdatedCount = 0;
                uwScorecard.scorecardYearUpdatedCount = 0;
                UserScorecardWrapperMap.put(userId,uwScorecard);
                //For Contact
                UserContactWrapper uwContact = new UserContactWrapper();
                uwContact.contactUserId = storeUserMap.get(userId).Id;
                uwContact.contactUserName = storeUserMap.get(userId).Name;
                uwContact.contactMonthUpdatedCount = 0;
                uwContact.contactYearUpdatedCount = 0;
                uwContact.contactMonthCreatedCount = 0;
                uwContact.contactYearCreatedCount = 0;
                UserContactWrapperMap.put(userId,uwContact);
                
                //For Event
                UserEventWrapper uwEvent = new UserEventWrapper();
                uwEvent.eventUserId = storeUserMap.get(userId).Id;
                uwEvent.eventUserName = storeUserMap.get(userId).Name;
                uwEvent.eventMonthCreatedCount = 0;
                uwEvent.eventYearCreatedCount = 0;
                UserEventWrapperMap.put(userId,uwEvent);    
            }
            */
        } catch(Exception e){
            System.debug('Exception:::'+e.getMessage());
            System.debug('Exception:::'+e.getLineNumber());
        }
        if(!invalidProfile){
            try {
                              
                
                   
                   
                   
             List<User> zoneManager = [
                  SELECT Id, Name 
                  FROM User 
                   WHERE (LPP_Region_Zone__c = :regionDisplay OR Qlik_LPP_Region_Zone__c = :region)
                       AND (LPP_Zone__c = :zone OR Qlik_LPP_Zone__c = :zone)
                   AND (LPP_Store__c = NULL OR LPP_Store__c = 'All')
                       AND (Profile.Name LIKE '%LPP Store_Zone Mgr%' OR Profile.Name LIKE '%LPP ZM/AZM%')                      
                       ];
               if(zoneManager != null && zoneManager.size() > 0){
                    managerName = zoneManager[0].Name;
                } else {
                    managerName = 'Manager Not Found';
                        }                                                         
                            
         
         
                String queryAccountPlan;
                
                if(Test.isRunningTest()){
                 queryAccountPlan = 'SELECT Dealer__r.OwnerId, MAX(Last_Sales_History_Update__c) date1 FROM Account_Planning__c WHERE Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.OwnerId LIMIT 100';
                } else {
                queryAccountPlan = 'SELECT Dealer__r.OwnerId, MAX(Last_Sales_History_Update__c) date1 FROM Account_Planning__c WHERE Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.OwnerId LIMIT 100';
                }
                
                System.debug('queryAccountPlan:::::'+queryAccountPlan);
                system.debug('here is the value of year ' + String.valueOf(year));
                try {
                    List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
                    System.debug('aggResutsAccountPlan:::::'+aggResutsAccountPlan);
                
                    List<Account_Planning__c> apl = [SELECT Id, Account_Plan_Year__c FROM Account_Planning__C WHERE Dealer__r.OwnerId = :UserInfo.getUserId()];
                
                    
                    if(aggResutsAccountPlan.size() > 0 ) {
                        for(AggregateResult q : aggResutsAccountPlan) {   
                            lastSalesHistoryUpdate = q.get('date1') != null ? date.valueOf((Date)q.get('date1')) : Date.today().addDays(-1); 
                            System.debug('lastSalesHistoryUpdate:::::'+lastSalesHistoryUpdate);
                        }
                    }
                } catch(QueryException e) {
                    // Handle the exception here
                    System.debug('An exception occurred while executing the query: ' + e.getMessage());
                }
                        
                                            
                            
                                          
                    //thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, 
                    //              CY_YTDDLSC__c,CY_YTDOther__c, CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, 
                    //              P2Y_SalesHistory__c,P3Y_SalesHistory__c, PY_SalesHistory__c,
                    //              PY_YTDSales__c,
                    //              LastModifiedDate 
                    //              FROM ExecutiveRollUpMain__c 
                    //              WHERE Year__c =: String.valueOf(year) 
                    //              AND Type__c = 'Zone Manager' 
                    //              AND UserId__c =: Id.ValueOf(u.Id) LIMIT 1];
                thisRecord = [
                    SELECT
                        Year__c,
                        SUM(CY_YTDSales__c) CY_YTDSales__c,
                        SUM(PY_YTDSales__c) PY_YTDSales__c,
                        SUM(PY_SalesHistory__c) PY_SalesHistory__c,
                        SUM(P2Y_SalesHistory__c) P2Y_SalesHistory__c,
                        SUM(P3Y_SalesHistory__c) P3Y_SalesHistory__c,
                        SUM(CY_SalesForecast__c) CY_SalesForecast__c,
                        SUM(CY_YTDResEquipment__c) CY_YTDResEquipment__c,
                        SUM(CY_YTDCommercial__c) CY_YTDCommercial__c,
                        SUM(CY_YTDPartsAndSupplies__c) CY_YTDPartsAndSupplies__c,
                        SUM(CY_YTDDLSC__c) CY_YTDDLSC__c,
                        SUM(CY_YTDElite__c) CY_YTDElite__c,
                        SUM(CY_YTDMerit__c) CY_YTDMerit__c,
                        SUM(CY_YTDAireFlo__c) CY_YTDAireFlo__c,
                        SUM(CY_YTDOther__c) CY_YTDOther__c,
                        SUM(PY_YTDDLSC__c) PY_YTDDLSC__c,
                        SUM(PY_YTDElite__c) PY_YTDElite__c,
                        SUM(PY_YTDMerit__c) PY_YTDMerit__c,
                        SUM(PY_YTDAireFlo__c) PY_YTDAireFlo__c,
                        SUM(PY_YTDOther__c) PY_YTDOther__c,
                        MAX(Last_Sales_History_Update__c) LastModifiedDate
                    FROM ExecutiveRollUpMain__c 
                    WHERE Year__c =: String.valueOf(year) 
                        AND Type__c LIKE 'Store Summary%'
                        AND Region__c = :region
                        AND Zone__c = :zone
                        //AND KPI_OppScorecards__c = null
                    GROUP BY Year__c 
                    LIMIT 1];                                 
                ableToFindDataWithUserId = true; 
            } catch (Exception e){
                ableToFindDataWithUserId = false;
            }
        }
        if(ableToFindDataWithUserId)
        {
            System.debug('thisRecord==>'+thisRecord);
            previousYearTotalSales = 0;
            previousTwoYearsTotalSales = 0;
            previousThreeYearsTotalSales = 0;

            presentYearSalesForecast = 0;
            ytdSales = 0;
            previousYearsYTDSales = 0;
            
            ytdSalesChange = 0;
            ytdResEquipment = 0;
            ytdCommercials = 0;
            ytdPartsndSupplies = 0; 

            map<String, String> mapStoreName = getStoreName(zone);
            //ytdSalesTSA = 0;
            //previousYearsYTDSalesTSA = 0; 
            try { 
                //DateTime dt = (DateTime)thisRecord.get('LastModifiedDate');
                
                 //lastSalesHistoryUpdate = dt != null ? Date.newInstance(dt.year(), dt.month(), dt.day()) : Date.today().addDays(-1);
                //lastSalesHistoryUpdate = Date.newInstance(dt.year(), dt.month(), dt.day());
                
                
                
                
                
                previousYearTotalSales = (decimal)thisRecord.get('PY_SalesHistory__c');
                previousTwoYearsTotalSales = (decimal)thisRecord.get('P2Y_SalesHistory__c');
                previousThreeYearsTotalSales = (decimal)thisRecord.get('P3Y_SalesHistory__c'); 
                
                presentYearSalesForecast = (decimal)thisRecord.get('CY_SalesForecast__c');
                ytdSales = (decimal)thisRecord.get('CY_YTDSales__c');
                previousYearsYTDSales = (decimal)thisRecord.get('PY_YTDSales__c');
                
                ytdSalesChange = (decimal)thisRecord.get('CY_YTDSales__c') - (decimal)thisRecord.get('PY_YTDSales__c');
                ytdResEquipment = (decimal)thisRecord.get('CY_YTDResEquipment__c');
                ytdCommercials = (decimal)thisRecord.get('CY_YTDCommercial__c');
                ytdPartsndSupplies = (decimal)thisRecord.get('CY_YTDPartsAndSupplies__c');

                changeDLSC = 0;
                changeMerit = 0;
                changeElite = 0;
                changeOther = 0;   
                currentYearDLSC = (decimal)thisRecord.get('CY_YTDDLSC__c');
                currentYearDLSCPercent = ytdSales == 0 ? 0 : currentYearDLSC / ytdSales;
                currentYearMerit = (decimal)thisRecord.get('CY_YTDMerit__c');
                currentYearMeritPercent = ytdSales == 0 ? 0 : currentYearMerit / ytdSales;
                currentYearElite = (decimal)thisRecord.get('CY_YTDElite__c');
                currentYearElitePercent = ytdSales == 0 ? 0 : currentYearElite / ytdSales;
                currentYearAireFlo = (decimal)thisRecord.get('CY_YTDAireFlo__c');
                currentYearOther = currentYearAireFlo + (decimal)thisRecord.get('CY_YTDOther__c');
                currentYearOtherPercent = ytdSales == 0 ? 0 : currentYearOther / ytdSales;
                if(previousYearsYTDSales == null) previousYearsYTDSales = 0; 
                previousYearDLSC = (decimal)thisRecord.get('PY_YTDDLSC__c');
                previousYearDLSCPercent = previousYearsYTDSales == 0 ? 0 : previousYearDLSC / previousYearsYTDSales;
                previousYearMerit = (decimal)thisRecord.get('PY_YTDMerit__c');
                previousYearMeritPercent = previousYearsYTDSales == 0 ? 0 : previousYearMerit / previousYearsYTDSales;
                previousYearElite = (decimal)thisRecord.get('PY_YTDElite__c');
                previousYearElitePercent = previousYearsYTDSales == 0 ? 0 : previousYearElite / previousYearsYTDSales;
                previousYearAireFlo = (decimal)thisRecord.get('PY_YTDAireFlo__c');
                previousYearOther = previousYearAireFlo + (decimal)thisRecord.get('PY_YTDOther__c');
                previousYearOtherPercent = previousYearsYTDSales == 0 ? 0 : previousYearOther / previousYearsYTDSales ;
                changeDLSC =  previousYearDLSC == null ? currentYearDLSC : currentYearDLSC - previousYearDLSC;
                changeMerit = previousYearMerit == null ? currentYearMerit : currentYearMerit - previousYearMerit;
                changeElite = previousYearElite == null ? currentYearElite : currentYearElite - previousYearElite; 
                changeOther = previousYearOther == null ? currentYearOther : currentYearOther - previousYearOther;                

                allStoreRecords = new List<ExecutiveRollUpChildWrapper>();
                //allTSAStoreRecords = new List<ExecutiveRollUpChildWrapper>(); 
                List<ExecutiveRollUpChild__c> childStoreRecords = new List<ExecutiveRollUpChild__c>();
                for(AggregateResult child : [SELECT 
                                                 Store__c, 
                                                 SUM(CY_YTDSales__c) CY_YTDSales__c, 
                                                 SUM(PY_YTDSales__c) PY_YTDSales__c
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'  
                                                 AND Region__c = :region
                                                 AND Zone__c = :zone
                                                 //AND KPI_OppScorecards__c = null
                                                 AND Store__c != ''
                                                 AND Store__c != null
                                                 AND Store__c != 'None'
                                             GROUP BY Store__c
                                             ORDER BY SUM(YTDSalesChange__c) DESC]){
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = '/apex/StoreAccountPlanAggregateVF?year=' + year + 
                        '&store=' + (String)child.get('Store__c') +
                        '&u=' + currentLoggedInUser; 
                    String storeNumber = (String)child.get('Store__c');
                    childWrapper.store = mapStoreName.containsKey(storeNumber) ? mapStoreName.get(storeNumber) : storeNumber;
                    childWrapper.CYYTDSales = (Decimal)child.get('CY_YTDSales__c');
                    childWrapper.PYYTDSales = (Decimal)child.get('PY_YTDSales__c');
                    allStoreRecords.add(childWrapper);  
                }

                for(AggregateResult child : [SELECT 
                                                 SUM(CY_YTDSales__c) CY_YTDSales__c, 
                                                 SUM(PY_YTDSales__c) PY_YTDSales__c
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'
                                                 AND Region__c = :region
                                                 AND Zone__c = :zone  
                                                 //AND KPI_OppScorecards__c = null
                                                 AND (Store__c = '' 
                                                     OR Store__c = null
                                                     OR Store__c = 'None')]){
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = '';
                    childWrapper.store = 'Non Store Accounts';
                    childWrapper.CYYTDSales = (Decimal)child.get('CY_YTDSales__c');
                    childWrapper.PYYTDSales = (Decimal)child.get('PY_YTDSales__c');
                    allStoreRecords.add(childWrapper);  
                }                

                storeKPIList = new List<storeKPI>();
                totalKPIScoreCards = 0;
                totalKPIContacts = 0;
                totalKPIPhoneCalls = 0;
                for(AggregateResult child : [SELECT 
                                                 Store__c, 
                                                 SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                                                 SUM(KPI_Contacts__c) KPI_Contacts__c,
                                                 SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'
                                                 AND Region__c = :region  
                                                 AND Zone__c = :zone
                                                 //AND KPI_OppScorecards__c != null
                                                 AND Store__c != ''
                                                 AND Store__c != null
                                                 AND Store__c != 'None'
                                             GROUP BY Store__c
                                             ORDER BY Store__c]){
                    storeKPI childWrapper = new storeKPI();
                    childWrapper.URLText = '/apex/StoreAccountPlanAggregateVF?year=' + year + 
                        '&store=' + (String)child.get('Store__c') +
                        '&u=' + currentLoggedInUser;                     
                    String storeNumber = (String)child.get('Store__c');
                    childWrapper.store = mapStoreName.containsKey(storeNumber) ? mapStoreName.get(storeNumber) : storeNumber;                                   
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c'));  
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                        
                    storeKPIList.add(childWrapper);  
                }

                for(AggregateResult child : [SELECT 
                                                 SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                                                 SUM(KPI_Contacts__c) KPI_Contacts__c,
                                                 SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'
                                                 AND Region__c = :region  
                                                 AND Zone__c = :zone
                                                 //AND KPI_OppScorecards__c != null
                                                 AND (Store__c = '' 
                                                     OR Store__c = null
                                                     OR Store__c = 'None')]){
                    storeKPI childWrapper = new storeKPI();
                    childWrapper.store = 'Non Store Accounts';
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c')); 
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                         
                    storeKPIList.add(childWrapper);  
                }

                Set<Id> userAndGroupIdSet = getUserOrGroupIdsForCurrentUserAndSpecificRole();
                Set<Id> favoritesIdSet = new Set<Id>();
                for (Favorites__Share favoritesShare : [
                    SELECT Id, ParentId
                    FROM Favorites__Share 
                    WHERE UserOrGroupId IN :userAndGroupIdSet
                ]) {
                    favoritesIdSet.add(favoritesShare.ParentId);
                }
                favoritesList = new List<Favorites__c>(); 
                for(Favorites__c favoriteRecord : [
                    SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c
                    FROM Favorites__c
                    WHERE Category__c = 'Reports/Dashboards'
                        AND Favorites_URL__c != NULL 
                        AND Id IN :favoritesIdSet
                        AND Show_On_Home_Page__c = true 
                    ORDER BY Sequence__c ASC]){ 
                    favoritesList.add(favoriteRecord);
                }   
                //List<ExecutiveRollUpChild__c> childTSAStoreRecords = new List<ExecutiveRollUpChild__c>();
                //childStoreRecords = [SELECT Id, URLText__c, Region__c, CY_YTDSales__c, PY_YTDSales__c
                //                    FROM ExecutiveRollUpChild__c
                //                    WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                //                    AND Type__c = 'Store Manager' 
                //                    ORDER BY CY_YTDSales__c DESC ];
                //for(ExecutiveRollUpChild__c child: childStoreRecords){
                //    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                //    childWrapper.URLText = child.URLText__c;
                //    childWrapper.Region = child.Region__c;
                //    childWrapper.CYYTDSales = child.CY_YTDSales__c;
                //    childWrapper.PYYTDSales = child.PY_YTDSales__c;
                //    allStoreRecords.add(childWrapper);  
                //}
                /*
                childTSAStoreRecords = [SELECT Id, URLText__c, Region__c, 
                                        CY_YTDSales__c, PY_YTDSales__c
                                        FROM ExecutiveRollUpChild__c
                                        WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                                        AND Type__c = 'Store Manager TSA'  
                                        ORDER BY CY_YTDSales__c DESC ];   
                for(ExecutiveRollUpChild__c tsaChild: childTSAStoreRecords){ 
                    ytdSalesTSA += tsaChild.CY_YTDSales__c ;
                    previousYearsYTDSalesTSA += tsaChild.PY_YTDSales__c;    
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = tsaChild.URLText__c;
                    childWrapper.Region = tsaChild.Region__c;
                    childWrapper.CYYTDSales = tsaChild.CY_YTDSales__c;
                    childWrapper.PYYTDSales = tsaChild.PY_YTDSales__c;
                    allTSAStoreRecords.add(childWrapper); 
                }                
                
                //Opportunity Scorecards, Contact and Outbound Phone Calls record count
                Map<Id, User> CounterSalesAssociateMap = new Map<Id, User> ([SELECT Id, Name, Title, LPP_Store__c,
                                                                                ProfileId,ManagerId 
                                                                                FROM USER 
                                                                                Where Id IN:storeUserMap.keySet() 
                                                                                OR (Title= 'Counter Sales Associate'   
                                                                                AND ManagerId = :storeUserMap.keySet()
                                                                                AND IsActive=true)]);
                System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap.Size()); 
                System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap); 
                processRecordCounts(CounterSalesAssociateMap,UserScorecardWrapperMap,UserContactWrapperMap,UserEventWrapperMap); 
                */
            } catch(Exception e) {
                System.debug('Exception:::'+e.getMessage());
                System.debug('Exception:::'+e.getLineNumber());
            }                
        }
    }
    
    /*
    public void processRecordCounts( Map<Id,User> CounterSalesAssociateMap, Map<Id,UserScorecardWrapper> UserScorecardWrapperMap,
                                    Map<Id,UserContactWrapper> UserContactWrapperMap,Map<Id,UserEventWrapper> UserEventWrapperMap ){
        Integer currentMonth = Date.Today().Month();
        
        List<AggregateResult> aggregateYearScorecardList = [SELECT Count(Id),LastModifiedById
                                                            FROM Scorecard__c
                                                            WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                            GROUP BY LastModifiedById];
        List<AggregateResult> aggregateMonthScorecardList = [SELECT Count(Id),LastModifiedById
                                                             FROM Scorecard__c
                                                             WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                             AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                             AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                             GROUP BY LastModifiedById];
        for(AggregateResult agg :aggregateYearScorecardList){
            String associatUserId = (String)agg.get('LastModifiedById');
            UserScorecardWrapper scorecard ;
            if(!UserScorecardWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                scorecard = UserScorecardWrapperMap.get(ManagerId);
            }else{
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }
            scorecard.scorecardYearUpdatedCount  += (Integer)agg.get('expr0');
        }  
        for(AggregateResult agg :aggregateMonthScorecardList){
            UserScorecardWrapper scorecard;
            String associatUserId = (String)agg.get('LastModifiedById');
            if(!UserScorecardWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                scorecard = UserScorecardWrapperMap.get(ManagerId);
            }else{
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }
            scorecard.scorecardMonthUpdatedCount  += (Integer)agg.get('expr0'); 
        }
        
        userOppScoreWrapList.addAll(UserScorecardWrapperMap.values());
        //userOppScoreWrapList.sort();
        List<AggregateResult> aggregateYearContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                FROM Contact
                                                                WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                GROUP BY LastModifiedById];
                                        
        List<AggregateResult> aggregateMonthContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                 FROM Contact
                                                                 WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                                 AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY LastModifiedById];
        List<AggregateResult> aggregateYearContactCreateList = [SELECT Count(Id),CreatedById
                                                                FROM Contact
                                                                WHERE CreatedById IN :CounterSalesAssociateMap.keySet() AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                GROUP BY CreatedById];
        List<AggregateResult> aggregateMonthContactCreateList = [SELECT Count(Id),CreatedById
                                                                 FROM Contact
                                                                 WHERE CreatedById IN :CounterSalesAssociateMap.keySet() 
                                                                 AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY CreatedById];
        
        
        for(AggregateResult agg :aggregateYearContactUpdateList){
            String associatUserId = (String)agg.get('LastModifiedById');
            UserContactWrapper contactUpdated ;
            if(!UserContactWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                contactUpdated = UserContactWrapperMap.get(ManagerId);
            }else{
                contactUpdated = UserContactWrapperMap.get(associatUserId);
            }
            contactUpdated.contactYearUpdatedCount  += (Integer)agg.get('expr0');
        }
        for(AggregateResult agg :aggregateMonthContactUpdateList){
            String associatUserId = (String)agg.get('LastModifiedById');
            UserContactWrapper contactUpdated ;
            if(!UserContactWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                contactUpdated = UserContactWrapperMap.get(ManagerId);
            }else{
                contactUpdated = UserContactWrapperMap.get(associatUserId);
            }
            contactUpdated.contactMonthUpdatedCount  += (Integer)agg.get('expr0');
        }
        
        for(AggregateResult agg :aggregateYearContactCreateList){
            String associatUserId = (String)agg.get('CreatedById');
            UserContactWrapper contactUpdated ;
            if(!UserContactWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                contactUpdated = UserContactWrapperMap.get(ManagerId);
            }else{
                contactUpdated = UserContactWrapperMap.get(associatUserId);
            }
            contactUpdated.contactYearCreatedCount  += (Integer)agg.get('expr0');
        }
        for(AggregateResult agg :aggregateMonthContactCreateList){
            String associatUserId = (String)agg.get('CreatedById');
            UserContactWrapper contactUpdated ;
            if(!UserContactWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                contactUpdated = UserContactWrapperMap.get(ManagerId);
            }else{
                contactUpdated = UserContactWrapperMap.get(associatUserId);
            }
            contactUpdated.contactMonthCreatedCount  += (Integer)agg.get('expr0'); 
        }
                                        
        userContactWrapList.addAll(UserContactWrapperMap.values());
        
        List<AggregateResult> aggregateYearEventCreateList = [SELECT Count(Id),OwnerId
                                                              FROM Event
                                                              WHERE OwnerId IN :CounterSalesAssociateMap.keySet() AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                              AND Event_TYpe__c ='Phone Call - Outbound'
                                                              GROUP BY OwnerId];
        List<AggregateResult> aggregateMonthEventCreateList = [SELECT Count(Id),OwnerId
                                                               FROM Event
                                                               WHERE OwnerId IN :CounterSalesAssociateMap.keySet() 
                                                               AND Event_TYpe__c ='Phone Call - Outbound'
                                                               AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                               AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                               GROUP BY OwnerId];  
        
        for(AggregateResult agg :aggregateYearEventCreateList){
            String associatUserId = (String)agg.get('OwnerId');
            UserEventWrapper event ;
            if(!UserEventWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                event = UserEventWrapperMap.get(ManagerId);
            }else{
                event = UserEventWrapperMap.get(associatUserId);   
            } 
            event.eventYearCreatedCount  += (Integer)agg.get('expr0');
        }
        for(AggregateResult agg :aggregateMonthEventCreateList){
            String associatUserId = (String)agg.get('OwnerId');
            UserEventWrapper event ;
            if(!UserEventWrapperMap.containsKey(associatUserId)){
                String ManagerId = CounterSalesAssociateMap.get(associatUserId).ManagerId; 
                event = UserEventWrapperMap.get(ManagerId);
            }else{
                event = UserEventWrapperMap.get(associatUserId); 
            }
            event.eventMonthCreatedCount  += (Integer)agg.get('expr0');
        }
        userEventWrapList.addAll(UserEventWrapperMap.values()); 
    }
    */
    /*
    // User Scorecard__c
    public class UserScorecardWrapper {   
        public string scorecardUserId{get; set;}
        public string scorecardUserName{get;set;}
        public integer scorecardMonthUpdatedCount{get;set;}
        public integer scorecardYearUpdatedCount{get;set;}
        
    }
    // User Contact and Event List
    public class UserContactWrapper{
        public string contactUserId{get; set;}
        public string contactUserName{get;set;}
        public integer contactMonthUpdatedCount{get;set;}
        public integer contactYearUpdatedCount{get;set;}
        public integer contactMonthCreatedCount{get;set;}
        public integer contactYearCreatedCount{get;set;}
    }
     // User Event List
    public class UserEventWrapper{
        public string eventUserId{get; set;}
        public string eventUserName{get;set;}
        public integer eventMonthCreatedCount{get;set;}
        public integer eventYearCreatedCount{get;set;}
    }
    */

    private map<String, String> getStoreName(String zone){
        Map<String, String> mapAccountStoreName = new Map<String, String>();
        for(AggregateResult a : [SELECT LPP_Plant_Code__c c1, Main_LPP_Store__c c2, Count(Id) c3
                                    FROM Account
                                    WHERE LPP_Zone__c = :zone
                                        AND Main_LPP_Store__c != NULL
                                    GROUP BY LPP_Plant_Code__c, Main_LPP_Store__c]){
            String storeNumber = (String)a.get('c1');
            String storeName = (String)a.get('c2');
            if(storeNumber != null && storeNumber != '' && storeName != null && storeName.contains(storeNumber)) {
                storeName = storeNumber + storeName.substringAfter(storeNumber);
                mapAccountStoreName.put(storeNumber, storeName);
            }
        }    
        return mapAccountStoreName;
    }
    private Set<Id> getUserOrGroupIdsForCurrentUserAndSpecificRole() {
        set<Id> ids = new set<Id>();

        User u = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        ids.add(u.Id);

        for (List<Group> groups : [SELECT Id FROM Group WHERE RelatedId = :u.UserRoleId]) {
            for (Group g : groups) {
                ids.add(g.Id);
            }
        }

        for (List<GroupMember> members : [SELECT Id, GroupId FROM GroupMember WHERE UserOrGroupId = :ids AND (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')]) {
            for (GroupMember gm : members) {
                ids.add(gm.GroupId);
            }
        }

        return ids;    
    }

    // User ExecutiveRollUpChild
    public class ExecutiveRollUpChildWrapper{
        public string URLText{get; set;}
        public string store{get;set;}
        public Decimal CYYTDSales{get;set;}
        public Decimal PYYTDSales{get;set;}
    }
    
    public class storeKPI
    {
        public string URLText{get; set;}
        public string store{get;set;}
        public integer opportunityScoreCard{get;set;}
        public integer contacts{get;set;}
        public integer outboundPhoneCalls{get;set;}
    }          
}