@IsTest//(SeeAllData=true)
public class UserTriggerTest {
    
    
    @testsetup
    private static void createTestData(){
        
       Event event = CreateEvent();
       Insert event; 
        
    }
    
    @IsTest
    private static void testUserTrigger(){
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        Id sysAdminId = [select id from profile where name='System Administrator'].id;
        user testUser = createUser(null, sysAdminId, r.Id, 'teddgd@test.com');
        Insert testUser;
        
        System.RunAs(testUser) {
            
            Account acc = createAccount(testUser.Id);
            Insert acc;
            
            Contact con = createContact(testUser.Id, acc.Id); 
            Insert con;
            
            Id p = [select id from profile where name='Customer Community Plus - FTL'].id;
            System.debug('p ' + p);
            user u = createUser(con.Id, p, null, 'test12@test.com');
            Insert u;
            
            Event event = [SELECT Id, IsVisibleInSelfService FROM Event LIMIT 1];
            
            event.IsVisibleInSelfService = TRUE;
            Update event;
            
            Contact con1 = createContact(testUser.Id, acc.Id); 
            Insert con1;
            
            System.debug('p ' + p);
            user u1 = createUser(con1.Id, p, null, 'test122@test.com');
            Insert u1;
            
        }
        
    }
    
    private static User createUser(String conId, String pId, String roleId, string username){
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', ProfileId = pId, country='United States',IsActive =true,
                             ContactId = conId,
                             timezonesidkey='America/Los_Angeles', username= username, UserRoleId = roleId);
        
        return user;
    }
    
    private static Account createAccount(String ownerId){
        
        Account ac = new Account(name ='Grazitti', OwnerId = ownerId, ShippingCity = 'test', Shippingpostalcode = '12345' , ShippingStreet = 'test', ShippingState = 'test', 
                                 ShippingCountry = 'US', Phone = '1234567890', SAP_Customer_Number__c = '123450') ;
        return ac; 
    }
    
    private static Contact createContact(String ownerId, string accId){
        
        Contact con = new Contact(ownerId = ownerId, LastName ='testCon12', FirstName = 'test12', accountId = accId, FTL_Program_Status__c = 'Enrolled', FTL_Provisioned__c = true, 
                                  Email = 'test12@sandbox.com', Phone = '222-222-2222', MobilePhone = '1234567890',
                                 DaveNet_Mobile__c = '0987654321', Mobile_Personal__c = '1234567890');
        return con;  
    }
    
    private static Event CreateEvent(){
        Id ftlEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Feel The Love Event').getRecordTypeId();
        
        Event e = new Event();
        e.RecordTypeId = ftlEventRecordTypeId;
        e.StartDateTime = system.now();
        e.EndDateTime = system.now().adddays(1);
        e.Description = 'testing';
        //e.IsVisibleInSelfService = true;
        e.IsAllDayEvent =  false;
        return e;
    }
}