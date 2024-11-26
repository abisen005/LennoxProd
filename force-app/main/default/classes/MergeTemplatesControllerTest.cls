/**  
* @Purpose         : Test Class for MergeTemplatesController
* @Created Date    : 22/01/2022
@LastModifedDate : 20/07/2022
@Last ModifiedBy : Abilash Senthilkumar
*/
@isTest
public class MergeTemplatesControllerTest {
    /**
* @Purpose : Method to create test data
*/
    @TestSetup
    public static void createTestData(){
        
        List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<Profile> profileList2 = [Select Id From Profile Where Name like '%Res Sales DM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Admin%'];
        
        User areamanager = new User();
        areamanager.UserName = 'areamanager@testuser.com';
        areamanager.LastName = 'Test areamanager';
        areamanager.email = 'test@lennoxind.com';
        areamanager.alias = 'am';
        areamanager.communitynickname = 'amusr';
        areamanager.TimeZoneSidKey = 'America/New_York';
        areamanager.LocaleSidKey = 'en_US';
        areamanager.EmailEncodingKey = 'ISO-8859-1';
        areamanager.ProfileId = profileList2[0].Id;
        areamanager.LanguageLocaleKey = 'en_US';   
        areamanager.UserRoleId = uRoleList[0].Id;
        areamanager.SAP_Sales_Group__c = '215';
        areamanager.Phone = '2233445566';
        insert areamanager;
        
        User manager = new User();
        manager.UserName = 'manager3434@testuser.com';
        manager.LastName = 'Test';
        manager.email = 'test@lennoxind.com';
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
        manager.ManagerId = areamanager.Id;
        
        insert manager;
        
        User tm = new User();
        tm.UserName = 'Lennox_testuser11@lennoxind.com';
        tm.LastName = 'Test';
        tm.email = 'test@lennoxind.com';
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
        List<Account> acList = new List<Account>();
        System.runAs(tm)
        {
            test.startTest();
            
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
            
            
            Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Submitted Layout (Stage 1)').getRecordTypeId();
            Id contactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Contact').getRecordTypeId();
            Id accountrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
            
            List<Opportunity> lstTesting = new List<Opportunity>();
  
            Opportunity opp1 = new Opportunity();
            opp1.Name= 'test1';
            opp1.RecordTypeId= recordTypeId;
            opp1.CloseDate = system.today();
            opp1.StageName = 'Incentive';
            opp1.AccountId = acList[0].Id;
            opp1.BDM__c = areamanager.Id;
            opp1.District_Manager__c = manager.Id;
            opp1.Regional_Director__c = tm.Id;
            opp1.Lifetime_Value_of_Deal__c =76000;
            opp1.Type ='Existing Dealer';
           lstTesting.add(opp1) ;


 			 Opportunity opp2 = new Opportunity();
            opp2.Name= 'test2';
            opp2.RecordTypeId= recordTypeId;
            opp2.CloseDate = system.today();
            opp2.StageName = 'Incentive';
            opp2.AccountId = acList[0].Id;
            opp2.BDM__c = areamanager.Id;
            opp2.District_Manager__c = manager.Id;
            opp2.Regional_Director__c = tm.Id;
            opp2.Lifetime_Value_of_Deal__c =300000;
            opp2.Type ='New Customer';
            lstTesting.add(opp2) ;
            Insert lstTesting;
            
            Contact cont = new Contact();
            cont.FirstName= 'F test';
            cont.LastName= 'L test';
            cont.RecordTypeId= contactrecordTypeId;
            cont.Contact_Type__c	 = 'Dealer';
            cont.AccountId	 = acList[0].Id;
            cont.Role__c = 'Assistant Manager';
            cont.MobilePhone = '5588996655';
            cont.Phone = '4477885598';
            cont.Email = 'test@lennoxind.com';
            INSERT cont;
            
        }
        
        
    }

    
    static testMethod void testMethod1() {
        
        Opportunity oppList = [select id,Name FROM Opportunity   LIMIT 1 ];
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(oppList); 
        MergeTemplatesController controller = new MergeTemplatesController(sc);
        PageReference pr = controller.getData();
        Set<String> contactIdLst = new Set<String>();
        Set<String> userIdLst = new Set<String>();
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name FROM Contact LIMIT 1];
        contactIdLst.add(contactList[0].Id);
        List<User> userList = new List<User>();
        userList = [SELECT Id, Name FROM User LIMIT 1];
        userIdLst.add(userList[0].Id);
        System.currentPageReference().getParameters().put('contactIdLst', JSON.serialize(contactIdLst));
        System.currentPageReference().getParameters().put('userIdLst', JSON.serialize(userIdLst));
        System.currentPageReference().getParameters().put('contactId', contactList[0].Id);
        PageReference pr1 = controller.getDealerSigners();
        PageReference pr2 = controller.getManagers();
        PageReference pr3 = controller.removeManagers();
        Map<String, List<String>> res = controller.getPicklistValuesMap();
        //controller.getOpportunityRecord(oppList[0].Id);
        PageReference pr4 = controller.setContactLst();
        
        Test.stopTest();
    }
    
    static testMethod void testMethod2() {
        Test.startTest();
        Opportunity oppList = [select id,Name FROM Opportunity  WHERE Name LIKE '%New Customer'  LIMIT 1];
          system.debug('!!1'+oppList);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppList); 
        MergeTemplatesController controller = new MergeTemplatesController(sc);
        controller.opportunity = oppList;
        Set<String> contactIdLst = new Set<String>();
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name FROM Contact LIMIT 1];
        contactIdLst.add(contactList[0].Id);        
        System.currentPageReference().getParameters().put('contactIdLst', JSON.serialize(contactIdLst));
        pageReference pdfPage = Page.IncentiveAgreementVF;
        pdfPage.getParameters().put('id',oppList.Id);
        controller.getOpportunityRecord(oppList.Id);
        PageReference pr4 = controller.SetDealerSigner();
        PageReference pr5 = controller.createDocument();
        PageReference pr6 = controller.sendDocusignNow();
        //MergeTemplatesController.Response = new MergeTemplatesController.Response(true,'test',);
        Test.stopTest();
    }
    
    static testMethod void testMethod3() {
        Test.startTest();
        Opportunity oppList = [select id,Name FROM Opportunity WHERE Name LIKE '%Existing Dealer'  LIMIT 1];
       system.debug('!!1'+oppList);
       // system.debug('!!1'+oppList.get(0));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oppList); 
        MergeTemplatesControllerPDF controller = new MergeTemplatesControllerPDF(sc);
        controller.opportunity = oppList;
        Set<String> contactIdLst = new Set<String>();
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name FROM Contact LIMIT 1];
        contactIdLst.add(contactList[0].Id);        
        System.currentPageReference().getParameters().put('contactIdLst', JSON.serialize(contactIdLst));
        pageReference pdfPage = Page.IncentiveAgreementVF;
        pdfPage.getParameters().put('id',oppList.Id);
        controller.getOpportunityRecord(oppList.Id);
        PageReference pr = controller.getData();
        Test.stopTest();
    }
    
}