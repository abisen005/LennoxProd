/*
*  @Description: This class is used to Check the functionality of "ComposeMailController" class.
*/
@isTest
public class ComposeMailControllerTest {

    public static final Integer TOTALRECORDS = 5;
    
  /*
   *	@Purpose - Create test records that are used while testing 'ComposeMailController' class.
   */
    @testSetup
    public static void createTestData() {
		//Get record type id for Contact
		Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
		
		//Create Contact record
		Contact contact = new Contact(RecordTypeId = recordTypeIdContact, FirstName = 'test', LastName = 'Test', email = 'test@example.com');
		Insert contact;
		
		
		//Get record type id for Case
		//Id recordTypeIdCase =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
		
        //Create Site location record
		Home_Owners__c homeOwner = new Home_Owners__c(Name = 'Test', Email__c = 'test@example.com');
        homeOwner.First_Name1__c = 'test';
        homeOwner.First_Name2__c = 'test';
        homeOwner.FirstName__c = 'test';
		INSERT homeOwner;
        
        //Insert Case records
        Case caseRecord = new Case(/*RecordTypeId = recordTypeIdCase,*/ Status = 'New', ContactId = contact.Id , Home_Owner__c = homeOwner.Id );
		Insert caseRecord; 
    }
	
    /**
    * @Purpose - Call ComposeMailController class methods and test the functionality of that class .
    */
    public static testmethod void testComposeMailController(){
        Home_Owners__c homeOwner = [SELECT Id FROM Home_Owners__c LIMIT 1];
        Id templateId = [SELECT Id FROM EmailTemplate LIMIT 1].Id;
        
        Case caseRecord = [SELECT Id FROM Case LIMIT 1];
        
        ComposeMailController.MailContents mailContent = new ComposeMailController.MailContents();
        mailContent.mSubject = 'mSubject';
        mailContent.mBody = 'mBody';
        mailContent.fileName = 'fileName';
        mailContent.mRecipients = new List<String>{'test@test.com'};
            mailContent.mCcs = new List<String>{'test@test.com', 'test1@test.com'};
                mailContent.mBccs = new List<String>{'test@test.com'};
                    mailContent.mAttachment = 'test';
        
        Test.startTest();
        
        ComposeMailController.getEmailTemplates();
        ComposeMailController.getEmailAddress(caseRecord.Id);
        ComposeMailController.getEmailDefaultValues(caseRecord.Id);
        ComposeMailController.sendMails(System.JSON.serialize(mailContent), caseRecord.Id);
        
        ComposeMailController.trimStrings(new List<String>{'test', 'test1'});
        ComposeMailController.getContact('Test');
        ComposeMailController.Response response = new ComposeMailController.Response(true,'test',null);
        Test.stopTest();   
    }   
}