/*
 * @Purpose       : Test class for ComposeMailDraftController
 * @Created Date  : 16-2-2019
 */
@IsTest
public class ComposeMailDraftControllerTest {
    
   /*
    * @Purpose : Create data required for testing
    */
    @TestSetup
    public Static void createTestData(){      
    		
      /*  Case caseObj = new Case(Status = 'New',
                                Origin = 'Email');
        insert caseObj;*/
        //Get record type id for Contact
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;

		Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
		
		//Create Contact record
		Contact contact = new Contact(RecordTypeId = recordTypeIdContact,FirstName='Test', LastName = 'Test', email = userEmail , contact_email__c = userEmail);
		Insert contact;
		
		
        //Create Site location record
		Home_Owners__c homeOwner = new Home_Owners__c(Name = 'Test',FirstName__c = 'Test', Email__c = userEmail);
		INSERT homeOwner;
        
        //Insert Case records
        Case caseRecord = new Case(Origin = 'Email', Status = 'New', ContactId = contact.Id , Home_Owner__c = homeOwner.Id );
		Insert caseRecord; 
    }  
    
   /*
    * @Purpose : To Test functionality(Positive Testing)
    */
    @isTest
    public static void functionalityPositiveTest(){      
        
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        
        Attachment attachment = new Attachment();
        attachment.Name = String.valueOf('test.txt');
        attachment.Body = EncodingUtil.base64Decode('TestingAttachment');
        
        Test.startTest();
        ComposeMailDraftController.fetchDraftDetails(caseObj.Id);
        Response res = ComposeMailDraftController.getEmailTemplates();
        System.debug('res');
        List<EmailTemplate> templateList = (List<EmailTemplate>)res.data;
        ComposeMailDraftController.getEmailDefaultValues(caseObj.Id, templateList[0].Id);
        
        Email_Message__c mailMessage = new Email_Message__c();
        mailMessage.BCC_Address__c = 'test@example.com';
        mailMessage.CC_Address__c = 'test@example.com';
        mailMessage.To__c = 'test@example.com';
        mailMessage.FromAddress__c = 'test@example.com';
        mailMessage.Subject__c = 'Subject';
        mailMessage.Mail_Body__c = 'body';
        
        ComposeMailDraftController.saveDraftMailMessage(JSON.serialize(mailMessage), 'abc', 'dataimage/jpg;base64,', 'test.txt');
        
        System.assertEquals(1,[SELECT Id from Email_Message__c].size()); 
        ComposeMailDraftController.fetchDraftDetails(caseObj.Id);
        System.assertEquals(1,[SELECT Id from Attachment].size());    
        Test.stopTest();
    }
    
    
    /*
    * @Purpose : To Test functionality(Negative Testing)
    */
    @isTest
    public static void functionalityNagativeTest(){ 
        Test.startTest();
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        
        Attachment attachment = new Attachment();
        attachment.Name = String.valueOf('test.txt');
        attachment.Body = EncodingUtil.base64Decode('TestingAttachment');
        
        ComposeMailDraftController.fetchDraftDetails(caseObj.Id);
        
        Email_Message__c mailMessage = new Email_Message__c();
        mailMessage.BCC_Address__c = 'test@gmail.com';
        mailMessage.CC_Address__c = 'test@gmail.com';
        mailMessage.To__c = 'test@gmail.com';
        mailMessage.FromAddress__c = 'test@example.com';
        mailMessage.Subject__c = 'Subject';
        mailMessage.Mail_Body__c = 'body';
        
        ComposeMailDraftController.saveDraftMailMessage(JSON.serialize(mailMessage), 'abc', 'image/jpg', 'fdfdhf');
        ComposeMailDraftController.saveDraftMailMessage(JSON.serialize(mailMessage), 'abc', 'image/jpg', '');
        ComposeMailDraftController.saveDraftMailMessage('"dhddgfdskgd"', 'abc', 'image/jpg', '');    
        Test.stopTest();
    }
    
    /*
    * @Purpose : Approval Mail Testings
    */
    @isTest
    public static void approvalMailTesting(){ 
        Test.startTest();
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        
        Attachment attachment = new Attachment();
        attachment.Name = String.valueOf('test.txt');
        attachment.Body = EncodingUtil.base64Decode('TestingAttachment');
        
        ComposeMailDraftController.fetchDraftDetails(caseObj.Id);
        
        Email_Message__c mailMessage = new Email_Message__c();
        mailMessage.BCC_Address__c = 'test@gmail.com';
        mailMessage.CC_Address__c = 'test@gmail.com';
        mailMessage.To__c = 'test@gmail.com';
        mailMessage.FromAddress__c = 'test@example.com';
        mailMessage.Subject__c = 'Subject';
        mailMessage.Mail_Body__c = 'body';

        ComposeMailDraftController.saveDraftMailMessage(JSON.serialize(mailMessage), 'abc', 'dataimage/jpg;base64,', 'test.txt');
        
        System.assertEquals(1,[SELECT Id from Email_Message__c].size()); 
        mailMessage = [SELECT Id, inApprovalStep2__c, Is_Approved__c, Is_Rejected__c from Email_Message__c LIMIT 1];
        mailMessage.inApprovalStep2__c = true;
        mailMessage.Is_Approved__c = true;
        mailMessage.Has_Attachment__c = true;
        update mailMessage;
        
        System.assertEquals(1,[SELECT Id from Attachment].size());    
        Test.stopTest();
    }
}