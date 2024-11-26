@isTest
public class storeRollupSummaryAggregateBatchTest {
    @isTest
    static void testBatch() {
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
            List<Roll_Up_Regions__mdt> listRegion = [SELECT Id, Label FROM Roll_Up_Regions__mdt LIMIT 1];
            String strRegion = ((listRegion != null && listRegion.size() > 0) ? listRegion[0].Label : '');
            Account newDealer = new Account(); 
            newDealer.Name = 'Test';
            newDealer.SAP_Sales_Office__c = 'test';
            newDealer.SAP_Sales_Group__c = '650';
            newDealer.SAP_Sales_District__c = strRegion;
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

            storeRollupSummaryAggregateBatch newBatch = new storeRollupSummaryAggregateBatch();
            database.executeBatch(newBatch);
        }
    }
}