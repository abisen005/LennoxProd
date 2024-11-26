@isTest
public class Test_executiveAggregate {
    
    private static Id create_Dealer(String pName, String pArea)
    {
        Account newDealer = new Account(); 
        newDealer.Name = pName;
        newDealer.SAP_Sales_Area__c = pArea;
        newDealer.SAP_Sales_District__c = pArea;
        newDealer.SAP_Sales_Office__c = 'SO1';
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
    
    private static Id create_AccountPlan(String pName, String pYear, Id pDealer)
    {
        Account_Planning__c newAccountPlan = new Account_Planning__c(); 
        newAccountPlan.Name = pName;
        newAccountPlan.Account_Plan_Year__c = pYear;
        //newAccountPlan.Account_Plan_Year__c = '2020';
        newAccountPlan.Dealer__c = pDealer; 
        newAccountPlan.YTD_Sales__c = 100.00;
        newAccountPlan.PY_YTD_Sales__c = 200.00;
        newAccountPlan.Last_Sales_History_Update__c = System.today();
        // newAccountPlan.Opportunity_Scorecard__c =  
        insert newAccountPlan;
        return newAccountPlan.Id;
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
    
    private static Id create_RetentionOpportunity(String pStatus, ID pDealerAccountPlan)
    {
        Retention_Opportunity__c newRetentionOpportunity = new Retention_Opportunity__c();
        newRetentionOpportunity.Dealer_Account_Plan__c = pDealerAccountPlan; 
        newRetentionOpportunity.Retention_Opportunity_Status__c = pStatus; 
        insert newRetentionOpportunity;
        return newRetentionOpportunity.Id; 
    }
    
    static TestMethod void should_set_year()
    {
        String year = String.valueOf(Date.today().year());
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales AM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales EXE';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        System.runAS(sfUser){
            Id dealerId = Test_executiveAggregate.create_Dealer('Test Dealer', 'C100');
            Id accountPlanId = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            
            ApexPages.currentPage().getParameters().put('year', year);
            
            executiveAggregate controller = new executiveAggregate();
            
            PageReference page;
            System.debug(controller.year);
            System.assertEquals(controller.year, Integer.valueOf(year));
        }
    }
    
    static TestMethod void should_retreive_data(){
        
        
        String year = String.valueOf(Date.today().year());
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales AM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales EXE';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxDMAgg.com');
        sfUser2.SAP_Sales_Area__c = 'C100';
        sfUser2.SAP_Sales_District__c = 'C100';
        sfUser2.SAP_Sales_Office__c = 'SO1';
        insert sfUser2;
        
        User sfUser3 = new User(Alias = 'standt', Email='lennoxDMAgg3@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg3@lennoxDMAgg.com');
        sfUser3.SAP_Sales_Area__c = 'C101';
        sfUser3.SAP_Sales_District__c = 'C101';
        sfUser3.SAP_Sales_Office__c = 'SO2';
        insert sfUser3;

        Test.startTest();        
        
        System.runAS(sfUser){
            Id dealerId = Test_executiveAggregate.create_Dealer('Test Dealer', 'C100', 'SO1');
            Id dealerId2 = Test_executiveAggregate.create_Dealer('Test Dealer2', 'C101', 'SO2');      
            Id accountPlanId = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            Id accountPlanId2 = Test_executiveAggregate.create_AccountPlan('Test Account Plan2', year, dealerId2);
            Id opp1 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId, 100);
            Id opp12 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId2, 104);
            Id opp2 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId2, 50);
            Id opp22 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId, 30);
            Id opp3 = Test_executiveAggregate.create_AccountOpportunity('Not Started', accountPlanId, 75);
            Id opp32 = Test_executiveAggregate.create_AccountOpportunity('Not Started', accountPlanId2, 125); 
            Id opp4 = Test_executiveAggregate.create_AccountOpportunity('Cancelled', accountPlanId2, 120);
            Id opp42 = Test_executiveAggregate.create_AccountOpportunity('Cancelled', accountPlanId, 20);
            Id opp5 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId, 20);
            Id opp52 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId2, 120);
            Id ret1 = Test_executiveAggregate.create_RetentionOpportunity('In Progress', accountPlanId);
            Id ret2 = Test_executiveAggregate.create_RetentionOpportunity('Completed', accountPlanId2);
            Id ret3 = Test_executiveAggregate.create_RetentionOpportunity('Not Started', accountPlanId);
            Id ret4 = Test_executiveAggregate.create_RetentionOpportunity('Cancelled', accountPlanId2);
            Id act1 = Test_executiveAggregate.create_ActionPlan('In Progress', accountPlanId);
            Id act2 = Test_executiveAggregate.create_ActionPlan('Completed', accountPlanId2);
            //Id act3 = Test_executiveAggregate.create_ActionPlan('Cancelled', accountPlanId);
            //Id act4 = Test_executiveAggregate.create_ActionPlan('Not Started', accountPlanId2);
            
            
            
            /*  String CRON_EXP = '0 0 0 15 3 ? 2022';
String jobId = System.schedule('ScheduleApexClassTest',
CRON_EXP,
new ExecutiveSummaryBatch());*/
            
            Id accountPlanRecord = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            List<Account_Planning__c> accountPlanList=[Select Id, Account_Plan_Year__c from Account_Planning__c where ID =:accountPlanRecord ];
            system.debug('accountPlanList--'+accountPlanList);
            ExecutiveSummaryBatchStateful batch = new ExecutiveSummaryBatchStateful();
            Database.QueryLocator ql = batch.start(null);
            
            batch.execute(null,accountPlanList);
            //batch.Finish(null);
            
            
            
            database.executeBatch(batch);
            
            Datetime sysTime = System.now();
            sysTime = sysTime.addMinutes(1);
            String chron_exp = ' ' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + 
                ' ' + sysTime.month() + ' ? ' + sysTime.year();
            System.schedule('Last Year Executive batch', chron_exp, new ExecutiveSummaryLastYear_Sch());
            
            
            Test.stopTest();
            
            ApexPages.currentPage().getParameters().put('year', year);
            
            executiveAggregate controller = new executiveAggregate();
            
            PageReference page;
            
            System.assertNotEquals(controller.ytdSales, null);
        }
    }
    
    static TestMethod void should_retreive_data_for_last_year(){
        
        String year = String.valueOf(Date.today().year()-1);
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales AM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales EXE';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxDMAgg.com');
        sfUser2.SAP_Sales_Area__c = 'C100';
        sfUser2.SAP_Sales_District__c = 'C100';
        sfUser2.SAP_Sales_Office__c = 'SO1';
        insert sfUser2;
        
        User sfUser3 = new User(Alias = 'standt', Email='lennoxDMAgg3@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg3@lennoxDMAgg.com');
        sfUser3.SAP_Sales_Area__c = 'C101';
        sfUser3.SAP_Sales_District__c = 'C101';
        sfUser3.SAP_Sales_Office__c = 'SO2';
        insert sfUser3;

        Test.startTest();        
        
        System.runAS(sfUser){
            Id dealerId = Test_executiveAggregate.create_Dealer('Test Dealer', 'C100', 'SO1');
            Id dealerId2 = Test_executiveAggregate.create_Dealer('Test Dealer2', 'C101', 'SO2');      
            Id accountPlanId = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            Id accountPlanId2 = Test_executiveAggregate.create_AccountPlan('Test Account Plan2', year, dealerId2);
            Id opp1 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId, 100);
            Id opp12 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId2, 104);
            Id opp2 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId2, 50);
            Id opp22 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId, 30);
            Id opp3 = Test_executiveAggregate.create_AccountOpportunity('Not Started', accountPlanId, 75);
            Id opp32 = Test_executiveAggregate.create_AccountOpportunity('Not Started', accountPlanId2, 125); 
            Id opp4 = Test_executiveAggregate.create_AccountOpportunity('Cancelled', accountPlanId2, 120);
            Id opp42 = Test_executiveAggregate.create_AccountOpportunity('Cancelled', accountPlanId, 20);
            Id opp5 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId, 20);
            Id opp52 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId2, 120);
            Id ret1 = Test_executiveAggregate.create_RetentionOpportunity('In Progress', accountPlanId);
            Id ret2 = Test_executiveAggregate.create_RetentionOpportunity('Completed', accountPlanId2);
            Id ret3 = Test_executiveAggregate.create_RetentionOpportunity('Not Started', accountPlanId);
            Id ret4 = Test_executiveAggregate.create_RetentionOpportunity('Cancelled', accountPlanId2);
            Id act1 = Test_executiveAggregate.create_ActionPlan('In Progress', accountPlanId);
            Id act2 = Test_executiveAggregate.create_ActionPlan('Completed', accountPlanId2);
            //Id act3 = Test_executiveAggregate.create_ActionPlan('Cancelled', accountPlanId);
            //Id act4 = Test_executiveAggregate.create_ActionPlan('Not Started', accountPlanId2);
            
            
            
            /*String CRON_EXP = '0 0 0 15 3 ? 2022';
String jobId = System.schedule('ScheduleApexClassTest',
CRON_EXP,
new ExecutiveSummaryBatchLastYear());*/
            Date todayDate = Date.today();
            String thisYear = String.valueOf(todayDate.year()-1);
            String pYear = String.valueOf(todayDate.addYears(-1).year());
            ExecutiveSummaryBatchStateful batch = new ExecutiveSummaryBatchStateful(pYear);
            database.executeBatch(batch);
            Test.stopTest();
            
            ApexPages.currentPage().getParameters().put('year', year);
            
            executiveAggregate controller = new executiveAggregate();
            
            PageReference page;
            
            System.assertNotEquals(controller.ytdSales, null);
        }
    }
    
    static TestMethod void should_delete_previous_records_lastyear()
    {
        Test.startTest();
        String year = String.valueOf(Date.today().year()-1);
        Double testValue = 999;
        ExecutiveRollUpMain__c previousRollUp = new ExecutiveRollUpMain__c();
        previousRollUp.Year__c = year; 
        previousRollUp.PY_SalesHistory__c = testValue;
        previousRollUp.Type__c = 'Executive';
        insert previousRollUp; 
        
        List<ExecutiveRollUpChild__c> previousChildRecords = new List<ExecutiveRollUpChild__c>();
        ExecutiveRollUpChild__c previousChildRecord1 = new ExecutiveRollUpChild__c();
        previousChildRecord1.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord1.Type__c = 'Opportunity';
        previousChildRecord1.AdjustedValue__c = testValue;
        previousChildRecords.add(previousChildRecord1); 
        ExecutiveRollUpChild__c previousChildRecord2 = new ExecutiveRollUpChild__c();
        previousChildRecord2.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord2.Type__c = 'Retention';
        previousChildRecord2.PotentialCRIPoints__c = testValue;
        previousChildRecords.add(previousChildRecord2);
        ExecutiveRollUpChild__c previousChildRecord3 = new ExecutiveRollUpChild__c();
        previousChildRecord3.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord3.Type__c = 'ActionPlan';
        previousChildRecord3.NumberOfActionPlans__c = testValue;
        previousChildRecords.add(previousChildRecord3); 
        insert previousChildrecords;
        
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales AM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales EXE';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxDMAgg.com');
        sfUser2.SAP_Sales_Area__c = 'C100';
        sfUser2.SAP_Sales_District__c = 'C100';
        sfUser2.SAP_Sales_Office__c = 'SO1';
        insert sfUser2;
        
        User sfUser3 = new User(Alias = 'standt', Email='lennoxDMAgg3@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg3@lennoxDMAgg.com');
        sfUser3.SAP_Sales_Area__c = 'C101';
        sfUser3.SAP_Sales_District__c = 'C101';
        sfUser3.SAP_Sales_Office__c = 'SO2';
        insert sfUser3;
        
        System.runAS(sfUser){
            Id dealerId = Test_executiveAggregate.create_Dealer('Test Dealer', 'C100', 'SO1');
            Id dealerId2 = Test_executiveAggregate.create_Dealer('Test Dealer2', 'C101', 'SO2');      
            Id accountPlanId = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            Id accountPlanId2 = Test_executiveAggregate.create_AccountPlan('Test Account Plan2', year, dealerId2);
            Id opp1 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId, 100);
            Id opp12 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId2, 104);
            Id opp2 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId2, 50);
            Id opp5 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId, 20);
            Id opp52 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId2, 120);
            Id ret1 = Test_executiveAggregate.create_RetentionOpportunity('In Progress', accountPlanId);
            Id ret2 = Test_executiveAggregate.create_RetentionOpportunity('Completed', accountPlanId2);
            Id act1 = Test_executiveAggregate.create_ActionPlan('In Progress', accountPlanId);
            Id act2 = Test_executiveAggregate.create_ActionPlan('Completed', accountPlanId2);
            Id act3 = Test_executiveAggregate.create_ActionPlan('Cancelled', accountPlanId);
            Id act4 = Test_executiveAggregate.create_ActionPlan('Not Started', accountPlanId2);
            
            
            
            /* String CRON_EXP = '0 0 0 15 3 ? 2022';
String jobId = System.schedule('ScheduleApexClassTest',
CRON_EXP,
new ExecutiveSummaryBatchLastYear());*/
            Date todayDate = Date.today();
            String thisYear = String.valueOf(todayDate.year());
            String pYear = String.valueOf(todayDate.addYears(-1).year());
            ExecutiveSummaryBatchStateful batch = new ExecutiveSummaryBatchStateful(pYear);
            database.executeBatch(batch);
            Test.stopTest();
            
            ApexPages.currentPage().getParameters().put('year', year);
            
            executiveAggregate controller = new executiveAggregate();
            
            PageReference page;
            
            List<ExecutiveRollUpMain__c> testPreviousMainRecords = [SELECT Id, PY_SalesHistory__c FROM ExecutiveRollUpMain__c WHERE Type__c = 'Executive' AND Year__c =: year];
            for(ExecutiveRollUpMain__c record: testPreviousMainRecords)
            {
                if(record.PY_SalesHistory__c == testValue)
                {
                    System.assert(false);
                }
            }
            List<ExecutiveRollUpChild__c> testPreviousChildRecords = [SELECT Id, AdjustedValue__c, PotentialCRIPoints__c, NumberOfActionPlans__c FROM executiveRollUpChild__c];
            for(ExecutiveRollUpChild__c record: testPreviousChildRecords)
            {
                if(record.AdjustedValue__c == testValue || record.PotentialCRIPoints__c == testValue || record.NumberOfActionPlans__c == testValue)
                {
                    System.assert(false);
                }
            }
        }
    }
    
    static TestMethod void should_delete_previous_records_thisyear()
    {
        Test.startTest();
        String year = String.valueOf(Date.today().year());
        Double testValue = 999;
        ExecutiveRollUpMain__c previousRollUp = new ExecutiveRollUpMain__c();
        previousRollUp.Year__c = year; 
        previousRollUp.PY_SalesHistory__c = testValue;
        previousRollUp.Type__c = 'Executive';
        insert previousRollUp; 
        
        List<ExecutiveRollUpChild__c> previousChildRecords = new List<ExecutiveRollUpChild__c>();
        ExecutiveRollUpChild__c previousChildRecord1 = new ExecutiveRollUpChild__c();
        previousChildRecord1.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord1.Type__c = 'Opportunity';
        previousChildRecord1.AdjustedValue__c = testValue;
        previousChildRecords.add(previousChildRecord1); 
        ExecutiveRollUpChild__c previousChildRecord2 = new ExecutiveRollUpChild__c();
        previousChildRecord2.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord2.Type__c = 'Retention';
        previousChildRecord2.PotentialCRIPoints__c = testValue;
        previousChildRecords.add(previousChildRecord2);
        ExecutiveRollUpChild__c previousChildRecord3 = new ExecutiveRollUpChild__c();
        previousChildRecord3.ExecutiveRollUpMain__c = previousRollUp.Id;
        previousChildRecord3.Type__c = 'ActionPlan';
        previousChildRecord3.NumberOfActionPlans__c = testValue;
        previousChildRecords.add(previousChildRecord3); 
        insert previousChildrecords;
        
        AggregateReportsSettings__c profilesettings = new AggregateReportsSettings__c();
        profilesettings.Territory_Access__c = 'Lennox - Res Sales TM';
        profilesettings.District_Access__c = 'Lennox - Res Sales DM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales AM';
        profilesettings.Region_Access__c = 'Lennox - Res Sales EXE';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        
        User sfUser2 = new User(Alias = 'standt', Email='lennoxDMAgg2@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg2@lennoxDMAgg.com');
        sfUser2.SAP_Sales_Area__c = 'C100';
        sfUser2.SAP_Sales_District__c = 'C100';
        sfUser2.SAP_Sales_Office__c = 'SO1';
        insert sfUser2;
        
        User sfUser3 = new User(Alias = 'standt', Email='lennoxDMAgg3@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg3@lennoxDMAgg.com');
        sfUser3.SAP_Sales_Area__c = 'C101';
        sfUser3.SAP_Sales_District__c = 'C101';
        sfUser3.SAP_Sales_Office__c = 'SO2';
        insert sfUser3;
        
        System.runAS(sfUser){
            Id dealerId = Test_executiveAggregate.create_Dealer('Test Dealer', 'C100', 'SO1');
            Id dealerId2 = Test_executiveAggregate.create_Dealer('Test Dealer2', 'C101', 'SO2');      
            Id accountPlanId = Test_executiveAggregate.create_AccountPlan('Test Account Plan', year, dealerId);
            Id accountPlanId2 = Test_executiveAggregate.create_AccountPlan('Test Account Plan2', year, dealerId2);
            Id opp1 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId, 100);
            Id opp12 = Test_executiveAggregate.create_AccountOpportunity('In Progress', accountPlanId2, 104);
            Id opp2 = Test_executiveAggregate.create_AccountOpportunity('Completed', accountPlanId2, 50);
            Id opp5 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId, 20);
            Id opp52 = Test_executiveAggregate.create_AccountOpportunity('On Hold', accountPlanId2, 120);
            Id ret3 = Test_executiveAggregate.create_RetentionOpportunity('Not Started', accountPlanId);
            Id ret4 = Test_executiveAggregate.create_RetentionOpportunity('Cancelled', accountPlanId2);
            Id act1 = Test_executiveAggregate.create_ActionPlan('In Progress', accountPlanId);
            Id act2 = Test_executiveAggregate.create_ActionPlan('Completed', accountPlanId2);
            Id act3 = Test_executiveAggregate.create_ActionPlan('Cancelled', accountPlanId);
            Id act4 = Test_executiveAggregate.create_ActionPlan('Not Started', accountPlanId2);
            
            
            /* String CRON_EXP = '0 0 0 15 3 ? 2022';
String jobId = System.schedule('ScheduleApexClassTest',
CRON_EXP,
new ExecutiveSummaryBatch());*/
            ExecutiveSummaryBatchStateful batch = new ExecutiveSummaryBatchStateful();
            database.executeBatch(batch);
            Test.stopTest();
            
            ApexPages.currentPage().getParameters().put('year', year);
            
            executiveAggregate controller = new executiveAggregate();
            
            PageReference page;
            
            List<ExecutiveRollUpMain__c> testPreviousMainRecords = [SELECT Id, PY_SalesHistory__c FROM ExecutiveRollUpMain__c WHERE Type__c = 'Executive' AND Year__c =: year];
            for(ExecutiveRollUpMain__c record: testPreviousMainRecords)
            {
                if(record.PY_SalesHistory__c == testValue)
                {
                    System.assert(false);
                }
            }
            List<ExecutiveRollUpChild__c> testPreviousChildRecords = [SELECT Id, AdjustedValue__c, PotentialCRIPoints__c, NumberOfActionPlans__c FROM executiveRollUpChild__c];
            for(ExecutiveRollUpChild__c record: testPreviousChildRecords)
            {
                if(record.AdjustedValue__c == testValue || record.PotentialCRIPoints__c == testValue || record.NumberOfActionPlans__c == testValue)
                {
                    System.assert(false);
                }
            }
        }
    }
    
    static TestMethod void should_create_task_in_salesforce()
    {
        AggregateReportsSettings__c reportSettings = new AggregateReportsSettings__c();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com');
        sfUser.SAP_Sales_Area__c = 'C100';
        sfUser.SAP_Sales_District__c = 'C100';
        insert sfUser;
        reportSettings.Task_User_Id__c = sfUser.Id; 
        insert reportSettings;
        
        ExecutiveSummaryUtils.CreateErrorTask('Error Task');
        List<Task> testTasks = [SELECT Id, OwnerId, Description FROM Task];
        for(Task aTask: testTasks)
        {
            if(aTask.OwnerId != sfUser.Id || aTask.Description != 'Error Task')
            {
                System.assert(true);
            }
        }
        
        if(testTasks == null || testTasks.isEmpty())
        {
            System.assert(false);
        }
    }
}