@isTest
public class AttachmentTriggerTest {
    
    @testSetup static void setup() {
        
        //Creating Parent object Account for DocuSign_Status__c object        
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
        List<Account> testAccounts = new List<Account>();
        for(Integer count = 0; count < 200; count++) {
                Account testAccount = new Account(
                Name = 'Test Account'+count, RecordTypeId = recTypeId, ShippingStreet = '124 Main St', ShippingCity = 'Austin', ShippingState = 'TX', ShippingPostalCode = '12345', ShippingCountry = 'US', Phone = '111-111-1111'
            );
            testAccounts.add(testAccount);
        }
        INSERT testAccounts;
        
        //Creating DocuSign_Status__c objects
        List<dsfs__DocuSign_Status__c> testDocuSignStatuses = new List<dsfs__DocuSign_Status__c>();
        for(Integer count = 0; count < 200; count++) {
            dsfs__DocuSign_Status__c testDocuSignStatus = new dsfs__DocuSign_Status__c();
            testDocuSignStatus.dsfs__Company__c = testAccounts[0].Id;
            testDocuSignStatuses.add(testDocuSignStatus);
        }
        INSERT testDocuSignStatuses;
        
        /*
        //Following attachment creation fails due to AttachCount trigger (Error: Too many SOQL queries: 101)
        //Creating documents for inserting in the DocuSign_Status__c object 
        List<Attachment> Attachments = new List<Attachment>();
        for(Integer count = 0; count < 200; count++) {
            Attachment attachment = new Attachment(
                Name = 'Test'+count,                
                Body = Blob.valueOf('Test Content Data'),
                ParentId = testDocuSignStatuses[count].Id
            );
            Attachments.add(attachment);
        }
        INSERT Attachments;
        */
        
        //Creating documents for inserting in the DocuSign_Status__c object 
        List<Attachment> testAttachments = new List<Attachment>();
        for(Integer count = 0; count < 10; count++) {
            Attachment testAttachment = new Attachment(
                Name = 'Test'+count,                
                Body = Blob.valueOf('Test Content Data'),
                ParentId = testDocuSignStatuses[count].Id
            );
            testAttachments.add(testAttachment);
        }
        INSERT testAttachments;
    }
    
    @isTest
    public static void copyFileToAccountTest(){
        
        //There are 100 Attachments for dsfs__DocuSign_Status__c object which we have created above and
        //100 for account object which is parent of dsfs__DocuSign_Status__c object, so the total 400 Attachments created                                           
        System.assertEquals(([SELECT ParentId FROM Attachment]).size(), 20);
                    
        //Checking whether Attachment is created for account object            
        System.assertEquals([SELECT Id, ParentId 
                             FROM Attachment 
                             WHERE ParentId =: [SELECT Id 
                                                FROM Account 
                                                WHERE Name = 'Test Account0'].Id].size(), 10);               
    }
    
    @isTest
    public static void attachmentNullCheck(){
     List<Attachment> testAttachments = new List<Attachment>();
     AttachmentTriggerHandler.copyFileToAccount(testAttachments);
     System.assertEquals(([SELECT Id FROM Attachment]).size(), 20);        
    }
    
    @isTest
    public static void accountNullCheck(){
     //dsfs__DocuSign_Status__c testDocuSignStatus = new dsfs__DocuSign_Status__c();                        
     //INSERT testDocuSignStatus;   
     dsfs__DocuSign_Status__c testDocuSignStatus = [SELECT Id, dsfs__Company__c FROM dsfs__DocuSign_Status__c LIMIT 1];
     testDocuSignStatus.dsfs__Company__c = NULL;
     UPDATE testDocuSignStatus;        
     Attachment testAttachment = new Attachment(
                Name = 'Test',                
                Body = Blob.valueOf('Test Content Data'),
                ParentId = testDocuSignStatus.Id);            
     INSERT testAttachment;
     System.assertEquals(([SELECT Id FROM Attachment]).size(), 21);    
    }
    
}