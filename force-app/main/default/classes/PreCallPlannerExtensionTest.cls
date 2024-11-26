@isTest
private class PreCallPlannerExtensionTest {

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
        insert evt;

        PreCallPlanner__c pc = new PreCallPlanner__c(Event_Id__c = evt.id);
        insert pc;

        Retention__c ret = new Retention__c(Account__c = acc.Id);
        insert ret;

        Test.StartTest();
        PageReference pageRef = Page.TMPreCallPlanner;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('aid', acc.Id);
        ApexPages.currentPage().getParameters().put('id', evt.Id);
        ApexPages.currentPage().getParameters().put('isCallFromAction', 'True');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(evt);
        PreCallPlannerExtension ext = new PreCallPlannerExtension(sc);
        ext.precallPlannerObj  = pc;
        ext.saveAndReturnToEvt();
        ext.saveAndRefresh();
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
        insert evt;

        PreCallPlanner__c pc = new PreCallPlanner__c();
        insert pc;

        Retention__c ret = new Retention__c(Account__c = acc.Id);
        insert ret;

        Test.StartTest();
        PageReference pageRef = Page.TMPreCallPlanner;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('aid', acc.Id);
        ApexPages.currentPage().getParameters().put('id', null);
        ApexPages.StandardController sc = new ApexPages.StandardController(evt);
        PreCallPlannerExtension ext = new PreCallPlannerExtension(sc);

        ext.saveAndReturnToEvt();
    }
    
    static testmethod void test2() {

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
        insert evt;

        PreCallPlanner__c pc = new PreCallPlanner__c(Event_Id__c = evt.id);
        insert pc;

        Retention__c ret = new Retention__c(Account__c = acc.Id);
        insert ret;

        Test.StartTest();
        PageReference pageRef = Page.TMPreCallPlanner;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', evt.Id);
        ApexPages.currentPage().getParameters().put('isCallFromAction', 'True');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(evt);
        PreCallPlannerExtension ext = new PreCallPlannerExtension(sc);
        ext.precallPlannerObj  = pc;
        ext.saveAndReturnToEvt();
        ext.saveAndRefresh();
    }

}