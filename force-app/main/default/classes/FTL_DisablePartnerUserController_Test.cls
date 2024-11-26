@isTest
public class FTL_DisablePartnerUserController_Test {
    
    static testMethod void myUnitTest() {
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE IsActive = true AND userRoleId = :sampleUserRole.Id LIMIT 1];
        Profile testProfile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];
        
        set<id> userid = new set<id>(); 
        
        System.runAs(admin){
            User thisUser = new User(LastName = 'test user 1', 
                                     FirstName = 'Aquaman',
                                     Username = 'test.user.123456@example.com', 
                                     Email = 'test.1@example.com', 
                                     Alias = 'testu1', 
                                     TimeZoneSidKey = 'GMT', 
                                     LocaleSidKey = 'en_GB', 
                                     EmailEncodingKey = 'ISO-8859-1', 
                                     ProfileId = testProfile.Id, 
                                     LanguageLocaleKey = 'en_US'); 
            						 
            insert thisUser;
            userid.add(thisUser.id);
            
            Id conrt = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
            
            contact con = new contact();
            con.FirstName = 'Aquaman';
            con.LastName = 'test';
            con.RecordTypeId =conrt;
            con.Email = 'a@a.com';
            insert con;
            
            System.currentPageReference().getParameters().put('id', con.Id);
            ApexPages.StandardController sc =new ApexPages.StandardController(con);
            FTL_DisablePartnerUserController DisCustUSer =new FTL_DisablePartnerUserController(sc);
            DisCustUSer.disableCustomerUser();
            DisCustUSer.updateContact();
            FTL_DisablePartnerUserController.updateUser(userid);
        }
        
    }
    
    static testmethod void myUnitTest1(){
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE IsActive = true AND userRoleId = :sampleUserRole.Id LIMIT 1];
        Profile portalProfile = [SELECT Id FROM Profile where Name='Feel the Love Community' Limit 1];
        
        System.runAs(admin){
            Id conrt = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
            Id accrt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
            
            Account acc = new Account();
            acc.RecordTypeId =accrt;
            acc.name = 'Test Account123';
            acc.Phone = '111-111-1111';
            acc.ShippingStreet = '123 Main St';
            acc.ShippingCity = 'Austin';
            acc.ShippingState = 'TX';
            acc.ShippingPostalCode = '12345';
            acc.ShippingCountry = 'US';
            acc.FTL_Eligibility__c = 'Eligible';
            
            insert acc;
            
            contact con = new contact();
            con.RecordTypeId =conrt;
            con.FirstName= 'Aquaman';
            con.lastname= 'test';
            con.Email = 'a@a.com';
            con.AccountId = acc.Id;
            con.Contact_Type__c = 'Dealer';
            con.FTL_Program_Status__c = 'Request to Unenroll';
            insert con;
            
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12346@test.com',
                ContactId = con.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test13',
                Email = 'test12346@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test1235',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            Test.startTest();
            System.runAs(user1) {
                System.currentPageReference().getParameters().put('id', con.Id);
                ApexPages.StandardController sc =new ApexPages.StandardController(con);
                FTL_DisablePartnerUserController DisCustUSer =new FTL_DisablePartnerUserController(sc);
                DisCustUSer.disableCustomerUser();
            }        
            Test.stopTest();
            
        }
        
    }
}