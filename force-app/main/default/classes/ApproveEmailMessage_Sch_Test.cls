@IsTest
public class ApproveEmailMessage_Sch_Test {
    
    /*
    * @Purpose : Create data required for testing
    */
    @TestSetup
    public Static void createTestData(){        
        Email_Message__c mailMessage = new Email_Message__c();
        mailMessage.BCC_Address__c = 'test@gmail.com';
        mailMessage.CC_Address__c = 'test@gmail.com';
        mailMessage.To__c = 'test@gmail.com';
        mailMessage.FromAddress__c = 'from@gmail.com';
        mailMessage.Subject__c = 'Subject';
        mailMessage.Mail_Body__c = 'body';
        mailMessage.inApprovalStep2__c = true;
        mailMessage.Is_Approved__c = true;
        
        insert mailMessage;
    }  
    
    /*
    * @Purpose : To Test functionality
    */
    @isTest
    public static void functionalityPositiveTest(){
        Email_Message__c mailMessage = [SELECT Id FROM Email_Message__c LIMIT 1];
        //Submit Quote for Approval
		/*Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
		app.setObjectId(mailMessage.id);
		Approval.ProcessResult result = Approval.process(app);*/
        
        Test.startTest();

        Datetime sysTime = System.now();
        
        sysTime = sysTime.addMinutes(1);
        String chron_exp = ' ' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + 
            ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('Approve Records', chron_exp, new ApproveEmailMessages(System.now()));
        
        Test.stopTest();
    }

    @isTest 
    public static void runApproveEmailMessage(){
        Database.executeBatch(new ApproveEmailMessagesBatch());
    }

}