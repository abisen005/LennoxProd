/********************************************************
Developer : Eduardo Rodriguez
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class areaManagerAggregate
{
//variable declarations
    public string currentLoggedInUser{get; set;}
    public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public User u{get; set;}
    private List<User> tmUsers{get; set;}
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
    public Boolean displaycanceledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppcanceled{get; set;}
    
    public Boolean displayActionPlanProgress{get; set;}
    public Boolean displayActionPlanCompleted{get; set;}
    public Boolean displayActionPlanNotStarted{get; set;}
    public Boolean displayActionPlancanceled{get; set;}
    
    public ExecutiveRollUpMain__c thisRecord {get; set;}
    public List<ExecutiveRollUpChild__c> regionRecords {get; set;}
    
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

public areaManagerAggregate()
{
    currentLoggedInUser = userinfo.getUserId();
    
    //Get Reports & dashboards Link for the current loggedin User
        showFavoritesLinkSalesUtility favLinkClass = new showFavoritesLinkSalesUtility();
    favURLList = favLinkClass.getFavoritesLink(currentLoggedInUser);
    
    AggregateReportsSettings__c profilesettings = AggregateReportsSettings__c.getOrgDefaults(); 
    
    List<String> validProfiles = new List<String>();
    for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                        FROM Quick_Links_Cmp_Setting__c 
                                        WHERE RollupSummary__c = true 
                                        OR RegionRollupSummary__c = true]){
        validProfiles.add(q.Profile_Name__c);
    }  
    //if(profilesettings != null && profilesettings.Executive_Access__c != null)
    //{
    //    validProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
    //}
    //if(profilesettings != null && profilesettings.Region_Access__c != null)
    //{
    //    validProfiles.addAll(profilesettings.Region_Access__c.split(';'));
    //}
    /*
    validProfiles.add('Lennox - Res Sales - EXE');
    validProfiles.add('Lennox - Res Sales - Corporate User');
    validProfiles.add('Lennox Business Administrator');
    validProfiles.add('Lennox Business Administrator Super');
    validProfiles.add('Lennox - Res Sales AM');
    validProfiles.add('Lennox - Res Sales BDM');
    validProfiles.add('Lennox - Res Sales RBM');*/
    
    User verProfile; 
    try
    {
        verProfile = [SELECT Id, Profile.Name, Name From USER WHERE Id =: currentLoggedInUser AND Profile.Name IN :validProfiles];
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
        else 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Year Value Missing.'));
            return;
        }
        } catch(Exception e)
        { System.debug('Error Obtaining Year -'+e.getMessage()); }
        
        Set<String> higherProfiles = new Set<String>();
        for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                            FROM Quick_Links_Cmp_Setting__c 
                                            WHERE RollupSummary__c = true]){
            higherProfiles.add(q.Profile_Name__c);
        }        
        //if(profilesettings != null && profilesettings.Executive_Access__c != null)
        //{
        //    higherProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
        //}
        /*
        higherProfiles.add('Lennox - Res Sales - EXE');
        higherProfiles.add('Lennox - Res Sales - Corporate User');
        higherProfiles.add('Lennox Business Administrator');
        higherProfiles.add('Lennox Business Administrator Super');*/
    
    try
    {
    //get the current logged in user's information

        if(verProfile != null && higherProfiles.contains(verProfile.Profile.Name))
        {
            System.debug('Current Profile = '+verProfile.Name);
            
            if(ApexPages.CurrentPage().getParameters() != null)
                 currentLoggedInUser = ApexPages.currentPage().getParameters().get('u');
            
            System.debug('Changing currentUser to -'+u);
            
            u = [SELECT Id, FirstName, LastName, SAP_Sales_District__c, SAP_Sales_Office__c, SAP_Sales_Group__c FROM User WHERE Id =: currentLoggedInUser LIMIT 1];
        }
        else
            u = [SELECT Id, FirstName, LastName, SAP_Sales_District__c, SAP_Sales_Office__c, SAP_Sales_Group__c FROM User WHERE Id =: currentLoggedInUser LIMIT 1];

        System.debug('Current User = '+u);

        currentLoggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() LIMIT 1].Name;

        System.debug('currentLoggedInUserArea::::::'+u.SAP_Sales_District__c);
        System.debug('currentLoggedInUser::::::'+currentLoggedInUser);

       //String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
             String forecastTotalSales;
            if(year == system.today().year()){
                        forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
            }
            else{
                 forecastTotalSales ='Dealer__r.Prior_Year_Sales_Forecast__c';
            }
        
        Set<String> tmProfiles = new Set<String>();
        tmProfiles.add('Lennox - Res Sales TM');
        tmProfiles.add('Lennox - Res Sales TM - Lightning');
        tmProfiles.add('Lennox - Res Sales TM Pilot');
        
        if(u != null)
        {
            if(Test.isRunningTest())
                    tmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Group__c, SAP_Sales_Office__c, SAP_Sales_District__c, IsActive FROM User WHERE SAP_Sales_District__c =: u.SAP_Sales_District__c];
                else 
                    tmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Group__c, SAP_Sales_Office__c, SAP_Sales_District__c, District_Description_Formula__c, IsActive FROM User WHERE SAP_Sales_District__c =: u.SAP_Sales_District__c AND Profile.Name IN: tmProfiles AND isActive = true];
        }
        
        System.debug('::tmUsers::'+tmUsers);
        
        Set<String> tmGroups = new Set<String>(); 
        if(tmUsers != null)
        {
            for(User us: tmUsers)
            {
                tmGroups.add(us.SAP_Sales_Group__c);
            }
        }
    } catch(Exception e)
    {
        System.debug('Error Getting User Information.');
        return;
    }

    Boolean ableToFindDataWithUserId = true;
    try {
             thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, CY_YTDDLSC__c, CY_YTDElite__c, CY_YTDMerit__c, CY_YTDOther__c,
                                                CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, P2Y_SalesHistory__c, P3Y_SalesHistory__c, PY_SalesHistory__c,
                                                PY_YTDAireFlo__c, PY_YTDDLSC__c, PY_YTDElite__c, PY_YTDMerit__c, PY_YTDOther__c, PY_YTDSales__c,
                                                TotalInProgressOpp__c, TotalCanceledOpp__c, TotalOnHoldOpp__c, TotalNotStartedOpp__c, TotalCompletedOpp__c, 
                                                TotalInProgressRet__c, TotalCanceledRet__c, TotalNotStartedRet__c, TotalCompletedRet__c, 
                                                TotalInProgressAcp__c, TotalCanceledAcp__c, TotalNotStartedAcp__c, TotalCompletedAcp__c, 
                                                TotalInProgressAdj__c, TotalCanceledAdj__c, TotalOnHoldAdj__c, TotalNotStartedAdj__c, TotalCompletedAdj__c, 
                                                TotalInProgressExp__c, TotalCanceledExp__c, TotalOnHoldExp__c, TotalNotStartedExp__c, TotalCompletedExp__c, LastModifiedDate, Last_Sales_History_Update__c  FROM ExecutiveRollUpMain__c WHERE Year__c =: String.valueOf(year) AND Type__c = 'Region' AND UserId__c =: currentLoggedInUser LIMIT 1];
            ableToFindDataWithUserId = true;
    } catch(Exception e)
    {
        ableToFindDataWithUserId = false;
    }  

    if(!ableToFindDataWithUserId)
    {
    String mainRegionalUserId = '';
    if(u.SAP_Sales_District__c == 'West Region') mainRegionalUserId = profilesettings.West_Region_User_Id__c;
    if(u.SAP_Sales_District__c == 'Central Region') mainRegionalUserId = profilesettings.Central_Region_User_Id__c; 
    if(u.SAP_Sales_District__c == 'Northeast Region') mainRegionalUserId = profilesettings.Northeast_Region_User_Id__c;
    if(u.SAP_Sales_District__c == 'Southeast Region') mainRegionalUserId = profilesettings.Southeast_Region_User_Id__c; 
        System.debug('::: Performing additional Search for Region: '+u.SAP_Sales_District__c);
        System.debug('::: Main Regional User Id = '+mainRegionalUserId);
        try {
             thisRecord = [SELECT Id, CY_SalesForecast__c, CY_YTDAireFlo__c, CY_YTDCommercial__c, CY_YTDDLSC__c, CY_YTDElite__c, CY_YTDMerit__c, CY_YTDOther__c,
                                                CY_YTDPartsAndSupplies__c, CY_YTDResEquipment__c, CY_YTDSales__c, P2Y_SalesHistory__c, P3Y_SalesHistory__c, PY_SalesHistory__c,
                                                PY_YTDAireFlo__c, PY_YTDDLSC__c, PY_YTDElite__c, PY_YTDMerit__c, PY_YTDOther__c, PY_YTDSales__c,
                                                TotalInProgressOpp__c, TotalCanceledOpp__c, TotalOnHoldOpp__c, TotalNotStartedOpp__c, TotalCompletedOpp__c, 
                                                TotalInProgressRet__c, TotalCanceledRet__c, TotalNotStartedRet__c, TotalCompletedRet__c, 
                                                TotalInProgressAcp__c, TotalCanceledAcp__c, TotalNotStartedAcp__c, TotalCompletedAcp__c, 
                                                TotalInProgressAdj__c, TotalCanceledAdj__c, TotalOnHoldAdj__c, TotalNotStartedAdj__c, TotalCompletedAdj__c, 
                                                TotalInProgressExp__c, TotalCanceledExp__c, TotalOnHoldExp__c, TotalNotStartedExp__c, TotalCompletedExp__c, LastModifiedDate,Last_Sales_History_Update__c FROM ExecutiveRollUpMain__c WHERE Year__c =: String.valueOf(year) AND Type__c = 'Region' AND UserId__c =: mainRegionalUserId LIMIT 1];
        } catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Could not retrieve information.'));
            return;
        }    
    }
    
            System.debug('Record Found: '+thisRecord);
            changeDLSC = 0;
            changeMerit = 0;
            changeElite = 0;
            changeAireFlo = 0;
            changeOther = 0;   
            Date reportDate = thisRecord.Last_Sales_History_Update__c != null ? thisRecord.Last_Sales_History_Update__c : Date.today().addDays(-1);

        lastSalesHistoryUpdate = Date.newInstance(reportDate.year(),reportDate.month(),reportDate.day());
            previousYearTotalSales = thisRecord.PY_SalesHistory__c != null ? thisRecord.PY_SalesHistory__c : 0;
            previousTwoYearsTotalSales = thisRecord.P2Y_SalesHistory__c != null ? thisRecord.P2Y_SalesHistory__c : 0;
            previousThreeYearsTotalSales = thisRecord.P3Y_SalesHistory__c != null ? thisRecord.P3Y_SalesHistory__c : 0;

            presentYearSalesForecast = thisRecord.CY_SalesForecast__c != null ? thisRecord.CY_SalesForecast__c : 0;
            ytdSales = thisRecord.CY_YTDSales__c != null ? thisRecord.CY_YTDSales__c : 0;
            previuosYearsYTDSales = thisRecord.PY_YTDSales__c != null ? thisRecord.PY_YTDSales__c : 0;

            ytdSalesChange = thisRecord.CY_YTDSales__c - thisRecord.PY_YTDSales__c;
            ytdResEquipment = thisRecord.CY_YTDResEquipment__c;
            ytdCommercials = thisRecord.CY_YTDCommercial__c;
            ytdPartsndSupplies = thisRecord.CY_YTDPartsAndSupplies__c;

            presetDLSC = thisRecord.CY_YTDDLSC__c;
            presetDLSCPercent = thisRecord.CY_YTDDLSC__c / ytdSales;
            presetMerit = thisRecord.CY_YTDMerit__c;
            presetMeritPercent = thisRecord.CY_YTDMerit__c / ytdSales;
            presetElite = thisRecord.CY_YTDElite__c;
            presetElitePercent = thisRecord.CY_YTDElite__c / ytdSales;
            presetAireFlo = thisRecord.CY_YTDAireFlo__c;
            presetAireFloPercent = thisRecord.CY_YTDAireFlo__c / ytdSales;
    //Enhancemnets 2023
            presetOther = thisRecord.CY_YTDOther__c + presetAireFlo;
            presentYearOtherPercent = thisRecord.CY_YTDOther__c / ytdSales;

            previousYearDLSC = thisRecord.PY_YTDDLSC__c;
            previousYearDLSCPercent = thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
            previousYearMerit = thisRecord.PY_YTDMerit__c;
            previousYearMeritPercent = thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
            previousYearElite = thisRecord.PY_YTDElite__c;
            previousYearElitePercent = thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
            previousYearAireFlo = thisRecord.PY_YTDAireFlo__c;
            previousYearAireFloPercent = thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
    //Enhancemnets 2023
            previousYearOther = thisRecord.PY_YTDOther__c +previousYearAireFlo ;
            previousYearOtherPercent = thisRecord.PY_YTDDLSC__c / previuosYearsYTDSales;
            
            changeDLSC = presetDLSC - previousYearDLSC;
            changeMerit = presetMerit - previousYearMerit;
            changeElite = presetElite - previousYearElite; 
            changeAireFlo = presetAireFlo - previousYearAireFlo;
    //New Enhancement 2023
            changeOther = presetOther - previousYearOther+changeAireFlo;
            
            System.debug('about to do queries for child records');
            
            regionRecords = [SELECT Id, URLText__c, Region__c, PY_YTDSales__c, CY_YTDSales__c, RegionYTDChange__c, NonResidentialAccounts__c FROM ExecutiveRollUpChild__c
                                                          WHERE ExecutiveRollUpMain__c =: thisRecord.Id AND Type__c = 'Region' ORDER BY RegionYTDChange__c DESC];
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