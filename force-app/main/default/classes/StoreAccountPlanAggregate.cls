/********************************************************
Developer : Ganesh Mahajan DWS 27/12/2021
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class StoreAccountPlanAggregate
{
    //variable declarations
    public List<Favorites__c> favoritesList{get; set;}
    public string currentLoggedInUser{get; set;}
    //public string currentLoggedInUserTerritory{get; set;}
    //public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
    //public string accountId{get; set;}
    //public Account acc{get; set;}
    public User u{get; set;}
    public String store{get;set;}
    
    public List<GrowthStore> growthStoreWrapperList{get; set;}
    public List<TargetStoreAccounts> TargetStoreAccountsWrapperList{get; set;}
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

    public Decimal dealerDeltAYTDSalesSum1{get;set;}
    public Decimal dealerYTDSalesLCSum1{get;set;}
    public Decimal dealerpre1TSSum1{get;set;}
    public Decimal dealerPre2TSSum1{get;set;}
    public Decimal dealerPre3TSSum1{get;set;}

    //public Decimal pieChartResEquipment {get;set;}
    //public decimal pieChartCommercials{get; set;}
    //public decimal pieChartPartsndSupplies{get; set;}
       
    public Decimal dealerDeltAYTDSalesSumTSA{get;set;}
    public Decimal dealerYTDSalesLCSumTSA{get;set;}
    public Decimal dealerpre1TSSumTSA{get;set;}
    public Decimal dealerPre2TSSumTSA{get;set;}
    public Decimal dealerPre3TSSumTSA{get;set;}

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
    //variable for YTD Sales - Product Tier Change
    public decimal changeDLSC{get; set;}
    public decimal changeMerit{get; set;}
    public decimal changeElite{get; set;}
    public decimal changeAireFlo{get; set;}
    public decimal changeOther{get; set;}    
    //public String managerName {get;set;}
    public String storeName {get;set;}

    //public List<UserScorecardWrapper> userOppScoreWrapList{get; set;}
    //public List<UserContactWrapper> userContactWrapList{get; set;}
    //public List<UserEventWrapper> userEventWrapList{get; set;}
    public List<storeKPI> storeKPIList{get;set;}
    //Map<Id,Integer> monthUpdatedScoreCount = new Map<Id,Integer>();
    //Map<Id,Integer> yearUpdatedScoreCount = new Map<Id,Integer>();
    //Map<Id,Integer> monthUpdatedContactCount = new Map<Id,Integer>();
    //Map<Id,Integer> yearUpdatedContactCount = new Map<Id,Integer>();
    //Map<Id,Integer> monthCreatedContactCount = new Map<Id,Integer>();
    //Map<Id,Integer> yearCreatedContactCount = new Map<Id,Integer>();
    //Map<Id,Integer> monthCreatedEventCount = new Map<Id,Integer>();
    //Map<Id,Integer> yearCreatedEventCount = new Map<Id,Integer>();
    
    public string yearSelected='';
    public Set<Id> accIdSetTerritory = new Set<Id>();
    public String getyearSelected() {
        return yearSelected;
    }
    
    public void setyearSelected(String yearSelected) 
    {
        this.yearSelected = yearSelected;
    }    
    public Pagereference cancel() {
        return new PageReference('javascript:window.close()');
    }
    
    public Pagereference navigateToReport() {
        String dummyRef = '/apex/StoreAccountPlanAggregate?year='+yearSelected;
        System.debug('yearSelected::::::'+yearSelected);
        System.debug('dummyRef::::::'+dummyRef);
        PageReference reference = new PageReference('/apex/StoreAccountPlanAggregate?year='+yearSelected);
        reference.setRedirect(true);
        return reference;
    }
    
    public List<SelectOption> getReportYear() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(string.valueOf(system.today().year()), string.valueOf(system.today().year())));
        options.add(new SelectOption(string.valueOf(system.today().year()-1), string.valueOf(system.today().year()-1)));
        return options;
    }
    public StoreAccountPlanAggregate()
    {
        Set<Id> accountIdInScope = new Set<Id>();     
        //try
        //{
            //get the year value from url and calculate 2pyrs, 1pyr, 3pyr values
            if(ApexPages.CurrentPage().getParameters().get('year') != null){
                year = integer.valueOf(ApexPages.CurrentPage().getParameters().get('year'));
                preYear = year -1;
                preTwoYear = year - 2;
                preThreeYear = year - 3;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please Provide The Year Value'));
            }
            
            if( ApexPages.currentPage().getParameters().get('u') != null){
                currentLoggedInUser = ApexPages.currentPage().getParameters().get('u');
            }else{
                currentLoggedInUser = userinfo.getUserId();
            }
            
            if(currentLoggedInUser != null)
                u = [SELECT Id, FirstName, LastName, District_Description_Formula__c, SAP_Sales_Office__c, SAP_Sales_Group__c, Prior_Year_Sales_Quota__c, Current_Year_Sales_Quota__c,LPP_Store__c,UserRoleId
                     FROM User 
                     WHERE Id =: currentLoggedInUser LIMIT 1];
            if(ApexPages.currentPage().getParameters().get('store') != null){
                store = ApexPages.currentPage().getParameters().get('store');
            } else {
                store = u.LPP_Store__c;
            }                     
            System.debug('store==>'+store);
            System.debug('Year==>'+year);
            if(store != null && store.trim() != '' && !store.containsIgnoreCase('none')){
                /*                 
                List<User> storeManager = [
                    SELECT Id, Name 
                    FROM User 
                    WHERE LPP_Store__c = :store
                        AND (Profile.Name LIKE '%LPP Store_Zone Mgr%' OR Profile.Name LIKE '%LPP ZM/AZM%')];
                if(storeManager != null && storeManager.size() > 0){
                    managerName = storeManager[0].Name;
                } else {
                    managerName = 'Manager Not Found';
                }
                */
                map<String, String> mapStoreName = getStoreName(store);                   
                if(mapStoreName != null && mapStoreName.containsKey(store)){
                    storeName = mapStoreName.get(store);
                } else {
                    storeName = store;
                }                 
                List<AggregateResult> aggResultsAccounts = [
                    SELECT 
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
                        AND Store__c = :store
                        //AND KPI_OppScorecards__c = null
                    GROUP BY Year__c 
                    LIMIT 1];          
                    //FROM Account_Planning__c  
                    //WHERE Dealer__r.LPP_Plant_Code__c = :store
                    //    AND Account_Plan_Year__c =:string.valueOf(year) 
                    //GROUP BY Dealer__r.OwnerId]; 
                                                            
                System.debug('aggResultsAccounts==>'+aggResultsAccounts.size());
                System.debug('aggResultsAccounts==>'+aggResultsAccounts); 
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
                //pieChartResEquipment = 0;
                //pieChartCommercials = 0;
                //pieChartPartsndSupplies = 0;
               //DateTime dt = (DateTime)aggResultsAccounts[0].get('LastModifiedDate');
              // lastSalesHistoryUpdate = dt != null ? Date.newInstance(dt.year(), dt.month(), dt.day()) : Date.today().addDays(-1);
                //lastSalesHistoryUpdate = Date.newInstance(dt.year(), dt.month(), dt.day());                  
                
                currentYearDLSC = 0;
                currentYearElite = 0;
                currentYearMerit = 0;
                currentYearAireFlo = 0;
                currentYearOther = 0;
                previousYearDLSC = 0;
                previousYearElite = 0;
                previousYearMerit = 0;
                previousYearAireFlo = 0;
                previousYearOther = 0;      
                
                dealerYTDSalesLCSum1 = 0;
                dealerDeltAYTDSalesSum1 = 0;
                dealerpre1TSSum1 = 0;
                dealerPre2TSSum1 = 0;
                dealerPre3TSSum1 = 0;
                
                dealerDeltAYTDSalesSumTSA = 0;
                dealerYTDSalesLCSumTSA = 0;
                dealerpre1TSSumTSA = 0;
                dealerPre2TSSumTSA = 0;
                dealerPre3TSSumTSA = 0;
                
                for(AggregateResult q : aggResultsAccounts)
                {   
                    previousYearTotalSales += q.get('PY_SalesHistory__c') == null ? 0 : (Decimal)q.get('PY_SalesHistory__c');
                    previousTwoYearsTotalSales += q.get('P2Y_SalesHistory__c') == null ? 0 : (Decimal)q.get('P2Y_SalesHistory__c');
                    previousThreeYearsTotalSales += q.get('P3Y_SalesHistory__c') == null ? 0 : (Decimal)q.get('P3Y_SalesHistory__c');
                    
                    ytdSales += q.get('CY_YTDSales__c') == null ? 0 : (Decimal)q.get('CY_YTDSales__c');
                    previousYearsYTDSales += q.get('PY_YTDSales__c') == null ? 0 : (Decimal)q.get('PY_YTDSales__c');
                    ytdSalesChange += (decimal)q.get('CY_YTDSales__c') - (decimal)q.get('PY_YTDSales__c');
                    
                    ytdResEquipment += q.get('CY_YTDResEquipment__c') == null ? 0 : (Decimal)q.get('CY_YTDResEquipment__c');
                    ytdCommercials += q.get('CY_YTDCommercial__c') == null ? 0 : (Decimal)q.get('CY_YTDCommercial__c');
                    ytdPartsndSupplies += q.get('CY_YTDPartsAndSupplies__c') == null ? 0 : (Decimal)q.get('CY_YTDPartsAndSupplies__c');

                    currentYearDLSC += q.get('CY_YTDDLSC__c') == null ? 0 : (decimal)q.get('CY_YTDDLSC__c');
                    currentYearElite += q.get('CY_YTDElite__c') ==  null ? 0 : (decimal)q.get('CY_YTDElite__c');
                    currentYearMerit += q.get('CY_YTDMerit__c') == null ? 0 : (decimal)q.get('CY_YTDMerit__c');
                    currentYearAireFlo += q.get('CY_YTDAireFlo__c') == null ? 0 : (decimal)q.get('CY_YTDAireFlo__c');
                    currentYearOther += (q.get('CY_YTDOther__c') == null ? 0 : (decimal)q.get('CY_YTDOther__c'));
                    previousYearDLSC += q.get('PY_YTDDLSC__c') == null ? 0 : (decimal)q.get('PY_YTDDLSC__c');
                    previousYearElite += q.get('PY_YTDElite__c') == null ? 0 : (decimal)q.get('PY_YTDElite__c');
                    previousYearMerit += q.get('PY_YTDMerit__c') == null ? 0 : (decimal)q.get('PY_YTDMerit__c');
                    previousYearAireFlo += q.get('PY_YTDAireFlo__c') == null ? 0 : (decimal)q.get('PY_YTDAireFlo__c');
                    previousYearOther += q.get('PY_YTDOther__c') == null ? 0 : (decimal)q.get('PY_YTDOther__c');
                }
                currentYearOther += currentYearAireFlo;
                previousYearOther += previousYearAireFlo;
                currentYearDLSCPercent = ytdSales == 0 ? 0 : currentYearDLSC / ytdSales;
                currentYearElitePercent = ytdSales == 0 ? 0 : currentYearElite / ytdSales;
                currentYearMeritPercent = ytdSales == 0 ? 0 : currentYearMerit / ytdSales;                
                currentYearOtherPercent = ytdSales == 0 ? 0 : currentYearOther / ytdSales;
                previousYearDLSCPercent = previousYearsYTDSales == 0 ? 0 : previousYearDLSC / previousYearsYTDSales;
                previousYearElitePercent = previousYearsYTDSales == 0 ? 0 : previousYearElite / previousYearsYTDSales;
                previousYearMeritPercent = previousYearsYTDSales == 0 ? 0 : previousYearMerit / previousYearsYTDSales;
                previousYearOtherPercent = previousYearsYTDSales == 0 ? 0 : previousYearOther / previousYearsYTDSales ;
                changeDLSC =  currentYearDLSC - previousYearDLSC;
                changeMerit = currentYearMerit - previousYearMerit;
                changeElite = currentYearElite - previousYearElite; 
                changeOther = currentYearOther - previousYearOther; 

                //pieChartResEquipment = ytdResEquipment < 0 ? 0 : ytdResEquipment;
                //pieChartCommercials = ytdCommercials < 0 ? 0 : ytdCommercials;
                //pieChartPartsndSupplies = ytdPartsndSupplies < 0 ? 0 : ytdPartsndSupplies;           

                growthStoreWrapperList = new List<GrowthStore>();
                targetStoreAccountsWrapperList = new List<TargetStoreAccounts>();
                
                for(AggregateResult a : [
                    SELECT 
                        Dealer__r.Name v0, 
                        Dealer__r.SAP_Customer_Number__c v1, 
                        Dealer__r.Id v11, 
                        Dealer__r.LastActivityDate v5, 
                        //Dealer__c, 
                        //Dealer__r.SAP_Sales_Group__c v2, 
                        SUM(YTD_Sales__c) v4,
                        SUM(PY_Sales__c) v7, 
                        SUM(PY2_Sales__c) v8,
                        //SUM(PY3_Sales__c) v9, 
                        SUM(YTD_Sales_Change__c) v10 
                        //Dealer__r.Pricing_Zone__c v3,
                        //SUM(X2020_Sales_Forecast__c) v20,
                        //SUM(X2021_Sales_Forecast__c) v21 
                    FROM Account_Planning__c 
                    WHERE Dealer__r.LPP_Plant_Code__c = :store 
                        AND Account_Plan_Year__c =: string.valueOf(year)
                        AND Dealer__r.Main_LPP_Store__c != null
                        AND Dealer__r.Main_LPP_Store__c != ''
                        AND Dealer__r.LPP_District_Formula__c = true
                        AND YTD_Sales__c != null
                    GROUP BY Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, Dealer__r.LastActivityDate
                    ORDER BY SUM(YTD_Sales__c) DESC LIMIT 20])
                {
                    accountIdInScope.add((String)a.get('v11'));
                    GrowthStore grwStore = new GrowthStore(); 
                    grwStore.dealerId = (String)a.get('v11');
                    grwStore.dealerCustNo = (String)a.get('v1');
                    grwStore.dealerName = (String)a.get('v0');
                    if(integer.valueOf((Decimal)a.get('v10')) != null)
                    {
                        grwStore.dealerDeltAYTDSales = integer.valueOf((Decimal)a.get('v10'));
                        dealerDeltAYTDSalesSum1 += (Decimal)a.get('v10');
                    }   
                    else
                        grwStore.dealerDeltAYTDSales = 0;
                    
                    if(integer.valueOf((Decimal)a.get('v4')) != null)  
                    {
                        grwStore.dealerYTDSalesLC  = (Decimal)a.get('v4');
                        dealerYTDSalesLCSum1 += (Decimal)a.get('v4');
                    }   
                    else
                        grwStore.dealerYTDSalesLC  = 0;                
                    
                    if(integer.valueOf((Decimal)a.get('v7')) != null)
                    {                   
                        grwStore.dealerpre1TS = (Decimal)a.get('v7');
                        dealerpre1TSSum1 += (Decimal)a.get('v7');
                    }   
                    else    
                        grwStore.dealerpre1TS = 0;

                    if(integer.valueOf((Decimal)a.get('v8')) != null){
                        grwStore.dealerPre2TS = (Decimal)a.get('v8');
                        dealerpre2TSSum1 += (Decimal)a.get('v8');
                    }else
                        grwStore.dealerPre2TS = 0;
                    
                    //if(integer.valueOf((Decimal)a.get('v9')) != null){
                    //    dealerpre3TSSum1 += (Decimal)a.get('v9');
                    //    grwStore.dealerPre3TS = (Decimal)a.get('v9');
                    //}else
                    //    grwStore.dealerPre3TS = 0;
                    grwStore.dealerTSAStatus = '### Invalid ###';
                    grwStore.lastActivity = date.valueOf((DateTime)a.get('v5'));
                    growthStoreWrapperList.add(grwStore);
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
                
                
                
                
                
                
                
                
                
                
                //for (Integer i = 0; i < growthStoreWrapperList.size(); i++) {
                //    for (Integer j = 1; j < (growthStoreWrapperList.size()-i); j++) {   
                //        if (growthStoreWrapperList.get(j-1).dealerYTDSalesLC < growthStoreWrapperList.get(j).dealerYTDSalesLC) {   
                //            GrowthStore temp = growthStoreWrapperList[j-1];
                //            growthStoreWrapperList[j-1] = growthStoreWrapperList[j];
                //            growthStoreWrapperList[j] = temp;
                //        }            
                //    }
                //} 

                //List<Sales_Initiative__c> salesInitiativeList = new List<Sales_Initiative__c>();
                //salesInitiativeList =  [SELECT Id, Name,Account__c FROM Sales_Initiative__c 
                //                        WHERE Account__r.LPP_Plant_Code__c = :store
                //                        AND Intiative__c = 'Target Store Accounts' 
                //                        AND Store_Target_Account_Enrolled__c = true
                //                       ];
                //Set<String> accountIds = new Set<String>();
                //for(Sales_Initiative__c rec: salesInitiativeList){
                //    accountIds.add(rec.Account__c);
                //}
                
                dealerDeltAYTDSalesSumTSA = 0;
                dealerYTDSalesLCSumTSA = 0;
                dealerpre1TSSumTSA = 0;
                dealerPre2TSSumTSA = 0;
                dealerPre3TSSumTSA = 0;
                for(AggregateResult a : [
                    SELECT 
                        Dealer__r.Name v0, 
                        Dealer__r.SAP_Customer_Number__c v1, 
                        Dealer__r.Id v11, 
                        Dealer__r.LastActivityDate v5, 
                        //Dealer__c, 
                        //Dealer__r.SAP_Sales_Group__c v2, 
                        SUM(YTD_Sales__c) v4,
                        SUM(PY_Sales__c) v7, 
                        SUM(PY2_Sales__c) v8,
                        SUM(PY3_Sales__c) v9, 
                        SUM(YTD_Sales_Change__c) v10
                        //Dealer__r.Pricing_Zone__c v3,
                        //SUM(X2020_Sales_Forecast__c) v20,
                        //SUM(X2021_Sales_Forecast__c) v21 
                    FROM Account_Planning__c 
                    WHERE Dealer__r.LPP_Plant_Code__c = :store
                        AND Account_Plan_Year__c =: string.valueOf(year)
                        AND Dealer__r.isStoreAccount__c = true
                        AND YTD_Sales__c != null
                    GROUP BY Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, Dealer__r.LastActivityDate
                    ORDER BY SUM(YTD_Sales__c) DESC LIMIT 20])
                {
                    
                    TargetStoreAccounts tsaStore = new TargetStoreAccounts();
                    accountIdInScope.add((String)a.get('v11'));
                    tsaStore.dealerId = (String)a.get('v11');
                    tsaStore.dealerCustNo = (String)a.get('v1');
                    tsaStore.dealerName = (String)a.get('v0');
                    tsaStore.dealerTSAStatus = '### Invalid ###';

                    if(integer.valueOf((Decimal)a.get('v10')) != null)
                    {
                        tsaStore.dealerDeltAYTDSales = integer.valueOf((Decimal)a.get('v10'));
                        dealerDeltAYTDSalesSumTSA += (Decimal)a.get('v10');
                    }   
                    else
                        tsaStore.dealerDeltAYTDSales = 0;
                    
                    if(integer.valueOf((Decimal)a.get('v4')) != null)  
                    {
                        tsaStore.dealerYTDSalesLC  = (Decimal)a.get('v4');
                        dealerYTDSalesLCSumTSA += (Decimal)a.get('v4');
                    }   
                    else
                        tsaStore.dealerYTDSalesLC  = 0;                
                    
                    if(integer.valueOf((Decimal)a.get('v7')) != null)
                    {                   
                        tsaStore.dealerpre1TS = (Decimal)a.get('v7');
                        dealerpre1TSSumTSA += (Decimal)a.get('v7');
                    }   
                    else    
                        tsaStore.dealerpre1TS = 0;
                    
                    if(integer.valueOf((Decimal)a.get('v8')) != null){
                        tsaStore.dealerPre2TS = (Decimal)a.get('v8');
                        dealerpre2TSSumTSA += (Decimal)a.get('v8');
                    }else
                        tsaStore.dealerPre2TS = 0;
                    
                    //if(integer.valueOf((Decimal)a.get('v9')) != null){
                    //    dealerpre3TSSumTSA += (Decimal)a.get('v9');
                    //    tsaStore.dealerPre3TS = (Decimal)a.get('v9');
                    //}else
                    //    tsaStore.dealerPre3TS = 0;

                    tsaStore.lastActivity = date.valueOf((DateTime)a.get('v5'));
                    targetStoreAccountsWrapperList.add(tsaStore);
                }
                //Sorting by dealerYTDSalesLC
                //for (Integer i = 0; i < targetStoreAccountsWrapperList.size(); i++) {
                //    for (Integer j = 1; j < (targetStoreAccountsWrapperList.size()-i); j++) {   
                //        if (targetStoreAccountsWrapperList.get(j-1).dealerYTDSalesLC < targetStoreAccountsWrapperList.get(j).dealerYTDSalesLC) {   
                //            TargetStoreAccounts temp = targetStoreAccountsWrapperList[j-1];
                //            targetStoreAccountsWrapperList[j-1] = targetStoreAccountsWrapperList[j];
                //            targetStoreAccountsWrapperList[j] = temp;
                //        }            
                //    }
                //}
                Map<Id, Account> mapAccountStatus = new Map<Id, Account>([SELECT Id, Store_Eligible_Account__c 
                                                                        FROM Account 
                                                                        WHERE Id IN :accountIdInScope]);
                for(GrowthStore g : growthStoreWrapperList){
                    g.dealerTSAStatus = mapAccountStatus.get(g.dealerId).Store_Eligible_Account__c;
                }
                for(TargetStoreAccounts t : TargetStoreAccountsWrapperList){
                    t.dealerTSAStatus = mapAccountStatus.get(t.dealerId).Store_Eligible_Account__c;
                }

                /*
                Map<String, storeKPI> mapStoreKPI = new Map<String, storeKPI>();
                Map<Id, Account> mapAccountStoreNumber = new Map<Id, Account>([SELECT Id, LPP_Plant_Code__c 
                                                                            FROM Account
                                                                            WHERE LPP_Plant_Code__c = :store
                                                                            ORDER BY Id
                                                                            LIMIT 50000]);
                for(AggregateResult a : [SELECT Account__r.LPP_Plant_Code__c c1, count(Id) c2
                                        FROM Scorecard__c
                                        WHERE CALENDAR_YEAR(Account__r.Last_Changed_Date__c) = :Integer.valueOf(year)
                                        AND Account__r.LPP_Plant_Code__c = :store
                                        AND Last_Changed_by_User_Stores__c != NULL
                                        GROUP BY Account__r.LPP_Plant_Code__c]){
                    if(!mapStoreKPI.containsKey((String)a.get('c1'))){
                        storeKPI s = new storeKPI();
                        s.storeNumber = (String)a.get('c1');
                        s.opportunityScoreCard = (Integer)a.get('c2');
                        s.contacts = 0;
                        s.outboundPhoneCalls = 0;
                        mapStoreKPI.put(s.storeNumber, s);
                    } else {
                        mapStoreKPI.get((String)a.get('c1')).opportunityScoreCard = (Integer)a.get('c2');
                    }
                }
                for(AggregateResult a : [SELECT Account.LPP_Plant_Code__c c1, count(Id) c2
                                        FROM Contact
                                        WHERE CALENDAR_YEAR(Last_Changed_Date__c) = :Integer.valueOf(year)
                                        AND Account.LPP_Plant_Code__c = :store
                                        AND Last_Changed_By_Role__c LIKE '%LPP SM%'
                                        GROUP BY Account.LPP_Plant_Code__c]){
                    if(!mapStoreKPI.containsKey((String)a.get('c1'))){
                        storeKPI s = new storeKPI();
                        s.storeNumber = (String)a.get('c1');
                        s.opportunityScoreCard = 0;
                        s.contacts = (Integer)a.get('c2');
                        s.outboundPhoneCalls = 0;
                        mapStoreKPI.put(s.storeNumber, s);
                    } else {
                        mapStoreKPI.get((String)a.get('c1')).contacts = (Integer)a.get('c2');
                    }
                }
                Date startDate = Date.valueOf(year + '-01-01');
                Date endDate = Date.valueOf(String.valueOf(Integer.valueOf(year) + 1) + '-01-01');
                for(AggregateResult a : [SELECT AccountId c1, count(Id) c2
                                        FROM Event
                                        WHERE ActivityDate >= :startDate AND ActivityDate < :endDate
                                        AND Event_TYpe__c ='Phone Call - Outbound'
                                        AND Owner.UserRole.Name LIKE '%Res LPP SM%'
                                        //AND WhatId IN :mapAccountStoreNumber.keySet()
                                        AND AccountId IN :mapAccountStoreNumber.keySet()
                                        GROUP BY AccountId]){
                    String storeNumber = mapAccountStoreNumber.get((String)a.get('c1')).LPP_Plant_Code__c;
                    if(!mapStoreKPI.containsKey(storeNumber)){
                        storeKPI s = new storeKPI();
                        s.storeNumber = storeNumber;
                        s.opportunityScoreCard = 0;
                        s.contacts = 0;
                        s.outboundPhoneCalls = (Integer)a.get('c2');
                        mapStoreKPI.put(s.storeNumber, s);
                    } else {
                        mapStoreKPI.get(storeNumber).outboundPhoneCalls += (Integer)a.get('c2');
                    }                
                }
                
                Map<String, String> mapAccountStoreName = new Map<String, String>();
                for(AggregateResult a : [SELECT LPP_Plant_Code__c c1, Main_LPP_Store__c c2, Count(Id) c3
                                        FROM Account
                                        WHERE LPP_Plant_Code__c = :store
                                            AND Main_LPP_Store__c != NULL
                                        GROUP BY LPP_Plant_Code__c, Main_LPP_Store__c]){
                    String storeNumber = (String)a.get('c1');
                    String storeName = (String)a.get('c2');
                    if(storeName.contains(storeNumber)) {
                        mapAccountStoreName.put(storeNumber, storeName);
                    }
                }
                for(String k : mapStoreKPI.keySet()){
                    mapStoreKPI.get(k).storeName = k + mapAccountStoreName.get(k).substringAfter(k);
                }
                storeKPIList = new List<storeKPI>(mapStoreKPI.values());
                */
                storeKPIList = new List<storeKPI>();
                for(AggregateResult a : [SELECT 
                                            Store__c, 
                                            SUM(KPI_OppScorecards__c) KPI_OppScorecards__c, 
                                            SUM(KPI_Contacts__c) KPI_Contacts__c,
                                            SUM(KPI_PhoneCalls__c) KPI_PhoneCalls__c
                                        FROM ExecutiveRollUpMain__c
                                        WHERE Year__c =: String.valueOf(year) 
                                            AND Type__c LIKE 'Store Summary%'
                                            AND Store__c = :store
                                        GROUP BY Store__c]){
                    storeKPI s = new storeKPI();
                    s.storeNumber = (String) a.get('Store__c');
                    s.storeName = mapStoreName.get(s.storeNumber);
                    s.opportunityScoreCard = Integer.valueOf((Decimal)a.get('KPI_OppScorecards__c'));
                    s.contacts = Integer.valueOf((Decimal)a.get('KPI_Contacts__c'));
                    s.outboundPhoneCalls = Integer.valueOf((Decimal)a.get('KPI_PhoneCalls__c'));
                    storeKPIList.add(s);
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
                //Map<Id,User> userMap = new Map<Id,User>([SELECT Id,Name,Email 
                //                                         FROM User WHERE Id=:currentLoggedInUser OR ( ManagerId = :u.Id 
                //                                         AND LPP_Store__c =:store
                //                                         AND Title='Counter Sales Associate'
                //                                         AND IsActive = true)
                //                                         ORDER BY NAME ASC]);
                
                //for(Id userId: userMap.keySet()){
                //    monthUpdatedScoreCount.put(userId,0);
                //    yearUpdatedScoreCount.put(userId,0);
                //    monthUpdatedContactCount.put(userId,0);
                //    yearUpdatedContactCount.put(userId,0);
                //    monthCreatedContactCount.put(userId,0);
                //    yearCreatedContactCount.put(userId,0);
                //    monthCreatedEventCount.put(userId,0);
                //    yearCreatedEventCount.put(userId,0);
                //}
                
                //Opportunity Scorecards, Contact and Outbound Phone Calls record count
                //processRecordCounts(userMap); 
                invalidProfile = false;
            } else {
                invalidProfile = true;
            }
        //}
        //catch(Exception e)
        //{
        //    System.debug('Exception:::'+e.getMessage());
        //    System.debug('Exception:::'+e.getLineNumber());
        //}
    }
    /*
    public void processRecordCounts(Map<Id,User> userMap){
        userOppScoreWrapList = new List<UserScorecardWrapper>();
        userContactWrapList = new List<UserContactWrapper>();
        userEventWrapList = new List<UserEventWrapper>();
        Integer currentMonth = Date.Today().Month(); 
        List<AggregateResult> aggregateYearScorecardList = [SELECT Count(Id),LastModifiedById
                                                            FROM Scorecard__c
                                                            WHERE LastModifiedById IN :userMap.keySet() AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                            GROUP BY LastModifiedById];
        List<AggregateResult> aggregateMonthScorecardList = [SELECT Count(Id),LastModifiedById
                                                             FROM Scorecard__c
                                                             WHERE LastModifiedById IN :userMap.keySet() 
                                                             AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                             AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                             GROUP BY LastModifiedById];
        
        for(AggregateResult agg :aggregateYearScorecardList){
            yearUpdatedScoreCount.put((String)agg.get('LastModifiedById'),(Integer)agg.get('expr0'));
        }
        for(AggregateResult agg :aggregateMonthScorecardList){
            monthUpdatedScoreCount.put((String)agg.get('LastModifiedById'),(Integer)agg.get('expr0'));
        }
        
        
        List<AggregateResult> aggregateYearContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                FROM Contact
                                                                WHERE LastModifiedById IN :userMap.keySet() AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                GROUP BY LastModifiedById];
        List<AggregateResult> aggregateMonthContactUpdateList = [SELECT Count(Id),LastModifiedById
                                                                 FROM Contact
                                                                 WHERE LastModifiedById IN :userMap.keySet() 
                                                                 AND CALENDAR_YEAR(LastModifiedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(LastModifiedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY LastModifiedById];
        List<AggregateResult> aggregateYearContactCreateList = [SELECT Count(Id),CreatedById
                                                                FROM Contact
                                                                WHERE CreatedById IN :userMap.keySet() AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                GROUP BY CreatedById];
        List<AggregateResult> aggregateMonthContactCreateList = [SELECT Count(Id),CreatedById
                                                                 FROM Contact
                                                                 WHERE CreatedById IN :userMap.keySet() 
                                                                 AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                                 AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                                 GROUP BY CreatedById];
        
        
        for(AggregateResult agg :aggregateYearContactUpdateList){
            yearUpdatedContactCount.put((String)agg.get('LastModifiedById'),(Integer)agg.get('expr0'));
        }
        for(AggregateResult agg :aggregateMonthContactUpdateList){
            monthUpdatedContactCount.put((String)agg.get('LastModifiedById'),(Integer)agg.get('expr0')); 
        }
        
        for(AggregateResult agg :aggregateYearContactCreateList){
            yearCreatedContactCount.put((String)agg.get('CreatedById'),(Integer)agg.get('expr0'));
        }
        for(AggregateResult agg :aggregateMonthContactCreateList){
            monthCreatedContactCount.put((String)agg.get('CreatedById'),(Integer)agg.get('expr0'));
        }
        
        
        List<AggregateResult> aggregateYearEventCreateList = [SELECT Count(Id),OwnerId
                                                              FROM Event
                                                              WHERE OwnerId IN :userMap.keySet() AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                              AND Event_TYpe__c ='Phone Call - Outbound'
                                                              GROUP BY OwnerId];
        List<AggregateResult> aggregateMonthEventCreateList = [SELECT Count(Id),OwnerId
                                                               FROM Event
                                                               WHERE OwnerId IN :userMap.keySet() 
                                                               AND Event_TYpe__c ='Phone Call - Outbound'
                                                               AND CALENDAR_YEAR(CreatedDate) = :Integer.valueOf(year)
                                                               AND CALENDAR_Month(CreatedDate) = :Integer.valueOf(currentMonth)
                                                               GROUP BY OwnerId]; 
        
        for(AggregateResult agg :aggregateYearEventCreateList){
            yearCreatedEventCount.put((String)agg.get('OwnerId'),(Integer)agg.get('expr0'));
        }
        for(AggregateResult agg :aggregateMonthEventCreateList){
            monthCreatedEventCount.put((String)agg.get('OwnerId'),(Integer)agg.get('expr0'));
        }
        
        for(Id userId: userMap.keySet()){
            //For Scorecard
            UserScorecardWrapper uwScorecard = new UserScorecardWrapper();
            uwScorecard.scorecardUserId = userMap.get(userId).Id;
            uwScorecard.scorecardUserName = userMap.get(userId).Name;
            uwScorecard.scorecardMonthUpdatedCount = monthUpdatedScoreCount.get(userId);
            uwScorecard.scorecardYearUpdatedCount = yearUpdatedScoreCount.get(userId);
            userOppScoreWrapList.add(uwScorecard); 
            
            //For Contact
            UserContactWrapper uwContact = new UserContactWrapper();
            uwContact.contactUserId = userMap.get(userId).Id;
            uwContact.contactUserName = userMap.get(userId).Name;
            uwContact.contactMonthUpdatedCount = monthUpdatedContactCount.get(userId);
            uwContact.contactYearUpdatedCount = yearUpdatedContactCount.get(userId);
            uwContact.contactMonthCreatedCount = monthCreatedContactCount.get(userId);
            uwContact.contactYearCreatedCount = yearCreatedContactCount.get(userId);
            userContactWrapList.add(uwContact);
            
            //For Event
            UserEventWrapper uwEvent = new UserEventWrapper();
            uwEvent.eventUserId = userMap.get(userId).Id;
            uwEvent.eventUserName = userMap.get(userId).Name;
            uwEvent.eventMonthCreatedCount = monthCreatedEventCount.get(userId);
            uwEvent.eventYearCreatedCount = yearCreatedEventCount.get(userId);
            userEventWrapList.add(uwEvent); 
        }
    }
    */
    // User Wrapper List
   /* public class UserWrapper{
        public string userId{get; set;}
        public string userName{get;set;}
        public integer monthUpdatedCount{get;set;}
        public integer yearUpdatedCount{get;set;}
        public integer monthCreatedCount{get;set;}
        public integer yearCreatedCount{get;set;}
    }*/
    
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

    private Map<String, String> getStoreName(String store){
        Map<String, String> mapAccountStoreName = new Map<String, String>();
        for(AggregateResult a : [SELECT LPP_Plant_Code__c c1, Main_LPP_Store__c c2, Count(Id) c3
                                FROM Account
                                WHERE LPP_Plant_Code__c = :store
                                    AND Main_LPP_Store__c != NULL
                                GROUP BY LPP_Plant_Code__c, Main_LPP_Store__c]){
            String storeNumber = (String)a.get('c1');
            String storeName = (String)a.get('c2');
            if(storeNumber != null && storeName != null && storeName.contains(storeNumber)) {
                storeName = storeNumber + storeName .substringAfter(storeNumber);
                mapAccountStoreName.put(storeNumber, storeName);
            }
        }
        return mapAccountStoreName;      
    }

    public class GrowthStore
    {
        public string dealerId{get; set;}
        public string dealerName{get;set;}
        public string dealerCustNo{get;set;}
        public string dealerTSAStatus{get;set;}
        public decimal dealerYTDSalesLC{get; set;}
        public decimal dealerDeltAYTDSales{get; set;}
        public decimal dealerPre1TS{get; set;}
        public decimal dealerPre2TS{get; set;}
        //public decimal dealerPre3TS{get; set;}
        public Date lastActivity{get;set;}
    }
    public class TargetStoreAccounts
    {
        public string dealerId{get; set;}
        public string dealerName{get;set;}
        public string dealerCustNo{get;set;}
        public string dealerTSAStatus{get;set;}
        public decimal dealerYTDSalesLC{get; set;}
        public decimal dealerDeltAYTDSales{get; set;}
        public decimal dealerPre1TS{get; set;}
        public decimal dealerPre2TS{get; set;}
        //public decimal dealerPre3TS{get; set;}
        public Date lastActivity{get;set;}
    }
    public class storeKPI 
    {
        public string storeNumber{get;set;}
        public string storeName{get;set;}
        public integer opportunityScoreCard{get;set;}
        public integer contacts{get;set;}
        public integer outboundPhoneCalls{get;set;}
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
}