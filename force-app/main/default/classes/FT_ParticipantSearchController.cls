/*
@Author : Amol B
@Purpose : find eligible field trial participant applications
@Usage : used as controller for lightning component to find eligible field trial participant applications
*/

public class FT_ParticipantSearchController {
    
    //return deails of all matching participant details eligible for selected field trial
    @AuraEnabled
    public static Object getMatchingParticipantApplications(String strFieldTrialId){
        
        if(String.isNotBlank(strFieldTrialId)){
            
            Map<String, List<Schema.FieldSetMember>> fieldSetMap = getFieldsToMatch();
            
            if(!fieldSetMap.isEmpty()){
                
                List<Schema.FieldSetMember> lstFieldsToMatch = new List<Schema.FieldSetMember>();
                lstFieldsToMatch.addAll( fieldSetMap.get( 'Application' ) );
                lstFieldsToMatch.addAll( fieldSetMap.get( 'System' ) );
                
                //get Field Trial record details
                FT_Field_Trial__c fieldTrialDetails = getFieldTrialDetails(strFieldTrialId, lstFieldsToMatch);
                
                if(fieldTrialDetails != null){
                    
                    //get all existing employee ids and exclude them from result
                    Set<String> setExistingEmployeeIds = new Set<String>();
                    
                    if(!fieldTrialDetails.Field_Trial_Contacts1__r.isEmpty()){
                        
                        for(Field_Trial_Contacts__c fieldTrialContact : fieldTrialDetails.Field_Trial_Contacts1__r){
                            if(String.isNotBlank(fieldTrialContact.FT_Employee_ID__c)){
                                setExistingEmployeeIds.add(fieldTrialContact.FT_Employee_ID__c.toLowerCase());
                            }
                        }
                    }
                    
                    //get list of Field Trial Participant Applications
                    List<FT_Field_Trial_Participant_Application__c> lstFieldTrialParticipantApplications = getParticipantApplications(fieldTrialDetails, fieldSetMap, setExistingEmployeeIds);
                    
                    if(!lstFieldTrialParticipantApplications.isEmpty()){
                        
                        //build a map to group result by State / province and display on UI
                        Map<String,List<FT_Field_Trial_Participant_Application__c>> mapState_ListOfApplications = new Map<String,List<FT_Field_Trial_Participant_Application__c>>();
                        
                        for(FT_Field_Trial_Participant_Application__c fieldTrialApplication : lstFieldTrialParticipantApplications){
                            
                            if( !fieldTrialApplication.Field_Trial_Participant_Applctn_Systems__r.isEmpty() ) {
                                
                                if(!mapState_ListOfApplications.containsKey(fieldTrialApplication.FT_State_Province__c)){
                                    mapState_ListOfApplications.put(fieldTrialApplication.FT_State_Province__c, new List<FT_Field_Trial_Participant_Application__c>());
                                }
                                
                                mapState_ListOfApplications.get(fieldTrialApplication.FT_State_Province__c).add(fieldTrialApplication);
                            }
                        }
                        
                        if(!mapState_ListOfApplications.isEmpty()){
                            
                            List<ApplicationDetail> lstApplicationDetails = new List<ApplicationDetail>();
                            
                            for(String stateOrProv : mapState_ListOfApplications.keySet()){
                                
                                List<String> lstParticipantApplicationIds = new List<String>();
                                
                                for(FT_Field_Trial_Participant_Application__c FTCPapplication :mapState_ListOfApplications.get(stateOrProv)){
                                    
                                    lstParticipantApplicationIds.add(FTCPapplication.Id);
                                }
                                
                                lstApplicationDetails.add(new ApplicationDetail(stateOrProv, lstParticipantApplicationIds, 0));
                            }
                            
                            return lstApplicationDetails;
                        }
                    }
                }
            }
        }
        
        return 'noRecords';
    }
    
