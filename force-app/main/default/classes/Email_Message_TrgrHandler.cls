public without sharing class Email_Message_TrgrHandler {
    
    public static void sendApprovedEmailMessages( Map<Id, Email_Message__c> newEmailMessages, Map<Id, Email_Message__c> oldEmailMessages ) {
        
        List<Email_Message__c> approvedEmails = new List<Email_Message__c>();
        List<Email_Message__c> step2Approval = new List<Email_Message__c>();
        for(Email_Message__c mailMessage : newEmailMessages.values()) {
            if( oldEmailMessages != null){
                Email_Message__c oldMailMessage = oldEmailMessages.get(mailMessage.Id);
                
                if(!oldMailMessage.Is_Approved__c && mailMessage.Is_Approved__c) {
                    approvedEmails.add(mailMessage);
                }
                
            }else{
                if( mailMessage.Is_Approved__c){
                    approvedEmails.add(mailMessage);
                }
            }
            
            if(mailMessage.inApprovalStep2__c){
                step2Approval.add(mailMessage);
            }
            
        }
        if(!approvedEmails.isEmpty()){
            SendEmailNotification.sendEmailNotification(approvedEmails);
        }        
    }
}