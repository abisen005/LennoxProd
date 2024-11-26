@isTest(seeAllData=true)
public class TestResNationalAggregate {
    /*static testmethod void testMemberVariables(){
        ResNationalAggregate d = new ResNationalAggregate();
        
        
        d.totalOppAmount = 0;
        
        d.previousYearTotalSales = 0;
        d.previousTwoYearsTotalSales = 0;
        d.previousThreeYearsTotalSales = 0;
        d.presentYearSalesForecast = 0;
        d.ytdSales = 0;
        d.previuosYearsYTDSales = 0;
        d.ytdSalesChange = 0;
        d.ytdResEquipment = 0;
        d.ytdCommercials = 0;
        d.ytdPartsndSupplies = 0;
        d.presetDLSC = 0;
        d.presetDLSCPercent = 0;
        d.presetMerit = 0;
        d.presetMeritPercent = 0;
        d.presetElite = 0;
        d.presetElitePercent = 0;
        d.presetAireFlo = 0;
        d.presetAireFloPercent = 0;
        d.presetOther = 0;
        d.presentYearOtherPercent = 0;
        d.dealerDeltAYTDSalesSum1 = 0;
        d.dealerYTDSalesLCSum1 = 0;
        d.dealerpre1TSSum1 = 0;
        d.dealerPre2TSSum1 = 0;
        d.dealerPre3TSSum1 = 0;
        d.totalSalesForecastGrowth = 0;
        d.dealerDeltAYTDSalesSum2 = 0;
        d.dealerpre1TSSum2 = 0;
        d.dealerPre2TSSum2 = 0;
        d.dealerPre3TSSum2 = 0;
        d.totalSalesForecastAttrition = 0;
        d.previousYearDLSC = 0;
        d.previousYearDLSCPercent = 0;
        d.previousYearMerit = 0;
        d.previousYearMeritPercent = 0;
        d.previousYearElite = 0;
        d.previousYearElitePercent = 0;
        d.previousYearAireFlo = 0;
        d.previousYearAireFloPercent = 0;
        d.previousYearOther = 0;
        d.previousYearOtherPercent = 0;
        d.changeDLSC = 0;
        d.changeMerit = 0;
        d.changeElite = 0;
        d.changeAireFlo = 0;
        d.changeOther = 0;
        d.dealerYTDSalesLCSum2 = 0;
        d.currentLoggedInUser ='123';
        String year = String.valueof(system.today().year());
        
        ApexPages.currentPage().getParameters().put('year', year);  
        String queryAccountPlan = 'SELECT Dealer__r.Name v0, Dealer__r.SAP_Customer_Number__c v1, Dealer__r.Id v11, Dealer__r.LastActivityDate v5, Dealer__c,' +
            'Dealer__r.SAP_Sales_Group__c v2, SUM(YTD_Sales__c) v4,SUM(PY_Sales__c) v7, SUM(PY2_Sales__c) v8,SUM(PY3_Sales__c) v9,'+
            'SUM(YTD_Sales_Change__c) v10, Dealer__r.Pricing_Zone__c v3 '+
            'FROM Account_Planning__c '+
            'WHERE   ' +
            'YTD_Sales_Change__c >= 0 AND  Account_Plan_Year__c =\''+string.valueOf(year)+'\'  AND Dealer__r.isResNationalAcct__c = true '+
            'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
            'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC' ;            List<AggregateResult> aggResultsAccountPlan = Database.query(queryAccountPlan);
        ResNationalAggregate controller = new ResNationalAggregate();
        PageReference page;
        
        
    }
*/
    
