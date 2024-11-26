public class areaManagerAggreagateHelperClass {
    //variable declarations
    
    public string currentLoggedInUser {get; set;}
    public string currentLoggedInUserTerritory{get; set;}
    public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public User u{get; set;}
    private List<User> dmUsers{get; set;}
    private List<Profile> dmProfileUsers{get; set;}
    private List<User> tmUsers{get; set;}
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
    
    private Set<String> salesOffices{get; set;}
    private Set<String> salesGroups{get; set;}
    
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

    public decimal completedRetOpty{get; set;}
    public decimal progressRetOpty{get; set;}
    public decimal notStartedRetOpty{get; set;}
    public decimal cancelledRetOpty{get; set;}

    public Date lastSalesHistoryUpdate{get; set;}

    public integer accOppProgCount{get; set;}
    public integer accountOppCompletedCount{get; set;}
    public integer accountOppNotStartedCount{get; set;}
    public integer accountOppCancelledCount{get; set;}
    public integer accountOppHoldCount{get; set;}

    public integer retOppProgCount{get; set;}
    public integer retOppCompletedCount{get; set;}
    public integer retOppNotStartedCount{get; set;}
    public integer retOppCancelledCount{get; set;}

    public integer actPlanProgCount{get; set;}
    public integer actPlanCompletedCount{get; set;}
    public integer actPlanCancelledCount{get; set;}
    public integer actPlanNotStartedCount{get; set;}

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
    
    public decimal changeDLSC{get; set;}
    public decimal changeMerit{get; set;}
    public decimal changeElite{get; set;}
    public decimal changeAireFlo{get; set;}
    public decimal changeOther{get; set;}
    
    public string yearSelected='';
    public Set<Id> accIdSetTerritory = new Set<Id>();
    public List<wrapper> dmDisplay{get; set;}
    
    public Boolean displayAccOpty{get; set;}
    public Boolean displayCompletedAccOpty{get; set;}
    public Boolean displayInProgressAccOpty{get; set;}
    public Boolean displayCancelledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppCancelled{get; set;}
    
    public Boolean displayActionPlanProgress{get; set;}
    public Boolean displayActionPlanCompleted{get; set;}
    public Boolean displayActionPlanNotStarted{get; set;}
    public Boolean displayActionPlanCancelled{get; set;}
    
    public List<wrapper> accountOpportunities{get; set;}
    
    public List<wrapper> accountOppInProgress{get; set;}
    public List<wrapper> accountOppCompleted{get; set;}
    public List<wrapper> accountOppOnHold{get; set;}
    public List<wrapper> accountOppNotStarted{get; set;}
    public List<wrapper> accountOppCancelled{get; set;}
    
    public List<wrapper> accountRetInProgress{get; set;}
    public List<wrapper> accountRetCompleted{get; set;}
    public List<wrapper> accountRetNotStarted{get; set;}
    public List<wrapper> accountRetCancelled{get; set;}
    
    public List<wrapper> accPlanInProgress{get; set;}
    public List<wrapper> accPlanCompleted{get; set;}
    public List<wrapper> accPlanNotStarted{get; set;}
    public List<wrapper> accPlanCancelled{get; set;}
    
    public integer totalOppAmount {get; set;}
    
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

public areaManagerAggreagateHelperClass(String pYear, String pUserId)
{       
    year = Integer.valueOf(pYear);
    preYear = year -1;
    preTwoYear = year - 2;
    preThreeYear = year - 3;
    currentLoggedInUser = userinfo.getUserId();

    try
    {
    //get the current logged in user's information
            
        u = [SELECT Id, FirstName, LastName, SAP_Sales_District__c, SAP_Sales_Office__c, SAP_Sales_Group__c FROM User WHERE Id =: pUserId LIMIT 1];

        /*System.debug('Current User = '+u);

        System.debug('currentLoggedInuserDistrict::::::'+u.SAP_Sales_District__c);
        System.debug('currentLoggedInUser::::::'+currentLoggedInUser);*/

        //String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
         String forecastTotalSales;
            if(year == system.today().year()){
                        forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
            }
            else if((year == system.today().year()-1)){
                 forecastTotalSales ='Dealer__r.Prior_Year_Sales_Forecast__c';
            }else{
                forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
        }
        
        Set<String> tmProfiles = new Set<String>();
        tmProfiles.add('Lennox - Res Sales TM');
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
        
        String queryAccountPlan = 'SELECT SUM(PY3_Sales__c),SUM(PY2_Sales__c),SUM(PY_Sales__c),SUM('+forecastTotalSales+'),SUM(YTD_Sales__c),SUM(PY_YTD_Sales__c),SUM(YTD_Sales_Change__c),SUM(YTD_Res_Equip_Sales__c),SUM(YTD_Commercial_Sales__c),SUM(YTD_P_S_Sales__c),SUM(YTD_DLSC_Sales__c),AVG(YTD_DLSC_Sales_Percent__c),SUM(PY_YTD_DLSC_Sales__c),AVG(PY_YTD_DLSC_Sales_Percent__c),SUM(YTD_DLSC_Sales_Change__c),SUM(YTD_Elite_Sales__c),AVG(YTD_Elite_Sales_Percent__c),SUM(PY_YTD_Elite_Sales__c),AVG(PY_YTD_Elite_Sales_Percent__c),SUM(YTD_Elite_Sales_Change__c),SUM(YTD_Merit_Sales__c),AVG(YTD_Merit_Sales_Percent__c),SUM(PY_YTD_Merit_Sales__c),AVG(PY_YTD_Merit_Sales_Percent__c),SUM(YTD_Merit_Sales_Change__c),SUM(YTD_Aire_Flo_Sales__c),AVG(YTD_Aire_Flo_Sales_Percent__c),SUM(PY_YTD_Aire_Flo_Sales__c),AVG(PY_YTD_Aire_Flo_Sales_Percent__c),SUM(YTD_Aire_Flo_Sales_Change__c),SUM(YTD_Other_Sales__c),AVG(YTD_Other_Sales_Percent__c),SUM(PY_YTD_Other_Sales__c),AVG(PY_YTD_Other_Sales_Percent__c),SUM(YTD_Other_Sales_Change__c), MAX(Last_Sales_History_Update__c) date1, Dealer__r.SAP_Sales_Office__c FROM Account_Planning__c WHERE Dealer__r.SAP_Sales_District__c =\''+u.SAP_Sales_District__c+'\' AND Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.SAP_Sales_Office__c';
        
        System.debug('queryAccountPlan:::::'+queryAccountPlan);

        List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
        System.debug('aggResutsAccountPlan:::::'+aggResutsAccountPlan);
        
        salesOffices = new Set<String>();
        salesGroups = new Set<String>();

        //calculate the average of all the Account Plans associated with the Dealer for present/previous years
        if(aggResutsAccountPlan.size() > 0)
        {
            dmDisplay = new List<wrapper>();

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

            //Used to show subtotals - decimal variables
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
            completedRetOpty = 0;
            progressRetOpty = 0;
            notStartedRetOpty = 0;
            cancelledRetOpty = 0;
                
            //Used to dislpay count of records - integer variables
            accOppProgCount = 0;
            accountOppCompletedCount = 0;
            accountOppNotStartedCount = 0;
            accountOppCancelledCount = 0;
            accountOppHoldCount = 0;
            retOppProgCount = 0;
            retOppCompletedCount = 0;
            retOppNotStartedCount = 0;
            retOppCancelledCount = 0;
            actPlanProgCount = 0;
            actPlanCompletedCount = 0;
            actPlanCancelledCount = 0;
            actPlanNotStartedCount = 0;

            changeDLSC = 0;
            changeMerit = 0;
            changeElite = 0;
            changeAireFlo = 0;
            changeOther = 0;

            for(AggregateResult q:aggResutsAccountPlan)
            {
                salesOffices.add(String.valueOf(q.get('SAP_Sales_Office__c')));  
            }

            if(Test.isRunningTest())
                dmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Office__c, District_Description_Formula__c, IsActive FROM User WHERE SAP_Sales_Office__c IN: salesOffices];
            else 
                dmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Office__c, District_Description_Formula__c, IsActive FROM User WHERE SAP_Sales_Office__c IN: salesOffices AND Profile.Name LIKE '%Sales DM%' AND isActive = true AND UserRole.Name LIKE '%District Manager%'];

            System.debug('salesOffices :::::' + salesOffices);
            System.debug('dmUsers :::::' + dmUsers);

            Map<String,String> districtToUserIDMap = new Map<String,String>();
            Map<String,String> districtToUserNameMap = new Map<String,String>();
            Map<String,String> districtToDescription = new Map<String,String>();

            if(dmUsers != null)
            {
                for(User a: dmUsers)
                {
                    districtToUserIDMap.put(a.SAP_Sales_Office__c,a.Id);
                    districtToUserNameMap.put(a.SAP_Sales_Office__c,a.FirstName+' '+a.LastName);
                    districtToDescription.put(a.SAP_Sales_Office__c,a.District_Description_Formula__c);
                }
            }
            
            wrapper houseAccounts = new wrapper();
            houseAccounts.userName = 'House Accounts';
            houseAccounts.userId = null;
            houseAccounts.districtThisYearSales = 0;
            houseAccounts.districtLastYearSales = 0;
            houseAccounts.districtTotalThisYearSales = 0;
            houseAccounts.districtTotalLastYearSales = 0;

            for(AggregateResult q:aggResutsAccountPlan)
            {
                if(1==1)
                {
                    wrapper dmRow;
                    if(q.get('SAP_Sales_Office__c') != null && districtToUserIDMap.keySet().contains((String)q.get('SAP_Sales_Office__c')))
                    {
                        dmRow = new wrapper();
                        dmRow.userDistrict = String.valueOf(q.get('SAP_Sales_Office__c'));
                        dmRow.userName = districtToUserNameMap.get((String)q.get('SAP_Sales_Office__c'));
                        dmRow.userId = districtToUserIDMap.get((String)q.get('SAP_Sales_Office__c'));
                        dmRow.userDescription = districtToDescription.get((String)q.get('SAP_Sales_Office__c'));
                        dmRow.districtThisYearSales = 0;
                        dmRow.districtLastYearSales = 0;
                    }
                    else
                    {
                        dmRow = houseAccounts;
                        if(q.get('SAP_Sales_Office__c') != null)
                            dmRow.userDistrict = String.valueOf(q.get('SAP_Sales_Office__c'));
                    }

                    previousYearTotalSales += q.get('expr2') == null ? 0 : (Decimal)q.get('expr2');
                    previousTwoYearsTotalSales += q.get('expr1') == null ? 0 : (Decimal)q.get('expr1');
                    previousThreeYearsTotalSales += q.get('expr0') == null ? 0 : (Decimal)q.get('expr0');

                    presentYearSalesForecast += q.get('expr3') == null ? 0 : (Decimal)q.get('expr3');
                    ytdSales += q.get('expr4') == null ? 0 : (Decimal)q.get('expr4');
                    dmRow.districtThisYearSales += q.get('expr4') == null ? 0 : (Decimal)q.get('expr4');
                    previuosYearsYTDSales += q.get('expr5') == null ? 0 : (Decimal)q.get('expr5');
                    dmRow.districtLastYearSales += q.get('expr5') == null ? 0 : (Decimal)q.get('expr5');

                    ytdSalesChange += q.get('expr6') == null ? 0 : (Decimal)q.get('expr6');
                    ytdResEquipment += q.get('expr7') == null ? 0 : (Decimal)q.get('expr7');
                    ytdCommercials += q.get('expr8') == null ? 0 : (Decimal)q.get('expr8');
                    ytdPartsndSupplies += q.get('expr9') == null ? 0 : (Decimal)q.get('expr9');

                    presetDLSC += q.get('expr10') == null ? 0 : (Decimal)q.get('expr10');
                    presetDLSCPercent += q.get('expr11') == null ? 0 : (Decimal)q.get('expr11');
                    presetMerit += q.get('expr20') == null ? 0 : (Decimal)q.get('expr20');
                    presetMeritPercent += q.get('expr21') == null ? 0 : (Decimal)q.get('expr21');
                    presetElite += q.get('expr15') == null ? 0 : (Decimal)q.get('expr15');
                    presetElitePercent += q.get('expr16') == null ? 0 : (Decimal)q.get('expr16');
                    presetAireFlo += q.get('expr25') == null ? 0 : (Decimal)q.get('expr25');
                    presetAireFloPercent += q.get('expr26') == null ? 0 : (Decimal)q.get('expr26');
                    presetOther += q.get('expr30') == null ? 0 : (Decimal)q.get('expr30');
                    presentYearOtherPercent += q.get('expr31') == null ? 0 : (Decimal)q.get('expr31');

                    previousYearDLSC += q.get('expr12') == null ? 0 : (Decimal)q.get('expr12');
                    previousYearDLSCPercent += q.get('expr13') == null ? 0 : (Decimal)q.get('expr13');
                    previousYearMerit += q.get('expr22') == null ? 0 : (Decimal)q.get('expr22');
                    previousYearMeritPercent += q.get('expr23') == null ? 0 : (Decimal)q.get('expr23');
                    previousYearElite += q.get('expr17') == null ? 0 : (Decimal)q.get('expr17');
                    previousYearElitePercent += q.get('expr18') == null ? 0 : (Decimal)q.get('expr18');
                    previousYearAireFlo += q.get('expr27') == null ? 0 : (Decimal)q.get('expr27');
                    previousYearAireFloPercent += q.get('expr28') == null ? 0 : (Decimal)q.get('expr28');
                    previousYearOther += q.get('expr32') == null ? 0 : (Decimal)q.get('expr32');
                    previousYearOtherPercent += q.get('expr33') == null ? 0 : (Decimal)q.get('expr33');
                    
                    changeDLSC += q.get('expr14') == null ? 0 : (Decimal)q.get('expr14');
                    changeMerit += q.get('expr24') == null ? 0 : (Decimal)q.get('expr24');
                    changeElite += q.get('expr19') == null ? 0 : (Decimal)q.get('expr19');
                    changeAireFlo += q.get('expr29') == null ? 0 : (Decimal)q.get('expr29');
                    changeOther += q.get('expr34') == null ? 0 : (Decimal)q.get('expr34');

                    if(dmRow != null && dmRow.userName != 'House Accounts')
                    {
                        if(dmDisplay == null || dmDisplay.size() == 0)
                               dmDisplay.add(dmRow);
                        else
                        {
                            for(Integer i = 0; i < dmDisplay.size(); i++)
                            {
                                if((dmRow.districtThisYearSales - dmRow.districtLastYearSales) > (dmDisplay[i].districtThisYearSales - dmDisplay[i].districtLastYearSales))
                                {
                                    dmDisplay.add(i,dmRow);
                                    i = dmDisplay.size();
                                }
                                else
                                    if((i+1) == dmDisplay.size())
                                {
                                    dmDisplay.add(dmRow); 
                                    i = dmDisplay.size();
                                }
                            }
                        }   
                    }
                    else
                        houseAccounts = dmRow;
                    

                    if(lastSalesHistoryUpdate == null)
                    {
                        if(q.get('date1') != null)
                            lastSalesHistoryUpdate = date.valueOf((Date)q.get('date1'));
                    }
                    else
                        if(q.get('date1') != null && lastSalesHistoryUpdate < date.valueOf((Date)q.get('date1')))
                            lastSalesHistoryUpdate = date.valueOf((Date)q.get('date1'));

                    System.debug('lastSalesHistoryUpdate:::::'+lastSalesHistoryUpdate);
                }
            }
            
            //if((houseAccounts.districtThisYearSales != null && houseAccounts.districtThisYearSales > 0)||(houseAccounts.districtLastYearSales != null && houseAccounts.districtLastYearSales > 0))
                    dmDisplay.add(houseAccounts);            
        }
    }
    catch(Exception e)
    {
        System.debug('Exception:::'+e);
        ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
    }

  
    try
    {
        SetAccountOpportunities();
        
        SetAccountRetentions();
        
        SetAccountPlans();
    }
    catch(Exception e)
    {
        System.debug(e.getMessage());
        System.debug('Line Number: '+e.getLineNumber());
        ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
    }
}

