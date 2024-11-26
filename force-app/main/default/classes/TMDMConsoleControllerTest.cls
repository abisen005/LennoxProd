@isTest
private class TMDMConsoleControllerTest {

    
    static testMethod void testTMDMConsoleControllerMethods() {
        
        String currentYear = String.valueOf(System.Today().year());
        
        ////////////////////////
        ////CREATE TEST DATA////
        ////////////////////////
        
        //create account
        Account testAcc = new Account(Name = 'Test');
        testAcc.Name = 'Test';
        testAcc.SAP_YTD_Sales__c = 500;
        testAcc.phone = '1234567890';
        testAcc.ShippingCity = 'test';
        testAcc.ShippingStreet = 'test';
        testAcc.ShippingState = 'test';
        testAcc.ShippingCountry = 'test';
        testAcc.ShippingPostalCode = '12345';
        insert testAcc;
        
        //create related contacts
        final Integer NUM_CONTACTS = 3;
        Contact[] testContacts = new List<Contact>();
        for(Integer i = 0; i < NUM_CONTACTS; i++) {
            testContacts.add(new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAcc.Id, Email = 'test@test.com',
                                        MobilePhone = '0987654321', phone = '1234567890'));
        }
        insert testContacts;
        
        //create opportunity scorecard
        Scorecard__c testScorecard = new Scorecard__c();
        testScorecard.Account__c = testAcc.Id;
        insert testScorecard;
        
        //create account plan
        Account_Planning__c testAccPlan = new Account_Planning__c();
        testAccPlan.Dealer__c = testAcc.Id;
        testAccPlan.Name = 'Test Account Plan';
        testAccPlan.Account_Plan_Year__c = currentYear;
        testAccPlan.Opportunity_Scorecard__c = testScorecard.Id;
        insert testAccPlan;
        
        //create retention opportunities
        Retention_Opportunity__c[] testRetentionOpps = new List<Retention_Opportunity__c>();
        final Integer NUM_RET_OPPS = 3;
        for(Integer i = 0; i < NUM_RET_OPPS; i++) {
            Retention_Opportunity__c retentionOpp = new Retention_Opportunity__c();
            retentionOpp.Dealer_Account_Plan__c = testAccPlan.Id;
            retentionOpp.Retention_Opportunity_Status__c = 'In Progress';
            testRetentionOpps.add(retentionOpp);
        }
        insert testRetentionOpps;
        
        //create account opportunities
        Account_Opportunty__c[] testAccountOpps = new List<Account_Opportunty__c>();
        final Integer NUM_ACCOUNT_OPPS = 3;
        for(Integer i = 0; i < NUM_ACCOUNT_OPPS; i++) {
            Account_Opportunty__c testAccountOpp = new Account_Opportunty__c();
            testAccountOpp.Dealer_Account_Plan__c = testAccPlan.Id;
            testAccountOpp.Opportunity_Status__c = 'In Progress';
        }
        insert testAccountOpps;
        
        //create action plans
        Action_Plan__c[] testActionPlans = new List<Action_Plan__c>();
        final Integer NUM_ACTION_PLANS = 3;
        for(Integer i = 0; i < NUM_ACTION_PLANS; i++) {
            Action_Plan__c testActionPlan = new Action_Plan__c();
            testActionPlan.Action_Status__c = 'In Progress';
            testActionPlan.Account_Plan__c = testAccPlan.Id;
        }
        insert testActionPlans;
        
        //create event
        Event testEvent = new Event();
        testEvent.Event_Type__c = 'Meeting';
        testEvent.WhatId = testAcc.Id;
        testEvent.ActivityDateTime = System.Now();
        testEvent.DurationInMinutes = 60;
        insert testEvent;
        
        //create retention record
        Retention__c testRetention = new Retention__c();
        testRetention.CRI_Score__c = 50;
        testRetention.Retention_Calendar_Date__c = System.Today();
        testRetention.Account__c = testAcc.Id;
        insert testRetention;
        
        //create retention history record
        Retention_History__c testRetentionHistory = new Retention_History__c();
        testRetentionHistory.CRI_Score__c = 51;
        testRetentionHistory.Retention_Calendar_Date__c = System.Today().addYears(-1);
        testRetentionHistory.Dealer_Name__c = testAcc.Id;
        insert testRetentionHistory;
        
        
        
        
        ////////////////////////
        //////BEGIN TESTS///////
        ////////////////////////
        
        //test getAccount()
        Account retrievedAccount = TMDMConsoleController.getAccount(testAcc.Id);
        System.assertEquals(retrievedAccount.Id, testAcc.Id);
        
        //test getAccountContacts()
        Contact[] retrievedContacts = TMDMConsoleController.getAccountContacts(testAcc.Id);
        System.assertEquals(retrievedContacts.size(), testContacts.size());

        //test getCurrentAccountPlan()
        Account_Planning__c retrievedAccountPlan = TMDMConsoleController.getCurrentAccountPlan(testAcc.Id);
        System.assertEquals(retrievedAccountPlan.Id, testAccPlan.Id);
        
        //test getOpenRetentionOpportunities()
        Retention_Opportunity__c[] retrievedRetentionOpps = TMDMConsoleController.getOpenRetentionOpportunities(testAccPlan.Id);
        System.assertEquals(retrievedRetentionOpps.size(), testRetentionOpps.size());
        
        //test getActionPlans()
        Action_Plan__c[] retrievedActionPlans = TMDMConsoleController.getActionPlans(testAccPlan.Id);
        System.assertEquals(retrievedActionPlans.size(), testActionPlans.size());
        
        //test getAccountOpps()
        Account_Opportunty__c[] retrievedAccountOpps = TMDMConsoleController.getAccountOpps(testAccPlan.Id);
        System.assertEquals(retrievedAccountOpps.size(), testAccountOpps.size());
        
        //test getLatestMeeting
        Event retrievedEvent = TMDMConsoleController.getLatestMeeting(testAcc.Id);
        System.assertEquals(retrievedEvent.Id, testEvent.Id);
        
        //test getRetentionHistoryData()
        TMDMConsoleController.MetricDetail retrievedRetentionData = TMDMConsoleController.getRetentionHistoryData(testAcc.Id);
        System.assertEquals(retrievedRetentionData.primaryValue, String.valueOf(testRetention.CRI_Score__c));
        System.assertEquals(retrievedRetentionData.secondaryValue, String.valueOf(testRetentionHistory.CRI_Score__c));
        
        //test getNewEvent()
        Event newEvent = TMDMConsoleController.getNewEvent(testAcc.Id);
        System.assertEquals(newEvent.WhatId, testAcc.Id);
        
        //test getYTDSalesData()
        retrievedAccount = TMDMConsoleController.getYTDSalesData(testAcc.Id);
        System.assertEquals(retrievedAccount.Id, testAcc.Id);
        
        //test getAccountPlanAndAccountOpps()
        retrievedAccountPlan = TMDMConsoleController.getAccountPlanAndAccountOpps(testAcc.Id);
        System.assertEquals(retrievedAccountPlan.Id, testAccPlan.Id);
        
        //test getOpportunityScorecard
        Scorecard__c retrievedScorecard = TMDMConsoleController.getOpportunityScorecard(testAcc.Id);
        System.assertEquals(retrievedScorecard.Id, testScorecard.Id);
        
        //test upsertAccount()
        Account upsertAccount = TMDMConsoleController.upsertAccount(testAcc);
        System.assertEquals(upsertAccount.Id, testAcc.Id);
        
        TMDMConsoleController.getpicklistValues();
    }
    
    
}