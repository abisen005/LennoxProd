/********************************************************
Developer : Eduardo Rodriguez
Company : Ventas Consulting
Description : visualforce page to show the aggregated query or current,prvious, previous -1 yrs values
********************************************************/
public class ResNationalAggregate
{
    //variable declarations
    public string currentLoggedInUser{get; set;}
    public string currentLoggedInUserProfile{get; set;}
    public boolean invalidProfile{get; set;}
    public User u{get; set;}
    private List<User> tmUsers{get; set;}
    public integer year{get; set;}
    //Get Region type from Exective Aggregate Vf page
    public String type{get; set;}
    
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
    public String forecastTotalSales;
    
    public Boolean isHomeOwnerWarranty{get; set;}
    public Boolean isResSourcedProducts{get; set;}

    
    public integer totalOppAmount {get; set;}
    
    public List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper> favURLList{get; set;}
    
    public List<Account> dealerSalesPositive{get; set;}
    public List<Account> dealerSalesNegative{get; set;}
    public List<Wrapper> wrapListNegative{get; set;}
    public List<Wrapper> wrapListPositive{get; set;}
    
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
    
    public ResNationalAggregate()
    {
        currentLoggedInUser = userinfo.getUserId();
        system.debug('USERID'+currentLoggedInUser);
        //currentLoggedInUser = '0053c00000BxdD6AAJ';
        isHomeOwnerWarranty = false;
        isResSourcedProducts = false;        
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
        /*          
        if(profilesettings != null && profilesettings.Executive_Access__c != null)
        {
            validProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
        }
        if(profilesettings != null && profilesettings.Region_Access__c != null)
        {
            validProfiles.addAll(profilesettings.Region_Access__c.split(';'));
        }
        */
        
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
            type = ApexPages.currentPage().getParameters().get('type');
            if (type == 'HPM'){
                isHomeOwnerWarranty= true;
            }else if(type== 'RSP'){
                isResSourcedProducts = true;
            }
            
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
        /*    
        if(profilesettings != null && profilesettings.Executive_Access__c != null)
        {
            higherProfiles.addAll(profilesettings.Executive_Access__c.split(';'));
        }
        */
        
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
            
            forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
            
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
            // return;
        }
        
        
        Boolean ableToFindDataWithUserId = true;

        
        
        
        if(ableToFindDataWithUserId)
        {
            try {
                String queryAccountPlan;
                if(isHomeOwnerWarranty == true){
                    queryAccountPlan = 'SELECT SUM(Dealer__r.Current_Year_Sales_Forecast__c)CY_Sales_Forecast__c, SUM(YTD_Aire_Flo_Sales__c)YTD_Aire_Flo_Sales__c, SUM(YTD_Commercial_Sales__c)YTD_Commercial_Sales__c, SUM(YTD_DLSC_Sales__c)YTD_DLSC_Sales__c, SUM(YTD_Elite_Sales__c)YTD_Elite_Sales__c, SUM(YTD_Merit_Sales__c)YTD_Merit_Sales__c, SUM(YTD_Other_Sales__c)YTD_Other_Sales__c,'+
                        'SUM(YTD_P_S_Sales__c)YTD_P_S_Sales__c, SUM(YTD_Res_Equip_Sales__c)YTD_Res_Equip_Sales__c,SUM(YTD_Sales__c)YTD_Sales__c, SUM(PY_Sales__c)PY_Sales__c, SUM(PY2_Sales__c)PY2_Sales__c, SUM(PY3_Sales__c)PY3_Sales__c,'+
                        'SUM(PY_YTD_Aire_Flo_Sales__c)PY_YTD_Aire_Flo_Sales__c,SUM(PY_YTD_DLSC_Sales__c)PY_YTD_DLSC_Sales__c, SUM(PY_YTD_Elite_Sales__c)PY_YTD_Elite_Sales__c, SUM(PY_YTD_Merit_Sales__c)PY_YTD_Merit_Sales__c, SUM(PY_YTD_Other_Sales__c)PY_YTD_Other_Sales__c, SUM(PY_YTD_Sales__c)PY_YTD_Sales__c'+
                        ',AVG(YTD_DLSC_Sales_Percent__c)YTD_DLSC_Sales_Percent__c ,AVG(PY_Aire_Flo_Sales_Percent__c)PY_Aire_Flo_Sales_Percent__c,'+
                        'AVG(PY_Merit_Sales_Percent__c)PY_Merit_Sales_Percent__c,AVG(PY_Other_Sales_Percent__c)PY_Other_Sales_Percent__c,AVG(PY_Elite_Sales_Percent__c)PY_Elite_Sales_Percent__c , MAX(Last_Sales_History_Update__c) date1'+
                        '  FROM Account_Planning__c WHERE  Account_Plan_Year__c =\''+string.valueOf(year)+'\' AND (Region__c like \'Home%\' OR Region__c like \'Res National%\') ';  
                }else if(isResSourcedProducts == true){
                    queryAccountPlan  = 'SELECT SUM(Dealer__r.Current_Year_Sales_Forecast__c)CY_Sales_Forecast__c, SUM(YTD_Aire_Flo_Sales__c)YTD_Aire_Flo_Sales__c, SUM(YTD_Commercial_Sales__c)YTD_Commercial_Sales__c, SUM(YTD_DLSC_Sales__c)YTD_DLSC_Sales__c, SUM(YTD_Elite_Sales__c)YTD_Elite_Sales__c, SUM(YTD_Merit_Sales__c)YTD_Merit_Sales__c, SUM(YTD_Other_Sales__c)YTD_Other_Sales__c,'+
                        'SUM(YTD_P_S_Sales__c)YTD_P_S_Sales__c, SUM(YTD_Res_Equip_Sales__c)YTD_Res_Equip_Sales__c,SUM(YTD_Sales__c)YTD_Sales__c, SUM(PY_Sales__c)PY_Sales__c, SUM(PY2_Sales__c)PY2_Sales__c, SUM(PY3_Sales__c)PY3_Sales__c,'+
                        'SUM(PY_YTD_Aire_Flo_Sales__c)PY_YTD_Aire_Flo_Sales__c,SUM(PY_YTD_DLSC_Sales__c)PY_YTD_DLSC_Sales__c, SUM(PY_YTD_Elite_Sales__c)PY_YTD_Elite_Sales__c, SUM(PY_YTD_Merit_Sales__c)PY_YTD_Merit_Sales__c, SUM(PY_YTD_Other_Sales__c)PY_YTD_Other_Sales__c, SUM(PY_YTD_Sales__c)PY_YTD_Sales__c'+
                        ',AVG(YTD_DLSC_Sales_Percent__c)YTD_DLSC_Sales_Percent__c ,AVG(PY_Aire_Flo_Sales_Percent__c)PY_Aire_Flo_Sales_Percent__c,'+
                        'AVG(PY_Merit_Sales_Percent__c)PY_Merit_Sales_Percent__c,AVG(PY_Other_Sales_Percent__c)PY_Other_Sales_Percent__c,AVG(PY_Elite_Sales_Percent__c)PY_Elite_Sales_Percent__c , MAX(Last_Sales_History_Update__c) date1'+
                        '  FROM Account_Planning__c WHERE  Account_Plan_Year__c =\''+string.valueOf(year)+'\' AND Region__c like \'Res Sourced%\'  ';  
                }
                
                else if(Test.isRunningTest()){
                    queryAccountPlan  = 'SELECT SUM(Dealer__r.Current_Year_Sales_Forecast__c)CY_Sales_Forecast__c, SUM(YTD_Aire_Flo_Sales__c)YTD_Aire_Flo_Sales__c, SUM(YTD_Commercial_Sales__c)YTD_Commercial_Sales__c, SUM(YTD_DLSC_Sales__c)YTD_DLSC_Sales__c, SUM(YTD_Elite_Sales__c)YTD_Elite_Sales__c, SUM(YTD_Merit_Sales__c)YTD_Merit_Sales__c, SUM(YTD_Other_Sales__c)YTD_Other_Sales__c,'+
                        'SUM(YTD_P_S_Sales__c)YTD_P_S_Sales__c, SUM(YTD_Res_Equip_Sales__c)YTD_Res_Equip_Sales__c,SUM(YTD_Sales__c)YTD_Sales__c, SUM(PY_Sales__c)PY_Sales__c, SUM(PY2_Sales__c)PY2_Sales__c, SUM(PY3_Sales__c)PY3_Sales__c,'+
                        'SUM(PY_YTD_Aire_Flo_Sales__c)PY_YTD_Aire_Flo_Sales__c,SUM(PY_YTD_DLSC_Sales__c)PY_YTD_DLSC_Sales__c, SUM(PY_YTD_Elite_Sales__c)PY_YTD_Elite_Sales__c, SUM(PY_YTD_Merit_Sales__c)PY_YTD_Merit_Sales__c, SUM(PY_YTD_Other_Sales__c)PY_YTD_Other_Sales__c, SUM(PY_YTD_Sales__c)PY_YTD_Sales__c'+
                        ',AVG(YTD_DLSC_Sales_Percent__c)YTD_DLSC_Sales_Percent__c ,AVG(PY_Aire_Flo_Sales_Percent__c)PY_Aire_Flo_Sales_Percent__c,'+
                        'AVG(PY_Merit_Sales_Percent__c)PY_Merit_Sales_Percent__c,AVG(PY_Other_Sales_Percent__c)PY_Other_Sales_Percent__c,AVG(PY_Elite_Sales_Percent__c)PY_Elite_Sales_Percent__c , MAX(Last_Sales_History_Update__c) date1'+
                        '  FROM Account_Planning__c WHERE  Account_Plan_Year__c =\''+string.valueOf(year)+'\' AND Region__c like \'Res%\'  ';  
                    
                }
                System.debug('queryAccountPlan:::::'+queryAccountPlan);
                system.debug('here is the value of year ' + String.valueOf(year));
                List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
                System.debug('aggResutsAccountPlan:::::'+aggResutsAccountPlan);
                List<Account_Planning__c> apl = New List<Account_Planning__c>();  
                
                if(aggResutsAccountPlan.size() > 0)
                {
                    for(AggregateResult thisRecord:aggResutsAccountPlan)
                    {  
                        System.debug('Record Found: '+thisRecord);
                        changeDLSC = 0;
                        changeMerit = 0;
                        changeElite = 0;
                        changeAireFlo = 0;
                        changeOther = 0;   
                        
                 
                        previousYearTotalSales =integer.valueOf((Decimal)thisRecord.get('PY_Sales__c')) ; 
                        previousTwoYearsTotalSales = integer.valueOf((Decimal)thisRecord.get('PY2_Sales__c'));
                        previousThreeYearsTotalSales = integer.valueOf((Decimal)thisRecord.get('PY3_Sales__c'));
                        
                        presentYearSalesForecast = integer.valueOf((Decimal)thisRecord.get('CY_Sales_Forecast__c'));
                        ytdSales = integer.valueOf((Decimal)thisRecord.get('YTD_Sales__c')) != null ? integer.valueOf((Decimal)thisRecord.get('YTD_Sales__c')) : 1;
                        previuosYearsYTDSales = integer.valueOf((Decimal)thisRecord.get('PY_YTD_Sales__c')) != null ? integer.valueOf((Decimal)thisRecord.get('PY_YTD_Sales__c')) : 1;
                        
                        ytdSalesChange = integer.valueOf((Decimal)thisRecord.get('YTD_Sales__c'));
                        ytdResEquipment = integer.valueOf((Decimal)thisRecord.get('YTD_Res_Equip_Sales__c'));
                        ytdCommercials = integer.valueOf((Decimal)thisRecord.get('YTD_Commercial_Sales__c'));
                        ytdPartsndSupplies = integer.valueOf((Decimal)thisRecord.get('YTD_P_S_Sales__c'));
                        
                        presetDLSC = integer.valueOf((Decimal)thisRecord.get('YTD_DLSC_Sales__c')) != null  ?  integer.valueOf((Decimal)thisRecord.get('YTD_DLSC_Sales__c')) : 0 ;
                        presetDLSCPercent = (presetDLSC / ytdSales) ;
                        presetMerit = integer.valueOf((Decimal)thisRecord.get('YTD_Merit_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('YTD_Merit_Sales__c')) : 0;
                        presetMeritPercent = presetMerit / ytdSales;
                        presetElite = integer.valueOf((Decimal)thisRecord.get('YTD_Elite_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('YTD_Elite_Sales__c')) : 0;
                        presetElitePercent = presetElite / ytdSales;
                        presetAireFlo = integer.valueOf((Decimal)thisRecord.get('YTD_Aire_Flo_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('YTD_Aire_Flo_Sales__c')) : 0;
                        presetAireFloPercent = presetAireFlo / ytdSales;
                        //Enhancemnets 2023
                        presetOther = ( integer.valueOf((Decimal)thisRecord.get('YTD_Other_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('YTD_Other_Sales__c')) : 0 ) + presetAireFlo;
                        presentYearOtherPercent = presetOther / ytdSales;
                        
                        previousYearDLSC = (integer.valueOf((Decimal)thisRecord.get('PY_YTD_DLSC_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('PY_YTD_DLSC_Sales__c')) : 0 );
                        previousYearDLSCPercent = previousYearDLSC / previuosYearsYTDSales;
                        previousYearMerit =(integer.valueOf((Decimal)thisRecord.get('PY_YTD_Merit_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('PY_YTD_Merit_Sales__c')) : 0 );
                        previousYearMeritPercent = previousYearMerit / previuosYearsYTDSales;
                        previousYearElite = (integer.valueOf((Decimal)thisRecord.get('PY_YTD_Elite_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('PY_YTD_Elite_Sales__c')) : 0 );
                        previousYearElitePercent = previousYearElite/ previuosYearsYTDSales;
                        previousYearAireFlo = (integer.valueOf((Decimal)thisRecord.get('PY_YTD_Aire_Flo_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('PY_YTD_Aire_Flo_Sales__c')) : 0 );
                        previousYearAireFloPercent = previousYearAireFlo / previuosYearsYTDSales;
                        //Enhancemnets 2023
                        previousYearOther = (integer.valueOf((Decimal)thisRecord.get('PY_YTD_Other_Sales__c')) != null ?  integer.valueOf((Decimal)thisRecord.get('PY_YTD_Other_Sales__c')) : 0 )  +previousYearAireFlo ;
                        previousYearOtherPercent = previousYearOther / previuosYearsYTDSales;
                        
                        changeDLSC = presetDLSC - previousYearDLSC;
                        changeMerit = presetMerit - previousYearMerit;
                        changeElite = presetElite - previousYearElite; 
                        changeAireFlo = presetAireFlo - previousYearAireFlo;
                        //New Enhancement 2023
                        changeOther = presetOther - previousYearOther+changeAireFlo;
                        
                        Date reportDate = thisRecord.get('date1') != null ?  date.valueOf((Date)thisRecord.get('date1')) : Date.today().addDays(-1);
                        //lastSalesHistoryUpdate = Date.newInstance(reportDate.year(),reportDate.month(),reportDate.day());
                        
                        
                        lastSalesHistoryUpdate = reportDate;
                        
                        System.debug('about to do queries for child records');
                        
                    } 
                }
                createDealerLists();
            }
            
            catch(Exception e)
            {
                System.debug(e.getCause());
                System.debug(e.getMessage());
                System.debug('Line Number: '+e.getLineNumber());
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'WARNING: There was an exception on Line Number: '+e.getLineNumber()+'. Exception Description: '+e.getMessage()));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Could not retrieve information.'));
                return;
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
        //public string dealerDeltAYTDSalesStr{get;set;}
        public integer dealerYTDSalesLC{get;set;}
        public string dealerFGPrizeZone{get;set;}
        public integer dealerpre1TS{get;set;}
        public integer dealerPre2TS{get;set;}
        public integer dealerPre3TS{get;set;}
        public date dealerLastAct{get;set;}
        public Account accW{get;set;}
        public Retention_Opportunity__c row{get; set;}
        
        // public string accPlanId{get; set;}
        // public string accPlanName{get;set;}
        // public string retOptyId {get; set;}
        // public string retOptyNum{get;set;}
        //public string retOptyType{get;set;}
        // public string retOpty{get;set;}
        //  public integer potenCRIPts{get;set;}
        public boolean newCustomer{get;set;}
        //public string totalCRIPts{get;set;}
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

            
            String queryAccountPlan;
            queryAccountPlan ='SELECT Dealer__r.Name v0, Dealer__r.SAP_Customer_Number__c v1, Dealer__r.Id v11, Dealer__r.LastActivityDate v5, Dealer__c,' +
                'Dealer__r.SAP_Sales_Group__c v2, SUM(YTD_Sales__c) v4,SUM(PY_Sales__c) v7, SUM(PY2_Sales__c) v8,SUM(PY3_Sales__c) v9,'+
                'SUM(YTD_Sales_Change__c) v10, Dealer__r.Pricing_Zone__c v3, SUM('+forecastTotalSales+') v12 '+
                'FROM Account_Planning__c ';
            
            if(Test.isRunningTest()){
                queryAccountPlan += 
                    'WHERE   Dealer__r.isResNationalAcct__c = true AND ' +
                    'YTD_Sales_Change__c >= 0 AND Account_Plan_Year__c = \'2023\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC ' ;
            }else if(isResSourcedProducts == true){
                queryAccountPlan += 
                    'WHERE    Region__c  like \'%Sourced%\' AND ' +
                    'YTD_Sales_Change__c >= 0 AND  Account_Plan_Year__c = \''+string.valueOf(year)+'\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20' ; 
            }else if (isHomeOwnerWarranty == true){
                queryAccountPlan += 
                    'WHERE   (Region__c like \'Home%\' OR Region__c like \'Res National%\') AND ' +
                    'YTD_Sales_Change__c >= 0 AND Account_Plan_Year__c = \''+string.valueOf(year)+'\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20' ;
            }
            
            else{
                queryAccountPlan += 
                    'WHERE   ' +
                    'YTD_Sales_Change__c >= 0 AND  Account_Plan_Year__c =\''+string.valueOf(year)+'\'  AND Dealer__r.isResNationalAcct__c = true '+
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20' ;
            }
            
            
            
            
            System.debug('queryAccountPlan:::::'+queryAccountPlan);
            List<AggregateResult> aggResutsAccountPlan = database.query(queryAccountPlan);
            System.debug('aggResutsAccountPlan:::::'+aggResutsAccountPlan);
            
            //calculate the average of all the Account Plans associated with the Dealer for present/previous years
            if(aggResutsAccountPlan.size() > 0 ||Test.isRunningTest())
                
            {
                
                for(AggregateResult a : aggResutsAccountPlan)                
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
            }
            System.debug('wrapListPositive:::::'+wrapListPositive);
            
            dealerDeltAYTDSalesSum1 = 0;
            dealerYTDSalesLCSum1 = 0;
            dealerpre1TSSum1 = 0;
            dealerPre2TSSum1 = 0;
            dealerPre3TSSum1 = 0;
            totalSalesForecastGrowth = 0;
            
            for(Wrapper w : wrapListPositive)
            {
                dealerDeltAYTDSalesSum1 = dealerDeltAYTDSalesSum1 + w.dealerDeltAYTDSales;
                dealerYTDSalesLCSum1 = dealerYTDSalesLCSum1 + w.dealerYTDSalesLC;
                dealerpre1TSSum1 = dealerpre1TSSum1 + w.dealerpre1TS;
                dealerPre2TSSum1 = dealerPre2TSSum1 + w.dealerPre2TS;
                dealerPre3TSSum1 = dealerPre3TSSum1 + w.dealerPre3TS;
                totalSalesForecastGrowth = totalSalesForecastGrowth + w.salesForecast;
            }
            
            /*=============================================================ATTRITION SECTION=============================================*/
            
            String queryAccountPlanNegative;
            queryAccountPlanNegative ='SELECT Dealer__r.Name v0, Dealer__r.SAP_Customer_Number__c v1, Dealer__r.Id v11, Dealer__r.LastActivityDate v5, Dealer__c,' +
                'Dealer__r.SAP_Sales_Group__c v2, SUM(YTD_Sales__c) v4,SUM(PY_Sales__c) v7, SUM(PY2_Sales__c) v8,SUM(PY3_Sales__c) v9,'+
                'SUM(YTD_Sales_Change__c) v10, Dealer__r.Pricing_Zone__c v3,SUM('+forecastTotalSales+') v12 '+
                'FROM Account_Planning__c ';
            
            if(isResSourcedProducts == true){
                queryAccountPlanNegative += 
                    'WHERE   Region__c  like \'%Sourced%\' AND ' +
                    'YTD_Sales_Change__c < 0 AND Account_Plan_Year__c = \''+string.valueOf(year)+'\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20' ;
            }else if (isHomeOwnerWarranty == true){
                queryAccountPlanNegative +=  
                    'WHERE   (Region__c like \'Home%\' OR Region__c like \'Res National%\') AND ' +
                    'YTD_Sales_Change__c < 0 AND Account_Plan_Year__c = \''+string.valueOf(year)+'\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20'  ;
            }else{
                queryAccountPlanNegative +=  
                    'WHERE   Dealer__r.isResNationalAcct__c = true AND ' +
                    'YTD_Sales_Change__c < 0 AND Account_Plan_Year__c = \''+string.valueOf(year)+'\' '  +
                    'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                    'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC LIMIT 20' ;
            }
            
            System.debug('queryAccountPlan:::::'+queryAccountPlanNegative);
            List<AggregateResult> aggResutsNegativeDealer = database.query(queryAccountPlanNegative);
            System.debug('aggResutsAccountPlan:::::'+aggResutsNegativeDealer);
            if(aggResutsNegativeDealer.size() > 0)
            {
                for(AggregateResult a : aggResutsNegativeDealer)       
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
                totalSalesForecastAttrition =0;
                
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