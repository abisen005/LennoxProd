@isTest
public class FTL_Program_Form_Trigger_Test {

    @TestSetup
    public static void setup(){

        //Create Account record
        Account account = createAccount();
        insert account;

        List<FTL_Program_Form__c> programforms =  createProgramFormRecords();
        insert programforms;
        System.assertEquals(2, [Select Id From FTL_Program_Form__c].size());

        List<Home_Owners__c> siteLocation = createSiteLocations();
        insert siteLocation;
        System.assertEquals(1, [Select Id From Home_Owners__c].size());

    }

    public static testmethod void geoLocationTest(){
        List<Id> recordIds = new List<Id>();
        List<FTL_Program_Form__c> getFTL = [SELECT Id FROM FTL_Program_Form__c LIMIT 2]; // Example query to retrieve some records
        for (FTL_Program_Form__c form : getFTL) {
            recordIds.add(form.Id);
        }
        // Convert the list of IDs to a comma-separated string
        String commaSeparatedIds = String.join(recordIds, ',');
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        // Serialize the list of record ID strings
        String recordsJson = JSON.serialize(recordIds);
        // Call the future method with the serialized JSON string
        FTL_Program_Form_TrgrHandler.setGeoLocation(recordsJson);
        Test.stopTest();
    }
    
    
    public static testmethod void triggerTest(){
        Test.startTest();
        Account assignedDealer = [Select Id FROM Account];

        List<FTL_Program_Form__c> programforms = [Select Id, Name, Site_Location__c, Assigned_Dealer__c
                                                  From FTL_Program_Form__c ];

        for(FTL_Program_Form__c form : programforms ){
            form.Assigned_Dealer__c = assignedDealer.Id;
        }

        update programforms;
        Test.stopTest();

        // Because FTL_Program_Form__c are updated twice within the update DML,
        // and internal test logic has a hard time converting the asynchronous
        // Batch class to synchronous logic, we see 3 here (2 of them duplicates)
        // In production, duplicates will not be made under most normal circumstances
       // System.assertEquals(3, [Select Id,Name FROM Home_Owners__c].size());
    }

    //Method to create Account records
    private static Account createAccount(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
        Account accountRec = new Account(RecordTypeId = recordTypeId, Name = 'Test Account',AccountNumber = '12345',Phone ='123',
                                         ShippingCity ='Nashik',ShippingStreet = 'Nashik Road',ShippingCountry = 'India',
                                         ShippingPostalCode = '12345',ShippingState = 'Maharashtra',
                                         FTL_Eligibility__c = 'Enrolled');
        return accountRec;
    }

    private static List<Home_Owners__c> createSiteLocations(){

        return new List<Home_Owners__c>{ new Home_Owners__c(
            FirstName__c = 'test',
            MailingAddress__c = '123 main st',
            MailingCity__c = 'Austin',
            MailingState__c = 'TX',
            MailingPostal__c = '12345',
            Country__c = 'US',
            Phone__c = '9999999999',
            Email__c = 'test@test.com',
            FTL_Contact__c = 'Test',
            RecordTypeId = Schema.SObjectType.Home_Owners__c.getRecordTypeInfosByName()
            .get('Feel The Love').getRecordTypeId()
        )};

    }

    private static List<FTL_Program_Form__c> createProgramFormRecords(){

        List<FTL_Program_Form__c> programforms = new List<FTL_Program_Form__c>();
        Id recordTypeId = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName()
            .get('Nomination Form').getRecordTypeId();

        programforms.add(new FTL_Program_Form__c(
            Nominee_Name__c = 'Test',
            Nominee_City__c = 'Austin',
            Nominee_State__c = 'TX',
            Nominee_Street_Address__c = '123 main st',
            Nominee_Zip_Code__c = '12345',
            Nominee_Country__c = 'US',
            Nominee_Phone_Number__c = '9999999999',
            Nominee_Email__c = 'test@test.com',
            RecordTypeId = recordTypeId
        ));

        programforms.add(new FTL_Program_Form__c(
            Nominee_Name__c = '2ndNominee',
            Nominee_City__c = 'Waco',
            Nominee_State__c = 'TX',
            Nominee_Street_Address__c = '82 Walking Track',
            Nominee_Zip_Code__c = '76705',
            Nominee_Country__c = 'US',
            Nominee_Phone_Number__c = '345667843546',
            Nominee_Email__c = 'test22@test.com',
            RecordTypeId = recordTypeId
        ));
            return programforms;

    }
   
   /* private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            // Set the response body according to the expected response format
            res.setBody('{"data":{"position":{"lat":1.23,"lng":4.56}}}');
            return res;
        }
    }*/

}