/********************************************************
Developer : Ganesh Mahajan DWS 27/12/2021
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class storeAggregate
{
//variable declarations
    public List<Favorites__c> favoritesList{get; set;}
    public string currentLoggedInUser{get; set;}
    //public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public User u{get; set;}
    //private List<User> tmUsers{get; set;}
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
   
    public Date lastSalesHistoryUpdate{get; set;}

    //variable for Dealer Sales History
    public decimal previousYearTotalSales{get; set;}
    public decimal previousTwoYearsTotalSales{get; set;}
    public decimal previousThreeYearsTotalSales{get; set;}

    //variable for YTD Sales Comparison
    public decimal presentYearSalesForecast{get; set;}
    public decimal ytdSales{get; set;}
    public decimal previousYearsYTDSales{get; set;}

    //variable for YTD Sales - Product Hierarchy
    public decimal ytdSalesChange{get; set;}
    public decimal ytdResEquipment{get; set;}
    public decimal ytdCommercials{get; set;}
    public decimal ytdPartsndSupplies{get; set;}

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


    //public decimal ytdSalesTSA{get; set;}
    //public decimal previousYearsYTDSalesTSA{get; set;}
    
    public AggregateResult thisRecord {get; set;}
    public List<ExecutiveRollUpChildWrapper> allRegionRecords {get; set;}
    public List<regionKPI> regionKPIList {get;set;}
    public decimal ytdSalesRegionTotal {get;set;}
    public decimal pyYTDSalesRegionTotal {get;set;}
    public Integer totalKPIScoreCards {get;set;}
    public Integer totalKPIContacts {get;set;}
    public Integer totalKPIPhoneCalls {get;set;}

    //public List<ExecutiveRollUpChildWrapper> allTSARegionRecords {get; set;}
    //public List<UserScorecardWrapper> userOppScoreWrapList{get; set;}
    //public List<UserContactWrapper> userContactWrapList{get; set;}
    //public List<UserEventWrapper> userEventWrapList{get; set;}
    
    //public Map<Id,Integer> monthUpdatedScoreCount = new Map<Id,Integer>();
    //public Map<Id,Integer> yearUpdatedScoreCount = new Map<Id,Integer>();
    //public Map<Id,Integer> monthUpdatedContactCount = new Map<Id,Integer>();
    //public Map<Id,Integer> yearUpdatedContactCount = new Map<Id,Integer>();
    //public Map<Id,Integer> monthCreatedContactCount = new Map<Id,Integer>();
    //public Map<Id,Integer> yearCreatedContactCount = new Map<Id,Integer>();
    //public Map<Id,Integer> monthCreatedEventCount = new Map<Id,Integer>();
    //public Map<Id,Integer> yearCreatedEventCount = new Map<Id,Integer>();
    public String renderPDF {get; set;}
    public String pdfLink {get; set;}
    public Pagereference cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    
    public storeAggregate()
        
    {
        system.debug(       '+++++++++first debug loggg+++++++++++++'       );
        Map<String, String> mapRegionManager = new Map<String, String>();
        currentLoggedInUser = userinfo.getUserId();
        u = [SELECT Id, Name FROM User WHERE Id = :currentLoggedInUser];
        List<String> validProfiles = new List<String>();
        renderPDF = '';
        //Map<Id,UserScorecardWrapper> UserScorecardWrapperMap = new Map<Id, UserScorecardWrapper>();
        //Map<Id,UserContactWrapper> UserContactWrapperMap = new Map<Id, UserContactWrapper>();
        //Map<Id,UserEventWrapper> UserEventWrapperMap = new Map<Id, UserEventWrapper>();
        
        //userOppScoreWrapList = new List<UserScorecardWrapper>();
        //userContactWrapList = new List<UserContactWrapper>();
        //userEventWrapList = new List<UserEventWrapper>();
        try
        {
            //get the year value from url and calculate 2pyrs, 1pyr, 3pyr values
            if(ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().get('year') != null)
            {
                year = integer.valueOf(ApexPages.CurrentPage().getParameters().get('year'));
                preYear = year -1;
                preTwoYear = year - 2;
                preThreeYear = year - 3;
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Year Value Missing.'));
                return;
            }
            if(ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().get('pdf') != null)
            {
                if(ApexPages.CurrentPage().getParameters().get('pdf') == 'true')
                {
                    renderPDF = 'PDF';
                }
            }
            
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String pageURL = ApexPages.currentPage().getUrl();
            
            if(renderPDF == ''){
                pageURL += '&pdf=true';
            }
            pdfLink = baseURL + pageURL;
        } 
        catch(Exception e){ 
            System.debug('Error Obtaining Year -'+e.getMessage()); 
            return; 
        }
    
        System.debug('##### Start Query #####');
        Boolean ableToFindDataWithUserId = true;
        try {
            //thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, CY_YTDDLSC__c, 
            //              CY_YTDElite__c, CY_YTDMerit__c, CY_YTDOther__c,
            //              CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, P2Y_SalesHistory__c, 
            //              P3Y_SalesHistory__c, PY_SalesHistory__c,
            //              PY_YTDAireFlo__c, PY_YTDDLSC__c, PY_YTDElite__c, PY_YTDMerit__c, PY_YTDOther__c, 
            //              PY_YTDSales__c,LastModifiedDate 
            //              FROM ExecutiveRollUpMain__c 
            //              WHERE Year__c =: String.valueOf(year) 
            //              AND Type__c = 'Store Executive'  LIMIT 1];
            for (User u : [SELECT Name, SAP_Sales_District__c FROM User WHERE Profile.Name LIKE '%AM%' AND isActive = true AND SAP_Sales_District__c != NULL AND SAP_Sales_District__c != '']){
                mapRegionManager.put(u.SAP_Sales_District__c, u.Name);     
            }       
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
                    //AND KPI_OppScorecards__c = null
                GROUP BY Year__c 
                LIMIT 1];
            ableToFindDataWithUserId = true;
        } catch(Exception e)
        {
            ableToFindDataWithUserId = false;
        }  
        
        //ytdSalesTSA = 0;
        //previousYearsYTDSalesTSA = 0;        
        if(ableToFindDataWithUserId){
            try{
                System.debug('Record Found: '+thisRecord);
                
                
                        
                
                
                                
               // DateTime dt = (DateTime)thisRecord.get('LastModifiedDate');                           
              // lastSalesHistoryUpdate = Date.newInstance(dt.year(), dt.month(), dt.day());
               
               
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

                allRegionRecords = new List<ExecutiveRollUpChildWrapper>();
                //allTSARegionRecords = new List<ExecutiveRollUpChildWrapper>();
                //List<ExecutiveRollUpChild__c> childRegionRecords = new List<ExecutiveRollUpChild__c>();
                //List<ExecutiveRollUpChild__c> childTSARegionRecords = new List<ExecutiveRollUpChild__c>();
                //childRegionRecords = [SELECT Id, URLText__c, Region__c, CY_YTDSales__c, PY_YTDSales__c
                //                      FROM ExecutiveRollUpChild__c
                //                      WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                //                      AND Type__c = 'Region Zone Manager' 
                //                      ORDER BY CY_YTDSales__c DESC ];
                ytdSalesRegionTotal = 0;
                pyYTDSalesRegionTotal = 0;
                for(AggregateResult child : [
                        SELECT 
                            Region__c, 
                            SUM(CY_YTDSales__c) CY_YTDSales__c, 
                            SUM(PY_YTDSales__c) PY_YTDSales__c
                        FROM ExecutiveRollUpMain__c
                        WHERE Year__c =: String.valueOf(year) 
                            AND Type__c LIKE 'Store Summary%'
                            //AND KPI_OppScorecards__c = null
                            AND Region__c != ''
                            AND Region__c != null
                            //AND Store__c != ''
                            //AND Store__c != null
                            //AND Store__c != 'None'
                        GROUP BY Region__c
                        ORDER BY SUM(YTDSalesChange__c) DESC]){
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = '/apex/RegionZoneManagerAggregateVF?year=' + year + 
                        '&region=' + (String)child.get('Region__c') +
                        '&u=' + currentLoggedInUser; 
                    childWrapper.Region = (String)child.get('Region__c');
                    if(childWrapper.Region == null || childWrapper.Region == ''){
                        childWrapper.Region = 'Unspecified Region';
                    } else if(mapRegionManager.containsKey(childWrapper.Region)){
                        childWrapper.Region = childWrapper.Region + ' - ' + mapRegionManager.get(childWrapper.Region);
                    }     
                    childWrapper.Region = childWrapper.Region.replace('LPP ', '');
                    childWrapper.CYYTDSales = (Decimal)child.get('CY_YTDSales__c');
                    childWrapper.PYYTDSales = (Decimal)child.get('PY_YTDSales__c');
                    allRegionRecords.add(childWrapper);  
                    ytdSalesRegionTotal += childWrapper.CYYTDSales == null ? 0 : childWrapper.CYYTDSales;
                    pyYTDSalesRegionTotal += childWrapper.PYYTDSales == null ? 0 : childWrapper.PYYTDSales;
                }
                
                
                
                
                
                //
                
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
                        
                            // Calculate the average of all the Account Plans associated with the Dealer for present/previous years
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
                        
                
                
                
                
                
                
                
                
                
                
                /*
                for(AggregateResult child : [
                        SELECT 
                            SUM(CY_YTDSales__c) CY_YTDSales__c, 
                            SUM(PY_YTDSales__c) PY_YTDSales__c
                        FROM ExecutiveRollUpMain__c
                        WHERE Year__c =: String.valueOf(year) 
                            AND Type__c LIKE 'Store Summary%'  
                            //AND KPI_OppScorecards__c = null
                            //AND (Store__c = '' 
                            //    OR Store__c = null
                            //    OR Store__c = 'None'
                            //    OR Region__c = ''
                            //    OR Region__c = null)]){
                            AND (Region__c = ''
                                OR Region__c = null)]){                                    
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = '';
                    childWrapper.Region = 'Non Store Accounts';
                    childWrapper.CYYTDSales = (Decimal)child.get('CY_YTDSales__c');
                    childWrapper.PYYTDSales = (Decimal)child.get('PY_YTDSales__c');
                    allRegionRecords.add(childWrapper);  
                }                
                */
                regionKPIList = new List<regionKPI>();
                totalKPIScoreCards = 0;
                totalKPIContacts = 0;
                totalKPIPhoneCalls = 0;
                for(AggregateResult child : [
                        SELECT 
                            Region__c, 
                            SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                            SUM(KPI_Contacts__c) KPI_Contacts__c,
                            SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                        FROM ExecutiveRollUpMain__c
                        WHERE Year__c =: String.valueOf(year) 
                            AND Type__c LIKE 'Store Summary%'  
                            //AND KPI_OppScorecards__c != null
                            AND Region__c != ''
                            AND Region__c != null
                            //AND Store__c != ''
                            //AND Store__c != null
                        GROUP BY Region__c
                        ORDER BY Region__c]){
                    regionKPI childWrapper = new regionKPI();
                    childWrapper.URLText = '/apex/RegionZoneManagerAggregateVF?year=' + year + 
                        '&region=' + (String)child.get('Region__c') +
                        '&u=' + currentLoggedInUser;                     
                    childWrapper.Region = (String)child.get('Region__c');
                    if(childWrapper.Region == null || childWrapper.Region == ''){
                        childWrapper.Region = 'Unspecified Region';
                    } else if(mapRegionManager.containsKey(childWrapper.Region)){
                        childWrapper.Region = childWrapper.Region + ' - ' + mapRegionManager.get(childWrapper.Region);
                    }                
                    childWrapper.Region = childWrapper.Region.replace('LPP ', '');
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c'));  
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                         
                    regionKPIList.add(childWrapper);  
                }
                /*
                for(AggregateResult child : [
                        SELECT 
                            SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                            SUM(KPI_Contacts__c) KPI_Contacts__c,
                            SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                        FROM ExecutiveRollUpMain__c
                        WHERE Year__c =: String.valueOf(year) 
                            AND Type__c LIKE 'Store Summary%'  
                            //AND KPI_OppScorecards__c != null
                            //AND (Store__c = '' 
                            //    OR Store__c = null
                            //    OR Region__c = ''
                            //    OR Region__c = null)]){
                            AND (Region__c = ''
                                OR Region__c = null)]){                                   
                    regionKPI childWrapper = new regionKPI();
                    childWrapper.Region = 'Non Store Accounts';
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c')); 
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                      
                    regionKPIList.add(childWrapper);  
                }   
                */
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
                for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c
                                                FROM Favorites__c
                                                WHERE Category__c = 'Reports/Dashboards'
                                                    AND Favorites_URL__c != NULL 
                                                    AND Id IN :favoritesIdSet
                                                    AND Show_On_Home_Page__c = true 
                                                ORDER BY Sequence__c ASC]){ 
                    favoritesList.add(favoriteRecord);
                }
                //childTSARegionRecords = [SELECT Id, URLText__c, Region__c, CY_YTDSales__c, PY_YTDSales__c
                //                       FROM ExecutiveRollUpChild__c
                //                       WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                //                       AND Type__c = 'Region Zone Manager TSA' 
                //                       ORDER BY CY_YTDSales__c DESC ];   
                //for(ExecutiveRollUpChild__c tsaChild: childTSARegionRecords){
                //    ytdSalesTSA += tsaChild.CY_YTDSales__c ;
                //    previousYearsYTDSalesTSA += tsaChild.PY_YTDSales__c; 
                //    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                //    childWrapper.URLText = tsaChild.URLText__c;
                //    childWrapper.Region = tsaChild.Region__c;
                //    childWrapper.CYYTDSales = tsaChild.CY_YTDSales__c;
                //    childWrapper.PYYTDSales = tsaChild.PY_YTDSales__c;
                //    allTSARegionRecords.add(childWrapper);  
                //}
                /*
                favoritesList = new List<Favorites__c>();
                
                for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c
                                                   FROM Favorites__c
                                                   WHERE (Category__c != NULL 
                                                          AND Favorites_URL__c != NULL 
                                                          AND Type__c = 'Admin' 
                                                          AND RUS_Assignment__c LIKE '%Executive Store%')
                                                   ORDER BY Sequence__c ASC]){ 
                                                       favoritesList.add(favoriteRecord);
                                                   }
                
                //System.debug('favoritesList==>'+favoritesList); 
                
                Map<Id,User> regionUserMap = new Map<Id,User>([SELECT Id, Name, Title, LPP_Store__c,
                                                               ProfileId,ManagerId
                                                               FROM USER 
                                                               Where UserRole.Name like '%P&S Region Manager%' 
                                                               AND IsActive=true]);
                
                Map<Id,User> zoneUserMap = new Map<Id,User>([SELECT Id, Name, Title, LPP_Store__c,ProfileId ,ManagerId
                                                             FROM USER 
                                                             Where UserRole.Name like '%P&S Zone Manager%' 
                                                             AND ManagerId IN :regionUserMap.keySet() 
                                                             AND IsActive=true]);
                Map<Id,User> storeUserMap = new Map<Id,User>([SELECT Id, Name,ManagerId, Title, LPP_Store__c,ProfileId 
                                                              FROM USER 
                                                              Where Title='Store Manager' 
                                                              AND ManagerId IN :zoneUserMap.keySet() 
                                                              AND IsActive=true]);  
                
                
                for(Id userId : regionUserMap.keySet()){
                    monthUpdatedScoreCount.put(userId,0);
                    yearUpdatedScoreCount.put(userId,0);
                    monthUpdatedContactCount.put(userId,0);
                    yearUpdatedContactCount.put(userId,0);
                    monthCreatedContactCount.put(userId,0);
                    yearCreatedContactCount.put(userId,0);
                    monthCreatedEventCount.put(userId,0);
                    yearCreatedEventCount.put(userId,0);
                    
                    UserScorecardWrapper uwScorecard = new UserScorecardWrapper();
                    uwScorecard.scorecardUserId = userId;
                    uwScorecard.scorecardUserName = regionUserMap.get(userId).Name;
                    uwScorecard.scorecardMonthUpdatedCount = 0;
                    uwScorecard.scorecardYearUpdatedCount = 0;
                    UserScorecardWrapperMap.put(userId,uwScorecard);
                    //For Contact
                    UserContactWrapper uwContact = new UserContactWrapper();
                    uwContact.contactUserId = userId;
                    uwContact.contactUserName = regionUserMap.get(userId).Name;
                    uwContact.contactMonthUpdatedCount = 0;
                    uwContact.contactYearUpdatedCount = 0;
                    uwContact.contactMonthCreatedCount = 0;
                    uwContact.contactYearCreatedCount = 0;
                    UserContactWrapperMap.put(userId,uwContact);
                    
                    //For Event
                    UserEventWrapper uwEvent = new UserEventWrapper();
                    uwEvent.eventUserId = userId;
                    uwEvent.eventUserName = regionUserMap.get(userId).Name;
                    uwEvent.eventMonthCreatedCount = 0;
                    uwEvent.eventYearCreatedCount = 0;
                    UserEventWrapperMap.put(userId,uwEvent);  
                }
                
                //processRecordCounts(regionUserMap,storeUserMap,zoneUserMap);
                Map<Id, User> CounterSalesAssociateMap = new Map<Id, User> ([SELECT Id, Name, Title, LPP_Store__c,
                                                                             ProfileId,ManagerId 
                                                                             FROM USER 
                                                                             Where (Id IN:regionUserMap.keySet()) OR
                                                                             (Id IN:zoneUserMap.keySet()) OR 
                                                                             (Id IN:storeUserMap.keySet()) OR
                                                                             (Title= 'Counter Sales Associate'   
                                                                             AND ManagerId = :storeUserMap.keySet() 
                                                                             AND IsActive=true)]);
                //System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap.Size());  
                //System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap);
                processRecordCounts(regionUserMap,storeUserMap,
                                    zoneUserMap,CounterSalesAssociateMap,
                                    UserScorecardWrapperMap,UserContactWrapperMap,
                                    UserEventWrapperMap);   
                */
            }catch(Exception exp){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exp.getMessage()));
                System.debug('Error Obtaining  -'+exp.getMessage());
                System.debug('Error Obtaining  -'+exp.getLineNumber()); 
            } 
        }
    }  
    /*
    public void processRecordCounts(Map<Id,User> regionUserMap, 
                                    Map<Id,User> storeUserMap, 
                                    Map<Id,User> zoneUserMap, 
                                    Map<Id,User> CounterSalesAssociateMap, 
                                    Map<Id,UserScorecardWrapper> UserScorecardWrapperMap,
                                    Map<Id,UserContactWrapper> UserContactWrapperMap,
                                    Map<Id,UserEventWrapper> UserEventWrapperMap )
    {
        Integer currentMonth = Date.Today().Month();
        
        List<AggregateResult> aggregateYearScorecardList = [SELECT Count(Id),LastModifiedById
                                                            FROM Scorecard__c
                                                            WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                            AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                            GROUP BY LastModifiedById];
        List<AggregateResult> aggregateMonthScorecardList = [SELECT Count(Id),LastModifiedById
                                                             FROM Scorecard__c
                                                             WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                             AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                             AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                             GROUP BY LastModifiedById];
        
        for(AggregateResult agg :aggregateYearScorecardList){
           /* String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserScorecardWrapper scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
            scorecard.scorecardYearUpdatedCount  += (Integer)agg.get('expr0');   */ 
    /*        
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserScorecardWrapper scorecard;
            if(UserScorecardWrapperMap.containsKey(associatUserId)){
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }
            }
            scorecard.scorecardYearUpdatedCount  += (Integer)agg.get('expr0'); 
        }
        for(AggregateResult agg :aggregateMonthScorecardList){
           /* String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserScorecardWrapper scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
            scorecard.scorecardMonthUpdatedCount  += (Integer)agg.get('expr0'); */
    /*        
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserScorecardWrapper scorecard;
            if(UserScorecardWrapperMap.containsKey(associatUserId)){
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(RegionzoneUserId);
                }
            }
            scorecard.scorecardMonthUpdatedCount  += (Integer)agg.get('expr0');             
        }
        userOppScoreWrapList.addAll(UserScorecardWrapperMap.values());   
        
        List<AggregateResult> aggregateYearContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                FROM Contact
                                                                WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                                AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                GROUP BY LastModifiedById];
        List<AggregateResult> aggregateMonthContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                 FROM Contact
                                                                 WHERE LastModifiedById IN :CounterSalesAssociateMap.keySet() 
                                                                 AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY LastModifiedById];
        List<AggregateResult> aggregateYearContactCreateList = [SELECT Count(Id),CreatedById
                                                                FROM Contact
                                                                WHERE CreatedById IN :CounterSalesAssociateMap.keySet() 
                                                                AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                GROUP BY CreatedById];
        List<AggregateResult> aggregateMonthContactCreateList = [SELECT Count(Id),CreatedById
                                                                 FROM Contact
                                                                 WHERE CreatedById IN :CounterSalesAssociateMap.keySet() 
                                                                 AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY CreatedById];
        for(AggregateResult agg :aggregateYearContactUpdateList){
            /*String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserContactWrapper ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
            ContactUpdate.contactYearUpdatedCount  += (Integer)agg.get('expr0');*/
    /*        
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserContactWrapper ContactUpdate;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                ContactUpdate = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }
            }
            ContactUpdate.contactYearUpdatedCount  += (Integer)agg.get('expr0');  
        }
        for(AggregateResult agg :aggregateMonthContactUpdateList){
            /*String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserContactWrapper ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
            ContactUpdate.contactMonthUpdatedCount  += (Integer)agg.get('expr0');  */
    /*
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserContactWrapper ContactUpdate;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                ContactUpdate = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactUpdate = UserContactWrapperMap.get(RegionzoneUserId);
                }
            }
            ContactUpdate.contactMonthUpdatedCount  += (Integer)agg.get('expr0'); 
        } 
        
        for(AggregateResult agg :aggregateYearContactCreateList){
            /*String associatUserId  = (String)agg.get('CreatedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserContactWrapper ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
            ContactCreated.contactYearCreatedCount  += (Integer)agg.get('expr0');  */
    /*
            String associatUserId  = (String)agg.get('CreatedById');
            UserContactWrapper ContactCreated;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                ContactCreated = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }
            }
            ContactCreated.contactYearCreatedCount  += (Integer)agg.get('expr0'); 
        }
        for(AggregateResult agg :aggregateMonthContactCreateList){
            /*String associatUserId  = (String)agg.get('CreatedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
            UserContactWrapper ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
            ContactCreated.contactMonthCreatedCount  += (Integer)agg.get('expr0'); */
    /*
            String associatUserId  = (String)agg.get('CreatedById');
            UserContactWrapper ContactCreated;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                ContactCreated = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    ContactCreated = UserContactWrapperMap.get(RegionzoneUserId);
                }
            }
            ContactCreated.contactMonthCreatedCount  += (Integer)agg.get('expr0'); 
        }
        userContactWrapList.addAll(UserContactWrapperMap.values());
        
        List<AggregateResult> aggregateYearEventCreateList = [SELECT Count(Id),OwnerId
                                                              FROM Event
                                                              WHERE OwnerId IN :CounterSalesAssociateMap.keySet() 
                                                              AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                              AND Event_TYpe__c ='Phone Call - Outbound'
                                                              GROUP BY OwnerId];
        List<AggregateResult> aggregateMonthEventCreateList = [SELECT Count(Id),OwnerId
                                                               FROM Event
                                                               WHERE OwnerId IN :CounterSalesAssociateMap.keySet() 
                                                               AND Event_TYpe__c ='Phone Call - Outbound'
                                                               AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                               AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                               GROUP BY OwnerId]; 
        //System.debug('aggregateYearEventCreateList => '+aggregateYearEventCreateList.Size());  
        //System.debug('aggregateYearEventCreateList => '+aggregateYearEventCreateList);
        //System.debug('aggregateMonthEventCreateList => '+aggregateMonthEventCreateList.Size());  
        //System.debug('aggregateMonthEventCreateList => '+aggregateMonthEventCreateList);
        
        for(AggregateResult agg :aggregateYearEventCreateList){
            /*String associatUserId  = (String)agg.get('OwnerId');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
            if(zoneUserMap.containsKey(zoneUserId) ){
                String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                UserEventWrapper event = UserEventWrapperMap.get(RegionzoneUserId);
                event.eventYearCreatedCount  += (Integer)agg.get('expr0');
            }  */
    /*
            String associatUserId  = (String)agg.get('OwnerId');
            UserEventWrapper event;
            if(UserEventWrapperMap.containsKey(associatUserId)){
                event = UserEventWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }
            }
            event.eventYearCreatedCount  += (Integer)agg.get('expr0'); 
        }
        for(AggregateResult agg :aggregateMonthEventCreateList){
            /*String associatUserId  = (String)agg.get('OwnerId');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
            if(zoneUserMap.containsKey(zoneUserId) ){
                String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                UserEventWrapper event = UserEventWrapperMap.get(RegionzoneUserId);
                event.eventMonthCreatedCount  += (Integer)agg.get('expr0');
            } */
    /*
            String associatUserId  = (String)agg.get('OwnerId');
            UserEventWrapper event;
            if(UserEventWrapperMap.containsKey(associatUserId)){
                event = UserEventWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }else if(zoneUserMap.containsKey(associatUserId)){
                    String RegionzoneUserId = zoneUserMap.get(associatUserId).ManagerId;
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;
                    String RegionzoneUserId = zoneUserMap.get(zoneUserId).ManagerId;  
                    event = UserEventWrapperMap.get(RegionzoneUserId);
                }
            } 
            event.eventMonthCreatedCount  += (Integer)agg.get('expr0'); 
        }  
        userEventWrapList.addAll(UserEventWrapperMap.values());         
    }
    
    
    /*
    // User Scorecard__c
    public class UserScorecardWrapper{
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

    private Set<Id> getUserOrGroupIdsForCurrentUserAndSpecificRole() {
        set<Id> ids = new set<Id>();

        User u = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
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
        public string Region{get;set;}
        public Decimal CYYTDSales{get;set;}
        public Decimal PYYTDSales{get;set;}
    }   

    public class regionKPI
    {
        public string URLText{get; set;}
        public string Region{get;set;}
        public integer opportunityScoreCard{get;set;}
        public integer contacts{get;set;}
        public integer outboundPhoneCalls{get;set;}
    }    
    
}