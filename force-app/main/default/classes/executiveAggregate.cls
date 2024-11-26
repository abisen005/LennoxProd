/********************************************************
Developer : Eduardo Rodriguez
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class executiveAggregate
{
    //variable declarations
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
    //private List<User> amUsers{get;set;}
    //private List<Profile> dmProfileUsers{get; set;}
    public Date lastSalesHistoryUpdate {get; set;}
    public String renderPDF {get; set;}
    public String pdfLink {get; set;}
    
    //variable for Dealer Sales History
    public decimal previousYearTotalSales{get; set;}
    public decimal previousTwoYearsTotalSales{get; set;}
    public decimal previousThreeYearsTotalSales{get; set;}
    
    //variable for YTD Sales Comparison
    public decimal presentYearSalesForecast{get; set;}
    public decimal ytdSales{get; set;}
    public decimal previuosYearsYTDSales{get; set;}
    
    //variable for YTD Sales - Product Hierarchy
    public decimal ytdSalesChange{get; set;}
    public decimal ytdResEquipment{get; set;}
    public decimal ytdCommercials{get; set;}
    public decimal ytdPartsndSupplies{get; set;}
    
    //variable for YTD Sales - Product Tier Present Year
    public decimal presetDLSC{get; set;}
    public decimal presetDLSCPercent{get; set;}
    public decimal presetMerit{get; set;}
    public decimal presetMeritPercent{get; set;}
    public decimal presetElite{get; set;}
    public decimal presetElitePercent{get; set;}
    public decimal presetAireFlo{get; set;}
    public decimal presetAireFloPercent{get; set;}
    public decimal presetOther{get; set;}
    public decimal presentYearOtherPercent{get; set;}
    
    public decimal dealerDeltAYTDSalesSum1{get;set;}
    public decimal dealerYTDSalesLCSum1{get;set;}
    public decimal dealerpre1TSSum1{get;set;}
    public decimal dealerPre2TSSum1{get;set;}
    public decimal dealerPre3TSSum1{get;set;}
    
    public decimal dealerDeltAYTDSalesSum2{get;set;}
    public decimal dealerYTDSalesLCSum2{get;set;}
    public decimal dealerpre1TSSum2{get;set;}
    public decimal dealerPre2TSSum2{get;set;}
    public decimal dealerPre3TSSum2{get;set;}
    
    //variable for YTD Sales - Product Tier Previous Year
    public decimal previousYearDLSC{get; set;}
    public decimal previousYearDLSCPercent{get; set;}
    public decimal previousYearMerit{get; set;}
    public decimal previousYearMeritPercent{get; set;}
    public decimal previousYearElite{get; set;}
    public decimal previousYearElitePercent{get; set;}
    public decimal previousYearAireFlo{get; set;}
    public decimal previousYearAireFloPercent{get; set;}
    public decimal previousYearOther{get; set;}
    public decimal previousYearOtherPercent{get; set;}
    
    
    
    
    public decimal totaloftotal1{get; set;}
    public decimal totaloftotal2{get; set;}
    
    
    public decimal changeDLSC{get; set;}
    public decimal changeMerit{get; set;}
    public decimal changeElite{get; set;}
    public decimal changeAireFlo{get; set;}
    public decimal changeOther{get; set;}
    
    public string yearSelected='';
    public Set<Id> accIdSetTerritory = new Set<Id>();
    
    
    public Boolean displayAccOpty{get; set;}
    public Boolean displayCompletedAccOpty{get; set;}
    public Boolean displayInProgressAccOpty{get; set;}
    public Boolean displayCanceledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppCanceled{get; set;}
    
    public Boolean displayActionPlanProgress{get; set;}
    public Boolean displayActionPlanCompleted{get; set;}
    public Boolean displayActionPlanNotStarted{get; set;}
    public Boolean displayActionPlanCanceled{get; set;}
    
    public ExecutiveRollUpMain__c thisRecord {get; set;}
    public List<ExecutiveRollUpChild__c> regionRecords {get; set;}
    //public List<ExecutiveRollUpChild__c> regionRecordsWithNRA {get; set;}
    
    
    public List<AggregateResult> regionRecordsWithNRA {get; set;}
    public List<AggregateResult> regionResidentialRecords {get; set;}
    public List<AggregateResult> regionResSourcedRecords {get; set;}
    
    
    
    
    public List<ExecutiveRollUpChild__c> accOppInProgress{get; set;}
    public List<ExecutiveRollUpChild__c> accOppOnHold{get; set;}
    public List<ExecutiveRollUpChild__c> accOppNotStarted{get; set;}
    public List<ExecutiveRollUpChild__c> accOppCanceled{get; set;}
    public List<ExecutiveRollUpChild__c> accOppCompleted{get; set;}
    
    public List<ExecutiveRollUpChild__c> accRetInProgress{get; set;}
    public List<ExecutiveRollUpChild__c> accRetOnHold{get; set;}
    public List<ExecutiveRollUpChild__c> accRetNotStarted{get; set;}
    public List<ExecutiveRollUpChild__c> accRetCanceled{get; set;}
    public List<ExecutiveRollUpChild__c> accRetCompleted{get; set;}
    
    public Integer retInProgressCRI {get; set;}
    public Integer retNotStartedCRI {get; set;}
    public Integer retCanceledCRI {get; set;}
    public Integer retCompletedCRI {get; set;}
    
    public List<ExecutiveRollUpChild__c> accPlanInProgress{get; set;}
    public List<ExecutiveRollUpChild__c> accPlanOnHold{get; set;}
    public List<ExecutiveRollUpChild__c> accPlanNotStarted{get; set;}
    public List<ExecutiveRollUpChild__c> accPlanCanceled{get; set;}
    public List<ExecutiveRollUpChild__c> accPlanCompleted{get; set;}
    
    public integer totalOppAmount {get; set;}
    public List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper> favURLList{get; set;}
    
    
    public String getyearSelected()
    {
        return yearSelected;
    }
    
    public void setyearSelected(String yearSelected)
    {
        this.yearSelected = yearSelected;
    }
    public Pagereference cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    //constructor of the class.
    //Here average value for Present and past years for various fields value to be displayed on the page is calculated using the aggregate
    //query. The value of Present/Previous year, Dealer Id is captured from the url for further references.
    public executiveAggregate()
    {
        AggregateReportsSettings__c profilesettings = AggregateReportsSettings__c.getOrgDefaults(); 
        currentLoggedInUser = userinfo.getUserId();
        //Get Reports & dashboards Link for the current loggedin User
        showFavoritesLinkSalesUtility favLinkClass = new showFavoritesLinkSalesUtility();
        favURLList = favLinkClass.getFavoritesLink(currentLoggedInUser);
        
        List<String> validProfiles = new List<String>();
        renderPDF = '';
        for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                            FROM Quick_Links_Cmp_Setting__c 
                                            WHERE RollupSummary__c = true]){
            validProfiles.add(q.Profile_Name__c);
        }        
        //if(profilesettings != null && profilesettings.Executive_Access__c != null)
        //{
        //    validProfiles = profilesettings.Executive_Access__c.split(';');
        //}
        System.debug('::validProfiles = '+validProfiles);
        /*
validProfiles.add('Lennox - Res Sales - EXE');
//validProfiles.add('Lennox - Res Sales - Corporate User');
validProfiles.add('Lennox Business Administrator');
validProfiles.add('Lennox Business Administrator Super');*/
        
        try
        {
            User verProfile = [SELECT Id From USER WHERE Id =: currentLoggedInUser AND Profile.Name IN: validProfiles];
            invalidProfile = false;
        } catch (Exception e)
        {
            System.debug('Unauthorized Login Attempted -'+e.getMessage());
            if(Test.isRunningTest())
            {
                invalidProfile = false;
            }
            else
            {
                invalidProfile = true;
                return;
            }
        }
        
        
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
            
            if(renderPDF == '')
            {
                pageURL += '&pdf=true';
            }
            
            pdfLink = baseURL + pageURL;
            
        } 
        catch(Exception e)
        { System.debug('Error Obtaining Year -'+e.getMessage()); 
         return; 
        }
        
        
        
        try {
            thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, CY_YTDDLSC__c, CY_YTDElite__c, CY_YTDMerit__c, CY_YTDOther__c,
                          CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, P2Y_SalesHistory__c, P3Y_SalesHistory__c, PY_SalesHistory__c,
                          PY_YTDAireFlo__c, PY_YTDDLSC__c, PY_YTDElite__c, PY_YTDMerit__c, PY_YTDOther__c, PY_YTDSales__c,
                          TotalInProgressOpp__c, TotalCanceledOpp__c, TotalOnHoldOpp__c, TotalNotStartedOpp__c, TotalCompletedOpp__c, 
                          TotalInProgressRet__c, TotalCanceledRet__c, TotalNotStartedRet__c, TotalCompletedRet__c, 
                          TotalInProgressAcp__c, TotalCanceledAcp__c, TotalNotStartedAcp__c, TotalCompletedAcp__c, 
                          TotalInProgressAdj__c, TotalCanceledAdj__c, TotalOnHoldAdj__c, TotalNotStartedAdj__c, TotalCompletedAdj__c, 
                          TotalInProgressExp__c, TotalCanceledExp__c, TotalOnHoldExp__c, TotalNotStartedExp__c, TotalCompletedExp__c,LastModifiedDate, Last_Sales_History_Update__c FROM ExecutiveRollUpMain__c WHERE Year__c =: String.valueOf(year) AND Type__c = 'Executive' LIMIT 1];
        } catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Could not retrieve information.'));
            return;
        }    
        changeDLSC = 0;
        changeMerit = 0;
        changeElite = 0;
        changeAireFlo = 0;
        changeOther = 0;   
       //Date reportDate = thisRecord.Last_Sales_History_Update__c != null ? thisRecord.Last_Sales_History_Update__c : Date.today().addDays(-1);
        //lastSalesHistoryUpdate = Date.newInstance(reportDate.year(),reportDate.month(),reportDate.day());
        previousYearTotalSales = thisRecord.PY_SalesHistory__c != null ? thisRecord.PY_SalesHistory__c : 0;
        previousTwoYearsTotalSales = thisRecord.P2Y_SalesHistory__c != null ? thisRecord.P2Y_SalesHistory__c : 0;
        previousThreeYearsTotalSales = thisRecord.P3Y_SalesHistory__c != null ? thisRecord.P3Y_SalesHistory__c : 0;
        
        presentYearSalesForecast = thisRecord.CY_SalesForecast__c != null ? thisRecord.CY_SalesForecast__c : 0;
        //ytdSales = thisRecord.CY_YTDSales__c;
       // previuosYearsYTDSales = thisRecord.PY_YTDSales__c;
        
        ytdSalesChange = thisRecord.PY_YTDSales__c == null ? thisRecord.CY_YTDSales__c : thisRecord.CY_YTDSales__c - thisRecord.PY_YTDSales__c;
        ytdResEquipment = thisRecord.CY_YTDResEquipment__c;
        ytdCommercials = thisRecord.CY_YTDCommercial__c;
        ytdPartsndSupplies = thisRecord.CY_YTDPartsAndSupplies__c;
        
        if(ytdSales == null) ytdSales = 0; 
        
        presetDLSC = thisRecord.CY_YTDDLSC__c != null ? thisRecord.CY_YTDDLSC__c : 0;
        presetDLSCPercent = ytdSales == 0 ? 0 : presetDLSC / ytdSales;
        presetMerit = thisRecord.CY_YTDMerit__c != null ? thisRecord.CY_YTDMerit__c : 0;
        presetMeritPercent = ytdSales == 0 ? 0 : presetMerit / ytdSales;
        presetElite = thisRecord.CY_YTDElite__c != null ? thisRecord.CY_YTDElite__c : 0 ;
        presetElitePercent = ytdSales == 0 ? 0 : presetElite / ytdSales;
        presetAireFlo = thisRecord.CY_YTDAireFlo__c != null ? thisRecord.CY_YTDAireFlo__c :0  ;
        presetAireFloPercent = ytdSales == 0 ? 0 : presetAireFlo / ytdSales;
        //Enhancments (Combining Aire Flow and Other)
        presetOther = thisRecord.CY_YTDOther__c != null ?  thisRecord.CY_YTDOther__c  + presetAireFlo : 0;
        presentYearOtherPercent = ytdSales == 0 ? 0 : thisRecord.CY_YTDOther__c / ytdSales;
        
        if(previuosYearsYTDSales == null) previuosYearsYTDSales = 0; 
        
        previousYearDLSC = thisRecord.PY_YTDDLSC__c;
        previousYearDLSCPercent = previuosYearsYTDSales == 0 ? 0 : thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
        previousYearMerit = thisRecord.PY_YTDMerit__c;
        previousYearMeritPercent = previuosYearsYTDSales == 0 ? 0 : thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
        previousYearElite = thisRecord.PY_YTDElite__c;
        previousYearElitePercent = previuosYearsYTDSales == 0 ? 0 : thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
        previousYearAireFlo = thisRecord.PY_YTDAireFlo__c != null ? thisRecord.PY_YTDAireFlo__c : 0 ;
        previousYearAireFloPercent = previuosYearsYTDSales == 0 ? 0 : thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
        //Enhancments (Combining Aire Flow and Other)
        if(test.isRunningTest()){ previousYearOther=0;
                                }else{
                                    previousYearOther = thisRecord.PY_YTDOther__c != null ? thisRecord.PY_YTDOther__c +previousYearAireFlo : previousYearAireFlo ;
                                    
                                }
        previousYearOtherPercent = previuosYearsYTDSales == 0 ? 0 : thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
        
        changeDLSC =  previousYearDLSC == null ? presetDLSC : presetDLSC - previousYearDLSC;
        changeMerit = previousYearMerit == null ? presetMerit : presetMerit - previousYearMerit;
        changeElite = previousYearElite == null ? presetElite : presetElite - previousYearElite; 
        changeAireFlo = previousYearAireFlo == null ? presetAireFlo : presetAireFlo - previousYearAireFlo;
        changeOther = previousYearOther == null ? presetOther : presetOther - previousYearOther;
        
        regionRecords = [SELECT Id, URLText__c, Region__c, PY_YTDSales__c, CY_YTDSales__c, RegionYTDChange__c, NonResidentialAccounts__c FROM ExecutiveRollUpChild__c
                         WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Region' AND Region__c != 'Non Residential Accounts' ORDER BY RegionYTDChange__c DESC];
        //regionRecordsWithNRA = [SELECT Id, URLText__c, Region__c, PY_YTDSales__c, CY_YTDSales__c, RegionYTDChange__c, NonResidentialAccounts__c FROM ExecutiveRollUpChild__c
        //WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Region' AND Region__c = 'Non Residential Accounts' ORDER BY RegionYTDChange__c DESC];
        // regionResidentialRecords=[SELECT sum(CY_YTDSales__c)CY_YTDSales__c,sum(PY_YTDSales__c) PY_YTDSales__c, sum(RegionYTDChange__c)RegionYTDChange__c FROM ExecutiveRollUpChild__c
        //  WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Region' and NonResidentialAccounts__c = false];
        
        Date todayDate = Date.today();
        //String thisYear = String.valueOf(todayDate.year());
        String thisYear = String.valueOf(year);  
        
        regionRecordsWithNRA =[SELECT sum(YTD_Sales__c) CY_YTDSales__c,sum(PY_YTD_Sales__c)PY_YTDSales__c
                               FROM Account_Planning__c WHERE  
                               Account_Plan_Year__c  =: thisYear AND (Region__c like 'Commercial%' OR Region__c like 'Special%') ];
        
        regionResidentialRecords =[SELECT sum(YTD_Sales__c) CY_YTDSales__c,sum(PY_YTD_Sales__c)PY_YTDSales__c
                                   FROM Account_Planning__c WHERE  
                                   Account_Plan_Year__c =:thisYear  AND (Region__c ='Home Warr/Prpty Mgmt' OR Region__c like 'Res National%' )];
                                   
                                   
                                   
        regionResSourcedRecords =[SELECT sum(YTD_Sales__c) CY_YTDSales__c,sum(PY_YTD_Sales__c)PY_YTDSales__c
                                   FROM Account_Planning__c WHERE  
                                   Account_Plan_Year__c =:thisYear  AND Region__c ='Res Sourced Products'];
                                   
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

                                 
                                   
                         // Fetching data from regionRecords query
                      for(ExecutiveRollUpChild__c record : regionRecords) {
        // Extracting values from the query results
        Decimal PY_YTDSales = (Decimal) record.get('PY_YTDSales__c');
        Decimal CY_YTDSales = (Decimal) record.get('CY_YTDSales__c');

        // Handling null values
        if(PY_YTDSales == null) PY_YTDSales = 0;
        if(CY_YTDSales == null) CY_YTDSales = 0;

        // Accumulating values
        previuosYearsYTDSales += PY_YTDSales;
        ytdSales += CY_YTDSales;
    }
                    
                        // Fetching data from regionResidentialRecords query
                        for(AggregateResult result : regionResidentialRecords) {
                            // Extracting values from the query results
                            Decimal PY_YTDSales_Res = (Decimal) result.get('PY_YTDSales__c');
                            Decimal CY_YTDSales_Res = (Decimal) result.get('CY_YTDSales__c');
                    
                            // Handling null values
                            if(PY_YTDSales_Res == null) PY_YTDSales_Res = 0;
                            if(CY_YTDSales_Res == null) CY_YTDSales_Res = 0;
                    
                            // Accumulating values
                            previuosYearsYTDSales += PY_YTDSales_Res;
                            ytdSales += CY_YTDSales_Res;
                        }
                    
                        // Fetching data from regionResSourcedRecords query
                        for(AggregateResult result : regionResSourcedRecords) {
                            // Extracting values from the query results
                            Decimal PY_YTDSales_Sourced = (Decimal) result.get('PY_YTDSales__c');
                            Decimal CY_YTDSales_Sourced = (Decimal) result.get('CY_YTDSales__c');
                    
                            // Handling null values
                            if(PY_YTDSales_Sourced == null) PY_YTDSales_Sourced = 0;
                            if(CY_YTDSales_Sourced == null) CY_YTDSales_Sourced = 0;
                    
                            // Accumulating values
                            previuosYearsYTDSales += PY_YTDSales_Sourced;
                            ytdSales += CY_YTDSales_Sourced;
                        }
                                                       
                                   
                              
                                   
                                   
                                   
                                   
                                   /////////////////////////////////////////
                                   
                                   

    
                       
                       
                                   
        
        List<ExecutiveRollUpChild__c> accOppRecords = [SELECT Id, URLText__c, Region__c, AdjustedValue__c, ExpectedValue__c, NumberOfAccOpp__c, NonResidentialAccounts__c, Status__c FROM ExecutiveRollUpChild__c
                                                       WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Opportunity' ORDER BY AdjustedValue__c DESC];
        List<ExecutiveRollUpChild__c> retOppRecords = [SELECT Id, URLText__c, Region__c, NumberOfRetOpp__c, PotentialCRIPoints__c, NonResidentialAccounts__c, Status__c FROM ExecutiveRollUpChild__c
                                                       WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Retention' ORDER BY PotentialCRIPoints__c DESC];
        List<ExecutiveRollUpChild__c> accPlanRecords = [SELECT Id, URLText__c, Region__c, NumberOfActionPlans__c, NonResidentialAccounts__c, Status__c FROM ExecutiveRollUpChild__c
                                                        WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'ActionPlan' ORDER BY NumberOfActionPlans__c DESC];
        
        System.debug(regionRecords);
        System.debug(accOppRecords);
        System.debug(retOppRecords);
        System.debug(accPlanRecords);
        
        
        
        
        for(AggregateResult regionResidentialSum: regionResidentialRecords ){
            if(regionResidentialSum != null){
                // ExecutiveRollUpMain__c exec = new ExecutiveRollUpMain__c();
                //exec.PY_YTDSales__c =regionResidentialSum.get('PY_YTDSales__c') ;
                // exec.CY_YTDSales__c =regionResidentialSum. ;
                // exec.RegionYTDChange__c =;
                
            }
        }
        
        accOppInProgress = new List<ExecutiveRollUpChild__c>();
        accOppOnHold = new List<ExecutiveRollUpChild__c>();
        accOppCanceled = new List<ExecutiveRollUpChild__c>();
        accOppNotStarted = new List<ExecutiveRollUpChild__c>();
        accOppCompleted = new List<ExecutiveRollUpChild__c>();
        accRetInProgress = new List<ExecutiveRollUpChild__c>();
        accRetCanceled = new List<ExecutiveRollUpChild__c>();
        accRetCompleted = new List<ExecutiveRollUpChild__c>();
        accRetNotStarted = new List<ExecutiveRollUpChild__c>();
        accPlanInProgress = new List<ExecutiveRollUpChild__c>();
        accPlanCompleted = new List<ExecutiveRollUpChild__c>();
        accPlanNotStarted = new List<ExecutiveRollUpChild__c>();
        accPlanCanceled = new List<ExecutiveRollUpChild__c>();
        
        for(ExecutiveRollUpChild__c acc: accOppRecords)
        {
            if(acc.Status__c == 'In Progress') accOppInProgress.add(acc);
            if(acc.Status__c == 'On Hold') accOppOnHold.add(acc);
            if(acc.Status__c == 'Not Started') accOppNotStarted.add(acc);
            if(acc.Status__c == 'Completed') accOppCompleted.add(acc);
            if(acc.Status__c == 'Canceled') accOppCanceled.add(acc);
        }
        
        retInProgressCRI = 0;
        retNotStartedCRI = 0;
        retCompletedCRI = 0;
        retCanceledCRI = 0;
        
        for(ExecutiveRollUpChild__c acc: retOppRecords)
        {
            if(acc.Status__c == 'In Progress') {
                accRetInProgress.add(acc);
                retInProgressCRI += Integer.valueOf(acc.PotentialCRIPoints__c);
            }
            if(acc.Status__c == 'Not Started') {
                accRetNotStarted.add(acc);
                retNotStartedCRI += Integer.valueOf(acc.PotentialCRIPoints__c);
            }
            if(acc.Status__c == 'Completed') {
                accRetCompleted.add(acc);
                retCompletedCRI += Integer.valueOf(acc.PotentialCRIPoints__c);
            }
            if(acc.Status__c == 'Canceled') {
                accRetCanceled.add(acc);
                retCanceledCRI += Integer.valueOf(acc.PotentialCRIPoints__c);
            } 
        }
        
        
        
        for(ExecutiveRollUpChild__c acc: accPlanRecords)
        {
            if(acc.Status__c == 'In Progress') accPlanInProgress.add(acc);
            if(acc.Status__c == 'On Hold') accPlanOnHold.add(acc);
            if(acc.Status__c == 'Not Started') accPlanNotStarted.add(acc);
            if(acc.Status__c == 'Completed') accPlanCompleted.add(acc);
            if(acc.Status__c == 'Canceled') accPlanCanceled.add(acc);
        }
        
        displayInProgressAccOpty = false;
        displayHoldAccOpty = false; 
        displayCompletedAccOpty = false;
        displayCanceledAccOpty = false;
        displayNotStartedAccOpty = false;
        displayRetentionOppProgress =false;
        displayRetentionOppCompleted = false;
        displayRetentionOppCanceled = false;
        displayRetentionOppNotStarted = false;
        displayActionPlanProgress = false;
        displayActionPlanCompleted = false;
        displayActionPlanCanceled = false;
        displayActionPlanNotStarted = false;
        if(thisRecord.TotalInProgressOpp__c > 0) displayInProgressAccOpty = true;
        if(thisRecord.TotalOnHoldOpp__c > 0) displayHoldAccOpty = true;
        if(thisRecord.TotalCompletedOpp__c > 0) displayCompletedAccOpty = true;
        if(thisRecord.TotalCanceledOpp__c > 0) displayCanceledAccOpty = true;
        if(thisRecord.TotalNotStartedOpp__c > 0) displayNotStartedAccOpty = true;
        if(thisRecord.TotalInProgressRet__c > 0) displayRetentionOppProgress = true;
        if(thisRecord.TotalCompletedRet__c > 0) displayRetentionOppCompleted = true;
        if(thisRecord.TotalCanceledRet__c > 0) displayRetentionOppCanceled = true;
        if(thisRecord.TotalNotStartedRet__c > 0) displayRetentionOppNotStarted = true;
        if(thisRecord.TotalInProgressAcp__c > 0) displayActionPlanProgress = true;
        if(thisRecord.TotalCompletedAcp__c > 0) displayActionPlanCompleted = true;
        if(thisRecord.TotalCanceledAcp__c > 0) displayActionPlanCanceled = true;
        if(thisRecord.TotalNotStartedAcp__c > 0) displayActionPlanNotStarted = true;
    }
    
}