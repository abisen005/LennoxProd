public without sharing class ConsumerDetailsController {
    
   /* 
    *  @Purpose   : Get object name.
	*  Parameter  : caseId (String)
    */
    @AuraEnabled
    public static Boolean getObjectName( String caseId ){ 
        
        try {
            if(String.valueOf(Id.valueOf(caseId).getsobjecttype()).equals('Case')){
                return true;
            }else{
                return false;
            }
            
        }catch (Exception Ex) {            
            return false;
        }
    }	
    
    @AuraEnabled
    public static string getRecordTypeId(){ 
        
        try {
            
            string devRecordTypeId = Schema.SObjectType.Lennox_Form__c.getRecordTypeInfosByName().get('Consumer Details').getRecordTypeId();
            return devRecordTypeId;
            
        }catch (Exception Ex) { 
            return '';
        }
    }	
    
   /* 
    *  @Purpose   : Insert Installation records. 
    *  @Parameter : lennoxFormList
    */
    @AuraEnabled
    public static Response updateSiteLocationRecord(String strlennoxFormRecord, String strSummeryOfConcern ){ 
        Response result = new Response();
        System.debug('strlennoxFormRecord--' + strlennoxFormRecord);   
        
        if(String.isNotBlank(strlennoxFormRecord) ){
            
            try{
                List<Lennox_Form__c> lennoxFormList = (List<Lennox_Form__c>) System.JSON.deserialize(strlennoxFormRecord, List<Lennox_Form__c>.class);
                System.debug('lennoxFormList--' + lennoxFormList);
                
                if( lennoxFormList != NULL && !lennoxFormList.isEmpty() && lennoxFormList[0].Case__c != NULL ){
                    
                    System.debug('lennoxFormList[0].Case__c--' + lennoxFormList[0].Case__c);
                     lennoxFormList[0].Case__c =  lennoxFormList[0].Case__c;
                    // lennoxFormList[0].Summary_of_Concerns__c = strSummeryOfConcern;  
                    Update lennoxFormList;
                    Response siteDetails = getSiteLocationDetails(lennoxFormList[0].Case__c);
                    
                    Object siteLocationObject = siteDetails.data;
                    Home_Owners__c siteLocation = (Home_Owners__c)siteLocationObject;
                    
                    if(siteLocation != NULL){
                        
                        siteLocation.FirstName__c = lennoxFormList[0].First_Name__c;
                        siteLocation.LastName__c = lennoxFormList[0].Last_Name__c;
                        siteLocation.Postal_Code__c = string.isNotBlank(lennoxFormList[0].Consumer_Postal_Code__c) ? lennoxFormList[0].Consumer_Postal_Code__c : siteLocation.Postal_Code__c;
                        siteLocation.Address__c = string.isNotBlank(lennoxFormList[0].Consumer_Street_Address__c) ? lennoxFormList[0].Consumer_Street_Address__c : siteLocation.Address__c;
                        siteLocation.City__c = string.isNotBlank(lennoxFormList[0].Consumer_City__c) ? lennoxFormList[0].Consumer_City__c:siteLocation.City__c;
                        siteLocation.StateProvince__c = string.isNotBlank(lennoxFormList[0].Consumer_State__c) ? lennoxFormList[0].Consumer_State__c : siteLocation.StateProvince__c;
                        siteLocation.Phone__c = lennoxFormList[0].Home_Phone__c;
                        siteLocation.Phone1__c = lennoxFormList[0].Business_Phone__c;
                        
                        System.debug('siteLocation.FirstName__c ' + siteLocation);
                        System.debug('lennoxFormList[0]  ' + lennoxFormList[0]);
                    }
                    
                    
                    System.debug('lennoxFormList[0].Consumer_State__c--' + lennoxFormList[0].Consumer_State__c);
                    System.debug('siteLocation--' + siteLocation);
                    
                    if( siteLocation != null && String.isNotBlank(siteLocation.Id)){
                        UPDATE siteLocation;
                    }                    
                    
                    result.isSuccess = TRUE;
                    result.data = lennoxFormList;
                }else{
                    result.isSuccess = FALSE;
                    result.msg = 'Lennox_Form record parsing error';
                }
                
                
            }catch(Exception ex){
                System.debug('Error occured while update SiteLocation Record--' + ex.getMessage());
                result.isSuccess = FALSE;
                result.msg = ex.getMessage();
            }
        }
        System.debug('result--' + result);
        return result;
    }
    
   /* 
    *  @Purpose   : Get all Site Location record details. 
	*  Parameter  : caseId (String)
    */
    @AuraEnabled
    public static Response getSiteLocationDetails( String caseId ){ 
        Response result = new Response();
        
        try {
            Case caseRecord = [SELECT Id, Home_Owner__c , Lennox_Consumer_Details_Form__c
                               FROM Case 
                               WHERE Id =: caseId LIMIT 1];
            
            System.debug('caseRecord--' + caseRecord);
            
            if( caseRecord != NULL && caseRecord.Home_Owner__c != NULL ){
                List<Home_Owners__c> homeOwner = [SELECT Id, FirstName__c, LastName__c, Postal_Code__c, Address__c, City__c, 
                                                  StateProvince__c, Phone__c, Phone1__c
                                                  FROM Home_Owners__c 
                                                  WHERE Id =: caseRecord.Home_Owner__c LIMIT 1];
                
                System.debug('homeOwner' + homeOwner );
                
                if(homeOwner != null && !homeOwner.isEmpty()){
                    result.data = homeOwner[0];
                    result.isSuccess = TRUE;
                    result.lennoxFormSubmitted = caseRecord.Lennox_Consumer_Details_Form__c;   
                }
                else{
                    result.data = new Home_Owners__c();
                    result.isSuccess = False;
                }
                
                
            }else{
                result.data = new Home_Owners__c();
                result.isSuccess = False;
            }
        }catch (QueryException qEx) {
            System.debug('Error getting Home_Owners: ' + qEx.getMessage());
            result.isSuccess = FALSE;
            result.msg = qEx.getMessage();
        }
        
        return result;
    }	

   /* 
    *  @Purpose   : Get  Form_Instruction__c records. 
    *  @Parameter : formType
    */
    @AuraEnabled
    public static List<Form_Instruction__c> getInstructions(String formType) {
        try {
            return [SELECT Id, Form_Type__c, Status__c, Order__c, Header__c, Instruction__c
                    FROM Form_Instruction__c
                    WHERE Form_Type__c = :formType
                    AND Status__c = 'Active'
                    ORDER BY Order__c ASC];
        }
        catch (QueryException qEx) {
            System.debug('Error getting instructions: ' + qEx.getMessage());
            return null;
        }
    }
    
   /* 
    *  @Purpose   : Insert Installation records. 
    *  @Parameter : String strInstallationList , String caseId
    */
    @AuraEnabled
    public static Response insertInstallationRecords(String strInstallationList , String caseId, String strSummeryOfConcern){ 
        Response result = new Response();
        System.debug('strInstallationList--' + strInstallationList);
        System.debug('strSummeryOfConcern--' + strSummeryOfConcern);
        
        if(String.isNotBlank(strInstallationList) ){
            
            try{
                List<Installation__c> installationList = (List<Installation__c>) System.JSON.deserialize(strInstallationList, List<Installation__c>.class);
                //INSERT installationList;
                
                List<String> serialNumberList = new List<String>();
                //Get Serial Numbers from list and check is there any Equipment record is present with this serial number 
                //if Equipment record is present then update this record other wise create new Equipment record
                for( Installation__c installation : installationList ){
                    serialNumberList.add(installation.Serial_Number__c);
                }
                
                System.debug('serialNumberList--' + serialNumberList);
                
                // Serch for Equipment records
                List<Case_Equip_Junction__c> equipmentList = [SELECT Id, Equipment_Data__c, Serial_Number__c
                                                              FROM Case_Equip_Junction__c
                                                              WHERE Serial_Number__c IN : serialNumberList
                                                              AND Case__c =: caseId];
                
                System.debug('equipmentList--' + equipmentList);
                List<Equipment_Data__c> equipmentDataList = new List<Equipment_Data__c>();
                
                Map<String,Case_Equip_Junction__c> equipmentMap = new Map<String,Case_Equip_Junction__c>();
                
                //Create Map of SerialNumber to Equipment record
                for(Case_Equip_Junction__c equipment: equipmentList){
                    if(!equipmentMap.containsKey(equipment.Serial_Number__c)){
                        equipmentMap.put(String.valueOf(equipment.Serial_Number__c),equipment);
                    }                        
                }
                
                System.debug('equipmentMap--' + equipmentMap);
                String type; 
                
                for(Installation__c installation : installationList){
                    System.debug('installation--' + installation);
                     System.debug('installation--' + installation.Installation_Type__c);
                    type = installation.Installation_Type__c;
                    
                    if( equipmentMap != NULL && equipmentMap.containsKey(String.valueOf(installation.Serial_Number__c)) ){
                       System.debug('installation--'+installation.Installation_Type__c);
                        
                        if(String.isNotBlank(installation.Installation_Type__c)){
                            
                            if(installation.Installation_Type__c == 'Indoor Unit'){
                                
                                type = 'Indoor';
                            }
                            
                            if(installation.Installation_Type__c == 'Outdoor Unit'){
                                
                                type = 'Outdoor';
                            }
                            
                            if(installation.Installation_Type__c == 'Evaporator Coil'){
                                
                                type = 'Coil';
                            }
                            
                        }
                        
                        //Update Equipment Data records here
                        equipmentDataList.add(new Equipment_Data__c(Id = equipmentMap.get(installation.Serial_Number__c).Equipment_Data__c,
                                                                    Type__c = type,
                                                                    Installation_Date__c = installation.Date_Installed__c,
                                                                    Serial_Number__c = installation.Serial_Number__c,
                                                                    Model_Number__c = installation.Model_Number__c));
                    }else{
                        system.debug('iN Else');
                        //Create new Equipment Data here
                        equipmentDataList.add(new Equipment_Data__c(Type__c = type,
                                                                    Installation_Date__c = installation.Date_Installed__c,
                                                                    Serial_Number__c = installation.Serial_Number__c,
                                                                    Model_Number__c = installation.Model_Number__c,
                                                                    Case__c = caseId));
                    }
                }
                
                system.debug('equipmentDataList'+equipmentDataList);
                UPSERT equipmentDataList;
                
                result.isSuccess = TRUE;
                result.data = installationList;
            }catch(Exception ex){
                System.debug('Error occured while inserting Installation__c records--' + ex.getMessage());
                result.isSuccess = FALSE;
                result.msg = ex.getMessage();
            }
        }
        
        // Send email to Case Owner
        //Get Owner Email and Name from Case
        Case caseRecord = [SELECT id, Owner.Email, Owner.Name, Summary_of_Concerns__c
                           FROM Case 
                           WHERE Id = : caseId];
        
        if( caseRecord != NULL && String.isNotBlank(caseRecord.Owner.Email)){
            String emailAddress = caseRecord.Owner.Email;
            String userName = caseRecord.Owner.Name;
            
            sendMail(emailAddress, userName );
            
            // Update Case record
            caseRecord.Lennox_Consumer_Details_Form__c = true;
            if(String.isNotBlank(strSummeryOfConcern)){
                caseRecord.Summary_of_Concerns__c = strSummeryOfConcern;
            }
            try{
                UPDATE caseRecord;
            }catch(Exception ex){
                System.debug('Error occured while updating Case record--' + ex.getMessage());
            }
            
            result.isSuccess = TRUE;
            result.data = 'Email Sent to Case Owner';
        }
                
        System.debug('result--' + result);
        return result;
    }
    
    @AuraEnabled
    public static void sendMail( String toMail, String userName){
        if( String.isNotBlank(toMail) ){
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string[] to = new string[] {toMail};
                
            email.setToAddresses(to);
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumeraffairs@lennoxind.com'];
            
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            email.setSubject('Response has been received');
            
            email.setHtmlBody('Hello '+ userName +' , <br/><br/> Consumer Affairs Support Form response has been received.');
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }catch(exception e){
                system.debug('$$$$ Exception e'+e);
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        }
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            system.debug('base64Data === '+base64Data);
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        System.debug('parentId--' + parentId);
        System.debug('base64Data--' + base64Data);
        System.debug('fileName--' + fileName);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
      /*  Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        system.debug('oAttachment'+oAttachment);
        insert oAttachment;
        
        return oAttachment.Id;*/
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = fileName; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        system.debug('conVer === '+conVer);
        
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
         system.debug('conDocLink === '+conDocLink);
        
        return conDocLink.Id;
        
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    public class Response{
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public object data;
        @AuraEnabled
        public boolean lennoxFormSubmitted;
        
        public Response(){}
     
    }
}