public ExecutiveRollUpMain__c getMainRecord()
{
    ExecutiveRollUpMain__c thisRollUp = new ExecutiveRollUpMain__c();
        thisRollUp.Year__c = String.valueOf(year);
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
        thisRollUp.Type__c = 'Region';
        thisRollUp.UserId__c = u.Id;
        return thisRollUp;
}

public List<ExecutiveRollUpChild__c> getAccountOpportunityRecords (String pUserId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accountOppInProgress != null)
    {
        for(wrapper acc: accountOppInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numInProgressOpp;
            newRecord.AdjustedValue__c = acc.oppInProgressAdjValue;
            newRecord.ExpectedValue__c = acc.oppInProgressExpValue;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppNotStarted != null)
    {    
        for(wrapper acc: accountOppNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numNotStartedOpp;
            newRecord.AdjustedValue__c = acc.oppNotStartedAdjValue;
            newRecord.ExpectedValue__c = acc.oppNotStartedExpValue;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppOnHold != null)
    {
        for(wrapper acc: accountOppOnHold)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.userId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numOnHoldOpp;
            newRecord.AdjustedValue__c = acc.oppOnHoldAdjValue;
            newRecord.ExpectedValue__c = acc.oppOnHoldExpValue;
            newRecord.Status__c = 'On Hold';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppCompleted != null)
    {
        for(wrapper acc: accountOppCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numCompletedOpp;
            newRecord.AdjustedValue__c = acc.oppCompletedAdjValue;
            newRecord.ExpectedValue__c = acc.oppCompletedExpValue;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppCancelled != null)
    {
        for(wrapper acc: accountOppCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numCancelledOpp;
            newRecord.AdjustedValue__c = acc.oppCancelledAdjValue;
            newRecord.ExpectedValue__c = acc.oppCancelledExpValue;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    return childRecords;
}

public List<ExecutiveRollUpChild__c> getRetentionOpportunityRecords (String pUserId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accountRetInProgress != null)
    {
        for(wrapper acc: accountRetInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numInProgressRet;
            newRecord.PotentialCRIPoints__c = acc.retInProgressCRIPoints;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetNotStarted != null)
    {
        for(wrapper acc: accountRetNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numNotStartedRet;
            newRecord.PotentialCRIPoints__c = acc.retNotStartedCRIPoints;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetCompleted != null)
    {
        for(wrapper acc: accountRetCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numCompletedRet;
            newRecord.PotentialCRIPoints__c = acc.retCompletedCRIPoints;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetCancelled != null)
    {
        for(wrapper acc: accountRetCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numCancelledRet;
            newRecord.PotentialCRIPoints__c = acc.retCancelledCRIPoints;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    return childRecords;
}

public List<ExecutiveRollUpChild__c> getActionPlanRecords (String pUserId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accPlanInProgress != null)
    {
        for(wrapper acc: accPlanInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numInProgressAccPlan;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanNotStarted != null)
    {
        for(wrapper acc: accPlanNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numNotStartedAccPlan;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanCompleted != null)
    {
        for(wrapper acc: accPlanCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numCompletedAccPlan;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanCancelled != null)
    {
        for(wrapper acc: accPlanCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numCancelledAccPlan;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    
    return childRecords;
}

public List<ExecutiveRollUpChild__c> getRegionRecords (String pUserId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(dmDisplay != null)
    {
        for(wrapper acc: dmDisplay)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.UserId__c = pUserId;
           
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userDistrict + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.CY_YTDSales__c = acc.districtThisYearSales;
            newRecord.PY_YTDSales__c = acc.districtLastYearSales;
            newRecord.Type__c = 'Region';
            newRecord.URLText__c = '/apex/districtManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    return childRecords;
} 

public void SetAccountOpportunities()
    {
        List<AggregateResult> aggResultsAccountOpportunities = [SELECT 
                                                COUNT(Id) numOpp, 
                                                SUM(Adjusted_Value__c) adjValue,
                                                SUM(Expected_Value__c) expValue, 
                                                Opportunity_Status__c status,
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c district
                                           FROM Account_Opportunty__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c =: u.SAP_Sales_District__c AND
                                               (Opportunity_Status__c = 'In Progress' OR Opportunity_Status__c = 'Completed' OR Opportunity_Status__c = 'Not Started' OR Opportunity_Status__c = 'Cancelled' OR Opportunity_Status__c = 'On Hold') 
                                           GROUP BY Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c 
                                           ];
                                                               
            System.debug('aggResultsAccountOpportunities :::::'+aggResultsAccountOpportunities );
            totalOppAmount  = 0;
            if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)
            {
                accountOpportunities = new List<wrapper>();
                accountOppInProgress = new List<wrapper>();
                accountOppCompleted = new List<wrapper>();
                accountOppNotStarted = new List<wrapper>();
                accountOppCancelled = new List<wrapper>();
                accountOppOnHold = new List<wrapper>();
                
                displayAccOpty = true;
                for(aggregateResult ag: aggResultsAccountOpportunities)
                {
                    totalOppAmount +=  ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue')); 
                    for(wrapper ow: dmDisplay)
                    {
                        if(ow.userDistrict == (String)ag.get('district'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppInProgressAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppInProgressExpValue = ag.get('expValue') == null ? 0 : Integer.valueOF((Decimal)ag.get('expValue'));
                               displayInProgressAccOpty = true;
                               progressAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               progressAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accOppProgCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               // Sorting by Exp Value Descending
                               if(accountOppInProgress == null || accountOppInProgress.size() == 0)
                                   accountOppInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppInProgress.size(); i++)
                                   {
                                       if(ow.oppInProgressAdjValue >= accountOppInProgress[i].oppInProgressAdjValue)
                                       {
                                           accountOppInProgress.add(i,ow);
                                           i = accountOppInProgress.size();
                                       }
                                       else
                                           if((i+1) == accountOppInProgress.size())
                                           {
                                              accountOppInProgress.add(ow); 
                                              i = accountOppInProgress.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCompletedAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCompletedExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCompletedAccOpty = true;
                               completedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               completedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCompletedCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppCompleted == null || accountOppCompleted.size() == 0)
                                   accountOppCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppCompleted.size(); i++)
                                   {
                                       if(ow.oppCompletedAdjValue >= accountOppCompleted[i].oppCompletedAdjValue )
                                       {
                                           accountOppCompleted.add(i,ow);
                                               i = accountOppCompleted.size();
                                       }
                                       else
                                           if((i+1) == accountOppCompleted.size())
                                           {
                                              accountOppCompleted.add(ow);
                                              i = accountOppCompleted.size();
                                           } 
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppNotStartedAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppNotStartedExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayNotStartedAccOpty = true;
                               notStartedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               notStartedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppNotStartedCount +=  ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppNotStarted == null || accountOppNotStarted.size() == 0)
                                   accountOppNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppNotStarted.size(); i++)
                                   {
                                       if(ow.oppNotStartedAdjValue >= accountOppNotStarted[i].oppNotStartedAdjValue )
                                       {
                                           accountOppNotStarted.add(i,ow);
                                           i = accountOppNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accountOppNotStarted.size())
                                           {
                                              accountOppNotStarted.add(ow); 
                                              i = accountOppNotStarted.size();
                                           }
                                   }
                               }
                               
                               System.debug('accountOppNotStarted :: ' + accountOppNotStarted);
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCancelledAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCancelledExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCancelledAccOpty = true;
                               cancelledAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               cancelledAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCancelledCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppCancelled == null || accountOppCancelled.size() == 0)
                                   accountOppCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppCancelled.size(); i++)
                                   {
                                       if(ow.oppCancelledAdjValue >= accountOppCancelled[i].oppCancelledAdjValue)
                                       {
                                           accountOppCancelled.add(i,ow);
                                           i = accountOppCancelled.size();
                                       }
                                       else
                                           if((i+1) == accountOppCancelled.size())
                                           {
                                              accountOppCancelled.add(ow); 
                                              i = accountOppCancelled.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'On Hold')
                           {
                               ow.numOnHoldOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppOnHoldAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppOnHoldExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayHoldAccOpty = true;
                               holdAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               holdAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppHoldCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppOnHold == null || accountOppOnHold.size() == 0)
                                   accountOppOnHold.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppOnHold.size(); i++)
                                   {
                                       if(ow.oppOnHoldAdjValue >= accountOppOnHold[i].oppOnHoldAdjValue)
                                       {
                                           accountOppOnHold.add(i,ow);
                                           i = accountOppOnHold.size();
                                       }
                                       else
                                           if((i+1) == accountOppOnHold.size())
                                           {
                                              accountOppOnHold.add(ow); 
                                              i = accountOppOnHold.size();
                                           }
                                   }
                               }
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
            }//if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)
            else
                displayAccOpty = false;
    }//SetAccountOpportunities()

public void SetAccountRetentions()
    {
        List<AggregateResult> aggResultsAccountRetentions = [SELECT 
                                                COUNT(Id) numRet, 
                                                SUM(Potential_CRI_Points__c) criPoints, 
                                                Retention_Opportunity_Status__c status,
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c district
                                           FROM Retention_Opportunity__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c =: u.SAP_Sales_District__c AND
                                               (Retention_Opportunity_Status__c = 'In Progress' OR Retention_Opportunity_Status__c = 'Completed' OR Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'Cancelled') 
                                           GROUP BY Retention_Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c 
                                           ];
                                                               
            System.debug('aggResultsAccountRetentions :::::'+aggResultsAccountRetentions );
            if(aggResultsAccountRetentions != null && aggResultsAccountRetentions.size() > 0)
            {
                accountRetInProgress = new List<wrapper>();
                accountRetCompleted = new List<wrapper>();
                accountRetNotStarted = new List<wrapper>();
                accountRetCancelled = new List<wrapper>();
                
                for(aggregateResult ag: aggResultsAccountRetentions)
                {
                    for(wrapper ow: dmDisplay)
                    {
                        if(ow.userDistrict == (String)ag.get('district'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retInProgressCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppProgress = true;
                               progressRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppProgCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetInProgress == null || accountRetInProgress.size() == 0)
                                   accountRetInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetInProgress.size(); i++)
                                   {
                                       if(ow.retInProgressCRIPoints >= accountRetInProgress[i].retInProgressCRIPoints)
                                       {
                                           accountRetInProgress.add(i,ow);
                                           i = accountRetInProgress.size();
                                       }
                                       else
                                           if((i+1) == accountRetInProgress.size())
                                           {
                                              accountRetInProgress.add(ow);
                                              i = accountRetInProgress.size();
                                           }     
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCompletedCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCompleted = true;
                               completedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCompletedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetCompleted == null || accountRetCompleted.size() == 0)
                                   accountRetCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetCompleted.size(); i++)
                                   {
                                       if(ow.retCompletedCRIPoints >= accountRetCompleted[i].retCompletedCRIPoints)
                                       {
                                           accountRetCompleted.add(i,ow);
                                           i = accountRetCompleted.size();
                                       }
                                       else
                                           if((i+1) == accountRetCompleted.size())
                                           {
                                              accountRetCompleted.add(ow); 
                                              i = accountRetCompleted.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retNotStartedCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppNotStarted = true;
                               notStartedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppNotStartedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetNotStarted == null || accountRetNotStarted.size() == 0)
                                   accountRetNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetNotStarted.size(); i++)
                                   {
                                       if(ow.retNotStartedCRIPoints >= accountRetNotStarted[i].retNotStartedCRIPoints)
                                       {
                                           accountRetNotStarted.add(i,ow);
                                           i = accountRetNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accountRetNotStarted.size())
                                           {
                                              accountRetNotStarted.add(ow); 
                                              i = accountRetNotStarted.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCancelledCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCancelled = true;
                               cancelledRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCancelledCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetCancelled == null || accountRetCancelled.size() == 0)
                                   accountRetCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetCancelled.size(); i++)
                                   {
                                       if(ow.retCancelledCRIPoints >= accountRetCancelled[i].retCancelledCRIPoints )
                                       {
                                           accountRetCancelled.add(i,ow);
                                           i = accountRetCancelled.size();
                                       }
                                       else
                                           if((i+1) == accountRetCancelled.size())
                                           {
                                              accountRetCancelled.add(ow);
                                              i = accountRetCancelled.size();
                                           } 
                                   }
                               }
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
            }//if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)

    }//SetAccountRetentions()
    
public void SetAccountPlans()
    {
        List<AggregateResult> aggResultsAccountPlans = [SELECT 
                                                COUNT(Id) numAP, 
                                                Action_Status__c status,
                                                Account_Plan__r.Dealer__r.SAP_Sales_Office__c district
                                           FROM Action_Plan__c 
                                           WHERE
                                               Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Account_Plan__r.Dealer__r.SAP_Sales_District__c =: u.SAP_Sales_District__c AND
                                               (Action_Status__c = 'In Progress' OR Action_Status__c = 'Completed' OR Action_Status__c = 'Not Started' OR Action_Status__c = 'Cancelled') 
                                           GROUP BY Action_Status__c, Account_Plan__r.Dealer__r.SAP_Sales_Office__c
                                           ];
                                                               
            System.debug('aggResultsAccountPlans :::::'+aggResultsAccountPlans );
            if(aggResultsAccountPlans != null && aggResultsAccountPlans.size() > 0)
            {
                accPlanInProgress = new List<wrapper>();
                accPlanCompleted = new List<wrapper>();
                accPlanNotStarted = new List<wrapper>();
                accPlanCancelled = new List<wrapper>();
                
                for(aggregateResult ag: aggResultsAccountPlans )
                {
                    for(wrapper ow: dmDisplay)
                    {
                        if(ow.userDistrict == (String)ag.get('district'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanProgress = true;
                               actPlanProgCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanInProgress == null || accPlanInProgress.size() == 0)
                                   accPlanInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanInProgress.size(); i++)
                                   {
                                       if(ow.numInProgressAccPlan >= accPlanInProgress[i].numInProgressAccPlan)
                                       {
                                           accPlanInProgress.add(i,ow);
                                           i = accPlanInProgress.size();
                                       }
                                       else
                                           if((i+1) == accPlanInProgress.size())
                                           {
                                              accPlanInProgress.add(ow); 
                                              i = accPlanInProgress.size();
                                           }
                                   }
                               
                               }
                               
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCompleted = true;
                               actPlanCompletedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanCompleted == null || accPlanCompleted.size() == 0)
                                   accPlanCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanCompleted.size(); i++)
                                   {
                                       if(ow.numCompletedAccPlan >= accPlanCompleted[i].numCompletedAccPlan)
                                       {
                                           accPlanCompleted.add(i,ow);
                                           i = accPlanCompleted.size();
                                       }
                                       else
                                           if((i+1) == accPlanCompleted.size())
                                           {
                                              accPlanCompleted.add(ow); 
                                              i = accPlanCompleted.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanNotStarted = true;
                               actPlanNotStartedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanNotStarted == null || accPlanNotStarted.size() == 0)
                                   accPlanNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanNotStarted.size(); i++)
                                   {
                                       if(ow.numNotStartedAccPlan >= accPlanNotStarted[i].numNotStartedAccPlan)
                                       {
                                           accPlanNotStarted.add(i,ow);
                                           i = accPlanNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accPlanNotStarted.size())
                                           {
                                              accPlanNotStarted.add(ow); 
                                              i = accPlanNotStarted.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCancelled = true;
                               actPlanCancelledCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanCancelled == null || accPlanCancelled.size() == 0)
                                   accPlanCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanCancelled.size(); i++)
                                   {
                                       if(ow.numCancelledAccPlan >= accPlanCancelled[i].numCancelledAccPlan )
                                       {
                                           accPlanCancelled.add(i,ow);
                                           i = accPlanCancelled.size();
                                       }
                                       else
                                           if((i+1) == accPlanCancelled.size())
                                           {
                                              accPlanCancelled.add(ow); 
                                              i = accPlanCancelled.size();
                                           }
                                   }
                               
                               }
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
            }//if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)

    }//SetAccountPlans()

//Wrapper Class
public class wrapper
{
public string userId{get;set;}
public string userName{get;set;}
public string userDistrict{get;set;}
public string userDescription{get; set;}
public decimal districtThisYearSales{get;set;}
public decimal districtLastYearSales{get;set;}
public decimal districtTotalThisYearSales{get; set;}
public decimal districtTotalLastYearSales{get; set;}

public integer change {get {
    return Integer.valueOf(districtThisYearSales - districtLastYearSales);
    } set;}
        
            // Account Opportunity Variables
            public integer numCompletedOpp{get; set;}
            public integer oppCompletedAdjValue {get; set;}
            public integer oppCompletedExpValue {get; set;}
            public integer numInProgressOpp{get; set;}
            public integer oppInProgressAdjValue {get; set;}
            public integer oppInProgressExpValue {get; set;}
            public integer numNotStartedOpp{get; set;}
            public integer oppNotStartedAdjValue {get; set;}
            public integer oppNotStartedExpValue {get; set;}
            public integer numCancelledOpp{get; set;}
            public integer oppCancelledAdjValue {get; set;}
            public integer oppCancelledExpValue {get; set;}
            public integer numOnHoldOpp{get; set;}
            public integer oppOnHoldAdjValue {get; set;}
            public integer oppOnHoldExpValue {get; set;}
            
            // Account Retention Variables
            public integer numCompletedRet{get; set;}
            public integer retCompletedCRIPoints {get; set;}
            public integer numInProgressRet{get; set;}
            public integer retInProgressCRIPoints {get; set;}
            public integer numNotStartedRet{get; set;}
            public integer retNotStartedCRIPoints {get; set;}
            public integer numCancelledRet{get; set;}
            public integer retCancelledCRIPoints {get; set;}
            public integer numOnHoldRet{get; set;}
            public integer retOnHoldCRIPoints {get; set;}
            
            // Account Plan Variables
            public integer numCompletedAccPlan{get; set;}
            public integer numInProgressAccPlan{get; set;}
            public integer numNotStartedAccPlan{get; set;}
            public integer numCancelledAccPlan{get; set;}
            
            public string accPlanId{get; set;}
            public string accPlanName{get;set;}
            public string retOptyId {get; set;}
            public string retOptyNum{get;set;}
            public string retOptyType{get;set;}
            public string retOpty{get;set;}
            public integer potenCRIPts{get;set;}

}
}