    //fetch details from field set "FT_Fields_To_Match" and return API names of all selected fields
    public static Map<String, List<Schema.FieldSetMember>> getFieldsToMatch(){
        
        Map<String, List<Schema.FieldSetMember>> fieldSetMap = new Map<String, List<Schema.FieldSetMember>>();
        
        try{
            
            fieldSetMap.put( 'Application', SObjectType.FT_Field_Trial_Participant_Application__c.FieldSets.FT_Fields_To_Match.getFields() );
            fieldSetMap.put( 'System', SObjectType.FT_Field_Trial_Participant_Applctn_Systm__c.FieldSets.FT_Fields_to_Match.getFields() );            
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return fieldSetMap;
    }
    
    //build dynamic query based on fields selected in field set and return record details
    public static FT_Field_Trial__c getFieldTrialDetails(String strFieldTrialId, List<Schema.FieldSetMember> lstFieldsToMatch){
        
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember field : lstFieldsToMatch){
            
            query += field.getFieldPath() + ',';
        }
        
        query += 'Id, (SELECT FT_Employee_ID__c FROM Field_Trial_Contacts1__r) FROM FT_Field_Trial__c WHERE Id = \'' + strFieldTrialId + '\' LIMIT 1';
        
        List<FT_Field_Trial__c> lstFieldTrials;
        
        try{
            
            lstFieldTrials = Database.query(query);
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        if(lstFieldTrials != null && !lstFieldTrials.isEmpty()){
            
            return lstFieldTrials[0];
        }
        
        return null;
    }
    
    //buils query for Field Trial Participant application object based on fields selected in field set
    public static List<FT_Field_Trial_Participant_Application__c> getParticipantApplications(FT_Field_Trial__c fieldTrialDetails, Map<String, List<Schema.FieldSetMember>> fieldSetMap, Set<String> setExistingEmployeeIds){
        
        List<FT_Field_Trial_Participant_Application__c> lstFieldTrialParticipantApplications = new List<FT_Field_Trial_Participant_Application__c>();
        
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember field : fieldSetMap.get('Application')){
            
            query += field.getFieldPath() + ',';
        }
        
        query += ' ( SELECT ';
        
        for(Schema.FieldSetMember field : fieldSetMap.get('System')){
            
            query += field.getFieldPath() + ',';
        }
        
        query += 'Id FROM Field_Trial_Participant_Applctn_Systems__r WHERE FT_Field_Trial_Participant_Application__r.FT_Field_Trial_Contacts__r.FT_Field_Trial__c != \'' + fieldTrialDetails.Id + '\'';
        
        query = createMatchingFieldCriteria( query, fieldTrialDetails, fieldSetMap.get('System') );
        
        query += ' LIMIT 1 ), ';
        
        query += 'Id,FT_Field_Trial_Contacts__r.FT_Employee_ID__c FROM FT_Field_Trial_Participant_Application__c WHERE ' + 
            	 'FT_State_Province__c != null AND FT_Field_Trial_Contacts__r.FT_Field_Trial__c != \'' + fieldTrialDetails.Id + '\' AND FT_Employee_ID__c NOT IN :setExistingEmployeeIds ';
        
        query = createMatchingFieldCriteria( query, fieldTrialDetails, fieldSetMap.get('Application') );          
        system.debug('Query -- ' + query);
        try{
            
            lstFieldTrialParticipantApplications = Database.query(query);
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        if(lstFieldTrialParticipantApplications != null && !lstFieldTrialParticipantApplications.isEmpty()){
            
            return lstFieldTrialParticipantApplications;
        }
        
        return lstFieldTrialParticipantApplications;
    }
    
    private static String createMatchingFieldCriteria( String query, FT_Field_Trial__c fieldTrialDetails, List<Schema.FieldSetMember> fieldSetList ) {
        
        if( fieldSetList <> null && !fieldSetList.isEmpty() ) {
            
            for(Schema.FieldSetMember field : fieldSetList){
            	if(fieldTrialDetails.get(field.getFieldPath()) == null){                    
                    //query += ' AND ' + field.getFieldPath() + ' = null ';
                }
                else{
                    if(String.valueOf(field.getType()) == 'BOOLEAN'){
                        
                        if(fieldTrialDetails.get(field.getFieldPath()) == 'Yes'){
                            query += ' AND ' + field.getFieldPath() + ' = true ';
                        }
                        else{
                            query += ' AND ' + field.getFieldPath() + ' = false ';
                        }                
                    }
                    else if(String.valueOf(field.getType()) == 'DOUBLE'){
                        query += ' AND ' + field.getFieldPath() + ' = ' + fieldTrialDetails.get(field.getFieldPath());
                    }
                    else{                
                        query += ' AND ' + field.getFieldPath() + ' = \'' + fieldTrialDetails.get(field.getFieldPath()) +  '\'';
                    }
                }
            }
        }
        
        return query;
    }
    
    //accept number of applications from user and create contact and field trial contact records
    @AuraEnabled
    public static Object createFieldTrialContacts(String strFieldTrialId, List<ApplicationDetail> lstApplicationDetails){
        
        if(!lstApplicationDetails.isEmpty()){
            
            //randomly select applications based on user inputs and available participant list
            List<ApplicationDetail> lstSelectedApplicationDetails = selectParticipantApplications(lstApplicationDetails);
            
            //query all required details from field trial participant record
            Map<Id,FT_Field_Trial_Participant_Application__c> mapParticipantDetails = getParticipantDetails(lstSelectedApplicationDetails);
            
            //check for existing contact and create new contact record if not exist for Employee Id
            Map<String,Contact> mapEmployeeId_Contact = getContactRecordDetails(strFieldTrialId, mapParticipantDetails);
            
            //create new field trial contact record for Employee Id
            createFieldTrialContactDetails(strFieldTrialId, mapParticipantDetails, mapEmployeeId_Contact);
        }
        
        return 'Success';
    }
    
    //fetch details from application wrapper class and query all required fields for creating contact records
    public static Map<Id,FT_Field_Trial_Participant_Application__c> getParticipantDetails(List<ApplicationDetail> lstApplicationDetails){
        
        List<String> lstAllSelectedApplications = new List<String>();
        Map<Id,FT_Field_Trial_Participant_Application__c> mapParticipantDetails = new Map<Id,FT_Field_Trial_Participant_Application__c>();
        
        for(ApplicationDetail application : lstApplicationDetails){
            
            if(!application.participantApplications.isEmpty()){
                
                lstAllSelectedApplications.addAll(application.participantApplications);
            }
        }
        
        if(!lstAllSelectedApplications.isEmpty()){
            
            mapParticipantDetails = new Map<Id,FT_Field_Trial_Participant_Application__c>([
                
                                            SELECT Id, FT_First_Name__c, FT_City__c, FT_Email__c, FT_State_Province__c,
                                                    FT_Street_Address__c, FT_Cell_Phone_Number__c, FT_Zip_Code__c,
                                                    FT_Employee_ID__c, FT_Country__c, FT_Last_Name__c
                                            FROM FT_Field_Trial_Participant_Application__c
                                            WHERE Id IN :lstAllSelectedApplications
                                        ]);
        }
        
        return mapParticipantDetails;
    }
    
    //randomly select applications based on user inputs and available participant list
    public static List<ApplicationDetail> selectParticipantApplications(List<ApplicationDetail> lstApplicationDetails){
        
        List<ApplicationDetail> lstSelectedApplicationDetails = new List<ApplicationDetail>();
        
        for(ApplicationDetail application : lstApplicationDetails){
            
            if(!application.participantApplications.isEmpty() && application.numberOfParticipantsRequired > 0){
                
                List<String> lstSelectedApplications = new List<String>();
                
                //randomly get record from list
                for(Integer loopVar = 0; loopVar < application.numberOfParticipantsRequired; loopVar++){
                    
                    Integer randomIndex = getRandomIndex(application.participantApplications.size());
                    
                    lstSelectedApplications.add(application.participantApplications[randomIndex]);
                    
                    //remove selected records from the list to avoid duplicate selection
                    application.participantApplications.remove(randomIndex);
                }
                
                lstSelectedApplicationDetails.add(new ApplicationDetail(application.stateOrProvince,lstSelectedApplications,application.numberOfParticipantsRequired));
            }
        }
        
        return lstSelectedApplicationDetails;
    }
    
    //check for existing contact or create new contact for participant record
    public static Map<String,Contact> getContactRecordDetails(String strFieldTrialId, Map<Id,FT_Field_Trial_Participant_Application__c> mapParticipantDetails){
        
        Map<String,Contact> mapEmployeeId_Contact = new Map<String,Contact>();
        Map<String,FT_Field_Trial_Participant_Application__c> mapEmployeeId_FieldTrialParticipantApplication = new Map<String,FT_Field_Trial_Participant_Application__c>();
        
        for(Id participantId :mapParticipantDetails.keySet()){
            
            if(mapParticipantDetails.get(participantId).FT_Employee_ID__c != null ){
                
                mapEmployeeId_Contact.put(mapParticipantDetails.get(participantId).FT_Employee_ID__c , null);
                mapEmployeeId_FieldTrialParticipantApplication.put(mapParticipantDetails.get(participantId).FT_Employee_ID__c, mapParticipantDetails.get(participantId));
            }
        }
        
        //query for Contact records
        List<Contact> lstContacts = new List<Contact>();
        
        lstContacts = [SELECT Id,Lennox_Employee_ID__c FROM Contact WHERE Lennox_Employee_ID__c IN :mapEmployeeId_Contact.keySet()];
        
        //add existing contact reference in employee id map
        if(!lstContacts.isEmpty()){
            
            for(Contact contactRec : lstContacts){
                
                mapEmployeeId_Contact.put(contactRec.Lennox_Employee_ID__c, contactRec);
            }
        }
        
        //get user / owner details
        Id ownerUserId = getContactOwnerDetails();
        
        //get account details
        Id accountId = getParentAccountId();
        
        //get record type details for Residential Contact
        Id contactRecordTypeId = getRecordTypeId('Residential Contact','Contact');
        
        //create new contact record for employee ids if needed
        for( String employeeId : mapEmployeeId_Contact.keySet()){
            
            if(mapEmployeeId_Contact.get(employeeId) == null){
                
                FT_Field_Trial_Participant_Application__c participantApplication = mapEmployeeId_FieldTrialParticipantApplication.get(employeeId);
                
                //create new contact
                mapEmployeeId_Contact.put(employeeId, new Contact(
                    
                    FirstName = participantApplication.FT_First_Name__c,
                    LastName = participantApplication.FT_Last_Name__c,
                    OwnerId = ownerUserId,
                    AccountId = accountId,
                    RecordTypeId = contactRecordTypeId,
                    MailingStreet = participantApplication.FT_Street_Address__c,
                    MailingState = participantApplication.FT_State_Province__c,
                    MailingCity = participantApplication.FT_City__c,
                    MailingPostalCode = participantApplication.FT_Zip_Code__c,
                    Email = participantApplication.FT_Email__c,
                    MobilePhone = participantApplication.FT_Cell_Phone_Number__c,
                    Contact_Type__c = 'Employee',
                    MailingCountry = participantApplication.FT_Country__c,
                    Lennox_Employee_ID__c = participantApplication.FT_Employee_ID__c,
                    Role__c = 'Other'
                ));
            }
        }
        
        if(!mapEmployeeId_Contact.isEmpty() && !mapEmployeeId_Contact.values().isEmpty()){
            
            try{
                
                UPSERT mapEmployeeId_Contact.values();
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }
        }
        
        return mapEmployeeId_Contact;
    }
    
    public static Integer getRandomIndex(Integer maxIndex){
        
        Integer randomIndex = 0;
        
        randomIndex = Math.round(Math.random()*1000);
        
        return Math.mod(randomIndex, maxIndex);
    }
    
    public static Id getContactOwnerDetails(){
        
        List<User> ownerUser = [SELECT Id FROM User WHERE Name = 'Lennox Intgrtduser' LIMIT 1];
        
        if(!ownerUser.isEmpty())
            return ownerUser[0].Id;
        
        return null;
    }
    
    public static Id getParentAccountId(){
        
        List<Account> parentAccount = [SELECT Id FROM Account WHERE Name = 'Lennox International' LIMIT 1];
        
        if(!parentAccount.isEmpty())
            return parentAccount[0].Id;
        
        return null;
    }
    
    public static Id getRecordTypeId(String recordTypeName, String sObjectName){
        
        List<RecordType> recordTypes = [SELECT Id
                                            FROM RecordType
                                            WHERE SobjectType = :sObjectName
                                            AND Name = :recordTypeName
                                            LIMIT 1];
        
        if(!recordTypes.isEmpty())
            return recordTypes[0].Id;
        
        return null;
    }
    
    //create new records for field trial contact with Candidate record type
    public static void createFieldTrialContactDetails(String strFieldTrialId, Map<Id,FT_Field_Trial_Participant_Application__c> mapParticipantDetails,
                                                        Map<String,Contact> mapEmployeeId_Contact){
        
        List<Field_Trial_Contacts__c> lstNewFieldtrialContacts = new List<Field_Trial_Contacts__c>();
        
        //get candidate record type id
        Id candidateRecordTypeId = getRecordTypeId('Candidate','Field_Trial_Contacts__c');
        
        for(Id participantApplicationId : mapParticipantDetails.keySet()){
            FT_Field_Trial_Participant_Application__c participantApplication = mapParticipantDetails.get(participantApplicationId);
            if(mapEmployeeId_Contact.containsKey(participantApplication.FT_Employee_ID__c)){
                
            
                lstNewFieldtrialContacts.add(new Field_Trial_Contacts__c(
                    FT_Country__c = participantApplication.FT_Country__c,
                    recordTypeId = candidateRecordTypeId,
                    FT_Field_Trial__c = strFieldTrialId,
                    FT_Contact_Record__c = mapEmployeeId_Contact.get(participantApplication.FT_Employee_ID__c).Id,
                    FT_Status__c = 'Eligible',
                    FT_Street_Address__c = participantApplication.FT_Street_Address__c,
                    FT_State__c = participantApplication.FT_State_Province__c,
                    FT_City__c = participantApplication.FT_City__c,
                    FT_Zip_Code__c = participantApplication.FT_Zip_Code__c,
                    FT_Contact_Email__c = participantApplication.FT_Email__c,
                    FT_Contact_Cell_Phone__c = participantApplication.FT_Cell_Phone_Number__c
                ));
            }            
        }
        
        if(!lstNewFieldtrialContacts.isEmpty()){
            
            try{
                
                INSERT lstNewFieldtrialContacts;
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }
        }
    }
    
    public class ApplicationDetail{
        
        @AuraEnabled
        public String stateOrProvince{get;set;}
        
        @AuraEnabled
        public List<String> participantApplications{get;set;}
        
        @AuraEnabled
        public Integer numberOfParticipants{get;set;}
        
        @AuraEnabled
        public Integer numberOfParticipantsRequired{get;set;}
        
        public ApplicationDetail(String state, List<String> lstApplications, Integer requiredParticipants){
            
            this.numberOfParticipants = lstApplications.size();
            this.numberOfParticipantsRequired = requiredParticipants;
            this.stateOrProvince = state;
            this.participantApplications = lstApplications;
        }
        
        public ApplicationDetail(){}
    }
}