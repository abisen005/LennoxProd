@isTest
public class FT_SObjectRelatedListTest {
    /*@TestSetup
    static void makeData(){
        
    }*/

    static User getUser(Id contactId){
        Profile p = [SELECT Id FROM Profile WHERE Name='Community - All Community Plus Login Profile']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',ContactId=contactId);
        return u;
    }

    static Account createAccount(){
        Account testAccount = new Account();
        String zip = String.valueOf(1000 + 1);
        testAccount.ShippingPostalCode = zip;
        testAccount.SAP_Customer_Number__c ='jhghgh';
        testAccount.ShippingStreet = 'tst';
        testAccount.ShippingState = 'stftf';
        testAccount.ShippingCity = 'jhjkhjkh';
        testAccount.ShippingCountry='kjkjklj';
        testAccount.Name='Test Account' ;
        testAccount.Phone='(222) 222-2222';
        insert testAccount;
        return testAccount;
    }

    static Contact createContact(string accountid){
        Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test1';
        cont.Email = 'xyz@pqr.com';
        cont.Phone='(222) 222-2222';
		cont.Accountid= accountid;
		insert cont;
        return cont;
    }

    static FT_Field_Trial__c createFieldTrial(String userId){
        FT_Field_Trial__c record = new FT_Field_Trial__c(Name='Test Field Trial',
                                                         FT_Field_Trial_Lead__c=userId,
                                                         FT_ProductServiceCoordinator__c=userId
                                                         );
        insert record;
        return record;
    }

    static Field_Trial_Contacts__c createFieldTrialContact(String fieldTrialId, String contactId){
        Id RecordTypeIdContact = Schema.SObjectType.Field_Trial_Contacts__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Field_Trial_Contacts__c record = new Field_Trial_Contacts__c(
                                                            FT_Field_Trial__c=fieldTrialId,FT_Contact_Record__c=contactId
                                                         );
        insert record;
        return record;
    }

    static Home_Owners__c createSiteLocation(string fieldTrialContactId){
        Id RecordTypeIdContact = Schema.SObjectType.Equipment_Data__c.getRecordTypeInfosByName().get('Field Trial').getRecordTypeId();
        Home_Owners__c record = new Home_Owners__c(FT_Field_Trial_Contact__c=fieldTrialContactId,Phone__c='(222) 222-2222',
                                                   Email__c='test@site.com',Name='Test address',FirstName__c='Test',LastName__c='Test1');
        insert record;
        return record;
    }

    static Equipment_Data__c createEquipmentData(String fieldTrialId, String siteLocationId){
        Id RecordTypeIdContact = Schema.SObjectType.Equipment_Data__c.getRecordTypeInfosByName().get('Field Trial').getRecordTypeId();
        Equipment_Data__c record = new Equipment_Data__c(Name='Test data',Category__c='r',Serial_Number__c='e',Model_Number__c='p',
                                                            FT_Field_Trial__c=fieldTrialId,FT_Field_Trial_Type__c='Field Trial',
                                                            Home_Owner__c=siteLocationId
                                                         );
        insert record;
        return record;
    } 
    
    /*static void createDocument(string parentId){
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = parentId;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }*/

    @IsTest
    static void positiveNegativeTest(){
        
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.id);
        User u = getUser(con.Id);
        insert u;
        System.runAs(u) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'FT_Field_Trial_Community_Dealer'];
			insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            FT_Field_Trial__c rec1 = createFieldTrial(u.Id);
            Field_Trial_Contacts__c rec2 = createFieldTrialContact(rec1.Id,con.Id);
            Home_Owners__c rec3 = createSiteLocation(rec2.Id);
            Equipment_Data__c rec4 = createEquipmentData(rec1.Id, rec3.Id);
            //ServiceRecord__c rec5 = createServiceRecord(rec2.Id)
            /*createDocument(rec1.Id);
            createDocument(rec2.Id);
            createDocument(rec3.Id);
            createDocument(rec4.Id);*/
            
            FT_SObjectRelatedListController.Response res1 = FT_SObjectRelatedListController.fetchRelatedListObjects(rec1.Id);
            FT_SObjectRelatedListController.Response res2 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec1.Id, 'Field_Trial_Contacts__c');
            FT_SObjectRelatedListController.Response res3 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec1.Id, 'Equipment_Data__c');
            FT_SObjectRelatedListController.Response res6 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec3.Id, 'Equipment_Data__c');
            FT_SObjectRelatedListController.Response res4 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec2.Id, 'Home_Owners__c');
            FT_SObjectRelatedListController.Response res5 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec2.Id, 'ServiceRecord__c');
            FT_SObjectRelatedListController.Response res7 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec3.Id, 'ServiceRecord__c');
            FT_SObjectRelatedListController.Response res8 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec4.Id, 'ServiceRecord__c');
            FT_SObjectRelatedListController.Response res9 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec1.Id, 'ContentDocumentLink');
            FT_SObjectRelatedListController.Response res10 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec2.Id, 'ContentDocumentLink');
            FT_SObjectRelatedListController.Response res11 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec2.Id, 'FieldTrialForms__c');
            //FT_SObjectRelatedListController.Response res12 = FT_SObjectRelatedListController.fetchSObjectRecordList(rec2.Id, 'FT_Field_Trial_Invoices__c');
            FT_SObjectRelatedListController.Response res12 = FT_SObjectRelatedListController.getRecordTypes('FieldTrialForms__c');
        }
        Test.stopTest();
        
    }

}