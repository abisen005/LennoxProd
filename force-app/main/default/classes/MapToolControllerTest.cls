@isTest
private class MapToolControllerTest {
    static testMethod void testMapToolMethods() {

        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        List<String> tmUserIds = new List<String>();
        List<String> emptyList = new List<String>();
        List<String> location = new List<String>();
        List<String> filList = new List<String>();
        User manager = new User();
        manager.UserName = 'manager@testuser1212.com';
        manager.LastName = 'Test';
        manager.email = 'test@testuser.com';
        manager.alias = 'tmmgr';
        manager.communitynickname = 'tstssusr';
        manager.TimeZoneSidKey = 'America/New_York';
        manager.LocaleSidKey = 'en_US';
        manager.EmailEncodingKey = 'ISO-8859-1';
        manager.ProfileId = profileList2[0].Id;
        manager.LanguageLocaleKey = 'en_US';
        manager.UserRoleId = uRoleList[0].Id;
        manager.SAP_Sales_District__c = 'Central Region';
        manager.SAP_Sales_Office__c = 'U412';
        insert manager;

        User tm = new User();
        tm.UserName = 'Lennox_testuser1@testuser.com';
        tm.LastName = 'Test';
        tm.email = 'test@testuser.com';
        tm.alias = 'testusr1';
        tm.communitynickname = 'tstusr';
        tm.ManagerId = manager.Id;
        tm.TimeZoneSidKey = 'America/New_York';
        tm.LocaleSidKey = 'en_US';
        tm.EmailEncodingKey = 'ISO-8859-1';
        tm.ProfileId = profileList[0].Id;
        tm.LanguageLocaleKey = 'en_US';
        tm.UserRoleId = uRoleList[0].Id;
        tm.SAP_Sales_Office__c = 'U412';
        tm.SAP_Sales_Group__c = '211';
        insert tm;

        tmUserIds.add(tm.Id);
        location.add('-87.88715363');
        location.add('41.85159683');
        filList.add('true');
        filList.add('SAP_YTD_Sales__c');
        filList.add('0');
        filList.add('20000000');
        System.runAs(manager) {
            Account[] accs = new List<Account>();
            Account premierDealer = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '211',Main_LPP_Store__c='A307', SAP_Customer_Number__c = 'abc123abc123', Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363,SAP_Premier_Dealer__c='Yes');
            accs.add(premierDealer);
            
            Account strategicDealer = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '211', Main_LPP_Store__c='A307', SAP_Customer_Number__c = 'abc123abc123b', Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363,Aire_Serv__c=true);
            accs.add(strategicDealer);
            Account allOtherDealer = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '211',Main_LPP_Store__c='A307', SAP_Customer_Number__c = 'abc123abc123c', Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363);
            accs.add(allOtherDealer);
            Account strategicProspect = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', LPP_3P_Program_Dealer__c = true, BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, Main_LPP_Store__c='A307', SAP_Sales_Group__c = '211', SAP_Customer_Number__c = null, Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363,Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
            accs.add(strategicProspect);
            Account allOtherProspect = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '211',Main_LPP_Store__c='A307', SAP_Customer_Number__c = null, Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363,Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
            accs.add(allOtherProspect);
            Account houseAccount = new Account(Name = 'Test Account1',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, Main_LPP_Store__c='A307', SAP_YTD_Sales__c=200, OwnerId = manager.Id,  SAP_Sales_Group__c = '1', SAP_Customer_Number__c = 'notanumbera' + 'abc', Pricing_Zone__c = 'NY', ShippingLongitude=41.85159683, ShippingLatitude=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
            accs.add(houseAccount);
            //not testing cash accounts because we could end up with a duplicate customer number and cause problems
            Account lowesAccount = new Account(Name = 'Test Account',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', OwnerId = manager.Id,ShippingLongitude=41.85159683,  Main_LPP_Store__c='A307', ShippingLatitude=-87.88715363, Retail_Store__c = 'Lowe\'s');
            accs.add(lowesAccount);
            Account hdAccount = new Account(Name = 'Test Account',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', OwnerId = manager.Id,ShippingLongitude=41.85159683, Main_LPP_Store__c='A307', ShippingLatitude=-87.88715363, Retail_Store__c = 'Home Depot');
            accs.add(hdAccount);
            Account ccAccount = new Account(Name = 'Test Account',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', OwnerId = manager.Id,ShippingLongitude=41.85159683, Main_LPP_Store__c='A307', ShippingLatitude=-87.88715363, Retail_Store__c = 'Costco');
            accs.add(ccAccount);
            Account ccAccount1 = new Account(Name = 'Test Account',ShippingPostalCode ='13345',ShippingCountry='country',ShippingStreet = 'street',ShippingCity = 'city',ShippingState = 'state',Phone='1234567890', OwnerId = manager.Id,ShippingLongitude=41.85159683,LPP_Plant_Code__c='A307', Main_LPP_Store__c = 'A307',ShippingLatitude=-87.88715363, Retail_Store__c = 'Costco');
            accs.add(ccAccount1);
            insert accs;
            Scorecard__c sc = new Scorecard__c(Name = 'test scorecard', Account__c = premierDealer.Id, Total_Number_of_Employees__c = 50);
            insert sc;
            test.startTest();
            MapToolController.getDistricts('Central Region');
            MapToolController.getDistricts('');
            MapToolController.getTerritories('U412');
            MapToolController.SaveDefaultLocation('-87.88715363', '41.85159683', '10', tm.Id);
            MapToolController.getAccountData(premierDealer.Id, 'pd');
            MapToolController.getAccountData(strategicDealer.Id, 'sd');
            
            List<String> allTypes = New List<String>();
            allTypes.add('pd');
            
            MapToolController.getAccounts(tmUserIds, 'pd', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'sd', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'aod', allTypes,location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'sp', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'aop', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'ca', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'cma', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(emptyList, 'ha', allTypes, location, 10000, 0, tmUserIds[0], filList);
            MapToolController.getAccounts(tmUserIds, 'lpp', allTypes, location, 10000, 0, null, filList);
            MapToolController.getAccounts(tmUserIds, 'lws', allTypes, location, 10000, 0, null, filList);
            MapToolController.getAccounts(tmUserIds, 'hd', allTypes, location, 10000, 0, null, filList);
            MapToolController.getAccounts(tmUserIds, 'cc', allTypes, location, 10000, 0, null,filList);
            MapToolController.getAccounts(tmUserIds, 'nce', allTypes, location, 10000, 0, null, filList);
            MapToolController.getAccounts(tmUserIds, 'nc', allTypes, location, 10000, 0, null, filList);
            MapToolController.getAccounts(tmUserIds, 'npp', allTypes, location, 10000, 0, null, filList);
            MapToolController.getSMADealers(accs[9].id, location, 10000, filList);
            test.stopTest();
        }
    }
}