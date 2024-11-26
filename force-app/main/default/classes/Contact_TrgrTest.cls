@isTest
public class Contact_TrgrTest {
    
    @testSetup
    private static void  dataSetup(){        
        Id pId = [select id from profile where name='Feel the Love Community'].id;
        
        Account ac = new Account(name ='Grazitti', Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432',ShippingCountry='US',DS_Completion_Date__c=System.today()) ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',
                                  AccountId = ac.Id, 
                                  Phone='1234322', 
                                  FTL_Role__c = 'Managing Partner',
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
    
    Public static testmethod void testTriggerAllowContact(){
        Test.startTest();
        Account accountRecord = [SELECT Id FROM Account LIMIT 1];
        User CustomerUser = [SELECT Id FROM User WHERE alias = 'test3434'];
        system.runAs(CustomerUser) {
            Contact con = new Contact(LastName ='Contactlastname',
                                      AccountId = accountRecord.Id, 
                                      Phone='123432222', 
                                      Email='tester123@sharklasers.com', 
                                      FirstName='FName1');
            insert con;  
        }
        Test.stopTest();
    }
    
    Public static testmethod void testTriggerPostError(){
        Test.startTest();
        User CustomerUser = [SELECT Id FROM User WHERE alias = 'test3434'];
        Account ac = new Account(name ='Test Account', Phone='111-111-1111',ShippingStreet='124 Main St',  ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US', DS_Completion_Date__c=System.today()) ;
        insert ac;    
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i< 1; i++){
            
            contacts.add(new Contact(LastName ='Contactlastnametest',//+i,
                                     AccountId = ac.Id, 
                                     Phone='123432222'+i, 
                                     FTL_Program_Status__c = 'Request to Enroll',
                                     FTL_Dealer_Signup_Status__c = 'New',
                                     Email='user5656'+i+'test@gmail.com', 
                                     FTL_Provisioned__c = false,
                                     FirstName='FName1'+i));
        }
        insert contacts;  
        for(Contact cont : contacts){
            cont.FTL_Provisioned__c = false;
            cont.FTL_Program_Status__c = 'Request to Enroll';
            cont.FTL_Dealer_Signup_Status__c = 'Approved';
        }
        Update contacts; 
        
        
        Test.stopTest();
    }
}