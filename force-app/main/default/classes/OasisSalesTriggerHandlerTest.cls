@isTest
public class OasisSalesTriggerHandlerTest {
 @testSetup
    static void setup() {
        // Create test users
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com.dev2',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser+123@example.com'
        );
        insert testUser;

        User integratedUser = new User(
            Alias = 'iuser',
            Email = 'len.intuser+Test123@lennoxintl.com.dev2',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Integrated',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'len.intuser@lennoxintl.com.test'
        );
        insert integratedUser;

        // Create Sales Group Master records
        List<Sales_Group_Master__c> salesGroupMasters = new List<Sales_Group_Master__c>();
        for (Integer i = 0; i < 3; i++) {
            Sales_Group_Master__c sgm = new Sales_Group_Master__c(
                Sales_Group__c = 'SG' + i,
                OwnerId = testUser.Id
            );
            salesGroupMasters.add(sgm);
        }
        insert salesGroupMasters;
    }
     @isTest
    static void testHandleBeforeInsert() {
        // Test before insert
        List<Oasis_Sales__c> newSales = new List<Oasis_Sales__c>();
        for (Integer i = 0; i < 3; i++) {
            Oasis_Sales__c os = new Oasis_Sales__c(
                Sales_Group__c = 'SG' + i
            );
            newSales.add(os);
        }

        Test.startTest();
        insert newSales;
        Test.stopTest();

        // Verify results
        for (Oasis_Sales__c os : newSales) {
           System.debug('Check1'+ os.OwnerId);
           //System.debug('Check2: ' + [SELECT Id FROM User WHERE UserName = 'testuser+123@example.com' LIMIT 1].Id);
            System.assertNotEquals([SELECT Id FROM User WHERE UserName = 'testuser+123@example.com' LIMIT 1].Id, os.OwnerId);
            //System.assertNotEquals(null, os.Sales_Group_Master__c);
        }
    }
}