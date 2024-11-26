/*
* @ Purpose      : This class is used to test the functionality of DealerAlertCmpController.                   
* @ CreatedDate  : 7/5/2019
*/
@IsTest
private class DealerAlertCmpControllerTest {
    
    
    /* 
* @Purpose      : this function used to create test data.
* @Parameter    : -
* @Returntype   : -
*/
    @testSetup
    private static void testData(){
        
        //Create Account record
        Account account = createAccount();
        Insert account;
        
        Id devRecordTypeId = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
        
        FTL_Program_Form__c pf = createProgramForm(devRecordTypeId);
        Insert pf;
        
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Contact').getRecordTypeId();
        Contact contactRec = new Contact(RecordTypeId = recordTypeId, Contact_Type__c = 'Partner', FirstName = 'Test',
                                         LastName = 'Contact', AccountId = account.Id, Email = 'test@gmail.com');
        Insert contactRec;
        
       // createUser();
    }
    
    /* 
* @Purpose      : this function used to test functionality of DealerAlertCmpController.
* @Parameter    : -
* @Returntype   : -
*/
    @IsTest
    private static void testDealerAlertCmpController(){ 
        
        Contact con = [Select Id FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community Plus - FTL%' Limit 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ContactId = con.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        
        System.runAs(u) {
            
            DealerAlertCmpController.Response res = DealerAlertCmpController.getOnloadData();
            //System.assertEquals(res.isSuccess, true);
        }
    }
    
    @IsTest
    private static void testGetLoginContactDetials(){ 
        
        Contact con = [Select Id FROM Contact Where LastName = 'Contact' LIMIT 1];
        
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community Plus - FTL%' Limit 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ContactId = con.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        
        System.runAs(u) {
            
            Contact result = DealerAlertCmpController.getLoginContactDetials();
            //System.assertEquals(res.isSuccess, true);
        }
    }
    
    /* 
* @Purpose      : this function used to create FTL_Program_Form__c.
* @Parameter    : String recordTypeId
* @Returntype   : FTL_Program_Form__c
*/
    private static FTL_Program_Form__c createProgramForm(String recordTypeId){
        FTL_Program_Form__c  pf = new FTL_Program_Form__c();
        pf.Nominee_Name__c = 'Test';
        pf.Nominee_City__c = 'Austin';
        pf.Nominee_State__c = 'TX';
        pf.Nominee_Street_Address__c = '123 main st';
        pf.Nominee_Zip_Code__c = '12345';
        pf.Nominee_Phone_Number__c = '9999999999';
        pf.Status__c = 'Assigned';
        pf.RecordTypeId = recordTypeId;
        
        return pf;
    }   
    
    //Method to create Account records
    private static Account createAccount(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
        Account accountRec = new Account(RecordTypeId = recordTypeId, Name = 'Test Account',AccountNumber = '12345',Phone ='123',
                                         ShippingCity ='Nashik',ShippingStreet = 'Nashik Road',ShippingCountry = 'India',
                                         ShippingPostalCode = '12345',ShippingState = 'Maharashtra');
        return accountRec;
    }
    
}