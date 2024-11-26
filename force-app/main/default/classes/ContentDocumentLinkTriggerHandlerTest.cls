@isTest
public with sharing class ContentDocumentLinkTriggerHandlerTest {
    @isTest
    public static void beforeInsertTest() {
        // GIVEN there is an existing account
        Account testAccount = new Account(Name = 'TestAccount',
                                Phone='111-111-1111',
                                ShippingStreet='124 Main St',
                                ShippingCity='Austin',
                                ShippingState='TX',
                                ShippingPostalCode='43212',
                                ShippingCountry='US',
                                SAP_Customer_Number__c = '123456789');
        insert testAccount;

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
            shareType = 'I',
            Visibility = 'InternalUsers'
        );

        // WHEN the content document link is inserted
        insert cdl;

        List<ContentDocumentLink> results = [SELECT Id, shareType, visibility 
                                             FROM ContentDocumentLink 
                                             WHERE Id = :cdl.Id
                                            ];
        
        for (ContentDocumentLink result : [SELECT Id, shareType, visibility 
                                             FROM ContentDocumentLink 
                                             WHERE Id = :cdl.Id
                                          ]) 
        {
        // THEN the trigger will change the shareType to 'V'
        //System.Assert(cdl.shareType == 'V',
        // 'The Content Document Link ShareType should have been V but was ' + cdl.shareType);

        // AND the trigger will change the Visibility to 'AllUsers'
        System.Assert(result.Visibility == 'AllUsers',
         'The Content Document Link Visibility should have been AllUsers but was ' + cdl.Visibility);
        
        }
    }
}