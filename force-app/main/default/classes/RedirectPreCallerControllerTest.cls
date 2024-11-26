@isTest
public class RedirectPreCallerControllerTest {

    
    static testmethod void test() {
        
        Account acc = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                  SAP_YTD_Sales__c=200, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                  Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                  Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
        acc.Phone = '123456789';
        acc.ShippingCity = 'city';
        acc.ShippingCity = 'state';
        acc.ShippingPostalCode = '123456';
        acc.ShippingStreet = 'test';
        acc.Lead_Source__c = 'test';
        acc.SAP_Customer_Number__c  = 'c3';
        insert acc;
        
        Event evt = new Event();
        evt.ActivityDateTime = System.now();
        evt.DurationInMinutes = 60;
        evt.WhatId = acc.Id;
        evt.Event_Type__c = 'Phone Call - Outbound' ;
        insert evt;
        
        PreCallPlanner__c pc = new PreCallPlanner__c(Event_Id__c = evt.id);
        insert pc;
        
        Retention__c ret = new Retention__c(Account__c = acc.Id);
        insert ret;
        
        Test.StartTest();
        PageReference pageRef = Page.RedirectPreCaller;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', evt.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(evt);
        RedirectPreCallerController ext = new RedirectPreCallerController(sc);
        ext.redirect();
    }
    
    static testmethod void test1() {
        
        Account acc = new Account(Name = 'Test Account1', BillingCity = 'city',BillingState = 'state',Prior_Year_YTD_Sales__c = 125,
                                  SAP_YTD_Sales__c=200, SAP_Sales_Group__c = '215', SAP_Customer_Number__c = null,
                                  Pricing_Zone__c = 'NY', location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                  Aire_Serv__c=true, SAP_Premier_Dealer__c=null);
        acc.Phone = '123456789';
        acc.ShippingCity = 'city';
        acc.ShippingCity = 'state';
        acc.ShippingPostalCode = '123456';
        acc.ShippingStreet = 'test';
        acc.Lead_Source__c = 'test';
        acc.SAP_Customer_Number__c  = 'c3';
        insert acc;
        
        Event evt = new Event();
        evt.ActivityDateTime = System.now();
        evt.DurationInMinutes = 60;
        evt.WhatId = acc.Id;
        evt.Event_Type__c = 'Meeting' ;
        insert evt;
        
        PreCallPlanner__c pc = new PreCallPlanner__c();
        insert pc;
        
        Retention__c ret = new Retention__c(Account__c = acc.Id);
        insert ret;
        
        Test.StartTest();
        PageReference pageRef = Page.RedirectPreCaller;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(evt);
        RedirectPreCallerController ext = new RedirectPreCallerController(sc);
        ext.redirect();
    }
    
}