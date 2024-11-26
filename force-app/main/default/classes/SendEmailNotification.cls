/*
 * @Purpose       :Controller for sendEmail throught the which gets called through Process Builder
 * @Created Date  :22-2-2019
 */
public class SendEmailNotification {
    
   /*
    * @Purpose : Fetch the Email Message for the case and send Email notifications to user(called from Trigger)
	* @Param   : emailMessageIdList
    * @Return  : -
    */
    @InvocableMethod(label='Send Email')
    public static void sendEmailNotification(List<Email_Message__c> emailMessages){
            try{
                sendEmail(emailMessages);    
            }catch(Exception ex){
                System.debug('Error has been occured while fetching Email Message is::::'+ex.getMessage());    
            }        
    }
    
    /*
    * @Purpose : Send Rejected Mail Notification to 
	* @Param   : emailMessageIdList
    * @Return  : -
    */
    public static void sendRejectedEmailNotification(List<Email_Message__c> emailMessages){
            try{
                sendEmail(emailMessages);    
            }catch(Exception ex){
                System.debug('Error has been occured while fetching Email Message is::::'+ex.getMessage());    
            }        
    }
    
   /*
    * @Purpose : Send the Email Notification
	* @Param   : emailMessageObj
    * @Return  : -
    */
    public static void sendEmail(List<Email_Message__c> emailMessages){
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        Map<Id, Email_Message__c> emailMessagesMap = new Map<Id, Email_Message__c>(emailMessages);
        Map<Id, List<Attachment>> emailMessagewithAttachments = fetchAllAttachments(emailMessagesMap.keySet());
        List<EmailMessage> emailMessagesToInsert = new List<EmailMessage>();
        
        for(Email_Message__c emailMessage : emailMessages){
            List<Attachment> attachments = new List<Attachment>();
            if(emailMessage.Has_Attachment__c && emailMessagewithAttachments.containsKey(emailMessage.Id)){
                attachments = emailMessagewithAttachments.get(emailMessage.Id);                
            }
            Messaging.SingleEmailMessage singleMailMessage = createSingleMailMessage(emailMessage, attachments);
            allMails.add(singleMailMessage);
            emailMessagesToInsert.add(createEmailMessage(emailMessage));
        }
        
        EmailMessageHandler.isCommunityMail = true;
        Database.insert( emailMessagesToInsert, false );
        EmailMessageHandler.isCommunityMail = false;
        System.debug('Sending mails' + allMails);
        // Send the email 
        Messaging.SendEmailResult[] result = Messaging.sendEmail(allMails);
        System.debug('Sent mails' + result);
    }
    
    public static EmailMessage createEmailMessage(Email_Message__c emailMessage){
        EmailMessage emailMsg = new EmailMessage();
        emailMsg.ToAddress= emailMessage.To__c;
        emailMsg.BccAddress = emailMessage.BCC_Address__c;
        emailMsg.CcAddress = emailMessage.CC_Address__c;
        emailMsg.FromAddress = emailMessage.FromAddress__c;
        emailMsg.Subject= emailMessage.Subject__c;
        emailMsg.HtmlBody= emailMessage.Mail_Body__c;
        emailMsg.ParentId = emailMessage.Case_Id__c; //Attach with the case
        emailMsg.MessageDate = system.now();        
        emailMsg.Status = '0';
        return emailMsg;
    }
	
    public static Messaging.SingleEmailMessage createSingleMailMessage(Email_Message__c mailMessage, List<Attachment> attachments){
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        //singleMail.setSaveAsActivity(true);
        if(String.isNotBlank(mailMessage.FromAddress__c)){
            singleMail.setSenderDisplayName(mailMessage.FromAddress__c);
            singleMail.setReplyTo(mailMessage.FromAddress__c);
        }
        if(String.isNotBlank(mailMessage.To__c)){
            singleMail.setToAddresses(createRecepientList(mailMessage.To__c));    
        }
        if(String.isNotBlank(mailMessage.CC_Address__c)){
            singleMail.setCcAddresses(createRecepientList(mailMessage.CC_Address__c));    
        }
        if(String.isNotBlank(mailMessage.BCC_Address__c)){
            singleMail.setBccAddresses(createRecepientList(mailMessage.BCC_Address__c));    
        }
        if(String.isNotBlank(mailMessage.Subject__c)){
            singleMail.setSubject(mailMessage.Subject__c);    
        }
        if(String.isNotBlank(mailMessage.Mail_Body__c)){
            singleMail.setHTMLBody(mailMessage.Mail_Body__c);    
        }else{
            singleMail.setHTMLBody('<p></p>');
        }
        
        if(!attachments.isEmpty()){
            List<Messaging.EmailFileAttachment> mailAttachments= new List<Messaging.EmailFileAttachment>();
            for(Attachment attachmentRecord : attachments){
                mailAttachments.add(createEamilAttachment(attachmentRecord));
            }
            singleMail.setFileAttachments( mailAttachments );  
        }
        
        return singleMail;
    }
    
    public static Map<Id, List<Attachment>> fetchAllAttachments(Set<Id> parentIds){
        Map<Id, List<Attachment>> parentIdWithAttachments = new Map<Id, List<Attachment>>();
        List<Attachment> attachments = [SELECT Id, Body, ContentType, Name, ParentId
                                        FROM Attachment
                                        WHERE ParentId IN :parentIds];
        
        for(Attachment attachment : attachments) {
            if(!parentIdWithAttachments.containsKey(attachment.ParentId)){
                parentIdWithAttachments.put(attachment.ParentId, new List<Attachment>());
            }
            parentIdWithAttachments.get(attachment.ParentId).add(attachment);
        }
        return parentIdWithAttachments;
    }
    
   /*
    * @Purpose : Create Email Attachment
	* @Param   : emailMessageId
    * @Return  : Messaging.EmailFileAttachment
    */    
    public static Messaging.EmailFileAttachment createEamilAttachment(Attachment attachmentRecord){        
        Messaging.EmailFileAttachment emailAttachment;       
        if(attachmentRecord != NULL){                
            emailAttachment = new Messaging.EmailFileAttachment();                
            emailAttachment.setBody(String.isNotBlank(String.valueOf(attachmentRecord.Body)) ? attachmentRecord.Body : NULL);
            emailAttachment.setContentType(String.isNotBlank(attachmentRecord.ContentType) ? attachmentRecord.ContentType : '');
            emailAttachment.setFileName(String.isNotBlank(attachmentRecord.Name) ? attachmentRecord.Name : '');
            //emailAttachment.setinline(false);
        }        
        return emailAttachment;
    }
    
   /*
    * @Purpose : Create Email Recepient List
	* @Param   : strEmailReceiver
    * @Return  : List<String>
    */ 
    public static List<String> createRecepientList(String strEmailReceiver){
        
        List<String> toEmailAddressList = new List<String>();
        
        if(String.isNotBlank(strEmailReceiver)){                
            if(strEmailReceiver.contains(';')){
                toEmailAddressList = strEmailReceiver.split(';');
            }else{
            	toEmailAddressList.add(strEmailReceiver);     
            }
        } 
        return toEmailAddressList;
    }
}