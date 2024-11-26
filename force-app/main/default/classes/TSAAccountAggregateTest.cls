@istest 
public class TSAAccountAggregateTest {

    static testmethod void testMemberVariables(){
        TSAAccountAggregate d = new TSAAccountAggregate();
        d.currentLoggedInUserTerritory = 'x';
        d.accountId = 'x';
        d.year1TotalSales = 'x';
        d.year2TotalSales = 'x';
        d.year3TotalSales = 'x';
        d.lastSalesHistoryUpdate = Date.today();
        d.accOppProgCount = 0;
        d.accountOppCompletedCount = 0;
        d.accountOppNotStartedCount = 0;
        d.accountOppCancelledCount = 0;
        d.accountOppHoldCount = 0;
        d.retOppProgCount = 0;
        d.retOppCompletedCount = 0;
        d.retOppNotStartedCount = 0;
        d.retOppCancelledCount = 0;
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

        
    }

    static testmethod void test1() 
    {  
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Lennox System Admin%'];
        User testUser = new User();
        testUser.UserName = 'Lennox_testuser1@testuser.com';
        testUser.LastName = 'Test';
        testUser.email = 'test1@testuser.com';
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
        
        System.runAs(testUser) 
        {       
            //insert custom setting    
            test.startTest(); 
            AggregateReportsSettings__c custSet = New AggregateReportsSettings__c();
            custSet.District_Access__c = 'Lennox - Res Sales DM;Lennox - Res Sales DM Pilot;Lennox - Res Sales ASM;Lennox - Res Sales - BDM';
            custSet.Region_Access__c = 'Lennox - Res Sales - Corporate User;Lennox - Res Sales AM;Lennox - Res Sales BDM;Lennox - Res Sales RBM;Res Area BD Manager;Lennox - Res Sales - BDM';
            custSet.Executive_Access__c = 'Lennox - Res Sales - EXE;Lennox Business Administrator;Lennox Business Administrator Super;Res Area BD Manager;Lennox - Res Sales - BDM';
            custSet.Territory_Access__c = 'Lennox - Res Sales TM;Lennox - Res Sales TM Pilot;Res Area BD Manager;Lennox - Res Sales - BDM';
            insert custSet;
            
            Account a = new Account(Name = 'Test Account', ShippingCity = 'city',ShippingStreet='Street',ShippingState = 'state',shippingCountry='USA',ShippingPostalCode='56665',Phone='444-343-3434',Prior_Year_YTD_Sales__c = 125,SAP_YTD_Sales__c=200,OwnerId = testUser.Id, SAP_Sales_Group__c = '700', SAP_Sales_Office__c = 'C489',SAP_Customer_Number__c = '123', Pricing_Zone__c = 'NY');
            insert a; 
            Sales_Initiative__c tsa = new Sales_Initiative__c(
                ZM_Engagement__c = 'Engaged',
                Store_Target_Account_Enrolled__c = true,
                Account__c = a.id
            );
            
            insert tsa;
            a.Target_Store_Account__c = tsa.id;
            update a;
            Date today = Date.today();
            
            Account_Planning__c ap = new Account_Planning__c(
                Name = 'testAp',
                Current_Year__c = String.valueOf(today.year()-1),
                Account_Plan_Year__c = String.valueOf(today.year()),
                Dealer__c = a.Id,
                PY_YTD_Sales__c = 2018,
                YTD_Sales__c = 3000,
                Unique_AP_Value__c = 'Test1',
                YTD_Merit_Sales__c = 2000,
                PY_Merit_Sales__c = 2000,
                PY_YTD_Merit_Sales__c = 2000,
                PY2_Merit_Sales__c = 2000,
                PY3_Merit_Sales__c = 2000,
                YTD_P_S_Sales__c = 1000,
                YTD_Res_Equip_Sales__c = 1000,
                YTD_Commercial_Sales__c = 1000,
                YTD_DLSC_Sales__c = 1000,
                PY_YTD_DLSC_Sales__c = 1000,
                YTD_Elite_Sales__c = 1000,
                PY_YTD_Elite_Sales__c = 1000,
                YTD_Aire_Flo_Sales__c = 1000,
                PY_YTD_Aire_Flo_Sales__c = 1000,
                YTD_Other_Sales__c = 1000,
                PY_YTD_Other_Sales__c = 1000,
                Last_Sales_History_Update__c = today
            );

            insert ap;
            
            Account_Planning__c ap1 = new Account_Planning__c();
            ap1.Name = 'testAp2';
            ap1.Current_Year__c = String.valueOf(today.year());
            ap1.Account_Plan_Year__c = String.valueOf(today.year());
            ap1.Dealer__c = a.Id;
            ap1.PY_YTD_Sales__c = 2018;
            ap1.YTD_Sales__c = 2015;
            ap1.Unique_AP_Value__c = 'Test2';
            insert ap1;

            Account_Planning__c ap2 = new Account_Planning__c();
            ap2.Name = 'testAp3';
            ap2.Current_Year__c = String.valueOf(today.year());
            ap2.Account_Plan_Year__c = String.valueOf(today.year());
            ap2.Dealer__c = a.Id;
            ap2.PY_YTD_Sales__c = 2018;
            ap2.YTD_Sales__c = 3000;
            ap2.Unique_AP_Value__c = 'Test3';
            insert ap2;
            
            Account_Opportunty__c ao = new Account_Opportunty__c();
            ao.Dealer_Account_Plan__c = ap.Id;
            ao.Opportunity_Status__c = 'In Progress';
            ao.Adjusted_Value__c = 100;
            insert ao;
            
            Retention_Opportunity__c ro = new Retention_Opportunity__c();
            ro.Dealer_Account_Plan__c = ap.Id;
            ro.Retention_Opportunity__c = 'E-Invoice - Participation - Points: 05';
            ro.Retention_Opportunity_Type__c = 'Financial';
            ro.Retention_Opportunity_Status__c = 'In Progress';
            ro.CRI_Point_Step_3__c = '04';
            insert ro;
            
            Retention_Opportunity__c ro1 = new Retention_Opportunity__c();
            ro1.Dealer_Account_Plan__c = ap.Id;
            ro1.Retention_Opportunity__c = 'E-Invoice - Participation - Points: 05';
            ro1.Retention_Opportunity_Type__c = 'Financial';
            ro1.Retention_Opportunity_Status__c = 'Completed';
            ro1.CRI_Point_Step_3__c = '04';
            insert ro1;
            
            
            //insert action plans with various statuses
            List<Action_Plan__c> aplans = New List<Action_Plan__c>();
            for(integer i = 0; i < 4; i++){
                Action_Plan__c acp = new Action_Plan__c();
                acp.Account_Plan__c = ap.Id;
                aplans.add(acp);
            }
            
            aplans[0].Action_Status__c = 'In Progress';
            aplans[1].Action_Status__c = 'Completed';
            aplans[2].Action_Status__c = 'Not Started';
            aplans[3].Action_Status__c = 'Cancelled';
            insert aplans;
            
            
            set<id> acpId = new set<id>();
            acpId.add(ap.Id);
            
            ApexPages.CurrentPage().getParameters().put('year',String.valueOf(today.year()));
            ApexPages.CurrentPage().getParameters().put('u',testUser.Id);
            
            TSAAccountAggregate d = new TSAAccountAggregate();
            d.prepareAccountOpportunityLists(); 
            d.prepareRetentionOpportunityLists(); 
            d.prepareActionPlanLists();
            d.createDealerLists();    
            d.setyearSelected('2019');  
            d.cancel();
            d.navigateToReport();
            d.getReportYear();
            d.getyearSelected();
            
            ao.Opportunity_Status__c = 'Completed';
            update ao;
            d.prepareAccountOpportunityLists();
            
            ao.Opportunity_Status__c = 'Not Started';
            ro.Retention_Opportunity_Status__c = 'Not Started';
            update ao;
            update ro;
            d.prepareAccountOpportunityLists();
            
            ao.Opportunity_Status__c = 'Cancelled';
            ro.Retention_Opportunity_Status__c = 'Cancelled';
            update ao;
            update ro;
            d.prepareAccountOpportunityLists();
            
            ao.Opportunity_Status__c = 'On Hold';
            update ao;
            d.prepareAccountOpportunityLists();
            
            
            //Integer year = Date.today().year();
            String year = String.valueof(system.today().year());
            ApexPages.currentPage().getParameters().put('year', year);
            String queryAccountPlan = 'SELECT SUM(PY3_Sales__c),SUM(PY2_Sales__c),SUM(PY_Sales__c),SUM(YTD_Sales__c),SUM(PY_YTD_Sales__c),SUM(YTD_Sales_Change__c),SUM(YTD_Res_Equip_Sales__c),SUM(YTD_Commercial_Sales__c),SUM(YTD_P_S_Sales__c),SUM(YTD_DLSC_Sales__c),AVG(YTD_DLSC_Sales_Percent__c),SUM(PY_YTD_DLSC_Sales__c),AVG(PY_YTD_DLSC_Sales_Percent__c),SUM(YTD_DLSC_Sales_Change__c),SUM(YTD_Elite_Sales__c),AVG(YTD_Elite_Sales_Percent__c),SUM(PY_YTD_Elite_Sales__c),AVG(PY_YTD_Elite_Sales_Percent__c),SUM(YTD_Elite_Sales_Change__c),SUM(YTD_Merit_Sales__c),AVG(YTD_Merit_Sales_Percent__c),SUM(PY_YTD_Merit_Sales__c),AVG(PY_YTD_Merit_Sales_Percent__c),SUM(YTD_Merit_Sales_Change__c),SUM(YTD_Aire_Flo_Sales__c),AVG(YTD_Aire_Flo_Sales_Percent__c),SUM(PY_YTD_Aire_Flo_Sales__c),AVG(PY_YTD_Aire_Flo_Sales_Percent__c),SUM(YTD_Aire_Flo_Sales_Change__c),SUM(YTD_Other_Sales__c),AVG(YTD_Other_Sales_Percent__c),SUM(PY_YTD_Other_Sales__c),AVG(PY_YTD_Other_Sales_Percent__c),SUM(YTD_Other_Sales_Change__c), Dealer__r.OwnerId, MAX(Last_Sales_History_Update__c) date1 FROM Account_Planning__c WHERE Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.OwnerId LIMIT 10';
            List<AggregateResult> aggResultsAccountPlan = Database.query(queryAccountPlan);
            
            // Verify the results
            // System.assertEquals(3, aggResultsAccountPlan.size(), 'There should be one result row');
            
            test.stopTest();
        }
    }
}