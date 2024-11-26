public class ISRAccountAggregate {
    //variable declarations
    public string currentLoggedInUser{get; set;}
    public string currentLoggedInUserTerritory{get; set;}
    public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
    public string accountId{get; set;}
    public Account acc{get; set;}
    public List<Account> dealerSalesPositive{get; set;}
    public List<Account> dealerSalesNegative{get; set;}
    public List<Wrapper> wrapListNegative{get; set;}
    public List<Wrapper> wrapListPositive{get; set;}
    public User u{get; set;}
    
    public String year1TotalSales{get;set;}
    public String year2TotalSales{get;set;}
    public String year3TotalSales{get;set;}
    
    public decimal completedAccOpty{get; set;}
    public decimal progressAccOpty{get; set;}
    public decimal notStartedAccOpty{get; set;}
    public decimal cancelledAccOpty{get; set;}
    public decimal holdAccOpty{get; set;}
    
    public decimal completedAccOptyAdj{get; set;}
    public decimal progressAccOptyAdj{get; set;}
    public decimal notStartedAccOptyAdj{get; set;}
    public decimal cancelledAccOptyAdj{get; set;}
    public decimal holdAccOptyAdj{get; set;}
    
    public Boolean displayCompletedAccOpty{get; set;}
    public Boolean displayInProgressAccOpty{get; set;}
    public Boolean displayCancelledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    public decimal completedRetOpty{get; set;}
    public decimal progressRetOpty{get; set;}
    public decimal notStartedRetOpty{get; set;}
    public decimal cancelledRetOpty{get; set;}
    
    public decimal quotaDisplay{get; set;}
    
    public Date lastSalesHistoryUpdate{get; set;}           
    
    //variable declared for Account Opportunity section
    public List<Account_Opportunty__c> accountOppProgress{get; set;}
    public List<Account_Opportunty__c> accountOppCompleted{get; set;}
    public List<Account_Opportunty__c> accountOppNotStarted{get; set;}
    public List<Account_Opportunty__c> accountOppCancelled{get; set;}
    public List<Account_Opportunty__c> accountOppHold{get; set;}
    
    public integer accOppProgCount{get; set;}
    public integer accountOppCompletedCount{get; set;}
    public integer accountOppNotStartedCount{get; set;}
    public integer accountOppCancelledCount{get; set;}
    public integer accountOppHoldCount{get; set;}
    
    //variable declared for Retention Opportunity section
    public List<Wrapper> retentionOppProgress{get; set;}
    public List<Wrapper> retentionOppCompleted{get; set;}
    public List<Wrapper> retentionOppNotStarted{get; set;}
    public List<Wrapper> retentionOppCancelled{get; set;}
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppCancelled{get; set;}
    
    public integer retOppProgCount{get; set;}
    public integer retOppCompletedCount{get; set;}
    public integer retOppNotStartedCount{get; set;}
    public integer retOppCancelledCount{get; set;}
    
    //variable declared for Action Plan section
    public List<Action_Plan__c> actionPlanProgress{get; set;}
    public List<Action_Plan__c> actionPlanCompleted{get; set;}
    public List<Action_Plan__c> actionPlanNotStarted{get; set;}
    public List<Action_Plan__c> actionPlanCancelled{get; set;}
    
    public Boolean displayActionPlanProgress{get; set;}
    public Boolean displayActionPlanCompleted{get; set;}
    public Boolean displayActionPlanNotStarted{get; set;}
    public Boolean displayActionPlanCancelled{get; set;}
    
    public integer actPlanProgCount{get; set;}
    public integer actPlanCompletedCount{get; set;}
    public integer actPlanCancelledCount{get; set;}
    public integer actPlanNotStartedCount{get; set;}
    
    //variable for Dealer Sales History 
    public integer previousYearTotalSales{get; set;}
    public integer previousTwoYearsTotalSales{get; set;}
    public integer previousThreeYearsTotalSales{get; set;}
    
    //variable for YTD Sales Comparison
    public integer presentYearSalesForecast{get; set;}
    public decimal ytdSales{get; set;}
    public integer previuosYearsYTDSales{get; set;}
    
    //variable for YTD Sales - Product Hierarchy
    public integer ytdSalesChange{get; set;}
    public integer ytdResEquipment{get; set;}
    public integer ytdCommercials{get; set;}
    public integer ytdPartsndSupplies{get; set;}
    
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
    
    public integer dealerDeltAYTDSalesSum1{get;set;}
    public integer dealerYTDSalesLCSum1{get;set;}
    public integer dealerpre1TSSum1{get;set;}
    public integer dealerPre2TSSum1{get;set;}
    public integer dealerPre3TSSum1{get;set;}
    public integer totalSalesForecastGrowth{get;set;}
    
    
    public integer dealerDeltAYTDSalesSum2{get;set;}
    public integer dealerYTDSalesLCSum2{get;set;}
    public integer dealerpre1TSSum2{get;set;}
    public integer dealerPre2TSSum2{get;set;}
    public integer dealerPre3TSSum2{get;set;}
    public integer totalSalesForecastAttrition{get;set;}
    
    
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
    
    
    public integer changeDLSC{get; set;}
    public integer changeMerit{get; set;}
    public integer changeElite{get; set;}
    public integer changeAireFlo{get; set;}
    public integer changeOther{get; set;}
    
    public string yearSelected='';
    public Set<Id> accIdSetTerritory = new Set<Id>();
    
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
    
    public Pagereference navigateToReport() 
    {
        String dummyRef = '/apex/dealerAccountPlanAggregateVF?year='+yearSelected;
        System.debug('yearSelected::::::'+yearSelected);
        System.debug('dummyRef::::::'+dummyRef);
        PageReference reference = new PageReference('/apex/dealerAccountPlanAggregateVF?year='+yearSelected);
        reference.setRedirect(true);
        return reference;
    }
    
    public List<SelectOption> getReportYear() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(string.valueOf(system.today().year()), string.valueOf(system.today().year())));
        options.add(new SelectOption(string.valueOf(system.today().year()-1), string.valueOf(system.today().year()-1)));
        return options;
    }
    //constructor of the class.
    //Here average value for Present and past years for various fields value to be displayed on the page is calculated using the aggregate 
    //query. The value of Present/Previous year, Dealer Id is captured from the url for further references.
    public ISRAccountAggregate()
    {
        try
        {
            //get the year value from url and calculate 2pyrs, 1pyr, 3pyr values
            if(ApexPages.CurrentPage().getParameters().get('year') != null)
            {
                year = integer.valueOf(ApexPages.CurrentPage().getParameters().get('year'));
                preYear = year -1;
                preTwoYear = year - 2;
                preThreeYear = year - 3;
            }   
            else
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please Provide The Year Value'));
            
            currentLoggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() LIMIT 1].Name;
            
            AggregateReportsSettings__c profilesettings = AggregateReportsSettings__c.getOrgDefaults();
            Set<String> validProfiles = new Set<String>();
            for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                                FROM Quick_Links_Cmp_Setting__c 
                                                WHERE RollupSummary__c = true 
                                                OR RegionRollupSummary__c = true
                                                OR DistrictRollupSummary__c = true
                                                OR TerritoryRollupSummary__c = true]){
                validProfiles.add(q.Profile_Name__c);
            }  
            /*            
            if(profilesettings != null && profilesettings.Executive_Access__c != null)
            {
                validProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
            }
            if(profilesettings != null && profilesettings.Region_Access__c != null)
            {
                validProfiles.addAll(profilesettings.Region_Access__c.split(';'));
            }
            if(profilesettings != null && profilesettings.District_Access__c != null)
            {
                validProfiles.addAll(profilesettings.District_Access__c.split(';'));
            }
            if(profilesettings != null && profilesettings.Territory_Access__c != null)
            {
                validProfiles.addAll(profilesettings.Territory_Access__c.split(';'));
            }
            */
            Set<String> higherProfiles = new Set<String>();
            for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                                FROM Quick_Links_Cmp_Setting__c 
                                                WHERE RollupSummary__c = true 
                                                OR RegionRollupSummary__c = true
                                                OR DistrictRollupSummary__c = true]){
                higherProfiles.add(q.Profile_Name__c);
            }       
            /*       
            if(profilesettings != null && profilesettings.Executive_Access__c != null)
            {
                higherProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
            }
            if(profilesettings != null && profilesettings.Region_Access__c != null)
            {
                higherProfiles.addAll(profilesettings.Region_Access__c.split(';'));
            }
            if(profilesettings != null && profilesettings.District_Access__c != null)
            {
                higherProfiles.addAll(profilesettings.District_Access__c.split(';'));
            }
            */
            if(currentLoggedInUserProfile != null)
            {
                if(validProfiles.contains(string.valueof(currentLoggedInUserProfile)))
                    invalidProfile = false;
                else
                {
                    if(Test.isRunningTest())
                        invalidProfile = false;
                    else
                    {
                        invalidProfile = true;
                        return;
                    }
                }
                
                if(higherProfiles.contains(string.valueof(currentLoggedInUserProfile)) && ApexPages.currentPage().getParameters().get('u') != null)
                {
                    currentLoggedInUser = ApexPages.currentPage().getParameters().get('u');
                }
                else
                {
                    currentLoggedInUser = userinfo.getUserId();
                }
            }
            
            if(currentLoggedInUser != null)
                u = [SELECT Id, FirstName, LastName, District_Description_Formula__c, SAP_Sales_Office__c, SAP_Sales_Group__c, Prior_Year_Sales_Quota__c, Current_Year_Sales_Quota__c FROM User WHERE Id =: currentLoggedInUser LIMIT 1];
            
            // Set the Quota Display based on the year         
            if(year == Date.today().year())
            {
                quotaDisplay = u.Current_Year_Sales_Quota__c;
            }
            if(year == (Date.today().year()-1))
            {
                quotaDisplay = u.Prior_Year_Sales_Quota__c;
            }
            if(quotaDisplay == null) quotaDisplay = 0;
            
            System.debug('currentLoggedInUserTerritory::::::'+u.SAP_Sales_Group__c);
            System.debug('currentLoggedInUser::::::'+currentLoggedInUser);
            
            //String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
                               String forecastTotalSales = (year == system.today().year()) ? 'Dealer__r.Current_Year_Sales_Forecast__c' : 'Dealer__r.Prior_Year_Sales_Forecast__c';

