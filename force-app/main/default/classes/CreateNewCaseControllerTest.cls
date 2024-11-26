@IsTest
public class CreateNewCaseControllerTest {
    
    @IsTest
    private static void unitTest(){
        Account acc = createAccount();
        Insert acc;
        Contact con = createContact(acc.Id);
        Insert con;
        
        Test.startTest();
        
        User userRec = getUser('CS Resource');
        System.runAs(userRec){
            CreateNewCaseApexController.Response res = CreateNewCaseApexController.getCaseRecordTypeId();
            CreateNewCaseApexController.Response res01 = CreateNewCaseApexController.getContacts(con.Id);
            CreateNewCaseApexController.Response res0 = CreateNewCaseApexController.getContacts(null);
            CreateNewCaseApexController.Response res1 = CreateNewCaseApexController.getAccountRecordId(con.Id);
            CreateNewCaseApexController.Response res2 = CreateNewCaseApexController.getAccountRecordId('invalidId');
        }
        User userRec1 = getUser('CS Agent P&S');
        System.runAs(userRec1){
            CreateNewCaseApexController.Response res = CreateNewCaseApexController.getCaseRecordTypeId();
            CreateNewCaseApexController.Response res01 = CreateNewCaseApexController.getContacts(con.Id);
            CreateNewCaseApexController.Response res0 = CreateNewCaseApexController.getContacts(null);
            CreateNewCaseApexController.Response res1 = CreateNewCaseApexController.getAccountRecordId(con.Id);
            CreateNewCaseApexController.Response res2 = CreateNewCaseApexController.getAccountRecordId('invalidId');
        }
        User userRec2 = getUser(null);
        System.runAs(userRec2){
            CreateNewCaseApexController.Response res = CreateNewCaseApexController.getCaseRecordTypeId();
            CreateNewCaseApexController.Response res01 = CreateNewCaseApexController.getContacts(con.Id);
            CreateNewCaseApexController.Response res0 = CreateNewCaseApexController.getContacts(null);
            CreateNewCaseApexController.Response res1 = CreateNewCaseApexController.getAccountRecordId(con.Id);
            CreateNewCaseApexController.Response res2 = CreateNewCaseApexController.getAccountRecordId('invalidId');
        }
        Test.stopTest();
        
    }
    
    private static User getUser(String picklistVal){
                
        User u = new User(
            ProfileId = userinfo.getProfileId(),
            LastName = 'last',
            Email = 'abc@abctest.com',
            Username = 'abc@abctest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Technical_Support__c = picklistVal
        );
        
        return u;
    }
    private static Account createAccount(){
        Account acc = new Account();
       
        acc.ShippingCity = 'City';
        acc.ShippingCountry = 'US';
        acc.ShippingPostalCode = '123456';
        acc.ShippingState = 'TX';
        acc.ShippingStreet = 'street';
        acc.Phone = '123';
        acc.Name = 'test';
        return acc;
    }
    
    private static Contact createContact(String accounId){
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Email = 'test@test.com';
            con.Phone = '123';
        con.AccountId = accounId;
        return con;
    }
}