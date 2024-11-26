@istest(seeAllData = true)

Public class HighPriorityAlertsController2_Test
{
    static testmethod void unitTest1() 
    {
        test.startTest();
        
        Account a = createAccount('Test', 'US');
        //insert a;
        
        Task t1 = new Task(SUBJECT='Test', Record_To_Navigate_to__c=a.Id, ACTIVITYDATE=System.Today().addDays(2),Alert_Type_Id__c='10');
        Task t2 = new Task(SUBJECT='Test2', Record_To_Navigate_to__c=a.Id, ACTIVITYDATE=System.Today().addDays(4),Alert_Type_Id__c='1');
        Task t3 = new Task(SUBJECT='Test3', Record_To_Navigate_to__c=a.Id, ACTIVITYDATE=System.Today().addDays(6),Alert_Type_Id__c='22');
        insert t1;
        insert t2;
        insert t3;
        
        HighPriorityAlertsController2 ct = new HighPriorityAlertsController2();
        HighPriorityAlertsController2.showPopup(0);
        HighPriorityAlertsController2.autoCompleteT(0);
        HighPriorityAlertsController2.createEventT(0);
        HighPriorityAlertsController2.navigateToRecordT(0);

        test.stopTest();
    }
    
    static testmethod void unitTest2() 
    {
        test.startTest();
        
        Account a = createAccount('Test', 'US');
        //insert a;
        
        Task t1 = new Task(SUBJECT='Test', Record_To_Navigate_to__c=a.Id, ACTIVITYDATE=System.Today().addDays(2),Alert_Type_Id__c='10');
        Task t2 = new Task(SUBJECT='Test2', Record_To_Navigate_to__c=a.Id, ACTIVITYDATE=System.Today().addDays(4),Alert_Type_Id__c='1');
        Task t3 = new Task(SUBJECT='Test3', ACTIVITYDATE=System.Today().addDays(6),Alert_Type_Id__c='22');
        insert t1;
        insert t2;
        insert t3;
        
        HighPriorityAlertsController2 ct = new HighPriorityAlertsController2();
        //HighPriorityAlertsController2.showPopup(0);
        //HighPriorityAlertsController2.autoCompleteT(0);
        //HighPriorityAlertsController2.createEventT(0);
        HighPriorityAlertsController2.navigateToRecordT(2);

        test.stopTest();
    }
    
     private static Account createAccount(String accName, String countryCode) {
        Account acc = new Account(Name = accName, BillingStreet = '123 Main St', BillingCity = 'Chicago', BillingState = 'IL', BillingPostalCode = '60603',
                                  BillingCountry = countryCode, Federal_Tax_ID__c = '123456789',Payment_Terms__c = 'A101', SAP_Customer_Number__c='TGy67588');
        insert acc;
        return acc;
    }
}