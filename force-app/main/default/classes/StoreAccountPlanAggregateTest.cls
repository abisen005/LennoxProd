/*  
 * @Purpose      : Test Class for StoreAccountPlanAggregate
 * @Created Date : 07/01/2022
 */ 
@isTest
public class StoreAccountPlanAggregateTest {
    
    static TestMethod void StoreAccountPlanAggregateTestMethod(){
        String year = String.valueof(system.today().year());
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name LIKE '%LPP SM%' LIMIT 1];
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com',
                              LPP_Store__c = 'test');
        sfUser.UserRoleId = r.Id;
        sfUser.SAP_Sales_Office__c = 'C100';
        sfUser.SAP_Sales_Group__c = 'C1';
        INSERT sfUser;
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxDMAgg.com');
        sfUser2.SAP_Sales_Office__c = 'C100';
        sfUser2.SAP_Sales_Group__c = 'C1';
        sfUser2.LPP_Store__c = 'test';
        INSERT sfUser2;
        
        User csaUser = new User(Alias = 'standt', Email='CSA@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='CSA Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                                ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='CSA@lennoxDMAgg.com');
        csaUser.SAP_Sales_Office__c = 'C100';
        csaUser.SAP_Sales_Group__c = 'C1';
        csaUser.Title = 'Counter Sales Associate';
        csaUser.UserRoleId = sfUser2.UserRoleId;
        csaUser.LPP_Store__c = 'test';
        INSERT csaUser; 
        
        System.runAS(sfUser){
            Account newDealer = new Account(); 
            newDealer.Name = 'Test';
            newDealer.SAP_Sales_Office__c = 'test';
            newDealer.SAP_Sales_Group__c = '650';
            newDealer.Phone = '123';
            newDealer.ShippingCity = 'City';
            newDealer.ShippingCountry = 'US';
            newDealer.ShippingPostalCode = '123456';
            newDealer.ShippingState = 'TX';
            newDealer.ShippingStreet = 'street';
            newDealer.LPP_Plant_Code__c = 'test';
            newDealer.SAP_Customer_Number__c = '1111';
            newDealer.Pricing_Zone__c = '11';
            newDealer.Main_LPP_Store__c = 'test StoreName';
            newDealer.Last_Changed_Date__c = system.today();
            insert newDealer; 
             
            Account_Planning__c newAccountPlan = new Account_Planning__c(); 
            newAccountPlan.Name = 'test';
            newAccountPlan.Account_Plan_Year__c = year;
            newAccountPlan.Dealer__c = newDealer.Id; 
            newAccountPlan.YTD_Sales__c = 100.00;
            newAccountPlan.PY_YTD_Sales__c = 200.00;
            newAccountPlan.YTD_Merit_Sales__c = 10;
            newAccountPlan.PY_YTD_Merit_Sales__c = 5;
            newAccountPlan.PY_Sales__c = 5;
            newAccountPlan.PY2_Sales__c = 5; 
            newAccountPlan.PY3_Sales__c = 5;
            insert newAccountPlan;

            Scorecard__c newScorecard = new Scorecard__c();
            newScorecard.Account__c = newDealer.Id;
            newScorecard.Last_Changed_by_User_Stores__c = sfUser.Id;
            insert newScorecard;

            Contact newContact = new Contact();
            newContact.FirstName = 'FirstName';
            newContact.LastName = 'LastName';
            newContact.Last_Changed_Date__c = system.today();
            newContact.AccountId = newDealer.Id;
            newContact.Last_Changed_By_Role__c = 'test LPP SM test';
            newContact.Email = 'test@test.com';
            newContact.Phone = '9999999999';
            newContact.MobilePhone = '7777777777';
            insert newContact;

            Event newEvent = new Event();
            newEvent.WhatId = newDealer.Id;
            newEvent.ActivityDate = system.today();
            newEvent.Event_TYpe__c ='Phone Call - Outbound';
            newEvent.OwnerId = sfUser.Id;
            newEvent.ActivityDateTime = system.today();
            newEvent.DurationInMinutes = 60;
            insert newEvent;      

            ExecutiveRollUpMain__c mainRecord = new ExecutiveRollUpMain__c();
            mainRecord.Region__c = 'LPP North Region';
            mainRecord.Zone__c = 'Canada';
            mainRecord.Store__c = 'test';
            mainRecord.CY_YTDSales__c = 100;
            mainRecord.PY_YTDSales__c = 100;
            mainRecord.PY_SalesHistory__c = 100;
            mainRecord.P2Y_SalesHistory__c = 100;
            mainRecord.P3Y_SalesHistory__c = 100;
            mainRecord.CY_SalesForecast__c = 100;
            mainRecord.CY_YTDResEquipment__c = 100;
            mainRecord.CY_YTDCommercial__c = 100;
            mainRecord.CY_YTDPartsAndSupplies__c = 100;
            mainRecord.CY_YTDDLSC__c = 100;
            mainRecord.CY_YTDElite__c = 100;
            mainRecord.CY_YTDMerit__c = 100;
            mainRecord.CY_YTDAireFlo__c = 100;
            mainRecord.CY_YTDOther__c = 100;
            mainRecord.PY_YTDDLSC__c = 100;
            mainRecord.PY_YTDElite__c = 100;
            mainRecord.PY_YTDMerit__c = 100;
            mainRecord.PY_YTDAireFlo__c = 100;
            mainRecord.PY_YTDOther__c = 100;
            mainRecord.Type__c= 'Store Summary Sales';
            mainRecord.Year__c= year;
            mainRecord.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord;          

            ExecutiveRollUpMain__c mainRecord2 = new ExecutiveRollUpMain__c();
            mainRecord2.Region__c = 'LPP North Region';
            mainRecord2.Zone__c = 'Canada';
            mainRecord2.Store__c = 'test';
            mainRecord2.KPI_OppScorecards__c = 11;
            mainRecord2.KPI_Contacts__c = 11;
            mainRecord2.KPI_PhoneCalls__c = 11;
            mainRecord2.Type__c= 'Store Summary KPI';
            mainRecord2.Year__c= year;
            mainRecord2.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord2; 

            ExecutiveRollUpMain__c mainRecord3 = new ExecutiveRollUpMain__c();
            mainRecord3.Region__c = 'LPP North Region';
            mainRecord3.Zone__c = 'Canada';
            //mainRecord3.Store__c = 'C489';
            mainRecord3.CY_YTDSales__c = 100;
            mainRecord3.PY_YTDSales__c = 100;
            mainRecord3.PY_SalesHistory__c = 100;
            mainRecord3.P2Y_SalesHistory__c = 100;
            mainRecord3.P3Y_SalesHistory__c = 100;
            mainRecord3.CY_SalesForecast__c = 100;
            mainRecord3.CY_YTDResEquipment__c = 100;
            mainRecord3.CY_YTDCommercial__c = 100;
            mainRecord3.CY_YTDPartsAndSupplies__c = 100;
            mainRecord3.CY_YTDDLSC__c = 100;
            mainRecord3.CY_YTDElite__c = 100;
            mainRecord3.CY_YTDMerit__c = 100;
            mainRecord3.CY_YTDAireFlo__c = 100;
            mainRecord3.CY_YTDOther__c = 100;
            mainRecord3.PY_YTDDLSC__c = 100;
            mainRecord3.PY_YTDElite__c = 100;
            mainRecord3.PY_YTDMerit__c = 100;
            mainRecord3.PY_YTDAireFlo__c = 100;
            mainRecord3.PY_YTDOther__c = 100;
            mainRecord3.Type__c= 'Store Summary Sales';
            mainRecord3.Year__c= year;
            mainRecord3.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord3;          

            ExecutiveRollUpMain__c mainRecord4 = new ExecutiveRollUpMain__c();
            mainRecord4.Region__c = 'LPP North Region';
            mainRecord4.Zone__c = 'Canada';
            //mainRecord4.Store__c = 'C489';
            mainRecord4.KPI_OppScorecards__c = 11;
            mainRecord4.KPI_Contacts__c = 11;
            mainRecord4.KPI_PhoneCalls__c = 11;
            mainRecord4.Type__c= 'Store Summary KPI';
            mainRecord4.Year__c= year;
            mainRecord4.Last_Sales_History_Update__c = System.today();

            //Sales_Initiative__c initiative = new Sales_Initiative__c();
            //initiative.Account__c = newDealer.Id; 
            //initiative.Intiative__c = 'Target Store Accounts' ;
            //initiative.Store_Target_Account_Enrolled__c = true ;
            //insert initiative;
            
            ApexPages.currentPage().getParameters().put('year', year);
            ApexPages.currentPage().getParameters().put('u', sfUser2.Id);
            StoreAccountPlanAggregate controller = new StoreAccountPlanAggregate();
            controller.getyearSelected(); 
            controller.setyearSelected(year);
            Pagereference pr1 =controller.cancel();
            Pagereference pr =controller.navigateToReport();
            List<SelectOption> report = controller.getReportYear();
            
            PageReference page;
            System.assertEquals('test', newDealer.LPP_Plant_Code__c);
        }
    }
}