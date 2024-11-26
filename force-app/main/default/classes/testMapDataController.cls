@isTest(seeAllData = true)
public class testMapDataController
{
    static testmethod void tmTest1() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
        manager.Phone = '123456789';
        
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            acList[0].Phone = '123456789';
            acList[0].ShippingCity = 'city';
            acList[0].ShippingCity = 'state';
            acList[0].ShippingCountry = 'country';
            acList[0].ShippingPostalCode = '123456';
            acList[0].ShippingStreet = 'test';
            acList[0].Lead_Source__c = 'test';
            acList[0].SAP_Customer_Number__c  = '1';
             
            
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+1000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  =  i +'d2';
                acList.add(a);
            }
            
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                        SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                        Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                        Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'c3';
                
                acList.add(a);
            }
            
            insert acList;

            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest2() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 allOtherProspects
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null, Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'b3';
                acList.add(a);
            }
            insert acList;
            
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~ao~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest3() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 All Other Dealers
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+10000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest4() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 House Accounts
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = manager.Id, SAP_Sales_Group__c = '115', SAP_Customer_Number__c = 'abcd'+String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest5() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 Cash Accounts
            for(integer i=0; i<=45; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = manager.Id, SAP_Sales_Group__c = '715', SAP_Customer_Number__c = String.valueOf(i+299000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            acList = new List<Account>();
            
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void dmTest1() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(manager)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+100) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+1000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'3';
                acList.add(a);
            }
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null, Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                 a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'a3';
                acList.add(a);
            }
            insert acList;
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            ApexPages.CurrentPage().getParameters().put('t','715~115~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void dmTest2() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(manager)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 All Other Dealers
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+10000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            ApexPages.CurrentPage().getParameters().put('t','715~115~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void dmTest3() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(manager)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 allOtherProspects
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+20000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            ApexPages.CurrentPage().getParameters().put('t','715~115~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void dmTest4() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(manager)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 5000 House Accounts
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = manager.Id, SAP_Sales_Group__c = '115', SAP_Customer_Number__c = 'abcd'+String.valueOf(i), Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            insert acList;
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            ApexPages.CurrentPage().getParameters().put('t','715~115~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void dmTest5() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(manager)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            
            //Create 5000 Cash Accounts
            for(integer i=0; i<=40; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = manager.Id, SAP_Sales_Group__c = '715', SAP_Customer_Number__c = String.valueOf(i+299000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=false, SAP_Premier_Dealer__c=null);
                acList.add(a);
            }
            insert acList;
            
            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            ApexPages.CurrentPage().getParameters().put('t','715~115~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest6() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Res Territory%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
        manager.Phone = '123456789';
        
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            acList[0].Phone = '123456789';
            acList[0].ShippingCity = 'city';
            acList[0].ShippingCity = 'state';
            acList[0].ShippingCountry = 'country';
            acList[0].ShippingPostalCode = '123456';
            acList[0].ShippingStreet = 'test';
            acList[0].Lead_Source__c = 'test';
            acList[0].SAP_Customer_Number__c  = '1';
             
            
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+1000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  =  i +'d2';
                acList.add(a);
            }
            
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                        SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                        Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                        Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'c3';
                
                acList.add(a);
            }
            
            insert acList;

            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    
    static testmethod void tmTest7() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Res District Manager%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
        manager.Phone = '123456789';
        
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            acList[0].Phone = '123456789';
            acList[0].ShippingCity = 'city';
            acList[0].ShippingCity = 'state';
            acList[0].ShippingCountry = 'country';
            acList[0].ShippingPostalCode = '123456';
            acList[0].ShippingStreet = 'test';
            acList[0].Lead_Source__c = 'test';
            acList[0].SAP_Customer_Number__c  = '1';
             
            
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i+1000) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  =  i +'d2';
                acList.add(a);
            }
            
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                        SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                        Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                        Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Number__c  = i +'c3';
                
                acList.add(a);
            }
            
            insert acList;

            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    static testmethod void tmTest8() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Res District Manager%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
        manager.Phone = '123456789';
        
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            acList[0].Phone = '123456789';
            acList[0].ShippingCity = 'city';
            acList[0].ShippingCity = 'state';
            acList[0].ShippingCountry = 'country';
            acList[0].ShippingPostalCode = '123456';
            acList[0].ShippingStreet = 'test';
            acList[0].Lead_Source__c = 'test';
            //acList[0].SAP_Customer_Number__c  = '1';
             
            
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                //a.SAP_Customer_Number__c  =  i +'d2';
                acList.add(a);
            }
            
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                        SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                        Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                        Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                //a.SAP_Customer_Number__c  = i +'c3';
                
                acList.add(a);
            }
            
            insert acList;

            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
    static testmethod void tmTest9() 
    {
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Res District Manager%'];
        User manager = new User();
        manager.UserName = 'manager@testuser.com';
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
        manager.SAP_Sales_Group__c = '215';
        manager.Phone = '123456789';
        
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
        tm.SAP_Sales_Group__c = '215';
        insert tm;

        System.runAs(tm)
        {
            test.startTest();
            List<Account> acList = new List<Account>();
            //Create 100 Premier Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200,OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = String.valueOf(i) + 'abc', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,SAP_Premier_Dealer__c='Yes');
                acList.add(a);
            }
            acList[0].Name = 'Test\'s Account';
            acList[0].ShippingStreet = 'Shipping\'s Street\r\n';
            acList[0].ShippingCity = 'Shipping\'s City\r\n';
            acList[0].Phone = '123456789';
            acList[0].ShippingCity = 'city';
            acList[0].ShippingCity = 'state';
            acList[0].ShippingCountry = 'country';
            acList[0].ShippingPostalCode = '123456';
            acList[0].ShippingStreet = 'test';
            acList[0].Lead_Source__c = 'test';
            acList[0].SAP_Customer_Group_Id__c   = '400';
             
            
            //Create 100 Strategic Dealers
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125, SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363, Aire_Serv__c=true);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Group_Id__c  =  '400';
                acList.add(a);
            }
            
            //Create 100 Strategic Prospects
            for(integer i=0; i<=10; i++)
            {
                Account a = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                        SAP_YTD_Sales__c=200, OwnerId = tm.Id, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                        Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                        Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
                a.Phone = '123456789';
                a.ShippingCity = 'city';
                a.ShippingCity = 'state';
                a.ShippingPostalCode = '123456';
                a.ShippingStreet = 'test';
                a.Lead_Source__c = 'test';
                a.SAP_Customer_Group_Id__c  =  '400';
                
                acList.add(a);
            }
            
            insert acList;

            ApexPages.CurrentPage().getParameters().put('show','pd~sd~aod~sp~aop~ha~ca~');
            MapDataController d = new MapDataController();
            test.stopTest();
        }
    }
}