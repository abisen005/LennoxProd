/********************************************************
Developer : Eduardo Rodriguez
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class RegionZoneManagerAggregate
{
    //variable declarations
    public List<Favorites__c> favoritesList{get; set;}
    public string currentLoggedInUser{get; set;}
    public string region{get;set;}
    public string regionDisplay{get;set;}
    //public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public User u{get; set;}
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
    //public decimal previuosYearsYTDSales{get; set;}

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
    
    public decimal ytdSalesTSA{get; set;}
    //public decimal previuosYearsYTDSalesTSA{get; set;}
    
    public AggregateResult thisRecord {get; set;}
    public List<ExecutiveRollUpChildWrapper> allZoneRecords {get; set;}
    public List<zoneKPI> zoneKPIList {get;set;}
    public Integer totalKPIScoreCards {get;set;}
    public Integer totalKPIContacts {get;set;}
    public Integer totalKPIPhoneCalls {get;set;}
    public String managerName {get;set;}

    //public List<ExecutiveRollUpChildWrapper> allTSAZoneRecords {get; set;}
    //public List<UserScorecardWrapper> userOppScoreWrapList{get; set;}
    //public List<UserContactWrapper> userContactWrapList{get; set;}
    //public List<UserEventWrapper> userEventWrapList{get; set;} 
    public Pagereference cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    public RegionZoneManagerAggregate()
    {
        currentLoggedInUser = userinfo.getUserId();
        //AggregateReportsSettings__c profilesettings = AggregateReportsSettings__c.getOrgDefaults(); 
        List<String> validProfiles = new List<String>();
        
        //Map<Id,UserScorecardWrapper> UserScorecardWrapperMap = 
        //    new Map<Id, UserScorecardWrapper>();
        //Map<Id,UserContactWrapper> UserContactWrapperMap =
        //    new Map<Id, UserContactWrapper>();
        //Map<Id,UserEventWrapper> UserEventWrapperMap =
        //    new Map<Id, UserEventWrapper>();
        
        //userOppScoreWrapList =  
        //    new List<UserScorecardWrapper>();
        //userContactWrapList = 
        //    new List<UserContactWrapper>();
        //userEventWrapList = 
        //    new List<UserEventWrapper>();
        
        try
        {
            if(ApexPages.CurrentPage().getParameters() != null && 
               ApexPages.CurrentPage().getParameters().get('year') != null) {
                year = 
                    integer.valueOf(ApexPages.CurrentPage().getParameters().get('year'));
                preYear = year -1;
                preTwoYear = year - 2;
                preThreeYear = year - 3;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Year Value Missing.'));
                return;
            }
        } catch(Exception e)
        { System.debug('Error Obtaining Year -'+e.getMessage()); }
        
        try
        {
            if(ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().get('u') != null){
                currentLoggedInUser = ApexPages.currentPage().getParameters().get('u');
                system.debug('currentLoggedInUser!!!'+currentLoggedInUser);
            }
            u = [SELECT Id, FirstName, LastName, Qlik_LPP_Region_Zone__c, LPP_Region_Zone__c, SAP_Sales_District__c
                 FROM User 
                 WHERE Id =: currentLoggedInUser LIMIT 1];
            if(ApexPages.CurrentPage().getParameters() != null && 
               ApexPages.CurrentPage().getParameters().get('region') != null){
                region = ApexPages.CurrentPage().getParameters().get('region');
            } else {
                //region = 'LPP ' + u.LPP_Region_Zone__c;
                region = (u.LPP_Region_Zone__c == null ? u.SAP_Sales_District__c : u.LPP_Region_Zone__c);
            }            
        } catch(Exception e){
            System.debug('Error Getting User Information.');
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Getting User Information.'));
            return;
        }
        Boolean ableToFindDataWithUserId = true;
        regionDisplay = region.replace('LPP ', '');
        if(region != null && region.trim() != ''){
            invalidProfile = false;
        } else {
            invalidProfile = true;
            ableToFindDataWithUserId = false;
        }
        if(!invalidProfile){
            try {
                List<User> regionManager = [
                //    SELECT Id, Name 
                //    FROM User 
                //    WHERE (LPP_Region_Zone__c = :regionDisplay OR Qlik_LPP_Region_Zone__c = :region)
                //        AND (LPP_Zone__c = NULL OR LPP_Zone__c = 'All')
                //        AND (LPP_Store__c = NULL OR LPP_Store__c = 'All')
                //        AND (Qlik_LPP_Zone__c = NULL OR Qlik_LPP_Zone__c = 'All')
                //        AND (Profile.Name LIKE '%LPP Store_Zone Mgr%' OR Profile.Name LIKE '%LPP ZM/AZM%')
                    SELECT Id, FirstName, LastName, Name, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive 
                    FROM User 
                    WHERE SAP_Sales_District__c = :region 
                        AND Profile.Name LIKE '%AM%' 
                        AND isActive = true    
                ];
                if(regionManager != null && regionManager.size() > 0){
                    managerName = regionManager[0].Name;
                } else {
                    managerName = 'Manager Not Found';
                }
                //thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, 
                //              CY_YTDDLSC__c, 
                //              CY_YTDElite__c, CY_YTDMerit__c, CY_YTDOther__c,
                //              CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, 
                //              P2Y_SalesHistory__c, 
                //              P3Y_SalesHistory__c, PY_SalesHistory__c,
                //              PY_YTDAireFlo__c, PY_YTDDLSC__c, PY_YTDElite__c, PY_YTDMerit__c, PY_YTDOther__c, 
                //              PY_YTDSales__c,
                //              LastModifiedDate 
                //              FROM ExecutiveRollUpMain__c 
                //              WHERE Year__c =: String.valueOf(year) 
                //              AND Type__c = 'Region Zone Manager' 
                //              AND UserId__c =: Id.ValueOf(currentLoggedInUser) LIMIT 1];
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
                        //AND KPI_OppScorecards__c = null
                    GROUP BY Year__c 
                    LIMIT 1];            
                ableToFindDataWithUserId = true; 
            } catch(Exception e){
                ableToFindDataWithUserId = false;
                System.debug('Error==>'+e.getMessage());
                System.debug('Error==>'+e.getLineNumber());
            }  
        }
        //ytdSalesTSA = 0;
        //previousYearsYTDSalesTSA = 0;        
        if(ableToFindDataWithUserId){
            try {
                //system.debug('ableToFindDataWithUserId' +thisRecord.Type__c );
                DateTime dt = (DateTime)thisRecord.get('LastModifiedDate');
               lastSalesHistoryUpdate = dt != null ? Date.newInstance(dt.year(), dt.month(), dt.day()) : Date.today().addDays(-1);
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

                allZoneRecords = new List<ExecutiveRollUpChildWrapper>();
                for(AggregateResult child : [SELECT 
                                                 Zone__c, 
                                                 SUM(CY_YTDSales__c) CY_YTDSales__c, 
                                                 SUM(PY_YTDSales__c) PY_YTDSales__c,
                                                 SUM(YTDSalesChange__c)
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'  
                                                 AND Region__c = :region
                                                 //AND KPI_OppScorecards__c = null
                                                 AND Zone__c != ''
                                                 AND Zone__c != null
                                                 //AND Store__c != ''
                                                 //AND Store__c != null
                                                 //AND Store__c != 'None'
                                             GROUP BY Zone__c
                                             ORDER BY SUM(YTDSalesChange__c) DESC]){
                    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                    childWrapper.URLText = '/apex/zoneManagerAggregateVF?year=' + year + 
                        '&region=' + region +
                        '&zone=' + (String)child.get('Zone__c') +
                        '&u=' + currentLoggedInUser; 
                    childWrapper.zone = (String)child.get('Zone__c');
                    if(childWrapper.zone == null || childWrapper.zone == ''){
                        childWrapper.zone = 'Unspecified Region';
                    }
                    childWrapper.zone = childWrapper.zone.replace('LPP ', '');
                    childWrapper.CYYTDSales = (Decimal)child.get('CY_YTDSales__c');
                    childWrapper.PYYTDSales = (Decimal)child.get('PY_YTDSales__c');
                    allZoneRecords.add(childWrapper);  
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
                
                
                
                
                
                
                

                zoneKPIList = new List<zoneKPI>();
                totalKPIScoreCards = 0;
                totalKPIContacts = 0;
                totalKPIPhoneCalls = 0;
                for(AggregateResult child : [SELECT 
                                                 Zone__c, 
                                                 SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                                                 SUM(KPI_Contacts__c) KPI_Contacts__c,
                                                 SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                                             FROM ExecutiveRollUpMain__c
                                             WHERE Year__c =: String.valueOf(year) 
                                                 AND Type__c LIKE 'Store Summary%'
                                                 AND Region__c = :region  
                                                 //AND KPI_OppScorecards__c != null
                                                 AND Zone__c != ''
                                                 AND Zone__c != null
                                                 //AND Store__c != ''
                                                 //AND Store__c != null
                                             GROUP BY Zone__c
                        ORDER BY Zone__c]){
                    zoneKPI childWrapper = new zoneKPI();
                    childWrapper.URLText = '/apex/zoneManagerAggregateVF?year=' + year + 
                        '&region=' + region +
                        '&zone=' + (String)child.get('Zone__c') +
                        '&u=' + currentLoggedInUser;                     
                    childWrapper.zone = (String)child.get('Zone__c');
                    if(childWrapper.zone == null || childWrapper.zone == ''){
                        childWrapper.zone = 'Unspecified Region';
                    }                    
                    childWrapper.zone = childWrapper.zone.replace('LPP ', '');
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c'));  
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                        
                    zoneKPIList.add(childWrapper);  
                }

                /*
                for(AggregateResult child : [SELECT 
                                                SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                                                SUM(KPI_Contacts__c) KPI_Contacts__c,
                                                SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                                            FROM ExecutiveRollUpMain__c
                                            WHERE Year__c =: String.valueOf(year) 
                                                AND Type__c LIKE 'Store Summary%'
                                                AND Region__c = :region  
                                                //AND KPI_OppScorecards__c != null
                                                //AND (Store__c = '' 
                                                //    OR Store__c = null
                                                //    OR Zone__c = ''
                                                //    OR Zone__c = null)]){
                                                AND (Zone__c = ''
                                                    OR Zone__c = null)]){                                                      
                    zoneKPI childWrapper = new zoneKPI();
                    childWrapper.zone = 'Non Store Accounts';
                    childWrapper.opportunityScoreCard = Integer.valueOf((Decimal)child.get('KPI_OppScorecards__c'));
                    childWrapper.contacts = Integer.valueOf((Decimal)child.get('KPI_Contacts__c'));
                    childWrapper.outboundPhoneCalls = Integer.valueOf((Decimal)child.get('KPI_PhoneCalls__c')); 
                    totalKPIScoreCards += childWrapper.opportunityScoreCard == null ? 0 : childWrapper.opportunityScoreCard;
                    totalKPIContacts += childWrapper.contacts == null ? 0 : childWrapper.contacts;
                    totalKPIPhoneCalls += childWrapper.outboundPhoneCalls == null ? 0 : childWrapper.outboundPhoneCalls;                          
                    zoneKPIList.add(childWrapper);  
                }
                */ 

                //allTSAZoneRecords = new List<ExecutiveRollUpChildWrapper>();
                //List<ExecutiveRollUpChild__c> childRegionRecords = new List<ExecutiveRollUpChild__c>();
                //List<ExecutiveRollUpChild__c> childTSARegionRecords = new List<ExecutiveRollUpChild__c>();
                //childRegionRecords = [SELECT Id, URLText__c, Region__c, CY_YTDSales__c, PY_YTDSales__c
                //                  FROM ExecutiveRollUpChild__c
                //                  WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                //                  AND Type__c = 'Zone Manager' 
                //                  ORDER BY CY_YTDSales__c DESC ]; 
                //for(ExecutiveRollUpChild__c child: childRegionRecords){
                //    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                //    childWrapper.URLText = child.URLText__c;
                //    childWrapper.Region = child.Region__c;
                //    childWrapper.CYYTDSales = child.CY_YTDSales__c;
                //    childWrapper.PYYTDSales = child.PY_YTDSales__c;
                //    allZoneRecords.add(childWrapper);  
                //}
                //childTSARegionRecords = [SELECT Id, URLText__c, Region__c, 
                //                     CY_YTDSales__c, PY_YTDSales__c
                //                     FROM ExecutiveRollUpChild__c
                //                     WHERE ExecutiveRollUpMain__c =: thisRecord.Id 
                //                     AND Type__c = 'Zone Manager TSA'  
                //                     ORDER BY CY_YTDSales__c DESC ];   
                //for(ExecutiveRollUpChild__c tsaChild: childTSARegionRecords){ 
                //    ytdSalesTSA += tsaChild.CY_YTDSales__c ;
                //    previousYearsYTDSalesTSA += tsaChild.PY_YTDSales__c;  
                //    ExecutiveRollUpChildWrapper childWrapper = new ExecutiveRollUpChildWrapper();
                //    childWrapper.URLText = tsaChild.URLText__c;
                //    childWrapper.Region = tsaChild.Region__c;
                //    childWrapper.CYYTDSales = tsaChild.CY_YTDSales__c;
                //    childWrapper.PYYTDSales = tsaChild.PY_YTDSales__c;
                //    allTSAZoneRecords.add(childWrapper);  
                //}
                
                Set<Id> userAndGroupIdSet = getUserOrGroupIdsForCurrentUserAndSpecificRole();
                system.debug('### Step 1');
                Set<Id> favoritesIdSet = new Set<Id>();
                for (Favorites__Share favoritesShare : [
                    SELECT Id, ParentId
                    FROM Favorites__Share 
                    WHERE UserOrGroupId IN :userAndGroupIdSet
                ]) {
                    favoritesIdSet.add(favoritesShare.ParentId);
                }
                system.debug('### Step 2');
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
                system.debug('### Step 3');                        
                /*
                for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c, 
                                                   External_Link__c 
                                                   FROM Favorites__c
                                                   WHERE (Category__c != NULL 
                                                          AND Favorites_URL__c != NULL 
                                                          AND Type__c = 'Admin' 
                                                          AND RUS_Assignment__c = 'Region Zone Manager')
                                                   ORDER BY Sequence__c ASC]){ 
                                                       favoritesList.add(favoriteRecord);
                                                   }
                Map<Id,User> zoneUserMap = new Map<Id,User>([SELECT Id, Name, Title,LPP_Store__c,ProfileId,
                                                             Qlik_LPP_Zone__c 
                                                             FROM USER 
                                                             Where UserRole.Name like '%P&S Zone Manager%' 
                                                             AND ManagerId = :u.Id 
                                                             AND IsActive=true]);
                for(Id userId : zoneUserMap.keySet()){
                    UserScorecardWrapper uwScorecard = new UserScorecardWrapper(); 
                    uwScorecard.scorecardUserId = userId;
                    uwScorecard.scorecardUserName = zoneUserMap.get(userId).Name;
                    uwScorecard.scorecardMonthUpdatedCount = 0;
                    uwScorecard.scorecardYearUpdatedCount = 0; 
                    uwScorecard.zoneName = zoneUserMap.get(userId).Qlik_LPP_Zone__c;
                    UserScorecardWrapperMap.put(userId,uwScorecard);
                    //For Contact
                    UserContactWrapper uwContact = new UserContactWrapper();
                    uwContact.contactUserId = userId;
                    uwContact.contactUserName = zoneUserMap.get(userId).Name;
                    uwContact.zoneName = zoneUserMap.get(userId).Qlik_LPP_Zone__c;
                    uwContact.contactMonthUpdatedCount = 0;
                    uwContact.contactYearUpdatedCount = 0;
                    uwContact.contactMonthCreatedCount = 0;
                    uwContact.contactYearCreatedCount = 0;
                    UserContactWrapperMap.put(userId,uwContact);
                    
                    //For Event
                    UserEventWrapper uwEvent = new UserEventWrapper();
                    uwEvent.eventUserId = userId;
                    uwEvent.eventUserName = zoneUserMap.get(userId).Name;
                    uwEvent.zoneName = zoneUserMap.get(userId).Qlik_LPP_Zone__c; 
                    uwEvent.eventMonthCreatedCount = 0;
                    uwEvent.eventYearCreatedCount = 0;
                    UserEventWrapperMap.put(userId,uwEvent);  
                }
                 //System.debug('zoneUserMap => '+zoneUserMap.Size()); 
                //System.debug('zoneUserMap => '+zoneUserMap); 
                Map<Id,User> storeUserMap = new Map<Id,User>([SELECT Id, Name,ManagerId, Title, LPP_Store__c,ProfileId 
                                                              FROM USER 
                                                              Where Title='Store Manager' 
                                                              AND ManagerId IN :zoneUserMap.keySet() 
                                                              AND IsActive=true]); 
                Map<Id, User> CounterSalesAssociateMap = new Map<Id, User> ([SELECT Id, Name, Title, LPP_Store__c,
                                                                             ProfileId,ManagerId 
                                                                             FROM USER 
                                                                             Where (Id IN :storeUserMap.KeySet()) OR 
                                                                             (Id IN :zoneUserMap.KeySet()) OR
                                                                             (Title= 'Counter Sales Associate'   
                                                                             AND ManagerId = :storeUserMap.keySet() 
                                                                             AND IsActive=true)]);
                System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap.Size()); 
                System.debug('CounterSalesAssociateList => '+CounterSalesAssociateMap);  
                processRecordCounts(storeUserMap,zoneUserMap,CounterSalesAssociateMap,
                                    UserScorecardWrapperMap,UserContactWrapperMap,
                                    UserEventWrapperMap);
                */  
            }catch(Exception exp){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exp.getMessage()));
            } 
        }
    }  
    /*
   // public void processRecordCounts(Map<Id,User> zoneUserwrapperMap,Map<Id,User> storeUserMap){
    public void processRecordCounts(Map<Id,User> storeUserMap, Map<Id,User> zoneUserMap, 
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
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserScorecardWrapper scorecard;
            if(UserScorecardWrapperMap.containsKey(associatUserId)){
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    scorecard = UserScorecardWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(zoneUserId);
                }
            }
            scorecard.scorecardYearUpdatedCount  += (Integer)agg.get('expr0'); 
            //yearUpdatedScoreCount.put(managerId,yearUpdatedScoreCount.get(managerId)+(Integer)agg.get('expr0'));
        }
        for(AggregateResult agg :aggregateMonthScorecardList){
            /*String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserScorecardWrapper scorecard = UserScorecardWrapperMap.get(zoneUserId);
            scorecard.scorecardMonthUpdatedCount  += (Integer)agg.get('expr0'); */
        /*    
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserScorecardWrapper scorecard;
            if(UserScorecardWrapperMap.containsKey(associatUserId)){
                scorecard = UserScorecardWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    scorecard = UserScorecardWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    scorecard = UserScorecardWrapperMap.get(zoneUserId);
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
            UserContactWrapper contactUpdate = UserContactWrapperMap.get(zoneUserId);
            contactUpdate.contactYearUpdatedCount  += (Integer)agg.get('expr0'); */
        /*    
            String associatUserId  = (String)agg.get('LastModifiedById');
            UserContactWrapper contactUpdate;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                contactUpdate = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    contactUpdate = UserContactWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    contactUpdate = UserContactWrapperMap.get(zoneUserId);
                }
            }
            contactUpdate.contactYearUpdatedCount  += (Integer)agg.get('expr0'); 
            
        }
        for(AggregateResult agg :aggregateMonthContactUpdateList){
            /*String associatUserId  = (String)agg.get('LastModifiedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserContactWrapper contactUpdate = UserContactWrapperMap.get(zoneUserId);
            contactUpdate.contactMonthUpdatedCount  += (Integer)agg.get('expr0'); */  
        /*    
            String associatUserId  = (String)agg.get('LastModifiedById'); 
            UserContactWrapper contactUpdate;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                contactUpdate = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    contactUpdate = UserContactWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    contactUpdate = UserContactWrapperMap.get(zoneUserId);
                }
            }
            contactUpdate.contactMonthUpdatedCount  += (Integer)agg.get('expr0');
            
        }
        
        for(AggregateResult agg :aggregateYearContactCreateList){
            /*String associatUserId  = (String)agg.get('CreatedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserContactWrapper contactCreated = UserContactWrapperMap.get(zoneUserId);
            contactCreated.contactYearCreatedCount  += (Integer)agg.get('expr0'); */ 
        /*    
            String associatUserId  = (String)agg.get('CreatedById'); 
            UserContactWrapper contactCreated;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                contactCreated = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    contactCreated = UserContactWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    contactCreated = UserContactWrapperMap.get(zoneUserId);
                }
            }
            contactCreated.contactYearCreatedCount  += (Integer)agg.get('expr0'); 
            
        }
        for(AggregateResult agg :aggregateMonthContactCreateList){
           /* String associatUserId  = (String)agg.get('CreatedById');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserContactWrapper contactCreated = UserContactWrapperMap.get(zoneUserId);
            contactCreated.contactMonthCreatedCount  += (Integer)agg.get('expr0');*/
        /*    
            String associatUserId  = (String)agg.get('CreatedById'); 
            UserContactWrapper contactCreated;
            if(UserContactWrapperMap.containsKey(associatUserId)){
                contactCreated = UserContactWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    contactCreated = UserContactWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    contactCreated = UserContactWrapperMap.get(zoneUserId);
                }
            }
            contactCreated.contactMonthCreatedCount  += (Integer)agg.get('expr0'); 
            
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
        
        for(AggregateResult agg :aggregateYearEventCreateList){
            /*String associatUserId  = (String)agg.get('OwnerId');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserEventWrapper event = UserEventWrapperMap.get(zoneUserId);
            event.eventYearCreatedCount  += (Integer)agg.get('expr0'); */
        /*    
            String associatUserId  = (String)agg.get('OwnerId'); 
            UserEventWrapper event;
            if(UserEventWrapperMap.containsKey(associatUserId)){
                event = UserEventWrapperMap.get(associatUserId);
            }else {
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    event = UserEventWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    event = UserEventWrapperMap.get(zoneUserId);
                }
            }
            event.eventYearCreatedCount  += (Integer)agg.get('expr0');
            
        }
        for(AggregateResult agg :aggregateMonthEventCreateList){
            /*String associatUserId  = (String)agg.get('OwnerId');
            String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
            String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
            UserEventWrapper event = UserEventWrapperMap.get(zoneUserId);
            event.eventMonthCreatedCount  += (Integer)agg.get('expr0');  */
        /*
            String associatUserId  = (String)agg.get('OwnerId'); 
            UserEventWrapper event;
            if(UserEventWrapperMap.containsKey(associatUserId)){
                event = UserEventWrapperMap.get(associatUserId);
            }else { 
                if(storeUserMap.containsKey(associatUserId)){
                    String zoneUserId = storeUserMap.get(associatUserId).ManagerId;
                    event = UserEventWrapperMap.get(zoneUserId);
                }else{
                    String storeUserId = CounterSalesAssociateMap.get(associatUserId).ManagerId;
                    String zoneUserId = storeUserMap.get(storeUserId).ManagerId;  
                    event = UserEventWrapperMap.get(zoneUserId);
                }
            }
            event.eventMonthCreatedCount  += (Integer)agg.get('expr0');
            
        }
        userEventWrapList.addAll(UserEventWrapperMap.values());
    }
    */
    /*
    // User Scorecard__c
    public class UserScorecardWrapper{
        public string scorecardUserId{get; set;}
        public string scorecardUserName{get;set;}
        public string zoneName{get;set;}
        public integer scorecardMonthUpdatedCount{get;set;}
        public integer scorecardYearUpdatedCount{get;set;}
    }
    // User Contact and Event List
    public class UserContactWrapper{
        public string contactUserId{get; set;}
        public string contactUserName{get;set;}
        public string zoneName{get;set;}
        public integer contactMonthUpdatedCount{get;set;}
        public integer contactYearUpdatedCount{get;set;}
        public integer contactMonthCreatedCount{get;set;}
        public integer contactYearCreatedCount{get;set;}
    }
    // User Event List
    public class UserEventWrapper{
        public string eventUserId{get; set;}
        public string eventUserName{get;set;}
        public string zoneName{get;set;}
        public integer eventMonthCreatedCount{get;set;}
        public integer eventYearCreatedCount{get;set;}
    }
    */
    private Set<Id> getUserOrGroupIdsForCurrentUserAndSpecificRole() {
        set<Id> ids = new set<Id>();
        system.debug('#### Step 1.0');
        User u = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        ids.add(u.Id);
        system.debug('#### Step 1.2');
        for (List<Group> groups : [SELECT Id FROM Group WHERE RelatedId = :u.UserRoleId]) {
            system.debug('#### Step 1.3');
            for (Group g : groups) {
                system.debug('#### Step 1.4');
                ids.add(g.Id);
            }
        }

        for (List<GroupMember> members : [SELECT Id, GroupId FROM GroupMember WHERE UserOrGroupId = :ids AND (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')]) {
            system.debug('#### Step 1.5');
            for (GroupMember gm : members) {
                system.debug('#### Step 1.6');
                ids.add(gm.GroupId);
            }
        }

        return ids;    
    }

    // User ExecutiveRollUpChild
    public class ExecutiveRollUpChildWrapper{
        public string URLText{get; set;}
        public string zone{get;set;}
        public Decimal CYYTDSales{get;set;}
        public Decimal PYYTDSales{get;set;}
    }

    public class zoneKPI
    {
        public string URLText{get; set;}
        public string zone{get;set;}
        public integer opportunityScoreCard{get;set;}
        public integer contacts{get;set;}
        public integer outboundPhoneCalls{get;set;}
    }      
    
}