    static TestMethod void should_retreive_data()
    {
        test.startTest(); 
        Boolean isHomeOwnerWarranty = true;
        String year = String.valueof(system.today().year()-1);
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxind.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxind.com');
        sfUser.SAP_Sales_Office__c = 'C100';
        sfUser.SAP_Sales_Group__c = 'C1';
        insert sfUser;
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxind.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxind.com');
        sfUser2.SAP_Sales_Office__c = 'C100';
        sfUser2.SAP_Sales_Group__c = 'C1';
        insert sfUser2;
        
        
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Lennox System Admin%'];
        User testUser = new User();
        testUser.UserName = 'Lennox_testuser1@lennoxind.com';
        testUser.LastName = 'Test';
        testUser.email = 'test1@lennoxind.com';
        testUser.alias = 'testusr1';
        testUser.communitynickname = 'tstusr';
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.ProfileId = profileList[0].Id;
        testUser.LanguageLocaleKey = 'en_US';   
        testUser.UserRoleId = uRoleList[0].Id;
        testUser.SAP_Sales_Group__c = '700';
        testUser.SAP_Sales_Office__c = 'C489';
        insert testUser;
        
        //System.runAs(sfUser) 
        
        System.runAS(testUser){
            Account newDealer = new Account(); 
            newDealer.Name = 'Test908';
            newDealer.SAP_Sales_Office__c = 'C489';
            newDealer.SAP_Sales_Group__c = '700';
            newDealer.Phone = '123';
            newDealer.ShippingCity = 'City';
            newDealer.ShippingCountry = 'US';
            newDealer.ShippingPostalCode = '123456';
            newDealer.ShippingState = 'TX';
            newDealer.ShippingStreet = 'street';
            newDealer.SAP_Sales_District__c = 'Res National';
            
            newDealer.Prior_Year_YTD_Sales__c = 100;
            newDealer.SAP_YTD_Sales__c = 200;
            insert newDealer;
            
            Account_Planning__c newAccountPlan = new Account_Planning__c(); 
            newAccountPlan.Name = 'Test432';
            newAccountPlan.Account_Plan_Year__c = '2023';
            newAccountPlan.Dealer__c = newDealer.Id; 
            newAccountPlan.YTD_Sales__c = 100.00;
            newAccountPlan.PY_YTD_Sales__c = 200.00;
            newAccountPlan.YTD_Merit_Sales__c = 10;
            newAccountPlan.PY_YTD_Merit_Sales__c = 5;
            
            //newAccountPlan.Opportunity_Scorecard__c = scorecard.Id;
            insert newAccountPlan;
            List<Account_Opportunty__c> accOppList = new List<Account_Opportunty__c>();
            
            Account_Opportunty__c newOpportunity31 = new Account_Opportunty__c(); 
            newOpportunity31.Adjusted_Value__c = 100;
            newOpportunity31.Opportunity_Status__c = 'On Hold';
            newOpportunity31.Dealer_Account_Plan__c = newAccountPlan.Id;
            accOppList.add(newOpportunity31);
            
            Account_Opportunty__c newOpportunity = new Account_Opportunty__c(); 
            newOpportunity.Adjusted_Value__c = 100;
            newOpportunity.Opportunity_Status__c = 'Completed';
            newOpportunity.Dealer_Account_Plan__c = newAccountPlan.Id;
            accOppList.add(newOpportunity);
            
            Account_Opportunty__c newOpportunity2 = new Account_Opportunty__c(); 
            newOpportunity2.Adjusted_Value__c = 100;
            newOpportunity2.Opportunity_Status__c = 'In Progress';
            newOpportunity2.Dealer_Account_Plan__c = newAccountPlan.Id;
            accOppList.add(newOpportunity2);
            
            Account_Opportunty__c newOpportunity3 = new Account_Opportunty__c(); 
            newOpportunity3.Adjusted_Value__c = 100;
            newOpportunity3.Opportunity_Status__c = 'Not Started';
            newOpportunity3.Dealer_Account_Plan__c = newAccountPlan.Id;
            accOppList.add(newOpportunity3);
            
            Account_Opportunty__c newOpportunity4 = new Account_Opportunty__c(); 
            newOpportunity4.Adjusted_Value__c = 100;
            newOpportunity4.Opportunity_Status__c = 'Cancelled';
            newOpportunity4.Dealer_Account_Plan__c = newAccountPlan.Id;
            accOppList.add(newOpportunity4);
            insert accOppList;
            
            List<Retention_Opportunity__c> accRetList = new List<Retention_Opportunity__c>();
            Retention_Opportunity__c newRetention = new Retention_Opportunity__c(); 
            newRetention.Retention_Opportunity_Status__c = 'Completed';
            newRetention.Dealer_Account_Plan__c = newAccountPlan.Id;
            accRetList.add(newRetention);
            
            Retention_Opportunity__c newRetention2 = new Retention_Opportunity__c(); 
            newRetention2.Retention_Opportunity_Status__c = 'In Progress';
            newRetention2.Dealer_Account_Plan__c = newAccountPlan.Id;
            accRetList.add(newRetention2);
            
            Retention_Opportunity__c newRetention3 = new Retention_Opportunity__c(); 
            newRetention3.Retention_Opportunity_Status__c = 'Cancelled';
            newRetention3.Dealer_Account_Plan__c = newAccountPlan.Id;
            accRetList.add(newRetention3);
            
            Retention_Opportunity__c newRetention4 = new Retention_Opportunity__c(); 
            newRetention4.Retention_Opportunity_Status__c = 'Not Started';
            newRetention4.Dealer_Account_Plan__c = newAccountPlan.Id;
            accRetList.add(newRetention4);
            
            insert accRetList;
            
            List<Action_Plan__c> accAPList = new List<Action_Plan__c>();
            
            Action_Plan__c newActionPlan = new Action_Plan__c();
            newActionPlan.Action_Status__c = 'Completed';
            newActionPlan.Account_Plan__c = newAccountPlan.Id;
            
            newActionPlan.Action__c = 'New Customer';
            newActionPlan.Action_Type__c = 'Business Development';
            newActionPlan.Action_Completed_Date__c = date.today();
            //newActionPlan.Opportunity_Scorecard__c
            //newActionPlan.Account_Opportunity__c
            //newActionPlan.Retention_Opportunity__c
            accAPList.add(newActionPlan);
            
            Action_Plan__c newActionPlan2 = new Action_Plan__c();
            newActionPlan2.Action_Status__c = 'In Progress';
            newActionPlan2.Account_Plan__c = newAccountPlan.Id;
            newActionPlan2.Action__c = 'New Customer';
            newActionPlan2.Action_Type__c = 'Business Development';
            newActionPlan2.Action_Completed_Date__c = date.today();
            accAPList.add(newActionPlan2);
            
            Action_Plan__c newActionPlan3 = new Action_Plan__c();
            newActionPlan3.Action_Status__c = 'Not Started';
            newActionPlan3.Account_Plan__c = newAccountPlan.Id;
            newActionPlan3.Action__c = 'New Customer';
            newActionPlan3.Action_Type__c = 'Business Development';
            newActionPlan3.Action_Completed_Date__c = date.today();
            accAPList.add(newActionPlan3);
            
            Action_Plan__c newActionPlan4 = new Action_Plan__c();
            newActionPlan4.Action_Status__c = 'Cancelled';
            newActionPlan4.Account_Plan__c = newAccountPlan.Id;
            newActionPlan4.Action__c = 'New Customer';
            newActionPlan4.Action_Type__c = 'Business Development';
            newActionPlan4.Action_Completed_Date__c = date.today();
            accAPList.add(newActionPlan4);
            
            insert accAPList;
            

            
            ResNationalAggregate d = new ResNationalAggregate();
           
            d.createDealerLists();    
            d.setyearSelected('2019');  
            d.cancel();
         
            d.getyearSelected();
            
            
           //String forecastTotalSales = 'X'+year+'_Sales_Forecast__c';
             String forecastTotalSales;
           
                        forecastTotalSales ='Dealer__r.Current_Year_Sales_Forecast__c';
          
         
            
            ApexPages.currentPage().getParameters().put('year', year);  
            String queryAccountPlan = 'SELECT Dealer__r.Name v0, Dealer__r.SAP_Customer_Number__c v1, Dealer__r.Id v11, Dealer__r.LastActivityDate v5, Dealer__c,' +
                'Dealer__r.SAP_Sales_Group__c v2, SUM(YTD_Sales__c) v4,SUM(PY_Sales__c) v7, SUM(PY2_Sales__c) v8,SUM(PY3_Sales__c) v9,'+
                'SUM(YTD_Sales_Change__c) v10, Dealer__r.Pricing_Zone__c v3,SUM('+forecastTotalSales+') '+
                'FROM Account_Planning__c '+
                'WHERE   ' +
                'YTD_Sales_Change__c >= 0 AND  Account_Plan_Year__c =\''+string.valueOf(year)+'\'  AND Dealer__r.isResNationalAcct__c = true '+
                'GROUP BY Dealer__c, Dealer__r.Name, Dealer__r.Id, Dealer__r.SAP_Customer_Number__c, '+
                'Dealer__r.SAP_Sales_Group__c, Dealer__r.LastActivityDate, Dealer__r.Pricing_Zone__c ORDER BY SUM(YTD_Sales_Change__c) DESC' ;            List<AggregateResult> aggResultsAccountPlan = Database.query(queryAccountPlan);
            ResNationalAggregate controller = new ResNationalAggregate();
            PageReference page;
            test.stopTest();
            // System.assertNotEquals(controller.ytdSales, null);
        }
    }
    
}