@isTest
public class ExecutiveSummary_Test {
    
    @isTest
    private static void scheduleBatches(){
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%AM%' LIMIT 1];
                User uu = new User(Alias = 'standt', SAP_Sales_District__c = 'C100' , Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');

        insert uu;
        
        System.runAS(uu){
            Id dealerId = ExecutiveSummary_Test.create_Dealer('Test Dealer', 'C100', 'SO1');
            Id dealerId2 = ExecutiveSummary_Test.create_Dealer('Test Dealer2', 'C101', 'SO2');  
            
            
            //Id accountPlanId = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan',  , dealerId);
            
            Id accountPlanId = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan', String.valueOf( system.today().addYears(-1).year()), dealerId);
            Id accountPlanId2 = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan2', String.valueOf( system.today().addYears(-1).year()), dealerId2);
            Id accountPlanId3 = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan', String.valueOf( system.today().addYears(-1).year()), dealerId);
            Id accountPlanId4 = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan2', String.valueOf( system.today().addYears(-1).year()), dealerId2);
            
            
           // Id opp1 = ExecutiveSummary_Test.create_AccountOpportunity('In Progress', accountPlanId, 100);
           // Id ret1 = ExecutiveSummary_Test.create_RetentionOpportunity('In Progress', accountPlanId);
            
            Id opp1 = ExecutiveSummary_Test.create_AccountOpportunity('In Progress', accountPlanId, 100);
            Id opp12 = ExecutiveSummary_Test.create_AccountOpportunity('In Progress', accountPlanId2, 104);
            Id opp2 = ExecutiveSummary_Test.create_AccountOpportunity('Completed', accountPlanId2, 50);
            Id opp22 = ExecutiveSummary_Test.create_AccountOpportunity('Completed', accountPlanId, 30);
            Id opp3 = ExecutiveSummary_Test.create_AccountOpportunity('Not Started', accountPlanId, 75);
            Id opp32 = ExecutiveSummary_Test.create_AccountOpportunity('Not Started', accountPlanId2, 125); 
            Id opp4 = ExecutiveSummary_Test.create_AccountOpportunity('Cancelled', accountPlanId2, 120);
            Id opp42 = ExecutiveSummary_Test.create_AccountOpportunity('Cancelled', accountPlanId, 20);
            Id opp5 = ExecutiveSummary_Test.create_AccountOpportunity('On Hold', accountPlanId, 20);
            Id opp52 = ExecutiveSummary_Test.create_AccountOpportunity('On Hold', accountPlanId2, 120);
            Id ret1 = ExecutiveSummary_Test.create_RetentionOpportunity('In Progress', accountPlanId);
            Id ret2 = ExecutiveSummary_Test.create_RetentionOpportunity('Completed', accountPlanId2);
            Id ret3 = ExecutiveSummary_Test.create_RetentionOpportunity('Not Started', accountPlanId);
            Id ret4 = ExecutiveSummary_Test.create_RetentionOpportunity('Cancelled', accountPlanId2);
            
            
            Test.startTest();
           
            Datetime sysTime = System.now();
            sysTime = sysTime.addMinutes(1);
            String chron_exp = ' ' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + 
                ' ' + sysTime.month() + ' ? ' + sysTime.year();
            //System.schedule('Last Year Executive batch', chron_exp, new ExecutiveSummaryLastYear_Sch());
            //System.schedule('Current Year Executive batch', chron_exp, new ExecutiveSummary_Sch());
            Database.executeBatch(new ExecutiveSummaryBatchLastYear());
            Database.executeBatch(new ExecutiveSummaryBatch());       
            
            Test.stopTest();
            
        }
    }
    
    @isTest
    private static void scheduleBatches_2(){
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%AM%' LIMIT 1];
                User uu = new User(Alias = 'standt', SAP_Sales_District__c = 'C100' , Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');

        insert uu;
        
        Id dealerId = ExecutiveSummary_Test.create_Dealer('Test Dealer', 'C100', 'SO1');
        Id accountPlanId = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan', String.valueOf( system.today().year()) , dealerId);
        
        Id opp1 = ExecutiveSummary_Test.create_AccountOpportunity('In Progress', accountPlanId, 100);
        Id ret1 = ExecutiveSummary_Test.create_RetentionOpportunity('In Progress', accountPlanId);
            
        Id act1 = ExecutiveSummary_Test.create_ActionPlan('In Progress', accountPlanId);
            
        Test.startTest();
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addMinutes(1);
        String chron_exp = ' ' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + 
            ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('Last Year Executive batch', chron_exp, new ExecutiveSummaryLastYear_Sch());
        System.schedule('Current Year Executive batch', chron_exp, new ExecutiveSummary_Sch());
        Database.executeBatch(new ExecutiveSummaryBatchLastYear());
         
        Test.stopTest();
    }
    
    @isTest
    private static void scheduleBatchesThisYear(){
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%AM%' LIMIT 1];
                User uu = new User(Alias = 'standt', SAP_Sales_District__c = 'C100' , Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');

        insert uu;
        
        Id dealerId = ExecutiveSummary_Test.create_Dealer('Test Dealer', 'C100', 'SO1');
        Id accountPlanId = ExecutiveSummary_Test.create_AccountPlan('Test Account Plan', String.valueOf( system.today().year()) , dealerId);
        
        Id opp1 = ExecutiveSummary_Test.create_AccountOpportunity('In Progress', accountPlanId, 100);
        Id ret1 = ExecutiveSummary_Test.create_RetentionOpportunity('In Progress', accountPlanId);
            
        Id act1 = ExecutiveSummary_Test.create_ActionPlan('In Progress', accountPlanId);
        
        
        Test.startTest();
        Database.executeBatch(new ExecutiveSummaryBatch());       
         
        Test.stopTest();
    }
    
    private static void createAccountPlans(String year, Account dealer){
		List<Account_Planning__c> accountPlanings = new List<Account_Planning__c>();
        for(Integer indx=0; indx < 10; indx++){
            accountPlanings.add(new Account_Planning__c(
                Account_Plan_Year__c=string.valueOf(year+indx), 
                Dealer__c = dealer.Id));
        }
        insert accountPlanings;
     }
    
    
    private static Id create_AccountPlan(String pName, String pYear, Id pDealer)
    {
        Account_Planning__c newAccountPlan = new Account_Planning__c(); 
        newAccountPlan.Name = pName;
        newAccountPlan.Account_Plan_Year__c = pYear;
        //newAccountPlan.Account_Plan_Year__c = '2020';
        newAccountPlan.Dealer__c = pDealer; 
        newAccountPlan.YTD_Sales__c = 100.00;
        newAccountPlan.PY_YTD_Sales__c = 200.00;
        // newAccountPlan.Opportunity_Scorecard__c =  
        insert newAccountPlan;
        return newAccountPlan.Id;
    }
    
    private static Id create_Dealer(String pName, String pArea, String pOffice)
    {
        Account newDealer = new Account(); 
        newDealer.Name = pName;
        newDealer.SAP_Sales_Area__c = pArea;
        newDealer.SAP_Sales_District__c = pArea;
        newDealer.SAP_Sales_Office__c = pOffice;
        newDealer.Phone = '22143245';
        newDealer.ShippingStreet = 'test';
        newDealer.ShippingPostalCode = 'test1234';
        newDealer.ShippingState = 'Test';
        newDealer.ShippingCity = 'testing';
        newDealer.ShippingCountry = 'test';
        newDealer.Lead_Source__c = 'test';
        insert newDealer;
        return newDealer.Id;
    }
    
    private static Id create_AccountOpportunity(String pStatus, ID pDealerAccountPlan, Decimal adjValue)
    {
        Account_Opportunty__c newAccountOpportunity = new Account_Opportunty__c(); 
        newAccountOpportunity.Dealer_Account_Plan__c = pDealerAccountPlan;
        newAccountOpportunity.Opportunity_Status__c = pStatus;
        newAccountOpportunity.Adjusted_Value__c = adjValue;
        insert newAccountOpportunity; 
        return newAccountOpportunity.Id; 
    }
    
    private static Id create_RetentionOpportunity(String pStatus, ID pDealerAccountPlan)
    {
        Retention_Opportunity__c newRetentionOpportunity = new Retention_Opportunity__c();
        newRetentionOpportunity.Dealer_Account_Plan__c = pDealerAccountPlan; 
        newRetentionOpportunity.Retention_Opportunity_Status__c = pStatus; 
        insert newRetentionOpportunity;
        return newRetentionOpportunity.Id; 
    }
    
    private static Id create_ActionPlan(String pStatus, ID pDealerAccountPlan)
    {
        Action_Plan__c newActionPlan = new Action_Plan__c(); 
        newActionPlan.Account_Plan__c = pDealerAccountPlan; 
        newActionPlan.Action_Status__c = pStatus; 
        newActionPlan.Action_Type__c = 'Conversion';
        newActionPlan.Action__c = 'Update Contacts';
        insert newActionPlan;
        return newActionPlan.Id;
    }
}