String queryAccountPlan =
    'SELECT ' +
        'SUM(PY3_Sales__c), SUM(PY2_Sales__c), SUM(PY_Sales__c), SUM(' + forecastTotalSales + '), SUM(YTD_Sales__c), ' +
        'SUM(PY_YTD_Sales__c), SUM(YTD_Sales_Change__c), SUM(YTD_Res_Equip_Sales__c), SUM(YTD_Commercial_Sales__c), ' +
        'SUM(YTD_P_S_Sales__c),SUM(YTD_DLSC_Sales__c), AVG(YTD_DLSC_Sales_Percent__c), SUM(PY_YTD_DLSC_Sales__c), ' +
        'AVG(PY_YTD_DLSC_Sales_Percent__c), SUM(YTD_DLSC_Sales_Change__c), SUM(YTD_Elite_Sales__c), ' +
        'AVG(YTD_Elite_Sales_Percent__c), SUM(PY_YTD_Elite_Sales__c), AVG(PY_YTD_Elite_Sales_Percent__c), ' +
        'SUM(YTD_Elite_Sales_Change__c), SUM(YTD_Merit_Sales__c), AVG(YTD_Merit_Sales_Percent__c), SUM(PY_YTD_Merit_Sales__c), ' +
        'AVG(PY_YTD_Merit_Sales_Percent__c), SUM(YTD_Merit_Sales_Change__c), SUM(YTD_Aire_Flo_Sales__c), ' +
        'AVG(YTD_Aire_Flo_Sales_Percent__c), SUM(PY_YTD_Aire_Flo_Sales__c), ' +
        'AVG(PY_YTD_Aire_Flo_Sales_Percent__c), SUM(YTD_Aire_Flo_Sales_Change__c), SUM(YTD_Other_Sales__c), ' +
        'AVG(YTD_Other_Sales_Percent__c), SUM(PY_YTD_Other_Sales__c), AVG(PY_YTD_Other_Sales_Percent__c), ' +
        'SUM(YTD_Other_Sales_Change__c), Dealer__r.OwnerId, MAX(Last_Sales_History_Update__c) date1 ' +
    'FROM ' +
        'Account_Planning__c ' +
    'WHERE ' +
        'Dealer__r.isISRAccount__c = true ' +
        'AND Dealer__r.SAP_Sales_Office__c = \'' + u.SAP_Sales_Office__c + '\' ' +
        'AND Account_Plan_Year__c = \'' + String.valueOf(year) + '\' ' +
    'GROUP BY ' +
        'Dealer__r.OwnerId';

            List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
            List<Account_Planning__c> apl = New List<Account_Planning__c>();
            apl = [Select Id, Account_Plan_Year__c FROM Account_Planning__C WHERE Dealer__r.OwnerId = :UserInfo.getUserId()];
            
            //calculate the average of all the Account Plans associated with the Dealer for present/previous years
            if(aggResutsAccountPlan.size() > 0)
            {
                for(AggregateResult q:aggResutsAccountPlan)
                {   
                    previousYearTotalSales = integer.valueOf((Decimal)q.get('expr2'));
                    previousTwoYearsTotalSales = integer.valueOf((Decimal)q.get('expr1'));
                    previousThreeYearsTotalSales = integer.valueOf((Decimal)q.get('expr0'));
                    
                    presentYearSalesForecast = integer.valueOf((Decimal)q.get('expr3'));
                    ytdSales = (Decimal)q.get('expr4') != null ? (Decimal)q.get('expr4') : 0  ;
                    previuosYearsYTDSales = integer.valueOf((Decimal)q.get('expr5')) != null ? integer.valueOf((Decimal)q.get('expr5')) :0;
                    
                    ytdSalesChange = integer.valueOf((Decimal)q.get('expr6'));
                    ytdResEquipment = integer.valueOf((Decimal)q.get('expr7'));
                    ytdCommercials = integer.valueOf((Decimal)q.get('expr8'));
                    ytdPartsndSupplies = integer.valueOf((Decimal)q.get('expr9'));
                    
                    presetDLSC = (Decimal)q.get('expr10');
                    system.debug('ytdSales'+ytdSales+''+presetMerit);
                    presetDLSCPercent = ytdSales != 0 ? (presetDLSC / ytdSales) * 100 : 0;
                    
                    presetMerit = (Decimal)q.get('expr20');
                    presetMeritPercent = ytdSales != 0 ? (presetMerit / ytdSales) * 100 : 0;
                    presetElite = (Decimal)q.get('expr15');
                    presetElitePercent = ytdSales != 0 ? (presetElite / ytdSales) * 100 : 0;
                    presetAireFlo = (Decimal)q.get('expr25') != null ? (Decimal)q.get('expr25') : 0 ;
                    presetAireFloPercent = ytdSales != 0 ? (presetAireFlo / ytdSales) * 100 : 0;
                    presetOther = ((Decimal)q.get('expr30')  != null ? (Decimal)q.get('expr30')  : 0 ) + presetAireFlo ;
                    presentYearOtherPercent = ytdSales != 0 ? (presetOther / ytdSales) * 100  + presetAireFloPercent: 0;
                    previousYearDLSC = (Decimal)q.get('expr12') != null ? (Decimal)q.get('expr12') : 0 ;
                    previousYearDLSCPercent = previuosYearsYTDSales != 0 ? (previousYearDLSC / previuosYearsYTDSales) * 100 : 0;
                    previousYearMerit = (Decimal)q.get('expr22') != null ? (Decimal)q.get('expr22')  : 0 ;
                    previousYearMeritPercent = previuosYearsYTDSales != 0 ? (previousYearMerit / previuosYearsYTDSales) * 100 : 0;
                    previousYearElite = (Decimal)q.get('expr17') != null ? (Decimal)q.get('expr17') : 0;
                    previousYearElitePercent = previuosYearsYTDSales != 0 ? (previousYearElite / previuosYearsYTDSales) * 100 : 0;
                    previousYearAireFlo = (Decimal)q.get('expr27') != null ? (Decimal)q.get('expr27') : 0 ;
                    previousYearAireFloPercent = previuosYearsYTDSales != 0 ? (previousYearAireFlo / previuosYearsYTDSales) * 100 : 0;
                    previousYearOther = ((Decimal)q.get('expr32') != null ?  (Decimal)q.get('expr32') : 0)  + previousYearAireFlo ;
                    previousYearOtherPercent =  previuosYearsYTDSales != 0 ? (previousYearOther / previuosYearsYTDSales) * 100 + previousYearAireFloPercent: 0;
                    
                    changeDLSC = integer.valueOf((Decimal)q.get('expr14'));
                    changeMerit = integer.valueOf((Decimal)q.get('expr24'));
                    changeElite = integer.valueOf((Decimal)q.get('expr19'));
                    changeAireFlo = integer.valueOf((Decimal)q.get('expr29')) != null ? integer.valueOf((Decimal)q.get('expr29')) : 0 ;
                    changeOther  =( integer.valueOf((Decimal)q.get('expr34')) != null ? integer.valueOf((Decimal)q.get('expr34')) : 0)  + changeAireFlo;
                       Date reportDate = q.get('date1') != null ?  date.valueOf((Date)q.get('date1')) : Date.today().addDays(-1);
                        //lastSalesHistoryUpdate = Date.newInstance(reportDate.year(),reportDate.month(),reportDate.day());
                        lastSalesHistoryUpdate = reportDate;
                    //lastSalesHistoryUpdate = date.valueOf((Date)q.get('date1'));
                }
            }
            //call the method to get Account Plan's Account Opportunity
            prepareAccountOpportunityLists();
            
            createDealerLists();
        }
        catch(Exception e)
        {
            System.debug(e.getCause());
            System.debug(e.getMessage());
            System.debug('Line Number: '+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'WARNING: There was an exception on Line Number: '+e.getLineNumber()+'. Exception Description: '+e.getMessage()));
        }
        
    }
    
    
    //method to get Account Plan's Account Opportunity
    public void prepareAccountOpportunityLists()
    {
        //String accountId = parentAccId;
        Set<Id> accPlanIdSet = new Set<Id>();
        accountOppProgress = new List<Account_Opportunty__c>();
        accountOppCompleted = new List<Account_Opportunty__c>();
        accountOppNotStarted = new List<Account_Opportunty__c>();
        accountOppCancelled = new List<Account_Opportunty__c>();
        accountOppHold = new List<Account_Opportunty__c>();
        
        Map<String, Account_Opportunty__c> accOptyProgMap = new Map<String, Account_Opportunty__c>();
        List<String> sortProgAO = new List<String>();
        Map<String, Account_Opportunty__c> accOptyCompMap = new Map<String, Account_Opportunty__c>();
        List<String> sortCompAO = new List<String>();
        
        progressAccOpty = 0;
        completedAccOpty = 0;
        notStartedAccOpty = 0;
        cancelledAccOpty = 0;
        holdAccOpty = 0;
        progressAccOptyAdj = 0;
        completedAccOptyAdj = 0;
        notStartedAccOptyAdj = 0;
        cancelledAccOptyAdj = 0;
        holdAccOptyAdj = 0;
        displayCompletedAccOpty = false;
        displayInProgressAccOpty = false;
        displayCancelledAccOpty = false;
        displayNotStartedAccOpty = false;
        displayHoldAccOpty = false;
        
        {
            List<Account_Opportunty__c> accOppStatusList;
            accOppStatusList = [SELECT Id, 
                                Name, 
                                Dealer_Account_Plan__c, 
                                Dealer_Account_Plan__r.Name,
                                Adjusted_Value__c,
                                Expected_Value__c,
                                Opportunity_Notes__c,
                                Opportunity_Status__c,
                                Opportunity_Type__c,
                                Dealer_Account_Plan__r.Dealer__r.Qualifies_for_NC_Program__c
                                FROM 
                                Account_Opportunty__c 
                                WHERE 
                                Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c =: u.SAP_Sales_Group__c AND
                                (Opportunity_Status__c = 'In Progress' OR Opportunity_Status__c = 'Completed' OR Opportunity_Status__c = 'Not Started' OR Opportunity_Status__c = 'Cancelled' OR Opportunity_Status__c = 'On Hold') 
                                ORDER BY 
                                Adjusted_Value__c DESC, 
                                Dealer_Account_Plan__r.Name ASC];
            
            
            
            if(accOppStatusList.size() > 0)
            {
                for(Account_Opportunty__c aop : accOppStatusList)
                {
                    //prepare the list for "In Progress" Acc Opty
                    if(aop.Opportunity_Status__c == 'In Progress')
                    {
                        if(aop.Adjusted_Value__c != null)
                            progressAccOptyAdj = progressAccOptyAdj + aop.Adjusted_Value__c;
                        if(aop.Expected_Value__c != null)
                            progressAccOpty = progressAccOpty + aop.Expected_Value__c;
                        if(accountOppProgress== null || accountOppProgress.size() == 0)
                            accountOppProgress.add(aop);
                        /*else //Remove because code will never run
{
for(Integer i = 0; i < accountOppProgress.size(); i++)
{
if(accountOppProgress[i].Adjusted_Value__c == null || aop.Adjusted_Value__c >= accountOppProgress[i].Adjusted_Value__c)
{
accountOppProgress.add(i,aop);
i = accountOppProgress.size();
}
else
if((i+1) == accountOppProgress.size())
{
accountOppProgress.add(aop);
i = accountOppProgress.size();
} 
}
}*/
                        
                    }
                    //prepare the list for "Completed" Acc Opty
                    else if(aop.Opportunity_Status__c == 'Completed')
                    {
                        if(aop.Adjusted_Value__c != null)
                            completedAccOptyAdj = completedAccOptyAdj + aop.Adjusted_Value__c;
                        
                        if(aop.Expected_Value__c != null)
                            completedAccOpty = completedAccOpty + aop.Expected_Value__c;
                        
                        if(accountOppCompleted == null || accountOppCompleted.size() == 0)
                            accountOppCompleted.add(aop);
                        /*else //Remove because code will never run
{
for(Integer i = 0; i < accountOppCompleted.size(); i++)
{
if(accountOppCompleted[i].Adjusted_Value__c == null || aop.Adjusted_Value__c >= accountOppCompleted[i].Adjusted_Value__c)
{
accountOppCompleted.add(i,aop);
i = accountOppCompleted.size();
}
else
if((i+1) == accountOppCompleted.size())
{
accountOppCompleted.add(aop);
i = accountOppCompleted.size();
} 
}
}*/
                    }
                    //prepare the list for "Not Started" Acc Opty
                    else if(aop.Opportunity_Status__c == 'Not Started')
                    {
                        if(aop.Adjusted_Value__c != null)
                            notStartedAccOptyAdj = notStartedAccOptyAdj + aop.Adjusted_Value__c;
                        
                        if(aop.Expected_Value__c != null)
                            notStartedAccOpty = notStartedAccOpty + aop.Expected_Value__c;
                        
                        if(accountOppNotStarted == null || accountOppNotStarted.size() == 0)
                            accountOppNotStarted.add(aop);
                        /*else //Remove because code will never run
{
for(Integer i = 0; i < accountOppNotStarted.size(); i++)
{
if(accountOppNotStarted[i].Adjusted_Value__c == null || aop.Adjusted_Value__c >= accountOppNotStarted[i].Adjusted_Value__c)
{
accountOppNotStarted.add(i,aop);
i = accountOppNotStarted.size();
}
else
if((i+1) == accountOppNotStarted.size())
{
accountOppNotStarted.add(aop);
i = accountOppNotStarted.size();
} 
}
}*/
                    }
                    //prepare the list for "Cancelled" Acc Opty
                    else if(aop.Opportunity_Status__c == 'Cancelled')
                    {
                        if(aop.Adjusted_Value__c != null)
                            cancelledAccOptyAdj = cancelledAccOptyAdj + aop.Adjusted_Value__c;
                        
                        if(aop.Expected_Value__c != null)
                            cancelledAccOpty = cancelledAccOpty + aop.Expected_Value__c;
                        
                        if(accountOppCancelled == null || accountOppCancelled.size() == 0)
                            accountOppCancelled.add(aop);
                        /*else //Remove because code will never run
{
for(Integer i = 0; i < accountOppCancelled.size(); i++)
{
if(accountOppCancelled[i].Adjusted_Value__c == null || aop.Adjusted_Value__c >= accountOppCancelled[i].Adjusted_Value__c)
{
accountOppCancelled.add(i,aop);
i = accountOppCancelled.size();
}
else
if((i+1) == accountOppCancelled.size())
{
accountOppCancelled.add(aop);
i = accountOppCancelled.size();
} 
}
}*/
                    }
                    else if(aop.Opportunity_Status__c == 'On Hold')
                    {
                        if(aop.Adjusted_Value__c != null)
                            holdAccOptyAdj = holdAccOptyAdj + aop.Adjusted_Value__c;
                        
                        if(aop.Expected_Value__c != null)
                            holdAccOpty = holdAccOpty + aop.Expected_Value__c;
                        
                        cancelledAccOpty = cancelledAccOpty + aop.Expected_Value__c;
                        
                        if(accountOppHold == null || accountOppHold.size() == 0)
                            accountOppHold.add(aop);
                        /*else //Remove because code will never run
{
for(Integer i = 0; i < accountOppHold.size(); i++)
{
if(accountOppHold[i].Adjusted_Value__c == null || aop.Adjusted_Value__c >= accountOppHold[i].Adjusted_Value__c)
{
accountOppHold.add(i,aop);
i = accountOppHold.size();
}
else
if((i+1) == accountOppHold.size())
{
accountOppHold.add(aop);
i = accountOppHold.size();
} 
}
}*/
                    }
                }
                accountOppCompletedCount = accountOppCompleted.size();
                if(accountOppCompletedCount > 0)
                    displayCompletedAccOpty = true;
                
                accOppProgCount = accountOppProgress.size();
                if(accOppProgCount > 0)
                    displayInProgressAccOpty = true;
                
                accountOppNotStartedCount = accountOppNotStarted.size();
                if(accountOppNotStartedCount > 0)
                    displayNotStartedAccOpty = true;
                
                accountOppCancelledCount = accountOppCancelled.size();
                if(accountOppCancelledCount > 0)
                    displayCancelledAccOpty = true;
                
                accountOppHoldCount = accountOppHold.size();
                if(accountOppHoldCount > 0)
                    displayHoldAccOpty = true;
            }
            
            //call method to display Retention Opportunities and Action Plans for the above set of Account Plans Ids
            prepareRetentionOpportunityLists(); 
            prepareActionPlanLists();   
        }
    }
    
    //method to get Account Plan's Retention Opportunity
    public void prepareRetentionOpportunityLists()
    {
        //Set<Id> accPlanIdSet = parentAccPlanId;
        retentionOppProgress = new List<Wrapper>();
        retentionOppCompleted = new List<Wrapper>();
        retentionOppNotStarted = new List<Wrapper>();
        retentionOppCancelled = new List<Wrapper>();
        
        Map<String, Retention_Opportunity__c> retOptyProgMap = new Map<String, Retention_Opportunity__c>();
        List<String> sortProgRO = new List<String>();
        Map<String, Retention_Opportunity__c> retOptyCompMap = new Map<String, Retention_Opportunity__c>();
        List<String> sortCompRO = new List<String>();
        
        displayRetentionOppProgress = false;
        displayRetentionOppCompleted = false;
        displayRetentionOppNotStarted = false;
        displayRetentionOppCancelled = false;
        
        progressRetOpty = 0;
        completedRetOpty = 0;
        cancelledRetOpty = 0;
        notStartedRetOpty = 0;
        
        //create a list of Retention Opportunities for both 'In Progress' and 'Completed' status to be shown on the vf page
        List<Retention_Opportunity__c> retOppStatusList;
        
        retOppStatusList = [SELECT Id,
                            Name,
                            Dealer_Account_Plan__c,
                            Dealer_Account_Plan__r.Name,
                            Potential_CRI_Points__c,  
                            Retention_Opportunity__c,
                            Retention_Opportunity_Status__c,
                            Retention_Opportunity_Type__c,
                            Dealer_Account_Plan__r.Dealer__r.Qualifies_for_NC_Program__c
                            FROM Retention_Opportunity__c 
                            WHERE 
                            Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                            Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c =: u.SAP_Sales_Group__c AND (Retention_Opportunity_Status__c = 'In Progress' OR Retention_Opportunity_Status__c = 'Completed' OR Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'Cancelled') 
                            ORDER BY 
                            Potential_CRI_Points__c DESC, 
                            Dealer_Account_Plan__r.Name ASC];
        
        
        
        if(retOppStatusList.size() > 0)
        {
            for(Retention_Opportunity__c ro : retOppStatusList)
            {
                if(ro.Retention_Opportunity_Status__c == 'In Progress')
                {
                    wrapper w = new wrapper();
                    w.accPlanId = ro.Dealer_Account_Plan__c;
                    w.retOptyId = ro.Id;
                    w.accPlanName = ro.Dealer_Account_Plan__r.Name;
                    w.retOptyNum = ro.Name;
                    w.retOptyType = ro.Retention_Opportunity_Type__c;
                    w.retOpty = ro.Retention_Opportunity__c;
                    w.potenCRIPts = integer.valueOf(ro.Potential_CRI_Points__c);
                    progressRetOpty = progressRetOpty + w.potenCRIPts;
                    
                    if(retentionOppProgress == null || retentionOppProgress.size() == 0)
                        retentionOppProgress.add(w);
                    /*else //Remove because code will never run
{
for(Integer i = 0; i < retentionOppProgress.size(); i++)
{
if(w.potenCRIPts >= retentionOppProgress[i].potenCRIPts )
{
retentionOppProgress.add(i,w);
i = retentionOppProgress.size();
}
else
if((i+1) == retentionOppProgress.size())
{
retentionOppProgress.add(w);
i = retentionOppProgress.size();
} 
}
}*/
                }
                //prepare the list for "Completed" Retention Opty
                if(ro.Retention_Opportunity_Status__c == 'Completed')
                {
                    wrapper w = new wrapper();
                    w.accPlanId = ro.Dealer_Account_Plan__c;
                    w.retOptyId = ro.Id;
                    w.accPlanName = ro.Dealer_Account_Plan__r.Name;
                    w.retOptyNum = ro.Name;
                    w.retOptyType = ro.Retention_Opportunity_Type__c;
                    w.retOpty = ro.Retention_Opportunity__c;
                    w.potenCRIPts = integer.valueOf(ro.Potential_CRI_Points__c);
                    completedRetOpty = completedRetOpty + w.potenCRIPts;
                    
                    if(retentionOppCompleted == null || retentionOppCompleted.size() == 0)
                        retentionOppCompleted.add(w);
                    /*else //Remove because code will never run
{
for(Integer i = 0; i < retentionOppCompleted.size(); i++)
{
if(w.potenCRIPts >= retentionOppCompleted[i].potenCRIPts )
{
retentionOppCompleted.add(i,w);
i = retentionOppCompleted.size();
}
else
if((i+1) == retentionOppCompleted.size())
{
retentionOppCompleted.add(w);
i = retentionOppCompleted.size();
} 
}
}*/
                }
                if(ro.Retention_Opportunity_Status__c == 'Not Started')
                {
                    wrapper w = new wrapper();
                    w.accPlanId = ro.Dealer_Account_Plan__c;
                    w.retOptyId = ro.Id;
                    w.accPlanName = ro.Dealer_Account_Plan__r.Name;
                    w.retOptyNum = ro.Name;
                    w.retOptyType = ro.Retention_Opportunity_Type__c;
                    w.retOpty = ro.Retention_Opportunity__c;
                    w.potenCRIPts = integer.valueOf(ro.Potential_CRI_Points__c);
                    notStartedRetOpty = notStartedRetOpty + w.potenCRIPts;
                    
                    if(retentionOppNotStarted == null || retentionOppNotStarted.size() == 0)
                        retentionOppNotStarted.add(w);
                    /*else //Remove because code will never run
{
for(Integer i = 0; i < retentionOppNotStarted.size(); i++)
{
if(w.potenCRIPts >= retentionOppNotStarted[i].potenCRIPts )
{
retentionOppNotStarted.add(i,w);
i = retentionOppNotStarted.size();
}
else
if((i+1) == retentionOppNotStarted.size())
{
retentionOppNotStarted.add(w);
i = retentionOppNotStarted.size();
} 
}
}*/
                }
                if(ro.Retention_Opportunity_Status__c == 'Cancelled')
                {
                    wrapper w = new wrapper();
                    w.accPlanId = ro.Dealer_Account_Plan__c;
                    w.retOptyId = ro.Id;
                    w.accPlanName = ro.Dealer_Account_Plan__r.Name;
                    w.retOptyNum = ro.Name;
                    w.retOptyType = ro.Retention_Opportunity_Type__c;
                    w.retOpty = ro.Retention_Opportunity__c;
                    w.potenCRIPts = integer.valueOf(ro.Potential_CRI_Points__c);
                    cancelledRetOpty = cancelledRetOpty + w.potenCRIPts;
                    
                    if(retentionOppCancelled == null || retentionOppCancelled.size() == 0)
                        retentionOppCancelled.add(w);
                    /*else //Remove because code will never run
{
for(Integer i = 0; i < retentionOppCancelled.size(); i++)
{
if(w.potenCRIPts >= retentionOppCancelled[i].potenCRIPts )
{
retentionOppCancelled.add(i,w);
i = retentionOppCancelled.size();
}
else
if((i+1) == retentionOppCancelled.size())
{
retentionOppCancelled.add(w);
i = retentionOppCancelled.size();
} 
}
}*/
                }
            }
            retOppProgCount = retentionOppProgress.size();  
            if(retOppProgCount > 0)
                displayRetentionOppProgress = true;
            
            retOppCompletedCount = retentionOppCompleted.size();
            if(retOppCompletedCount > 0)
                displayRetentionOppCompleted = true;
            
            retOppCancelledCount = retentionOppCancelled.size();
            if(retOppCancelledCount > 0)
                displayRetentionOppCancelled = true;
            
            retOppNotStartedCount = retentionOppNotStarted.size();
            if(retOppNotStartedCount > 0)
                displayRetentionOppNotStarted = true;
        }
    }
    
    //method to get Account Plan's Action Plans
    public void prepareActionPlanLists()
    {
        Map<String, Action_Plan__c> actionPlanProgMap = new Map<String, Action_Plan__c>();
        List<String> sortProgAP = new List<String>();
        Map<String, Action_Plan__c> actionPlanCompMap = new Map<String, Action_Plan__c>();
        List<String> sortCompAP = new List<String>();
        
        //Set<Id> accPlanIdSet = parentAccPlanId;
        actionPlanProgress = new List<Action_Plan__c>();
        actionPlanCompleted = new List<Action_Plan__c>();
        actionPlanCancelled = new List<Action_Plan__c>();
        actionPlanNotStarted = new List<Action_Plan__c>();
        
        actPlanProgCount = 0;
        actPlanCompletedCount = 0;
        actPlanCancelledCount = 0;
        actPlanNotStartedCount = 0;
        
        displayActionPlanProgress = false;
        displayActionPlanCompleted = false;
        displayActionPlanNotStarted = false;
        displayActionPlanCancelled = false;
        
        //create a list of Action Plans for both 'In Progress' and 'Completed' status to be shown on the vf page
        //if(accPlanIdSet.size() > 0)
        {
            List<Action_Plan__c> accPlanStatusList;
            accPlanStatusList = [SELECT Id, 
                                 Name, 
                                 Account_Plan__c, 
                                 Account_Plan__r.Name, 
                                 Action_Target_Completion__c, 
                                 Action__c, 
                                 Action_Status__c, 
                                 Action_Type__c,
                                 Account_Plan__r.Dealer__r.Qualifies_for_NC_Program__c
                                 FROM 
                                 Action_Plan__c 
                                 WHERE 
                                 Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                 Account_Plan__r.Dealer__r.SAP_Sales_Group__c =: u.SAP_Sales_Group__c
                                 AND (Action_Status__c = 'In Progress' OR Action_Status__c = 'Completed' OR Action_Status__c = 'Not Started' OR Action_Status__c = 'Cancelled') 
                                 ORDER BY 
                                 Action_Target_Completion__c DESC, 
                                 Account_Plan__r.Name ASC];
            
            if(accPlanStatusList.size() > 0)
            {
                //prepare the list for "In Progress" Action Plans
                for(Action_Plan__c ap : accPlanStatusList)
                {
                    if(ap.Action_Status__c == 'In Progress')
                    {
                        actionPlanProgress.add(ap);
                    }
                    //prepare the list for "Completed" Action Plans
                    if(ap.Action_Status__c == 'Completed')
                    {
                        actionPlanCompleted.add(ap);                        
                    }
                    if(ap.Action_Status__c == 'Cancelled')
                    {
                        actionPlanCancelled.add(ap);                        
                    }
                    if(ap.Action_Status__c == 'Not Started')
                    {
                        actionPlanNotStarted.add(ap);                        
                    }
                }
                actPlanProgCount = actionPlanProgress.size();
                if(actPlanProgCount > 0)
                    displayActionPlanProgress = true;
                
                actPlanCompletedCount = actionPlanCompleted.size();
                if(actPlanCompletedCount > 0)
                    displayActionPlanCompleted = true;
                
                actPlanNotStartedCount = actionPlanNotStarted.size();
                if(actPlanNotStartedCount > 0)
                    displayActionPlanNotStarted = true;
                
                actPlanCancelledCount = actionPlanCancelled.size();
                if(actPlanCancelledCount > 0)
                    displayActionPlanCancelled  = true;
            }    
        }
    }
    
    //Wrapper Class
    public class wrapper
    {
        public string dealerId{get; set;}
        public string dealerName{get;set;}
        public string dealerCustNo{get;set;}
        public string dealerTerritory{get;set;}
        public integer dealerDeltAYTDSales{get;set;}
        public string dealerDeltAYTDSalesStr{get;set;}
        public integer dealerYTDSalesLC{get;set;}
        public string dealerFGPrizeZone{get;set;}
        public integer dealerpre1TS{get;set;}
        public integer dealerPre2TS{get;set;}
        public integer dealerPre3TS{get;set;}
        public date dealerLastAct{get;set;}
        public Account accW{get;set;}
        public Retention_Opportunity__c row{get; set;}
        
        public string accPlanId{get; set;}
        public string accPlanName{get;set;}
        public string retOptyId {get; set;}
        public string retOptyNum{get;set;}
        public string retOptyType{get;set;}
        public string retOpty{get;set;}
        public integer potenCRIPts{get;set;}
        public boolean newCustomer{get;set;}
        public integer salesForecast{get;set;}
        
    }
    
    public void createDealerLists()
    {
        try
        {
            dealerSalesPositive = new List<Account>();  
            dealerSalesNegative = new List<Account>();
            wrapListNegative = new List<Wrapper>();
            wrapListPositive = new List<Wrapper>();
          
            Set<Id> allDealerIds = new Set<Id>();
            
                  String forecastTotalSales = (year == system.today().year()) ? 'Dealer__r.Current_Year_Sales_Forecast__c' : 'Dealer__r.Prior_Year_Sales_Forecast__c';

String queryAccountPlanGrowth = 
    'SELECT ' +
        'Dealer__r.Name v0, ' +
        'Dealer__r.SAP_Customer_Number__c v1, ' +
        'Dealer__r.Id v11, ' +
        'Dealer__r.LastActivityDate v5, ' +
        'Dealer__c, ' +
        'Dealer__r.SAP_Sales_Group__c v2, ' +
        'SUM(YTD_Sales__c) v4, ' +
        'SUM(PY_Sales__c) v7, ' +
        'SUM(PY2_Sales__c) v8, ' +
        'SUM(PY3_Sales__c) v9, ' +
        'SUM(YTD_Sales_Change__c) v10, ' +
        'Dealer__r.Pricing_Zone__c v3, ' +
        'SUM(' + forecastTotalSales + ') v12 ' +
    'FROM ' +
        'Account_Planning__c ' +
    'WHERE ' +
        'Dealer__r.OwnerId = :currentLoggedInUser ' +
        'AND Account_Plan_Year__c = \'' + String.valueOf(year) + '\' ' +
        'AND YTD_Sales_Change__c >= 0 ' +
        'AND Dealer__r.SAP_Sales_Office__c = \'' + u.SAP_Sales_Office__c + '\' ' +
        'AND Dealer__r.isISRAccount__c = true ' +
    'GROUP BY ' +
        'Dealer__c, ' +
        'Dealer__r.Name, ' +
        'Dealer__r.Id, ' +
        'Dealer__r.SAP_Customer_Number__c, ' +
        'Dealer__r.SAP_Sales_Group__c, ' +
        'Dealer__r.LastActivityDate, ' +
        'Dealer__r.Pricing_Zone__c ' +
    'ORDER BY ' +
        'SUM(YTD_Sales_Change__c) DESC LIMIT 20';
            
            List<AggregateResult> aggResutsISRAccountPlanGrowth = database.query(queryAccountPlanGrowth);
            
            
            if(aggResutsISRAccountPlanGrowth.size() > 0)
            {                
                for(AggregateResult a : aggResutsISRAccountPlanGrowth)
                {
                    wrapper w = new wrapper();
                    w.dealerId = (String)a.get('v11');
                    w.dealerName = (String)a.get('v0');
                    w.dealerCustNo = (String)a.get('v1') != null ? (String)a.get('v1') : 'NA';
                    w.dealerTerritory = (String)a.get('v2');
                    allDealerIds.add(w.dealerId);
                    
                    w.salesForecast  = integer.valueOf((Decimal)a.get('v12')) != null ? integer.valueOf((Decimal)a.get('v12'))  : 0;
                    
                    // Use ternary operator to handle null values more succinctly
                    w.salesForecast = (Integer)(Decimal) a.get('v12') != null ? (Integer) (Decimal)a.get('v12') : 0;
                    w.dealerDeltAYTDSales = (Integer)(Decimal) a.get('v10') != null ? (Integer)(Decimal) a.get('v10') : 0;
                    w.dealerYTDSalesLC = (Integer)(Decimal) a.get('v4') != null ? (Integer)(Decimal) a.get('v4') : 0;
                    //w.dealerFGPrizeZone = (String) a.get('v3');
                    w.dealerpre1TS = (Integer) (Decimal)a.get('v7') != null ? (Integer)(Decimal) a.get('v7') : 0;
                    w.dealerPre2TS = (Integer)(Decimal) a.get('v8') != null ? (Integer)(Decimal) a.get('v8') : 0;
                    w.dealerPre3TS = (Integer) (Decimal)a.get('v9') != null ? (Integer)(Decimal) a.get('v9') : 0;
                    w.dealerLastAct = date.valueOf((DateTime)a.get('v5'));
                    
                    if(wrapListPositive == null || wrapListPositive.size() == 0)
                        wrapListPositive.add(w);
                    else
                    {
                        for(Integer i = 0; i < wrapListPositive.size(); i++)
                        {
                            if(w.dealerDeltAYTDSales > wrapListPositive[i].dealerDeltAYTDSales )
                            {
                                wrapListPositive.add(i,w);
                                i = wrapListPositive.size();
                            }
                            else
                                if((i+1) == wrapListPositive.size())
                            {
                                wrapListPositive.add(w);
                                i = wrapListPositive.size();
                            } 
                        }
                    }
                }
                
                System.debug('wrapListPositive:::::'+wrapListPositive);
                
                dealerDeltAYTDSalesSum1 = 0;
                dealerYTDSalesLCSum1 = 0;
                dealerpre1TSSum1 = 0;
                dealerPre2TSSum1 = 0;
                dealerPre3TSSum1 = 0;
                totalSalesForecastGrowth=0;
                
                for(Wrapper w : wrapListPositive)
                {
                  dealerDeltAYTDSalesSum1 = dealerDeltAYTDSalesSum1 + w.dealerDeltAYTDSales;
                   dealerYTDSalesLCSum1 = dealerYTDSalesLCSum1 + w.dealerYTDSalesLC;
                    dealerpre1TSSum1 = dealerpre1TSSum1 + w.dealerpre1TS;
                    dealerPre2TSSum1 = dealerPre2TSSum1 + w.dealerPre2TS;
                    dealerPre3TSSum1 = dealerPre3TSSum1 + w.dealerPre3TS;
                    totalSalesForecastGrowth = totalSalesForecastGrowth + w.salesForecast;
                }
            }
            /*=============================================================ATTRITION SECTION=============================================*/
              
String queryAccountPlanAttrition =
    'SELECT ' +
        'Dealer__r.Name v0, ' +
        'Dealer__r.Id v11, ' +
        'Dealer__r.SAP_Customer_Number__c v1, ' +
        'Dealer__c, ' +
        'Dealer__r.SAP_Sales_Group__c v2, ' +
        'SUM(YTD_Sales__c) v4, ' +
        'Dealer__r.LastActivityDate v5, ' +
        'SUM(PY_Sales__c) v7, ' +
        'SUM(PY2_Sales__c) v8, ' +
        'SUM(PY3_Sales__c) v9, ' +
        'SUM(YTD_Sales_Change__c) v10, ' +
        'Dealer__r.Pricing_Zone__c v3, ' +
        'SUM(' + forecastTotalSales + ') v12 ' +
    'FROM ' +
        'Account_Planning__c ' +
    'WHERE ' +
        'Dealer__r.OwnerId = :currentLoggedInUser ' +
        'AND Dealer__r.SAP_Sales_Office__c = \'' + u.SAP_Sales_Office__c + '\' ' +
        'AND Account_Plan_Year__c = \'' + String.valueOf(year) + '\' ' +
        'AND YTD_Sales_Change__c < 0 ' +
        'AND Dealer__r.isISRAccount__c = true ' +
    'GROUP BY ' +
        'Dealer__c, ' +
        'Dealer__r.Name, ' +
        'Dealer__r.Id, ' +
        'Dealer__r.SAP_Customer_Number__c, ' +
        'Dealer__r.SAP_Sales_Group__c, ' +
        'Dealer__r.LastActivityDate, ' +
        'Dealer__r.Pricing_Zone__c ' +
    'ORDER BY ' +
        'SUM(YTD_Sales_Change__c) ASC LIMIT 20';
            
            List<AggregateResult> aggResutsISRAccountPlanAttrition = database.query(queryAccountPlanAttrition);
            
            if(aggResutsISRAccountPlanAttrition.size() > 0)
            {                
                for(AggregateResult a : aggResutsISRAccountPlanAttrition)
                {
                    wrapper w = new wrapper();  
                    w.dealerId = (String)a.get('v11');
                    w.dealerName = (String)a.get('v0');
                    w.dealerCustNo = (String)a.get('v1') != null ? (String)a.get('v1') : 'NA';
                    w.dealerTerritory = (String)a.get('v2');
                    allDealerIds.add(w.dealerId);
                    
                      w.salesForecast  = integer.valueOf((Decimal)a.get('v12')) != null ? integer.valueOf((Decimal)a.get('v12'))  : 0;
                    
                    // Use ternary operator to handle null values more succinctly
                    w.salesForecast = (Integer)(Decimal) a.get('v12') != null ? (Integer) (Decimal)a.get('v12') : 0;
                    w.dealerDeltAYTDSales = (Integer)(Decimal) a.get('v10') != null ? (Integer)(Decimal) a.get('v10') : 0;
                    w.dealerYTDSalesLC = (Integer)(Decimal) a.get('v4') != null ? (Integer)(Decimal) a.get('v4') : 0;
                    //w.dealerFGPrizeZone = (String) a.get('v3');
                    w.dealerpre1TS = (Integer) (Decimal)a.get('v7') != null ? (Integer)(Decimal) a.get('v7') : 0;
                    w.dealerPre2TS = (Integer)(Decimal) a.get('v8') != null ? (Integer)(Decimal) a.get('v8') : 0;
                    w.dealerPre3TS = (Integer) (Decimal)a.get('v9') != null ? (Integer)(Decimal) a.get('v9') : 0;
                    w.dealerLastAct = date.valueOf((DateTime)a.get('v5'));
                    
                    if(wrapListNegative == null || wrapListNegative.size() == 0)
                        wrapListNegative.add(w);
                    else
                    {
                        for(Integer i = 0; i < wrapListNegative.size(); i++)
                        {
                            if(w.dealerDeltAYTDSales < wrapListNegative[i].dealerDeltAYTDSales )
                            {
                                wrapListNegative.add(i,w);
                                i = wrapListNegative.size();
                            }
                            else
                                if((i+1) == wrapListNegative.size())
                            {
                                wrapListNegative.add(w);
                                i = wrapListNegative.size();
                            } 
                        }
                    }
                }
                
                dealerDeltAYTDSalesSum2 = 0;
                dealerYTDSalesLCSum2 = 0;
                dealerpre1TSSum2 = 0;
                dealerPre2TSSum2 = 0;
                dealerPre3TSSum2 = 0;
                totalSalesForecastAttrition=0;
                
                for(Wrapper w : wrapListNegative)
                {
                    dealerDeltAYTDSalesSum2 = dealerDeltAYTDSalesSum2 + w.dealerDeltAYTDSales;
                    dealerYTDSalesLCSum2 = dealerYTDSalesLCSum2 + w.dealerYTDSalesLC;
                    dealerpre1TSSum2 = dealerpre1TSSum2 + w.dealerpre1TS;
                    dealerPre2TSSum2 = dealerPre2TSSum2 + w.dealerPre2TS;
                    dealerPre3TSSum2 = dealerPre3TSSum2 + w.dealerPre3TS;
                    totalSalesForecastAttrition= totalSalesForecastAttrition + w.salesForecast;
                    
                }
            }
            
            if(!allDealerIds.isEmpty())
            {
                List<Account> allDealers = [SELECT Qualifies_for_NC_Program__c FROM Account WHERE Id IN: allDealerIds];
                Map<String,String> dealerIdToQualifies = new Map<String,String>();
                
                if(allDealers != null)
                {
                    for(Account dealer: allDealers)
                    {
                        dealerIdToQualifies.put(dealer.Id, dealer.Qualifies_for_NC_Program__c);
                    }
                    
                    for(Wrapper w: wrapListPositive)
                    {
                        if(dealerIdToQualifies.get(w.dealerId).containsIgnoreCase('Currently Enrolled'))
                        {
                            w.newCustomer = true;
                        }
                        else
                        {
                            w.newCustomer = false;
                        }
                    }
                    
                    for(Wrapper w: wrapListNegative)
                    {
                        if(dealerIdToQualifies.get(w.dealerId).containsIgnoreCase('Currently Enrolled'))
                        {
                            w.newCustomer = true;
                        }
                        else
                        {
                            w.newCustomer = false;
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug(e.getCause());
            System.debug(e.getMessage());
            System.debug('Line Number: '+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'WARNING: There was an exception on Line Number: '+e.getLineNumber()+'. Exception Description: '+e.getMessage()));
        }
    }
}