@isTest
public class FTLDocusignListControllerTest {
    @isTest
    public static void getDocusignDocumentsTest() {

        // GIVEN there is an existing account
        Account testAccount = new Account(Name = 'TestAccount',
                                Phone='111-111-1111',
                                ShippingStreet='124 Main St',
                                ShippingCity='Austin',
                                ShippingState='TX',
                                ShippingPostalCode='43212',
                                ShippingCountry='US',
                                SAP_Customer_Number__c = '123456');
        insert testAccount;
        
        // AND there is a community user that has a link to the account through contact
        Id communityProfileId = [SELECT Id FROM Profile 
                                 WHERE Name = 'Customer Community Plus - FTL' 
                                 LIMIT 1].Id;

        Contact con = new Contact(FirstName='Test',LastName ='Testing',email='test123@noemail.com',
                                  AccountId = testAccount.Id);
        insert con;  
                                           
        User communityUser = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8',FirstName='Test', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = communityProfileId, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

        // AND the account has at least 1 related file
        // AND the related file Title begins with 'DealerAgreement'        
        ContentVersion cv = new ContentVersion(
            title = 'DealerAgreementTest',
            pathOnClient = 'DealerAgreementTest.pdf',
            versionData = Blob.valueOf('Hello'),
            isMajorVersion = true
        );
        insert cv;
                
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = New ContentDocumentLink(
            LinkedEntityId = testAccount.Id,
            ContentDocumentId = conDocId,
            shareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;
        
        List<ContentDocumentLink> testDocs = [
            SELECT Id, ContentDocument.Id, ContentDocument.Title 
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :testAccount.Id
        ];
        
        for(ContentDocumentLink test : testDocs) {
            System.debug('testDoc id: ' + test.ContentDocument.Id);
            System.debug('testDoc title: ' + test.ContentDocument.Title);
        }
        
        // WHEN getDocusignDocuments is called by that user
        List<FTLDocusignListController.DocumentInformation> docs;
        System.runAs(communityUser) {
            System.debug('communityUser.Id: ' + communityUser.Id);
            docs = FTLDocusignListController.getDocusignDocuments();
        }
        
        // THEN getDocusignDocuments will return a list of at least 1 related files
        System.assert(docs.size() > 0, 
            'getDocusignDocuments should have returned a list with a size of at least 1 but the size was actually ' 
            + docs.size()
        );
        // AND the list will include a link to the file for downloading
        System.assert(docs[0].documentId != null,
            'getDocusignDocuments should have returned a document with an id but instead there was no id'
        );
    }
    
}