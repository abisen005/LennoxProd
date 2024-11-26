@IsTest
public with sharing class LightningSelfRegisterControllerTest {
    @testSetup
    private static void  dataSetup(){
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE IsActive = true AND userRoleId = :sampleUserRole.Id LIMIT 1];
        Id pId = [select id from profile where name='Feel the Love Community'].id;
        
        System.runAs(admin){
            Account ac = new Account(name ='Grazitti', Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='12345', 
                                     SAP_Customer_Number__c = '23',
                                     FTL_Eligibility__c = 'Eligible',
                                     DS_Completion_Date__c=System.today()) ;
            insert ac;
            Contact con = new Contact(LastName ='testCon',
                                      AccountId = ac.Id, 
                                      Phone='1234322', 
                                      Email='tester@'+System.currentTimeMillis()+'.com', 
                                      FirstName='FName');
            insert con;  
            
            User user = new User(alias = 'test3434', email='test@sharklasers.com',Partner__c = true, Customer__c = true,
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                                 ContactId = con.Id,
                                 timezonesidkey='America/Los_Angeles', username='test@sharklasers.com.9876');
            
            insert user;
            
        }
    }
    
    @IsTest
    static void LightningSelfRegisterControllerInstantiation() {
        Contact contact = [SELECT Id, Name, AccountId, Email FROM Contact LIMIT 1];
        
        LightningSelfRegisterController controller = new LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
        LightningSelfRegisterController.checkIdValidity('23'); 
        
        FTL_Dealer_Signup_Form__c form = new FTL_Dealer_Signup_Form__c();
        form.Point_of_Contact_First_Name__c = 'Fname';
        form.Point_of_Contact_Last_Name__c = 'LName';
        form.Point_of_Contact_Email__c = contact.Email;
        form.Point_of_Contact_Phone_Number__c = '1232546';

       // insert form;
        
        Account acc =[SELECT Id FROM Account LIMIT 1];
        System.debug('Account '+acc);
        //LightningSelfRegisterController.insertForm(acc.Id, form);
        
        LightningSelfRegisterController.searchContact(contact.Email, acc.Id, form);
        
    }
     @IsTest
    static void SelfRegisterControllerInstantiationWithContact() {
        LightningSelfRegisterController controller = new LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
        LightningSelfRegisterController.checkIdValidity('23'); 
        
        Account acc =[SELECT Id FROM Account LIMIT 1]; 
        
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i< 1; i++){
            
            contactList.add(new Contact(LastName ='ContactLastnametest',
                                        AccountId = acc.Id, 
                                        Phone='123432222'+i, 
                                        FTL_Program_Status__c = 'Request to Enroll',
                                        FTL_Dealer_Signup_Status__c = 'New',
                                        Email='user5656'+i+'test@gmail.com', 
                                        FTL_Provisioned__c = false,
                                        FirstName='FName1'));
        }
        insert contactList;  

        FTL_Dealer_Signup_Form__c form = new FTL_Dealer_Signup_Form__c();
        form.Point_of_Contact_First_Name__c = 'Fname';
        form.Point_of_Contact_Last_Name__c = 'LName';
        form.Point_of_Contact_Email__c = 'EmailTest@gmail.vom';
        form.Point_of_Contact_Phone_Number__c = '1232546';
        //insert form;
        
        //LightningSelfRegisterController.insertForm(acc.Id, form);
        
        LightningSelfRegisterController.searchContact('user56560test@gmail.com', acc.Id, form);
    }
    
    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'testUser@salesforce.com';
        String password = 'testuser123';
        String confirmPasswordCorrect = 'testuser123';
        String confirmPasswordWrong = 'wrongpassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'http://registration-confirm.com';
        String startUrl = 'http://my.company.salesforce.com';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        return paramsMap;
    }
    
}