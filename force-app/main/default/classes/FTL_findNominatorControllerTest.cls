@isTest
public class FTL_findNominatorControllerTest {
    @testSetup
    public static void setup(){
        // Create dealer account for test
        Account dealerAccount = new Account(
            Name = 'testDealerAccount',
            ShippingPostalCode = '22902',
            FTL_Eligibility__c = 'Eligible',
            ShippingState = 'VA',
            ShippingStreet = '1015 Glendale Road',
            ShippingCity = 'Charlottesville',
            ShippingCountry = 'US',
            Phone = '111-111-1111',
            Location__Latitude__s = 38.01717,
            Location__Longitude__s = -78.47629
        );
        insert dealerAccount;
        
        // Create contact for the dealer account
        Contact c1 = new Contact(
            FirstName = 'First',
            LastName = 'test',
            FTL_Program_Status__c = 'Enrolled',
            FTL_Provisioned__c = true,
            AccountId = dealerAccount.Id,
            Email = 'test@gmail.com',
            MobilePhone = '1234567890'
        );
        insert c1;
        
        // Create another dealer account for test
        Account dealerAccount2 = new Account(
            Name = 'testDealerAccount2',
            ShippingPostalCode = '22902',
            FTL_Eligibility__c = 'Enrolled',
            ShippingState = 'VA',
            ShippingStreet = '1015 Glendale Road',
            ShippingCity = 'Charlottesville',
            ShippingCountry = 'US',
            Phone = '111-111-1111',
            Location__Latitude__s = 38.01717,
            Location__Longitude__s = -78.47629
        );
        insert dealerAccount2;
        
        // Create contact for the second dealer account
        Contact c2 = new Contact(
            FirstName = 'First',
            LastName = 'test',
            FTL_Program_Status__c = 'Enrolled',
            FTL_Provisioned__c = true,
            AccountId = dealerAccount2.Id,
            Email = 'test2@gmail.com',
            MobilePhone = '1244567890'
        );
        insert c2;
        
        // Create FTL Program Form
        FTL_Program_Form__c ftlForm = new FTL_Program_Form__c(
            Nominee_Zip_Code__c = dealerAccount.ShippingPostalCode,
            Nominee_State__c = 'VA',
            Nominee_Street_Address__c = '1015 Glendale Road',
            Nominee_City__c = 'Charlottesville',
            Nominee_Country__c = 'US',
            Location__Latitude__s = 38.01717,
            Location__Longitude__s = -78.47629
        );
        insert ftlForm;
    }
    
    @isTest
    public static void findNominatorControllerTest(){
        FTL_Program_Form__c ftlForm = [SELECT Id FROM FTL_Program_Form__c LIMIT 1];
        Account account = [SELECT Id FROM Account WHERE FTL_Eligibility__c = 'Enrolled' LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('id', account.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(account); 

        FTL_findNominatorController findNominatorController = new FTL_findNominatorController(standardController);
        
             
        findNominatorController.paramValueNominator = ftlForm.Id; 
        findNominatorController.paramValueDealer = account.Id; 
        findNominatorController.getNearbyNominators();

        findNominatorController.assignNominator();
        
        findNominatorController.doReferesh();
        findNominatorController.doTableRefresh();
            
        
        // FTL_Program_Form__c form = [SELECT Id, Assigned_Dealer__c FROM FTL_Program_Form__c LIMIT 1];
        // System.assertNotEquals(form.Assigned_Dealer__c, Null);
    }
     @isTest
    static void testQueueableExecution() {
        // Create test data
        // For example, you may want to create some recordsJson string here to pass it to the Queueable class constructor
        String recordsJson = '["a053c00000G3ZK1AAN", "a053c00000G3ZK1AAN"]';

        // Enqueue the Queueable class
        Test.startTest();
        System.enqueueJob(new FTL_setGeoLocationQueueable(recordsJson));
        Test.stopTest();

        // Verify that the Queueable job has been enqueued
        System.assert(FTL_setGeoLocationQueueable.jobEnqueued, 'Queueable job should have been enqueued');

        // Add more assertions if needed
    }
}