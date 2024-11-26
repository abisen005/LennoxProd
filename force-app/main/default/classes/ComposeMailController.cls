public class ComposeMailController {
    
   /* 
    *  @Purpose   : Get all Email templates. 
    */
    @AuraEnabled
    public static Response getEmailTemplates(){ 
        Response result = new Response();
        List<EmailTemplate> emailTemplateList = new List<EmailTemplate>();        
        
        //Fetch all EmailTemplates            
        
        try{
            emailTemplateList = [SELECT Id, Name
                                 FROM EmailTemplate];
            result.isSuccess = TRUE;
            result.data = emailTemplateList;
        }catch(Exception ex){
            System.debug('Error occured while fetching EmailTemplate records--' + ex.getMessage());
            result.isSuccess = FALSE;
            result.msg = ex.getMessage();
        }
        
        return result;
    }
    
    /* 
    *  @Purpose   : Get email address of Contact related to Site location of Case. 
    */
    @AuraEnabled
    public static Response getEmailAddress(Id recordId){ 
        Response result = new Response();
        String emailAddress;
        
        //Fetch all EmailTemplates            
        List<Home_Owners__c> siteLocationList;
        System.debug('REcord Id ::;' + recordId);
        try{            
            Case caseRecord = [SELECT Id, Home_Owner__c, CA_Form_Sent__c
                               FROM Case 
                               WHERE Id =: recordId LIMIT 1];
            System.debug('caseRecord ::' + JSON.serialize(caseRecord));
            if( caseRecord != NULL && caseRecord.Home_Owner__c != NULL ){
                //Get Contact Email in the related Site Location record of Case. 
                siteLocationList = [SELECT Id, Email__c FROM Home_Owners__c WHERE Id =: caseRecord.Home_Owner__c LIMIT 1];
                result.isEnabled = !caseRecord.CA_Form_Sent__c;
            } 

            
            
            System.debug('siteLocation :' + JSON.serialize(siteLocationList));
        }catch(Exception ex){
            System.debug('Error occured while fetching Home_Owners__c records--' + ex.getMessage());
            result.isSuccess = FALSE;
            result.msg = ex.getMessage();
        }
        
        if( siteLocationList != NULL 
           && !siteLocationList.isEmpty()
           && String.isNotBlank(siteLocationList[0].Email__c)){
               result.isSuccess = TRUE;
               result.data = siteLocationList[0].Email__c;
           }else{
               result.isSuccess = FALSE;
               result.msg = 'Email address is not found, Please check Site Location and its Contact record.';
           }
        
        return result;
    }
    
    public class Response{
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public object data;
        @AuraEnabled
        public boolean isEnabled;
        
        public Response(){}
        
        public Response(boolean isSuccess, String msg, object data){
            this.msg = msg;
            this.isSuccess = isSuccess;
            this.data = data; 
        }
    }
    
    @AuraEnabled
    public static DTO.Response getEmailDefaultValues(String recordId) {
        DTO.Response response = new DTO.Response();
        
        try { 
            
            Case caseRecord = [SELECT Id, Home_Owner__c, sitelocationname__c,CaseNumber
                               FROM Case 
                               WHERE Id =: recordId LIMIT 1];
            
            System.debug('caseRecord--' + caseRecord);
            Map<String,String> emailTemplateData = new Map<String, String>();
                
            if( caseRecord != NULL && caseRecord.Home_Owner__c != NULL ){
                //Get Contact Email in the related Site Location record of Case.                 
                Home_Owners__c siteLocation = [SELECT Id, Email__c
                                               FROM Home_Owners__c 
                                               WHERE Id =: caseRecord.Home_Owner__c LIMIT 1];
                
                
                System.debug('siteLocation :' + JSON.serialize(siteLocation));
                if( siteLocation != NULL && String.isNotBlank(siteLocation.Email__c)){
                    EmailTemplate template = [select Id from EmailTemplate where DeveloperName = 'Consumer_Support_Request'];
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id, UserInfo.getUserId(), siteLocation.Id);
                    
                    Id srecordId = recordId;
                    Schema.SObjectType objectName = srecordId.getSobjectType();
                    
                    EmailWrapper emailResponse = new EmailWrapper();                
                    
                    emailTemplateData.put('subject',email.getSubject()+caseRecord.CaseNumber );
                    
                    String emailBody = email.getPlainTextBody();
                    emailBody = emailBody.replaceAll('\n', '<br />');
                    emailBody = emailBody.replaceAll('\r', '');
                    emailBody = emailBody.replaceAll('CaseId', caseRecord.Id);
                    emailBody = emailBody.replaceAll('sitelocationname', caseRecord.sitelocationname__c);
                    
                    emailTemplateData.put('body',emailBody);
                    
                    emailResponse.subject = email.getSubject();
                    emailResponse.body = email.getHtmlBody();
                    
                    response.Success = true;
                    response.Message = 'Consumer_Support_Request';
                    
                    emailTemplateData.put('to',siteLocation.Email__c);
                }
            }else{
                response.Success = false;
                response.Message = 'Site Location not found.';
            }
            
            response.Data = emailTemplateData; 
        } catch (Exception ex) {            
            response.Success = false;            
            response.Message = ex.getMessage();
        }
        System.debug('Response :' + JSON.serialize(response));
        return response;
    }
    
    @AuraEnabled
    public static DTO.Response sendMails(String mailContentJson, Id caseId) {
        DTO.Response response = new DTO.Response();
        SavePoint savePt = Database.setSavepoint();
        String htmlBodyStr; 

        
       
        try {            
            MailContents mContent = new MailContents();
            mContent = mContent.parseMailContent(mailContentJson);
            
            Messaging.SingleEmailMessage singleMailMessage = createMailMessage(mContent);//= createSingleMailMessage(emailMessage, attachments);
            System.debug('singleMailMessage--' + JSON.serializePretty(singleMailMessage));            
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {singleMailMessage});

            update new Case(Id = caseId, CA_Form_Sent__c = true);

            response.Success = true;
            response.Message = 'Your mail has been sent.';
            
        } catch (Exception ex) { 
            Database.rollback(savePt);                        
            response.Success = false;
            response.Message = ex.getMessage();
        }
        
        return response;
    }
    
    private static Messaging.SingleEmailMessage createMailMessage( MailContents mContent ) {
        Messaging.SingleEmailMessage sEmailMessage = new Messaging.SingleEmailMessage();
        if(!mContent.mRecipients.isEmpty()){
            sEmailMessage.setToAddresses(mContent.mRecipients);
        }
        if(!mContent.mCcs.isEmpty()){
            sEmailMessage.setCcAddresses(mContent.mCcs);
        }
        if(!mContent.mBccs.isEmpty()){
            sEmailMessage.setBccAddresses(mContent.mBccs);
        }
        
        if(String.isNotBlank(mContent.mSubject)){
            sEmailMessage.setSubject(mContent.mSubject);
        }

        if(String.isNotBlank(mContent.mBody)){            
            sEmailMessage.setHtmlBody(mContent.mBody);
        }else{
            sEmailMessage.setHtmlBody('<p> </p>');
        }
        if(String.isNotBlank(mContent.mAttachment)){
            Messaging.EmailFileAttachment emailFile = new Messaging.EmailFileAttachment();
            emailFile.setFileName(mContent.fileName.trim());
            emailFile.setContentType(extractMimeType(mContent.contentType));
            emailFile.setBody(EncodingUtil.base64Decode(mContent.mAttachment));

            sEmailMessage.setFileAttachments(new List<Messaging.EmailFileAttachment> {emailFile});
        }
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumeraffairs@lennoxind.com'];
            
            if ( owea.size() > 0 ) {
                sEmailMessage.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
        }catch(Exception ex){
            System.debug('Error occured while fetching OrgWideEmailAddress--' + ex.getMessage());
        }
        
        
        return sEmailMessage;
    }   
    
    public static List<String> trimStrings(List<String> ipStrings) {
        List<String> opStrings = new List<String>();
        for (String ipStr : ipStrings) {
            ipStr = ipStr.trim();
            if (String.isNotBlank(ipStr)) {
                opStrings.add(ipStr.trim()); 
            }            
        }
        return opStrings;
    }

    private static String extractMimeType(String encoded) {
        encoded = encoded + ',as';
        List<String> strs = encoded.split(',');
        Pattern mime = Pattern.compile('^data:([a-zA-Z0-9]+/[a-zA-Z0-9]+).*,.*');
        Matcher matcher = mime.matcher(strs[0] + ',');
        if (!matcher.find())
            return '';
        return matcher.group(1).toLowerCase();
    }   
    
    @AuraEnabled
    public static DTO.Response getContact(String contactName) {
        DTO.Response response = new DTO.Response();
        List<Contact> contactList = new List<Contact>();
        
        if(String.isNotBlank(contactName)){
            
            try{
                contactList = [SELECT id,Name,Email
                               FROM Contact
                               WHERE Name Like : contactName + '%'
                               AND Email != : ''] ;   
                
                response.Success = true;
                response.Message = 'Contacts are sucessfully retrived';
                response.Data = contactList;  
                
            }catch(Exception ex){
                response.Success = false;
                response.Message = 'Error occured while fetching contacts is:::'+ex.getMessage();
                response.Data = null;   
            }
        }else{
            response.Success = false;
            response.Message = 'contactName can not be blank';
            response.Data = null;       
        }
        
        return response;
    }
    
    public class MailContents {
        public List<String> mRecipients;
        public List<String> mCcs;
        public List<String> mBccs;
        Public String mSubject;
        Public String mBody; 
        Public String mAttachment;
        public String fileName;
        public String contentType;
        
        public MailContents() {
            //parseMailContent(mailContentJson); 
        }
        
        public MailContents parseMailContent(String mailContentJson) {
            return (MailContents)JSON.deserialize(mailContentJson, MailContents.class);          
        }
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