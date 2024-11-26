@IsTest
public class EventTriggerTest {
    
    @testsetup
    private static void createTestData(){
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        Id sysAdminId = [select id from profile where name='System Administrator'].id;
        user testUser2 = createUser(null, sysAdminId, r.Id, 'newtestuser@example.com');
        Insert testUser2;
        
    }
    
    
    @IsTest
    private static void testEvenTrigger(){
        
        User user = [SELECT Id FROM User WHERE profile.Name = 'System Administrator' AND UserRoleId != NULL and IsActive = true LIMIT 1 ];
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User usr = [Select Id,UserRoleId from User where UserRoleId=:portalRole.Id limit 1];
        
        
        
        System.RunAs(user) {
            
            Account acc = createAccount(user.Id);
            Insert acc;
            
            Contact con = createContact(user.Id, acc.Id); 
            Insert con;
            
            Id p = [select id from profile where name='Customer Community Plus - FTL'].id;
            System.debug('p ' + p);
            user u = createUser(con.Id, p, null, 'test12@test.com');
            Insert u;
            
            
            Event event = CreateEvent();
            Insert event;
            
            EventTriggerHandler.hasExecuted = false;
            
            event.EndDateTime =  event.EndDateTime.adddays(1);
            event.IsAllDayEvent = true;
            Update event;
            
            EventTriggerHandler.hasExecuted = false;
            Delete event;
        }
        
        
    }
    
    private static Event CreateEvent(){
        Id ftlEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Feel The Love Event').getRecordTypeId();
        
        Event e = new Event();
        e.RecordTypeId = ftlEventRecordTypeId;
        e.StartDateTime = system.now();
        e.EndDateTime = system.now().adddays(1);
        e.Description = 'testing';
        e.IsVisibleInSelfService = true;
        e.IsAllDayEvent =  false;
        return e;
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
                                 ShippingCountry = 'US', Phone = '1234567890', SAP_Customer_Number__c = '12345') ;
        return ac; 
    }
    
    private static Contact createContact(String ownerId, string accId){
        
        Contact con = new Contact(ownerId = ownerId, LastName ='testCon1', FirstName = 'test1', accountId = accId, 
                                  FTL_Program_Status__c = 'Enrolled', FTL_Provisioned__c = true, Email = 'test@sandbox.com',
                                  Phone = '222-222-2222', MobilePhone = '0987654321', DaveNet_Mobile__c = '0987654321',
                                  Mobile_Personal__c = '1234567890');
        return con;  
    }
    
    @isTest
    public static void testgetTimeDurationInMinutes(){
       
        DateTime StartDate = system.today();
        DateTime EndDate= system.today()+5;
        test.startTest();
        EventTriggerHandler.getTimeDurationInMinutes(StartDate, EndDate);
        test.stopTest();
    }
}