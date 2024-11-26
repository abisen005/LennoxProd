@isTest
private class PrintPDFControllerTest {

    @testSetup
    static void setupData() {
        
        User currentUser = new User();
        currentUser.Id = UserInfo.getUserId();
        currentUser.Admin_Bypass__c = true;
        update currentUser;

        System.runAs(currentUser){
            Account acc = new Account();
            acc.Name = 'Test Account';
            insert acc;

            Contact con = new Contact();
            con.LastName = 'Test Contact';
            con.AccountId = acc.Id;
            insert con;
        }
    }

    @isTest static void test_getPicklistValuesMap() {
        printPDFController ctl = new printPDFController();
        Map<String, List<String>> result = ctl.getPicklistValuesMap();
        System.assert(result.size() == 3, 'Failed! Expected three sets of picklist values :(');
    }

    @isTest static void test_saveContact() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        Contact testCon = new Contact(LastName = 'New Contact', AccountId = testAcc.Id);
        Id conId = printPDFController.saveContact(testCon);
        System.assert(String.isNotBlank(conId), 'Failed! conId should should not be blank :(');
    }

    @isTest static void test_addEmail() {
        final String NEW_EMAIL = 'newemail@newemail.newemail';
        Contact testCon = [SELECT Id, Email FROM Contact LIMIT 1];
        Contact updateContact = printPDFController.addEmail(String.valueOf(testCon.Id), NEW_EMAIL);
        System.assert(updateContact.Email == NEW_EMAIL, 'Failed! The email wasn\'t updated :(');
    }

    @isTest static void test_getContacts() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        List<Contact> result = printPDFController.getContacts(testAcc.Id);
        System.assert(!result.isEmpty(), 'Failed! The result should not be empty :(');
    }

    @isTest static void test_searchUsers() {
        String query = UserInfo.getFirstName();
        Id userId = UserInfo.getUserId();
        Id[] fixedSearchResults = new List<Id>{userId};
        Test.setFixedSearchResults(fixedSearchResults);
        List<User> result = printPDFController.searchUsers(query);
        System.assert(!result.isEmpty(), 'Failed! The result should not be empty :(');
    }

    @isTest static void test_searchUsersNoResults() {
        String query = '';
        List<User> result = printPDFController.searchUsers(query);
        System.assert(result.isEmpty(), 'Failed! The result should ne an empty list :(');
    }

    @isTest static void test_searchContacts() {
        Contact testCon = [SELECT Id, LastName, AccountId FROM Contact LIMIT 1];
        String query = testCon.LastName;
        Id[] fixedSearchResults = new List<Id>{testCon.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        List<Contact> result = printPDFController.searchContacts(query, testCon.AccountId);
        System.assert(!result.isEmpty(), 'Failed! The result should not be empty :(');
    }

    @isTest static void test_searchContactsNoResults() {
        Contact testCon = [SELECT AccountId FROM Contact LIMIT 1];
        String query = '';
        List<Contact> result = printPDFController.searchContacts(query, testCon.AccountId);
        System.assert(result.isEmpty(), 'Failed! The result should be an empty list :(');
    }

    @isTest static void test_sendEmail() {
        String html = '<p>hello world</p>';
        List<String> toAddresses = new List<String>{'test@ventasconsulting.test'};
        String subject = 'Hello';
        String body = 'World';
        String attachmentFileName = 'attachment.pdf';
        Boolean copyMyself = true;

        Blob blobResponse = Blob.valueOf('blobresponse');
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'Complete', blobResponse, null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.StartTest();
        printPDFController.sendEmail(html, attachmentFileName, toAddresses, subject, body, copyMyself,'Potrait','0');
        Test.StopTest();
    }

    @isTest static void test_saveEvent() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        String result = printPDFController.saveEvent(testAcc.Id, 'Test Subject', 'Test Description', 'Area Rollup Summary');
        System.assert(String.isNotBlank(result), 'Failed! The result should not be blank :(');
    }

}