/*
* @Purpose       :	Controller for ComposeMailDraft Lightning Component(Creating EmailMessage with Status 'Draft' 
					and File Attachment)
* @Created Date  :	13-2-2019
*/
public without sharing class ComposeMailDraftController {
    
    /*
    * @Purpose : Fetch the current logged In User Email If email Message is not present 
    * 			 otherwise fetcth the draft email details.
    * @Param   : String caseId
    * @Return  : Response
    */
    @AuraEnabled 
    public static Response fetchDraftDetails(String caseId){
        String emailAddress;// = UserInfo.getUserEmail();
        Home_Owners__c siteLocation;
        try{
            Case caseRecord = [SELECT Id, Home_Owner__c, Home_Owner__r.Email__c
                               FROM Case 
                               WHERE Id = :caseId LIMIT 1];
            
            if( caseRecord != NULL && caseRecord.Home_Owner__c != NULL && String.isNotBlank(caseRecord.Home_Owner__r.Email__c)){
                emailAddress = caseRecord.Home_Owner__r.Email__c;
            } 
            
        }catch(Exception exp){
            System.debug('exp :' + exp.getMessage());
            System.debug('exp :' + exp.getStackTraceString());
        }
               
        // Email Message Details
        List<Email_Message__c> emailMessages = fetchDraftEmailMessage(caseId);
        
        if(!emailMessages.isEmpty()){
            return new Response(true, emailMessages, 'Email details has been fetch Sucessfully');  
        }
        if(String.isNotBlank(emailAddress)){
            return new Response(true, emailAddress, 'User Email has been fetch Sucessfully');    
        }
        
        return new Response(false, NULL,'Error has been occurred while fetching User Email');
    }
    
    /*
    * @Purpose : fetcth the draft email details.
    * @Param   : String caseId
    * @Return  : List<Email_Message__c>
    */
    private static List<Email_Message__c> fetchDraftEmailMessage(String caseId) {
        return [SELECT Id, Mail_Body__c, Subject__c, Case_Id__c, BCC_Address__c, CC_Address__c, FromAddress__c, 
                Is_Approved__c, To__c, Email_Message_Status__c, Has_Attachment__c, Is_Rejected__c 
                FROM Email_Message__c WHERE Email_Message_Status__c = 'Draft' AND Case_Id__c = :caseId];
    }
    
    /*
    * @Purpose : Create or Update the Email Message with status Draft for the Case
    * @Param   : String mailMessageJSON, String attachmentBlob, String cType, String fileName
    * @Return  : Response
    */
    @AuraEnabled
    public static Response saveDraftMailMessage(String mailMessageJSON, String attachmentBlob, String cType, String fileName){
        Response response = new Response(false, null, null);
        Savepoint sp = Database.setSavepoint();
        
        try{
            Email_Message__c emailMessage = (Email_Message__c) JSON.deserialize(mailMessageJSON, Email_Message__c.class);
            emailMessage.Rejcted_In_Step_1__c = false;
            emailMessage.Is_Rejected__c = false;
            emailMessage.inApprovalStep2__c = false;
            upsert emailMessage;
            if(attachmentBlob != null){
                createAttachement(emailMessage, attachmentBlob, fileName, cType);
            }
            response.isSuccess = true;
            response.data = emailMessage;
            response.message = 'Email Draft is Successfully Created';
            
        }catch(Exception ex){
            Database.rollback(sp);
            System.debug('Exception occurred while creating EmailMessage is::::'+ex.getMessage()+'Cause is::'+ex.getCause()+'Line Number:::'+ex.getLineNumber());
            response = new Response(false, NULL,'Error has been occurred while creating Email Draft::::'+ex.getMessage()+'Cause is::'+ex.getStackTraceString());
        }
        return response;
    }
    
    /*
    * @Purpose : Create Attachment for email Message
    * @Param   : Email_Message__c mailMessage, String fileData, String fileName, String cType
    * @Return  : Attachment
    */
    private static Attachment createAttachement(Email_Message__c mailMessage, String fileData, String fileName, String cType) {
        
        if(String.isNotBlank(mailMessage.Id) && String.isNotBlank(fileData) && String.isNotBlank(fileName)){
            fileData = fileData.replaceFirst('data:image/jpeg;base64,', '');
            fileData = fileData.replaceFirst('data:image/png;base64,', '');
            Attachment attachmentObj = new Attachment();
            attachmentObj.parentId = mailMessage.Id;
            attachmentObj.ContentType = extractMimeType(cType);
            attachmentObj.Body = EncodingUtil.base64Decode(fileData);
            attachmentObj.Name = fileName;
            
            insert attachmentObj;
            return attachmentObj;
        }
        return null;
    }
    
    /*
    * @Purpose : Get the content type for attachment
    * @Param   : String encoded
    * @Return  : String
    */
    private static String extractMimeType(String encoded) {
        encoded = encoded + ',as';
        List<String> strs = encoded.split(',');
        Pattern mime = Pattern.compile('^data:([a-zA-Z0-9]+/[a-zA-Z0-9]+).*,.*');
        Matcher matcher = mime.matcher(strs[0] + ',');
        if (!matcher.find())
            return '';
        return matcher.group(1).toLowerCase();
    }
    
    /* 
    *  @Purpose   : Get all Email templates. 
    */
    @AuraEnabled
    public static Response getEmailTemplates(){ 
        Response result = new Response();
        List<EmailTemplate> emailTemplateList = new List<EmailTemplate>();        
        
        //Fetch all EmailTemplates            
        
        try{
            
            for(EmailTemplate template : [SELECT Id, Name, FolderName, IsActive FROM EmailTemplate]){
                if(template.FolderName.equalsIgnoreCase('StarTek')){
                    emailTemplateList.add(template);
                }
            }
            result.isSuccess = TRUE;
            result.data = emailTemplateList;
        }catch(Exception ex){
            System.debug('Error occured while EmailTemplate records--' + ex.getMessage());
            result.isSuccess = FALSE;
            result.message = ex.getMessage();
        }
        
        return result;
    }
    
    @AuraEnabled
    public static DTO.Response getEmailDefaultValues(String recordId, Id templateId) {
        DTO.Response response = new DTO.Response();
        
        try { 
            EmailTemplate template = [select Id from EmailTemplate where Id = : templateId];
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id, UserInfo.getUserId(), recordId);
            
            Id srecordId = recordId;
            Schema.SObjectType objectName = srecordId.getSobjectType();
            
            EmailWrapper emailResponse = new EmailWrapper();
            Map<String,String> emailTemplateData = new Map<String, String>();
            
            emailTemplateData.put('subject',email.getSubject());
            
            String emailBody = email.getPlainTextBody();
            emailBody = emailBody.replaceAll('\n', '<br />');
            emailBody = emailBody.replaceAll('\r', '');
            emailTemplateData.put('body',emailBody);
            
            emailResponse.subject = email.getSubject();
            emailResponse.body = email.getHtmlBody();
            
            response.Success = true;
            response.Message = 'Opportunity Quote Email Template';
            
            //emailTemplateData.put('to','sample@gmail.com');
            //Get Contact Email in the related Site Location record of Case.
            response.Data = emailTemplateData; 
        } catch (Exception ex) {            
            response.Success = false;            
            response.Message = ex.getMessage();
        }
        System.debug('Response :' + JSON.serialize(response));
        return response;
    }
    
     public class EmailWrapper
    {
        String to;
        String cc;
        String bcc;
        String subject;
        String body;
        
        EmailWrapper()
        {
            to = '';
            cc = '';
            body = '';
            subject = '';
            bcc = '';
        }
    }
}