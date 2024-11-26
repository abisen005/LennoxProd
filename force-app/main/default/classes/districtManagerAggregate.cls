/********************************************************
Developer : Eduardo Rodriguez
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class districtManagerAggregate
{
    //variable declarations
    public string currentLoggedInUser{get; set;}
    public string currentLoggedInUserTerritory{get; set;}
    public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public boolean isAmProfile{get; set;}
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
    public string accountId{get; set;}
    
    public User u{get; set;}

    public Set<String> salesGroups{get; set;}
    
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
    
    public Boolean displayAccOpty{get; set;}
    public Boolean displayCompletedAccOpty{get; set;}
    public Boolean displayInProgressAccOpty{get; set;}
    public Boolean displayCancelledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    public decimal completedRetOpty{get; set;}
    public decimal progressRetOpty{get; set;}
    public decimal notStartedRetOpty{get; set;}
    public decimal cancelledRetOpty{get; set;}
    
    public Date lastSalesHistoryUpdate{get; set;}
    
    //variable declared for Account Opportunity section
    
    public integer accOppProgCount{get; set;}
    public integer accountOppCompletedCount{get; set;}
    public integer accountOppNotStartedCount{get; set;}
    public integer accountOppCancelledCount{get; set;}
    public integer accountOppHoldCount{get; set;}
    
    //variable declared for Retention Opportunity section
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppCancelled{get; set;}
    
    public integer retOppProgCount{get; set;}
    public integer retOppCompletedCount{get; set;}
    public integer retOppNotStartedCount{get; set;}
    public integer retOppCancelledCount{get; set;}
    
    //variable declared for Action Plan section
    
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
    public integer ytdSales{get; set;}
    public integer previuosYearsYTDSales{get; set;}
    
    //variable for YTD Sales - Product Hierarchy
    public integer ytdSalesChange{get; set;}
    public integer ytdResEquipment{get; set;}
    public integer ytdCommercials{get; set;}
    public integer ytdPartsndSupplies{get; set;}
    
    //variable for YTD Sales - Product Tier Present Year
    public integer presetDLSC{get; set;}
    public decimal presetDLSCPercent{get; set;}
    public integer presetMerit{get; set;}
    public decimal presetMeritPercent{get; set;}
    public integer presetElite{get; set;}
    public decimal presetElitePercent{get; set;}
    public integer presetAireFlo{get; set;}
    public decimal presetAireFloPercent{get; set;}
    public integer presetOther{get; set;}
    public decimal presentYearOtherPercent{get; set;}
    
    public integer dealerDeltAYTDSalesSum1{get;set;}
    public integer dealerYTDSalesLCSum1{get;set;}
    public integer dealerpre1TSSum1{get;set;}
    public integer dealerPre2TSSum1{get;set;}
    public integer dealerPre3TSSum1{get;set;}
    
    public integer dealerDeltAYTDSalesSum2{get;set;}
    public integer dealerYTDSalesLCSum2{get;set;}
    public integer dealerpre1TSSum2{get;set;}
    public integer dealerPre2TSSum2{get;set;}
    public integer dealerPre3TSSum2{get;set;}
    
    //variable for YTD Sales - Product Tier Previous Year
    public integer previousYearDLSC{get; set;}
    public decimal previousYearDLSCPercent{get; set;}
    public integer previousYearMerit{get; set;}
    public decimal previousYearMeritPercent{get; set;}
    public integer previousYearElite{get; set;}
    public decimal previousYearElitePercent{get; set;}
    public integer previousYearAireFlo{get; set;}
    public decimal previousYearAireFloPercent{get; set;}
    public integer previousYearOther{get; set;}
    public decimal previousYearOtherPercent{get; set;}
    
    
    public integer changeDLSC{get; set;}
    public integer changeMerit{get; set;}
    public integer changeElite{get; set;}
    public integer changeAireFlo{get; set;}
    public integer changeOther{get; set;}
    
    public string yearSelected='';
    public Set<Id> accIdSetTerritory = new Set<Id>();
    public List<wrapper> tmDisplay{get; set;}
        public List<wrapper> tmISR_TSADisplay{get; set;}

    
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
    
     public List<wrapper> favLinks{get; set;}
    public List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper> favURLList{get; set;}
    
     
    public integer totalOppAmount {get; set;}
    
    //Variable for ISR & TSA 
    public integer totalISRAmount {get; set;}
     public integer ytdISRSales {get; set;}
    public integer ytdTSASales {get; set;}
    public integer ytdISRSalesPreviousYear {get; set;}
    public integer ytdTSASalesPreviousYear {get; set;}
    
     public integer totalytdISRSales {get; set;}
     public integer totalytdTSASales {get; set;}
   
     public integer YTDSalesNotOwnedByTM {get; set;}
     public integer PYYTDSalesNotOwnedByTM {get; set;}

    
    public Pagereference cancel()
    {
    return new PageReference('javascript:window.close()');
    }
    
    
    /*private List<wrapper> sortTMDisplay(List<wrapper> pTMDisplay)
    {
        List<wrapper> temp = new List<wrapper>();
        System.debug('Sorting...');
        if(pTMDisplay != null && pTMDisplay.size() > 0)
        {
            for(Integer i = 0; i < pTMDisplay.size(); i++)
            {
                if(temp == null || temp.size() == 0)
                {
                    temp.add(pTMDisplay[i]);
                    System.debug('First Item Added : '+pTMDisplay[i]);
                }
                else
                {
                    for(Integer n = 0; n < temp.size(); n++)
                    {
                        if((pTMDisplay[i].territoryThisYearSales - pTMDisplay[i].territoryLastYearSales) > (temp[n].territoryThisYearSales - temp[n].territoryLastYearSales))
                        {
                            temp.add(n,pTMDisplay[i]);
                            n = pTMDisplay.size();
                            System.debug('Item Added front of List : '+pTMDisplay[i]);
                        }
                        else if((n+1) == temp.size())
                        {
                            temp.add(pTMDisplay[i]);
                            System.debug('Item Added end of List : '+pTMDisplay[i]);
                            n = temp.size();
                        }
                    }
                    
                }
            }
            
            return temp;
        }
        else
            return pTMDisplay;
    }*/

    //constructor of the class.
    //Here average value for Present and past years for various fields value to be displayed on the page is calculated using the aggregate
    //query. The value of Present/Previous year, Dealer Id is captured from the url for further references.
  
    
    public districtManagerAggregate()
    {
       currentLoggedInUser = userinfo.getUserId();
        
       //currentLoggedInUser='0053c00000BBGx3AAH'  ;
        showFavoritesLinkSalesUtility favLinkClass = new showFavoritesLinkSalesUtility();
       // myList = new List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper> ();
 favURLList = favLinkClass.getFavoritesLink(currentLoggedInUser);
        //system.debug('!!!BREAKDOWN'+favURLList);
        
        AggregateReportsSettings__c profilesettings = AggregateReportsSettings__c.getOrgDefaults();
        List<String> validProfiles = new List<String>();
        for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                            FROM Quick_Links_Cmp_Setting__c 
                                            WHERE RollupSummary__c = true 
                                                OR RegionRollupSummary__c = true
                                                OR DistrictRollupSummary__c = true]){
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
        //if(profilesettings != null && profilesettings.District_Access__c != null)
        //{
        //    validProfiles.addAll(profilesettings.District_Access__c.split(';'));
        //}
        /*
        validProfiles.add('Lennox - Res Sales - EXE');
        validProfiles.add('Lennox - Res Sales - Corporate User');
        validProfiles.add('Lennox Business Administrator');
        validProfiles.add('Lennox Business Administrator Super');
        validProfiles.add('Lennox - Res Sales AM');
        validProfiles.add('Lennox - Res Sales BDM');
        validProfiles.add('Lennox - Res Sales RBM');
        validProfiles.add('Lennox - Res Sales DM');
        validProfiles.add('Lennox - Res Sales DM Pilot');*/
        
        try
        {
            User verProfile = [SELECT Id From USER WHERE Id =: currentLoggedInUser AND Profile.Name IN: validProfiles];
            invalidProfile = false;
        } 
        catch (Exception e)
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
        } 
        catch(Exception e)
        { 
            System.debug('Error Obtaining Year -'+e.getMessage());
        }
    
        //if User is Area Manager, allow to set the User Parameter
        Set<String> higherProfiles = new Set<String>();
        for(Quick_Links_Cmp_Setting__c q : [SELECT Profile_Name__c
                                            FROM Quick_Links_Cmp_Setting__c 
                                            WHERE RollupSummary__c = true 
                                            OR RegionRollupSummary__c = true]){
            higherProfiles.add(q.Profile_Name__c);
        }                    
        //if(profilesettings != null && profilesettings.Executive_Access__c != null)
        //{
        //    higherProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
        //}
        //if(profilesettings != null && profilesettings.Region_Access__c != null)
        //{
        //    higherProfiles.addAll(profilesettings.Region_Access__c.split(';'));
        //}
        /*
        higherProfiles.add('Lennox - Res Sales - EXE');
        higherProfiles.add('Lennox - Res Sales - Corporate User');
        higherProfiles.add('Lennox Business Administrator');
        higherProfiles.add('Lennox Business Administrator Super');
        higherProfiles.add('Lennox - Res Sales AM');
        higherProfiles.add('Lennox - Res Sales BDM');
        higherProfiles.add('Lennox - Res Sales RBM');*/

        try
        {
           User amProfile = [SELECT Id From USER WHERE Id =: currentLoggedInUser AND Profile.Name IN: higherProfiles];
           isAmProfile = true;
        } 
        catch (Exception e)
        {
           isAmProfile = false;
        }
        
        Set<String> dmProfiles = new Set<String>();
        dmProfiles.add('Lennox - Res Sales DM');
        dmProfiles.add('Lennox - Res Sales DM - Lightning');
        
        if(isAmProfile)
        {
           if(ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().get('u') != null)
           {
               try
               {
                   String dmUser = ApexPages.CurrentPage().getParameters().get('u');
                   User amProfile = [SELECT Id From USER WHERE Id =: dmUser AND Profile.Name IN: dmProfiles];
                   currentLoggedInUser = dmUser;
               } 
               catch(Exception e){}
           }
        }

        try
        {
        //get the current logged in user's information            
            
            u = [SELECT Id, FirstName, LastName, District_Description_Formula__c, SAP_Sales_Office__c, SAP_Sales_Group__c FROM User WHERE Id =: currentLoggedInUser LIMIT 1];
            
            currentLoggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() LIMIT 1].Name;

    
          //  System.debug('currentLoggedInUserDistrict::::::'+u.SAP_Sales_Office__c);
            //System.debug('currentLoggedInUser::::::'+currentLoggedInUser);
    
           // String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
            String forecastTotalSales;
            if(year == system.today().year()){
                        forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
            }
            else{
                 forecastTotalSales ='Dealer__r.Prior_Year_Sales_Forecast__c';
            }

         String queryAccountPlan = 'SELECT SUM(PY3_Sales__c),SUM(PY2_Sales__c),SUM(PY_Sales__c),SUM('+forecastTotalSales+'),SUM(YTD_Sales__c),SUM(PY_YTD_Sales__c),SUM(YTD_Sales_Change__c),SUM(YTD_Res_Equip_Sales__c),SUM(YTD_Commercial_Sales__c),SUM(YTD_P_S_Sales__c),SUM(YTD_DLSC_Sales__c),AVG(YTD_DLSC_Sales_Percent__c),SUM(PY_YTD_DLSC_Sales__c),AVG(PY_YTD_DLSC_Sales_Percent__c),SUM(YTD_DLSC_Sales_Change__c),SUM(YTD_Elite_Sales__c),AVG(YTD_Elite_Sales_Percent__c),SUM(PY_YTD_Elite_Sales__c),AVG(PY_YTD_Elite_Sales_Percent__c),SUM(YTD_Elite_Sales_Change__c),SUM(YTD_Merit_Sales__c),AVG(YTD_Merit_Sales_Percent__c),SUM(PY_YTD_Merit_Sales__c),AVG(PY_YTD_Merit_Sales_Percent__c),SUM(YTD_Merit_Sales_Change__c),SUM(YTD_Aire_Flo_Sales__c),AVG(YTD_Aire_Flo_Sales_Percent__c),SUM(PY_YTD_Aire_Flo_Sales__c),AVG(PY_YTD_Aire_Flo_Sales_Percent__c),SUM(YTD_Aire_Flo_Sales_Change__c),SUM(YTD_Other_Sales__c),AVG(YTD_Other_Sales_Percent__c),SUM(PY_YTD_Other_Sales__c),AVG(PY_YTD_Other_Sales_Percent__c),SUM(YTD_Other_Sales_Change__c), Dealer__r.OwnerId, MAX(Last_Sales_History_Update__c) date1,Dealer__r.SAP_Sales_Group__c,Dealer__r.isISRAccount__c, Dealer__r.isTSA__c,Dealer__r.SAP_Sales_District__c  FROM Account_Planning__c WHERE   Dealer__r.SAP_Sales_Office__c  =\''+u.SAP_Sales_Office__c+'\' AND Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.OwnerId,Dealer__r.SAP_Sales_Group__c,Dealer__r.isISRAccount__c, Dealer__r.isTSA__c,Dealer__r.SAP_Sales_District__c';            
            List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
            System.debug('aggResutsAccountPlan:::::'+aggResutsAccountPlan);
            
            salesGroups = new Set<String>();
            
            List<User> tmUsers;
            if(Test.isRunningTest())
                tmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Group__c, IsActive FROM User WHERE SAP_Sales_Office__c =: u.SAP_Sales_Office__c];
            else
                tmUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_Group__c, IsActive FROM User WHERE SAP_Sales_Office__c =: u.SAP_Sales_Office__c AND (Profile.Name = 'Lennox - Res Sales TM' OR Profile.Name = 'Lennox - Res Sales TM - Lightning' OR Profile.Name = 'Lennox - Res Sales DM' OR Profile.Name = 'Lennox - Res Sales DM - Lightning') AND isActive = true AND SAP_Sales_Group__c != ''];
            
            Map<String,String> territoryToUserIdMap = new Map<String,String>();
            Map<String,String> territoryToUserNameMap = new Map<String,String>();
            
            if(tmUsers  != null && tmUsers.size() > 0)
            {
                for(User us: tmUsers)
                {
                    territoryToUserIdMap.put(us.SAP_Sales_Group__c, us.Id);
                    territoryToUserNameMap.put(us.SAP_Sales_Group__c, us.FirstName+' '+us.LastName);
                }
            }
    
            //calculate the average of all the Account Plans associated with the Dealer for present/previous years
            if(aggResutsAccountPlan.size() > 0)
            {
                tmDisplay = new List<wrapper>();
                
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
                
                wrapper houseAccounts = new wrapper();
                houseAccounts.userName = 'House Accounts';
                houseAccounts.territoryThisYearSales = 0;
                houseAccounts.territoryLastYearSales = 0;
                houseAccounts.territoryTotalThisYearSales = 0;
                houseAccounts.territoryTotalLastYearSales = 0;
                houseAccounts.houseTerritories = new Set<String>();
                
                //Find ISR and TSA Summary
                totalISRAmount = 0;
                ytdISRSales = 0;
                totalytdISRSales = 0;
                totalytdTSASales = 0;
                ytdTSASales = 0;
                ytdISRSalesPreviousYear =0;
                ytdTSASalesPreviousYear=0;
                YTDSalesNotOwnedByTM = 0;
                PYYTDSalesNotOwnedByTM = 0;
                
                
                for(AggregateResult q:aggResutsAccountPlan)
                {
                    wrapper tmRow;
                    
                   if(1==1)
                    {
                        if(q.get('SAP_Sales_Group__c') != null && territoryToUserIdMap != null && territoryToUserIdMap.keySet().contains(String.valueOf(q.get('SAP_Sales_Group__c'))))
                        {
                            tmRow = new wrapper();
                            tmRow.userTerritory = String.valueOf(q.get('SAP_Sales_Group__c'));
                            tmRow.userId = territoryToUserIdMap.get(String.valueOf(q.get('SAP_Sales_Group__c')));
                            tmRow.userName = territoryToUserNameMap.get(String.valueOf(q.get('SAP_Sales_Group__c')));
                            tmRow.territoryThisYearSales = 0;
                            tmRow.territoryLastYearSales = 0;
                            tmRow.totalytdISRSales = 0 ;
                            tmRow.totalytdTSASales = 0;
                        }
                        else
                        {
                            tmRow = houseAccounts;
                            if(q.get('SAP_Sales_Group__c') != null)
                            {
                                tmRow.userTerritory = String.valueOf(q.get('SAP_Sales_Group__c'));
                                tmRow.houseTerritories.add(String.valueOf(q.get('SAP_Sales_Group__c')));
                                
                            }
                            tmRow.userId = null;
                            tmRow.userName = 'House Accounts';
                        }
                    }
                    
                    

                    
                    previousYearTotalSales += q.get('expr2') == null ? 0 : integer.valueOf((Decimal)q.get('expr2'));
                    previousTwoYearsTotalSales += q.get('expr1') == null ? 0 : integer.valueOf((Decimal)q.get('expr1'));
                    previousThreeYearsTotalSales += q.get('expr0') == null ? 0 : integer.valueOf((Decimal)q.get('expr0'));
                    
                    presentYearSalesForecast += q.get('expr3') == null ? 0 : integer.valueOf((Decimal)q.get('expr3'));
                    ytdSales += q.get('expr4') == null ? 0 : integer.valueOf((Decimal)q.get('expr4'));
                    tmRow.territoryThisYearSales += q.get('expr4') == null ? 0 : integer.valueOf((Decimal)q.get('expr4'));
                    previuosYearsYTDSales += q.get('expr5') == null ? 0 : integer.valueOf((Decimal)q.get('expr5'));
                    tmRow.territoryLastYearSales += q.get('expr5') == null ? 0 : integer.valueOf((Decimal)q.get('expr5'));
                    
                    ytdSalesChange += q.get('expr6') == null ? 0 : integer.valueOf((Decimal)q.get('expr6'));
                    ytdResEquipment += q.get('expr7') == null ? 0 : integer.valueOf((Decimal)q.get('expr7'));
                    ytdCommercials += q.get('expr8') == null ? 0 : integer.valueOf((Decimal)q.get('expr8'));
                    ytdPartsndSupplies += q.get('expr9') == null ? 0 : integer.valueOf((Decimal)q.get('expr9'));
    
                    presetDLSC += q.get('expr10') == null ? 0 : integer.valueOf((Decimal)q.get('expr10'));
                    presetMerit += q.get('expr20') == null ? 0 : integer.valueOf((Decimal)q.get('expr20'));
                    presetElite += q.get('expr15') == null ? 0 : integer.valueOf((Decimal)q.get('expr15'));
                    presetAireFlo += q.get('expr25') == null ? 0 : integer.valueOf((Decimal)q.get('expr25'));
                    //New Enhancement 2023
                    presetOther += q.get('expr30') == null ? 0 : integer.valueOf((Decimal)q.get('expr30')) + presetAireFlo;
                    
                    previousYearDLSC += q.get('expr12') == null ? 0 : integer.valueOf((Decimal)q.get('expr12'));
                    system.debug('previousYearDLSC'+previousYearDLSC);
                    previousYearMerit += q.get('expr22') == null ? 0 : integer.valueOf((Decimal)q.get('expr22'));
                    
                    
                    previousYearElite += q.get('expr17') == null ? 0 : integer.valueOf((Decimal)q.get('expr17'));
                    previousYearAireFlo += q.get('expr27') == null ? 0 : integer.valueOf((Decimal)q.get('expr27'));
                    //New Enhancement 2023
                    previousYearOther += q.get('expr32') == null ? 0 : integer.valueOf((Decimal)q.get('expr32')) + previousYearAireFlo;
    
                    changeDLSC += q.get('expr14') == null ? 0 : integer.valueOf((Decimal)q.get('expr14'));
                    
                    //changeMerit += q.get('expr18') == null ? 0 : integer.valueOf((Decimal)q.get('expr18')); 
                   
                    
                         changeMerit=presetMerit-previousYearMerit;
                      

                    
                    
                    changeElite += q.get('expr19') == null ? 0 : integer.valueOf((Decimal)q.get('expr19'));
                    changeAireFlo += q.get('expr29') == null ? 0 : integer.valueOf((Decimal)q.get('expr29'));
                     //New Enhancement 2023
                    changeOther += q.get('expr34') == null ? 0 : integer.valueOf((Decimal)q.get('expr34'))+changeAireFlo;

                    if(tmRow != null && tmRow.userName != 'House Accounts')
                    {
                        if(tmDisplay == null || tmDisplay.size() == 0)
                               tmDisplay.add(tmRow);
                        else
                        {
                            for(Integer i = 0; i < tmDisplay.size(); i++)
                            {
                                if((tmRow.territoryThisYearSales - tmRow.territoryLastYearSales) > (tmDisplay[i].territoryThisYearSales - tmDisplay[i].territoryLastYearSales))
                                {
                                    tmDisplay.add(i,tmRow);
                                    i = tmDisplay.size();
                                }
                                else
                                    if((i+1) == tmDisplay.size())
                                {
                                    tmDisplay.add(tmRow); 
                                    i = tmDisplay.size();
                                }
                            }
                        }   
                    }
                    else
                        houseAccounts = tmRow;
    
                    if(lastSalesHistoryUpdate == null)
                        lastSalesHistoryUpdate = date.valueOf((Date)q.get('date1'));
                    else if(lastSalesHistoryUpdate < date.valueOf((Date)q.get('date1'))) lastSalesHistoryUpdate = date.valueOf((Date)q.get('date1'));
    
               
                    // System.debug('lastSalesHistoryUpdate:::::'+lastSalesHistoryUpdate);
                if(q.get('isISRAccount__c') == true){
                    
                     ytdISRSales += q.get('expr4') == null ? 0 : integer.valueOf((Decimal)q.get('expr4'));
                      ytdISRSalesPreviousYear  += q.get('expr5') == null ? 0 : integer.valueOf((Decimal)q.get('expr5'));        
                }
                    if(q.get('isTSA__c') == true) {
                         ytdTSASales += q.get('expr4') == null ? 0 : integer.valueOf((Decimal)q.get('expr4'));
                        ytdTSASalesPreviousYear += q.get('expr5') == null ? 0 : integer.valueOf((Decimal)q.get('expr5'));    
             
                    }
                    
                    
                }

                //if((houseAccounts.territoryThisYearSales != null && houseAccounts.territoryThisYearSales > 0) || (houseAccounts.territoryLastYearSales != null && houseAccounts.territoryLastYearSales > 0))
                    tmDisplay.add(houseAccounts);
                
               

            }
            
            // createDealerLists();
        }
        catch(Exception e)
        {
        System.debug('Exception:::'+e.getLineNumber()

);
        }

        
        if(tmDisplay != null && tmDisplay.size() >0)
        {
        /*
            for(wrapper w: tmDisplay)
            {
                for(User u: tmUsers)
                {
                    if(u.SAP_Sales_Group__c == w.userTerritory)
                    {
                        w.userId = u.Id;
                        w.userName = u.FirstName + ' ' + u.LastName;
                    }
                }
                    w.territoryTotalThisYearSales = ytdSales;
                    w.territoryTotalLastYearSales = previousYearTotalSales;
                if(w.userId == null)
                {
                    houseAccounts.territoryTotalThisYearSales = ytdSales;
                    houseAccounts.territoryTotalLastYearSales = previousYearTotalSales;
                    houseAccounts.territoryThisYearSales += w.territoryThisYearSales;
                    houseAccounts.territoryLastYearSales += w.territoryLastYearSales;
                    houseAccounts.territoryTotalThisYearSales += w.territoryTotalThisYearSales;
                    houseAccounts.territoryTotalLastYearSales += w.territoryTotalLastYearSales; 
                }
            }
        
            integer j = 0;
            while(j < tmDisplay.size())
            {
                if(tmDisplay.get(j).userId == null)
                    tmDisplay.remove(j);
                else
                    j++;
            }
            
            tmDisplay = sortTMDisplay(tmDisplay);
            
            tmDisplay.add(houseAccounts); 
            
            System.debug('tmDisplay ='+tmDisplay);
            */
            system.debug('!!BOOM'+tmDisplay);
            try{
        
                SetAccountOpportunities();
                
                SetAccountRetentions();
                
                SetAccountPlans();
            }
            catch(Exception e)
            {
                
                
                System.debug(e.getCause());
                System.debug(e.getMessage());
                System.debug('Line Number: '+e.getLineNumber());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'WARNING: There was an exception on Line Number: '+e.getLineNumber()+'. Exception Description: '+e.getMessage()));
            }
        }//if(tmDisplay != null && tmDisplay.size() >0)
    }//districtManagerAggregate()
    
    
    public void SetAccountOpportunities()
    {
        List<AggregateResult> aggResultsAccountOpportunities = [SELECT 
                                                COUNT(Id) numOpp, 
                                                SUM(Adjusted_Value__c) adjValue,
                                                SUM(Expected_Value__c) expValue, 
                                                Opportunity_Status__c status,
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c territory
                                           FROM Account_Opportunty__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c =: u.SAP_Sales_Office__c AND
                                               (Opportunity_Status__c = 'In Progress' OR Opportunity_Status__c = 'Completed' OR Opportunity_Status__c = 'Not Started' OR Opportunity_Status__c = 'Cancelled' OR Opportunity_Status__c = 'On Hold') 
                                           GROUP BY Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c
                                           ];
                                                               
            //System.debug('aggResultsAccountOpportunities :::::'+aggResultsAccountOpportunities );
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
                wrapper houseAccountsInProgress;
                wrapper houseAccountsCompleted;
                wrapper houseAccountsCancelled;
                wrapper houseAccountsNotStarted;
                wrapper houseAccountsOnHold;
                
                for(aggregateResult ag: aggResultsAccountOpportunities)
                {
                    totalOppAmount +=  ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue')); 
                    for(wrapper ow: tmDisplay)
                    {
                        System.debug('Checking ag:: '+ag);
                        System.debug('tmDisplay:: '+ow);
                        if(ow.userTerritory == (String)ag.get('territory') || (ow.houseTerritories != null && ow.houseTerritories.contains((String)ag.get('territory'))))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressOpp += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppInProgressAdjValue += ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppInProgressExpValue += ag.get('expValue') == null ? 0 : Integer.valueOF((Decimal)ag.get('expValue'));
                               displayInProgressAccOpty = true;
                               progressAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               progressAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accOppProgCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               // Sorting by Exp Value Descending
                               if(ow.userName != 'House Accounts')
                               {
                                   if(accountOppInProgress == null || accountOppInProgress.size() == 0)
                                       accountOppInProgress.add(ow);
                                   else
                                   {
                                       for(Integer i = 0; i < accountOppInProgress.size(); i++)
                                       {
                                           if(ow.oppInProgressAdjValue >= accountOppInProgress[i].oppInProgressAdjValue)
                                           {
                                               if(ow.userName != 'House Accounts')
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
                               else
                               {
                                   houseAccountsInProgress = ow;
                               }
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedOpp += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCompletedAdjValue += ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCompletedExpValue += ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCompletedAccOpty = true;
                               completedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               completedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCompletedCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(ow.userName != 'House Accounts')
                               {
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
                               else
                               {
                                   houseAccountsCompleted = ow;
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedOpp += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppNotStartedAdjValue += ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppNotStartedExpValue += ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayNotStartedAccOpty = true;
                               notStartedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               notStartedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppNotStartedCount +=  ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(ow.userName != 'House Accounts')
                               {
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
                               }
                               else
                               {
                                  houseAccountsNotStarted = ow;
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledOpp += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCancelledAdjValue += ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCancelledExpValue += ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCancelledAccOpty = true;
                               cancelledAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               cancelledAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCancelledCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(ow.userName != 'House Accounts')
                               {
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
                               else
                               {
                                  houseAccountsCancelled = ow;
                               }
                           }
                           if((String)ag.get('status') == 'On Hold')
                           {
                               ow.numOnHoldOpp += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppOnHoldAdjValue += ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppOnHoldExpValue += ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayHoldAccOpty = true;
                               holdAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               holdAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppHoldCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(ow.userName != 'House Accounts')
                               {
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
                               else
                               {
                                   houseAccountsCancelled = ow;
                               }
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
                    
                if(houseAccountsInProgress != null) accountOppInProgress.add(houseAccountsInProgress);
                if(houseAccountsCompleted != null) accountOppCompleted.add(houseAccountsCompleted);
                if(houseAccountsNotStarted != null) accountOppNotStarted.add(houseAccountsNotStarted);
                if(houseAccountsOnHold != null) accountOppOnHold.add(houseAccountsOnHold);
                if(houseAccountsCancelled != null) accountOppCancelled.add(houseAccountsCancelled);
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
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c territory
                                           FROM Retention_Opportunity__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Office__c =: u.SAP_Sales_Office__c AND
                                               (Retention_Opportunity_Status__c = 'In Progress' OR Retention_Opportunity_Status__c = 'Completed' OR Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'Cancelled') 
                                           GROUP BY Retention_Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_Group__c
                                           ];
                                                               
           // System.debug('aggResultsAccountRetentions :::::'+aggResultsAccountRetentions );
            if(aggResultsAccountRetentions != null && aggResultsAccountRetentions.size() > 0)
            {
                accountRetInProgress = new List<wrapper>();
                accountRetCompleted = new List<wrapper>();
                accountRetNotStarted = new List<wrapper>();
                accountRetCancelled = new List<wrapper>();
                
                wrapper houseAccountsInProgress;
                wrapper houseAccountsCompleted;
                wrapper houseAccountsNotStarted;
                wrapper houseAccountsCancelled;
                
                for(aggregateResult ag: aggResultsAccountRetentions)
                {
                     
                    for(wrapper ow: tmDisplay)
                    {
                        if(ow.userTerritory == (String)ag.get('territory') || (ow.houseTerritories != null && ow.houseTerritories.contains((String)ag.get('territory'))))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressRet += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retInProgressCRIPoints += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppProgress = true;
                               progressRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppProgCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsInProgress = ow;
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedRet += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCompletedCRIPoints += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCompleted = true;
                               completedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCompletedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsCompleted = ow;
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedRet += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retNotStartedCRIPoints += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppNotStarted = true;
                               notStartedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppNotStartedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsNotStarted = ow;
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               
                               ow.numCancelledRet += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCancelledCRIPoints += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCancelled = true;
                               cancelledRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCancelledCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsCancelled = ow;
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
                
                if(houseAccountsInProgress != null) accountRetInProgress.add(houseAccountsInProgress);
                if(houseAccountsCompleted != null) accountRetCompleted.add(houseAccountsCompleted);
                if(houseAccountsNotStarted != null) accountRetNotStarted.add(houseAccountsNotStarted);
                if(houseAccountsCancelled != null) accountRetCancelled.add(houseAccountsCancelled);
                
            }//if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)

    }//SetAccountRetentions()
    
    public void SetAccountPlans()
    {
        List<AggregateResult> aggResultsAccountPlans = [SELECT 
                                                COUNT(Id) numAP, 
                                                Action_Status__c status,
                                                Account_Plan__r.Dealer__r.SAP_Sales_Group__c territory
                                           FROM Action_Plan__c 
                                           WHERE
                                               Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               Account_Plan__r.Dealer__r.SAP_Sales_Office__c =: u.SAP_Sales_Office__c AND
                                               (Action_Status__c = 'In Progress' OR Action_Status__c = 'Completed' OR Action_Status__c = 'Not Started' OR Action_Status__c = 'Cancelled') 
                                           GROUP BY Action_Status__c, Account_Plan__r.Dealer__r.SAP_Sales_Group__c
                                           ];
                                                               
            System.debug('aggResultsAccountPlans :::::'+JSON.serialize(aggResultsAccountPlans) );
            if(aggResultsAccountPlans != null && aggResultsAccountPlans.size() > 0)
            {
                accPlanInProgress = new List<wrapper>();
                accPlanCompleted = new List<wrapper>();
                accPlanNotStarted = new List<wrapper>();
                accPlanCancelled = new List<wrapper>();
                
                wrapper houseAccountsInProgress;
                wrapper houseAccountsCompleted;
                wrapper houseAccountsNotStarted;
                wrapper houseAccountsCancelled;
                
                for(aggregateResult ag: aggResultsAccountPlans )
                {
                    if((String)ag.get('status') == 'In Progress')
                    { 
                        System.debug('Status==  Ag : : ' + ag);
                    }
                    for(wrapper ow: tmDisplay)
                    {
                        
                        if(ow.userTerritory == (String)ag.get('territory') || (ow.houseTerritories != null && ow.houseTerritories.contains((String)ag.get('territory'))))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               //System.debug('::NewAccPlanInProgress:: '+ag);
                               System.debug('::Matching TM Display:: '+ow);
                               ow.numInProgressAccPlan += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanProgress = true;
                               actPlanProgCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               //System.debug('::actPlanProgCount = '+actPlanProgCount);
                               //System.debug('::numInProgressAccPlan = '+ow.numInProgressAccPlan);
                               if(ow.userName != 'House Accounts')
                                   if(accPlanInProgress == null || accPlanInProgress.size() == 0)
                                       accPlanInProgress.add(ow);
                                   else
                                   {
                                       for(Integer i = 0; i < accPlanInProgress.size(); i++)
                                       {
                                          
                                           if(ow.numInProgressAccPlan >= accPlanInProgress[i].numInProgressAccPlan)
                                           {
                                               System.debug('InIf ');
                                               accPlanInProgress.add(i,ow);
                                               i = accPlanInProgress.size();
                                           }
                                           else if((i+1) == accPlanInProgress.size())
                                             //  if((i+1) == accountOppInProgress.size())
                                               {
                                                   System.debug('In else If ');
                                                  accPlanInProgress.add(ow); 
                                                  i = accPlanInProgress.size();
                                               }
                                       }
                                   }
                               
                               if(ow.userName == 'House Accounts' || ow.userName == null)
                                   if(houseAccountsInProgress == null)
                                        houseAccountsInProgress = ow;
                                   else
                                       houseAccountsInProgress.numInProgressAccPlan += ow.numInProgressAccPlan;
                               
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedAccPlan += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCompleted = true;
                               actPlanCompletedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsCompleted = ow;
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedAccPlan += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanNotStarted = true;
                               actPlanNotStartedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(ow.userName != 'House Accounts')
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
                               
                               if(ow.userName == 'House Accounts')
                                   houseAccountsNotStarted = ow;
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledAccPlan += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCancelled = true;
                               actPlanCancelledCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(ow.userName == 'House Accounts')
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
                               if(ow.userName == 'House Accounts')
                                houseAccountsCancelled = ow;
                           }
                        }//if(ow.userTerritory == (String)ag.get('territory'))
                    }//for(wrapper ow: tmDisplay)
                }//for(aggregateResult ag: aggResultsAccountOpportunities)
                
                if(houseAccountsInProgress != null) accPlanInProgress.add(houseAccountsInProgress);
                if(houseAccountsCompleted != null) accPlanCompleted.add(houseAccountsCompleted);
                if(houseAccountsCancelled != null) accPlanCancelled.add(houseAccountsCancelled);
                if(houseAccountsNotStarted != null) accPlanNotStarted.add(houseAccountsNotStarted);
            }//if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)
        System.debug('accPlanInProgress -- ' +JSON.serialize(accPlanInProgress) );
    
        
    
    }//SetAccountRetentions()
    
    //Wrapper Class
    public class wrapper
    {
        public string userId{get;set;}
        public string userName{get;set;}
        public string userTerritory{get;set;}
        public Set<String> houseTerritories{get; set;}
        public integer territoryThisYearSales{get;set;}
        public integer territoryLastYearSales{get;set;}
        public integer territoryTotalThisYearSales{get; set;}
        public integer territoryTotalLastYearSales{get; set;}
         public integer totalISRAmount{get;set;}
         public integer totalytdISRSales{get;set;}
         public integer totalytdTSASales{get;set;}
        
        public Decimal percThisYear{
            get 
            {
                if(territoryTotalThisYearSales != null && territoryThisYearSales != null && territoryTotalThisYearSales > 0)
                    return (territoryThisYearSales / territoryTotalThisYearSales) * 100.00;
                else
                    return 0;
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
        
            public wrapper()
            {
                numCompletedOpp = 0;
                oppCompletedAdjValue = 0;
                oppCompletedExpValue = 0;
                numInProgressOpp = 0;
                oppInProgressAdjValue = 0; 
                oppInProgressExpValue = 0;
                numNotStartedOpp = 0;
                oppNotStartedAdjValue = 0;
                oppNotStartedExpValue = 0;
                numCancelledOpp = 0;
                oppCancelledAdjValue = 0;
                oppCancelledExpValue = 0;
                numOnHoldOpp = 0;
                oppOnHoldAdjValue = 0;
                oppOnHoldExpValue = 0;
                
                numCompletedRet = 0;
                retCompletedCRIPoints = 0;
                numInProgressRet = 0;
                retInProgressCRIPoints = 0;
                numNotStartedRet = 0;
                retNotStartedCRIPoints = 0;
                numCancelledRet = 0;
                retCancelledCRIPoints = 0;
                numOnHoldRet = 0;
                retOnHoldCRIPoints = 0;
                
                numCompletedAccPlan = 0;
                numInProgressAccPlan = 0;
                numNotStartedAccPlan = 0;
                numCancelledAccPlan = 0;
                   
            }
    }
        
}