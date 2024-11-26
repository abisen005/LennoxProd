@isTest
private class Test_districtManagerAggregate {
    
    private static Id create_Dealer(String pName, String pDistrict, String pGroup)
    {
        Account newDealer = new Account(); 
        newDealer.Name = pName;
        newDealer.SAP_Sales_Office__c = pDistrict;
        newDealer.SAP_Sales_Group__c = pGroup;
        newDealer.Phone = '123';
        newDealer.ShippingCity = 'City';
        newDealer.ShippingCountry = 'US';
        newDealer.ShippingPostalCode = '123456';
        newDealer.ShippingState = 'TX';
        newDealer.ShippingStreet = 'street';
        insert newDealer;
       
        
        return newDealer.Id;
    }
    
    private static Id create_AccountPlan(String pName, String pYear, Id pDealer)
    {
        //Scorecard__c scorecard = new Scorecard__c();
        //scorecard.Account__c = pDealer;
        //insert scorecard;
        
        Account_Planning__c newAccountPlan = new Account_Planning__c(); 
        newAccountPlan.Name = pName;
        newAccountPlan.Account_Plan_Year__c = pYear;
        newAccountPlan.Dealer__c = pDealer; 
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
        
        return newAccountPlan.Id;

    }
    
    static TestMethod void should_set_year()
    {
        String year = String.valueof(system.today().year());
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
        sfUser2.SAP_Sales_Group__c = 'C2';
        insert sfUser2;
        System.runAS(sfUser){
        Id dealerId = Test_districtManagerAggregate.create_Dealer('Test Dealer', 'C100', 'C1');
        Id accountPlanId = Test_districtManagerAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
        Id dealerId2 = Test_districtManagerAggregate.create_Dealer('Test Dealer2', 'C100', 'C2');
        Id accountPlanId2 = Test_districtManagerAggregate.create_AccountPlan('Test Account Plan2', year, dealerId2);
            
        ApexPages.currentPage().getParameters().put('year', year);
        
        districtManagerAggregate controller = new districtManagerAggregate();
        controller.cancel();
        PageReference page;
        System.debug(controller.year);
        //System.assertEquals(controller.year, Integer.valueOf(year));
        }
    }
    
        static TestMethod void should_retreive_data()
    {
        String year = String.valueof(system.today().year());
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
        System.runAS(sfUser){
        Id dealerId = Test_districtManagerAggregate.create_Dealer('Test Dealer', 'C100','C1');
        Id accountPlanId = Test_districtManagerAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
        
        ApexPages.currentPage().getParameters().put('year', year);
        districtManagerAggregate controller = new districtManagerAggregate();   
        PageReference page;
              
       // System.assertNotEquals(controller.ytdSales, null);
        }
    }
}