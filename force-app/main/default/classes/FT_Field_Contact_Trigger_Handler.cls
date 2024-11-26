/*
    Author : Amol B
    Date : 
    Purpose : used process trigger operations on Field Trial Contact object update
*/
public class FT_Field_Contact_Trigger_Handler{
    
    static String COMMUNITY_LICENSE_TYPE = 'Customer Community Plus Login';
    static String COMMUNITY_USER_PROFILE = 'Community - All Community Plus Login Profile';
    
    static String DEALER_RECORD_TYPE = 'FT_Dealer_Field_Trial_Contact';
    static String PARTICIPANT_RECORD_TYPE = 'FT_ParticipantFieldTrialContact';
    
    static String DEALER_PUBLIC_GROUP = 'FT_Field_Trial_Dealer';
    static String PARTICIPANT_PUBLIC_GROUP = 'FT_Field_Trial_Participant';
    
    static String DEALER_PERMISSION_SET = 'FT_Field_Trial_Community_Dealer';
    static String PARTICIPANT_PERMISSION_SET = 'FT_Field_Trial_Community_Participant';
    
    public static void handleAfterUpdate(Map<Id,Field_Trial_Contacts__c> mapNewRecords, Map<Id,Field_Trial_Contacts__c> mapOldRecords){
        
        //filter updated list to get the records whose status got updated to Approved
        List<Field_Trial_Contacts__c> lstApprovedRecords = getApprovedRecords(mapNewRecords, mapOldRecords);
        
        if(!lstApprovedRecords.isEmpty()){
            
            //update user information
            Map<String,Set<Id>> mapUserDetails = updateCommunityUsers(lstApprovedRecords);
            
            if(!mapUserDetails.isEmpty()){
                
                //assign users to respective public groups
                assignPublicGroup(JSON.serialize(mapUserDetails));
                
                //assign users to respective permission sets
                assignPermissionSet(JSON.serialize(mapUserDetails));
                
                //process apex sharing
                updateRecordSharing(mapUserDetails.get('Dealers'),mapUserDetails.get('Participants'));
            }
        }
    }
    
    public static List<Field_Trial_Contacts__c> getApprovedRecords(Map<Id,Field_Trial_Contacts__c> mapNewRecords, Map<Id,Field_Trial_Contacts__c> mapOldRecords){
        
        List<Field_Trial_Contacts__c> lstRecordsToProcess = new List<Field_Trial_Contacts__c>();
        
        for(Id recordId : mapNewRecords.keySet()){
            
            Field_Trial_Contacts__c newRecord = mapNewRecords.get(recordId);
            Field_Trial_Contacts__c oldRecord = mapOldRecords.get(recordId);
            
            //compare old and new status in order to ignore updates on already approved records
            if((newRecord.FT_Status__c != null
                && newRecord.FT_Status__c != oldRecord.FT_Status__c
                && newRecord.FT_Status__c == 'Approved') ||
               
               (newRecord.FT_Dealer__c != null // Check if FT_Dealer__c field is populated
                && newRecord.FT_Dealer__c != oldRecord.FT_Dealer__c)) {
                
                lstRecordsToProcess.add(newRecord);
            }
        }
        
        //query additional fields and return
        return [SELECT Id, RecordTypeId, FT_Contact_Record__c, FT_Status__c, 
                        FT_Dealer__r.FT_Contact_Record__c, FT_Dealer__r.RecordTypeId,
                        FT_Contact_Record__r.FirstName, FT_Contact_Record__r.LastName,
                        FT_Contact_Record__r.AccountId,  FT_Contact_Record__r.Email,
                        FT_Contact_Record__r.Account.Owner.UserRoleId
                FROM Field_Trial_Contacts__c 
                WHERE Id IN :lstRecordsToProcess];
    }
    
    public static Map<String,Set<Id>> updateCommunityUsers(List<Field_Trial_Contacts__c> lstApprovedRecords){
        
        Map<String,Set<Id>> mapUserTypeDetails = new Map<String,Set<Id>>();
        
        //initialize result map
        mapUserTypeDetails.put('Dealers',new Set<Id>());
        mapUserTypeDetails.put('Participants',new Set<Id>());
        
        if(!lstApprovedRecords.isEmpty()){
            
            //get All contact record ids
            Map<Id,Field_Trial_Contacts__c> mapContactIds_FieldTrialContacts = new Map<Id,Field_Trial_Contacts__c>();
            
            //get Field contacts record type information
            Map<Id,Schema.RecordTypeInfo> mapFTCRecordTypes = Field_Trial_Contacts__c.sObjectType.getDescribe().getRecordTypeInfosById();
            
            for(Field_Trial_Contacts__c fieldTrialContact : lstApprovedRecords){
                
                if(fieldTrialContact.FT_Contact_Record__c != null){
                    
                    mapContactIds_FieldTrialContacts.put(fieldTrialContact.FT_Contact_Record__c, fieldTrialContact);
                }
                
                if(fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c != null){
                    
                    mapContactIds_FieldTrialContacts.put(fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c, fieldTrialContact);
                }
            }
             
            //process all contacts
            if(!mapContactIds_FieldTrialContacts.isEmpty()){
                
                List<User> lstExistingUsers = [SELECT Id, ContactId, Profile.Name
                                                FROM User 
                                                WHERE ContactId IN :mapContactIds_FieldTrialContacts.keySet()
                                                AND LicenseType__c = :COMMUNITY_LICENSE_TYPE];
                                                
                String COMMUNITY_PROFILE_ID = getCommunityProfileId();
                List<User> lstUsersToUpdate = new List<User>();
                List<User> lstUsersToInsert = new List<User>();
                Map<Id, Id> contactIdUserIdMap = new Map<Id, Id>();
                
                for(User existingUser : lstExistingUsers){
                    contactIdUserIdMap.put(existingUser.ContactId, existingUser.Id);
                }
                
                //update user profiles for all existing users                               
                if(!lstExistingUsers.isEmpty()){                    
                    
                    for(User existingUser : lstExistingUsers){
                        
                        if(existingUser.Profile.Name != COMMUNITY_USER_PROFILE && String.isNotBlank(COMMUNITY_PROFILE_ID)){
                            
                            existingUser.ProfileId = COMMUNITY_PROFILE_ID;
                            lstUsersToUpdate.add(existingUser);
                        }
                        
                        //prepare map for further processing
                        Field_Trial_Contacts__c fieldContact = mapContactIds_FieldTrialContacts.get(existingUser.ContactId);
                        
                        if(fieldContact.FT_Dealer__r != null &&
                           fieldContact.FT_Dealer__r.RecordTypeId != null &&
                           DEALER_RECORD_TYPE == mapFTCRecordTypes.get(fieldContact.FT_Dealer__r.RecordTypeId).getDeveloperName() &&
                           contactIdUserIdMap.containsKey(fieldContact.FT_Dealer__r.FT_Contact_Record__c)){
                               
                            mapUserTypeDetails.get('Dealers').add(contactIdUserIdMap.get(fieldContact.FT_Dealer__r.FT_Contact_Record__c));
                        }
                        
                        if(DEALER_RECORD_TYPE == mapFTCRecordTypes.get(fieldContact.RecordTypeId).getDeveloperName() && 
                           contactIdUserIdMap.containsKey(fieldContact.FT_Contact_Record__c)){
                               
                            mapUserTypeDetails.get('Dealers').add(contactIdUserIdMap.get(fieldContact.FT_Contact_Record__c));
                        }
                        
                        if(PARTICIPANT_RECORD_TYPE == mapFTCRecordTypes.get(fieldContact.RecordTypeId).getDeveloperName() && 
                           contactIdUserIdMap.containsKey(fieldContact.FT_Contact_Record__c)){
                               
                            mapUserTypeDetails.get('Participants').add(contactIdUserIdMap.get(fieldContact.FT_Contact_Record__c));
                        }
                        
                        //remove processed records from list
                        mapContactIds_FieldTrialContacts.remove(existingUser.ContactId);
                    }
                }
                 
                //create new records
                if(!mapContactIds_FieldTrialContacts.isEmpty()){
                    
                    for(Id contactId : mapContactIds_FieldTrialContacts.keySet()){
                        
                        Field_Trial_Contacts__c fieldContact = mapContactIds_FieldTrialContacts.get(contactId);
                        String alias = '';
                        
                        if(fieldContact.FT_Contact_Record__c != null && 
                           String.isNotBlank(fieldContact.FT_Contact_Record__r.FirstName) && 
                           fieldContact.FT_Contact_Record__r.FirstName.length() > 5){
                               
                            alias = fieldContact.FT_Contact_Record__r.FirstName.subString(0, 5);
                        }
                            
                        User newUser = new User(
                            
                            FirstName = fieldContact.FT_Contact_Record__r.FirstName,
                            LastName = fieldContact.FT_Contact_Record__r.LastName,
                            Email = fieldContact.FT_Contact_Record__r.Email,
                            ProfileId = COMMUNITY_PROFILE_ID,
                            ContactId = contactId,
                            Username = fieldContact.FT_Contact_Record__r.Email + '.lennox',  // 4/4 - changed the username to be .lennox and removed '.FT' + Integer.valueof((Math.random() * 100))
                            IsActive = true,
                            EmailEncodingKey = 'UTF-8',
                            LanguageLocaleKey = 'en_US',
                            LocaleSidKey = 'en_US',
                            Alias =  alias + Integer.valueof((Math.random() * 100)),
                            TimeZoneSidKey = 'America/Los_Angeles',
                            CommunityNickname = alias + Integer.valueof((Math.random() * 100))
                        );
                        
                        lstUsersToInsert.add(newUser);
                    }
                }
                        
                try{
                    
                    if(!lstUsersToUpdate.isEmpty())
                        UPDATE lstUsersToUpdate;
                    
                    if(!lstUsersToInsert.isEmpty()){  
                        INSERT lstUsersToInsert;
                        
                        for(User existingUser : lstUsersToInsert){
                            
                            //prepare map for further processing
                            Field_Trial_Contacts__c fieldContact = mapContactIds_FieldTrialContacts.containsKey(existingUser.ContactId) ? mapContactIds_FieldTrialContacts.get(existingUser.ContactId) : null;
                            
                            if(fieldContact != null && DEALER_RECORD_TYPE == mapFTCRecordTypes.get(fieldContact.RecordTypeId).getDeveloperName()){
                                mapUserTypeDetails.get('Dealers').add(existingUser.Id);
                            }
                            
                            if(fieldContact != null && PARTICIPANT_RECORD_TYPE == mapFTCRecordTypes.get(fieldContact.RecordTypeId).getDeveloperName()){
                                mapUserTypeDetails.get('Participants').add(existingUser.Id);
                            }
                        }
                    }
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    // Send a user creation error notification to the email stored in label
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add(Label.User_Creation_Failure_Email);
                    mail.setToAddresses(sendTo); 
                    
                    mail.setSubject('User Creation Failure Email');
                    String body = 'Dear admin, <br/><br/>';
                    body += 'There was an error while creating users for contact records from Field Contact Trigger. Please check the cause below - <br/><br/> '; 
                    body += e.getMessage();
                    mail.setHtmlBody(body); 
                    
                    mails.add(mail);
                    
                    Messaging.sendEmail(mails);        
                }
            }
        }
        
        return mapUserTypeDetails;
    }
    
    public static Id getCommunityProfileId(){
        
        try{
            Profile communityProfile = [SELECT Id, Name 
                                        FROM Profile 
                                        WHERE Name = :COMMUNITY_USER_PROFILE 
                                        LIMIT 1];
                                        
            if(communityProfile != null){
                
                return communityProfile.Id;
            }
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return null;
    }
    
    @future
    public static void assignPublicGroup( String strUserDetails){
        
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(strUserDetails);
        Map<String,List<Object>> mapUserDetails = new Map<String,List<Object>>();
        
        mapUserDetails.put('Dealers',(List<Object>)meta.get('Dealers'));
        mapUserDetails.put('Participants',(List<Object>)meta.get('Participants'));
        
        List<GroupMember> lstGroupMembers = new List<GroupMember>();
        
        //add dealers to public group
        if(!mapUserDetails.isEmpty() && mapUserDetails.containsKey('Dealers')){
            
            //get Dealers public group details
            Id publicGroupId = getPublicGroupId(DEALER_PUBLIC_GROUP);
            
            if(publicGroupId != null){
                
                for(Object userId : mapUserDetails.get('Dealers')){
                    
                    lstGroupMembers.add(new GroupMember(
                        
                        GroupId = publicGroupId,
                        UserOrGroupId = (Id)userId
                    ));
                }
            }
        }
        
        //add participants to public group
        if(!mapUserDetails.isEmpty() && mapUserDetails.containsKey('Participants')){
            
            //get Participants public group details
            Id publicGroupId = getPublicGroupId(PARTICIPANT_PUBLIC_GROUP);
            
            if(publicGroupId != null){
                
                for(Object userId : mapUserDetails.get('Participants')){
                    
                    lstGroupMembers.add(new GroupMember(
                        
                        GroupId = publicGroupId,
                        UserOrGroupId = (Id)userId
                    ));
                }
            }
        }
        
        if(!lstGroupMembers.isEmpty()){
            
            try{
                INSERT lstGroupMembers;
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }
        }
    }
    
    public static Id getPublicGroupId( String groupName){
        
        try{
            Group publicGroup = [SELECT Id 
                                 FROM Group 
                                 WHERE DeveloperName = :groupName 
                                 LIMIT 1];
                                        
            if(publicGroup != null){
                
                return publicGroup.Id;
            }
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return null;
    }
    
    @future
    public static void assignPermissionSet(String strUserDetails){
        
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(strUserDetails);
        Map<String,List<Object>> mapUserDetails = new Map<String,List<Object>>();
        
        mapUserDetails.put('Dealers',(List<Object>)meta.get('Dealers'));
        mapUserDetails.put('Participants',(List<Object>)meta.get('Participants'));
        
        List<PermissionSetAssignment> lstPSMembers = new List<PermissionSetAssignment>();
        
        //add dealers to permission set
        if(!mapUserDetails.isEmpty() && mapUserDetails.containsKey('Dealers')){
            
            //get Dealers public group details
            Id permissionSetId = getPermissionSetId(DEALER_PERMISSION_SET);
            
            //get existing permission set members
            Set<Id> existingDealerUsers = getPermissionSetMembers(permissionSetId);
            
            if(permissionSetId != null){
                
                for(Object userId : mapUserDetails.get('Dealers')){
                    
                    if(!existingDealerUsers.contains((Id)userId)){
                        
                        lstPSMembers.add(new PermissionSetAssignment(
                            
                            PermissionSetId = permissionSetId,
                            AssigneeId = (Id)userId
                        ));
                    }
                }
            }
        }
        
        //add participants to permission set
        if(!mapUserDetails.isEmpty() && mapUserDetails.containsKey('Participants')){
            
            //get Participants public group details
            Id permissionSetId = getPermissionSetId(PARTICIPANT_PERMISSION_SET);
            
            //get existing permission set members
            Set<Id> existingParticipantUsers = getPermissionSetMembers(permissionSetId);
            
            if(permissionSetId != null){
                
                for(Object userId : mapUserDetails.get('Participants')){
                    
                    if(!existingParticipantUsers.contains((Id)userId)){
                        
                        lstPSMembers.add(new PermissionSetAssignment(
                            
                            PermissionSetId = permissionSetId,
                            AssigneeId = (Id)userId
                        ));
                    }
                }
            }
        }
        
        if(!lstPSMembers.isEmpty()){
            
            try{
                INSERT lstPSMembers;
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }
        }
    }
    
    public static Id getPermissionSetId( String permissionSetName){
        
        try{
            PermissionSet permSet = [SELECT Id 
                                     FROM PermissionSet 
                                     WHERE Name = :permissionSetName 
                                     LIMIT 1];
                                        
            if(permSet != null){
                
                return permSet.Id;
            }
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return null;
    }
    
    public static Set<Id> getPermissionSetMembers(Id permissionSetId){
        
        Set<Id> setMemberUserIds = new Set<Id>();
        
        try{
            List<PermissionSetAssignment> lstPermissionSetMembers = [SELECT Id,AssigneeId
                                                                     FROM PermissionSetAssignment 
                                                                     WHERE PermissionSetId = :permissionSetId];
                                        
            if(!lstPermissionSetMembers.isEmpty()){
                
                for(PermissionSetAssignment assignment : lstPermissionSetMembers){
                    setMemberUserIds.add(assignment.AssigneeId);
                }
            }
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return setMemberUserIds;
    }
    
    @future
    public static void updateRecordSharing(Set<Id> setDealerUserIds, Set<Id> setParticipantUserIds){
        
        //get contact id and user ids map
        Map<Id,Id> mapContactId_UserId = getUserContactDetails(setDealerUserIds,setParticipantUserIds);
        
        if(!mapContactId_UserId.isEmpty()){
            
            //update field trial and field trial contacts sharing
            updateFieldTrialContactSharing(mapContactId_UserId, setDealerUserIds);
            
            //update field trial forms sharing
            updateFieldTrialFormSharing(mapContactId_UserId);
            
            //get separate maps of contact ids for dealer and participants
            Map<Id,Id> mapContactId_DealerUserId = new Map<Id,Id>();
            Map<Id,Id> mapContactId_ParticipantUserId = new Map<Id,Id>();
            
            for(Id contactId :mapContactId_UserId.keySet()){
                
                if(setDealerUserIds.contains(mapContactId_UserId.get(contactId)))
                    mapContactId_DealerUserId.put(contactId,mapContactId_UserId.get(contactId));
                
                if(setParticipantUserIds.contains(mapContactId_UserId.get(contactId)))
                    mapContactId_ParticipantUserId.put(contactId,mapContactId_UserId.get(contactId));
                
            }
            
            //update field trial invoices sharing for dealers
            if(!mapContactId_DealerUserId.isEmpty())
                updateFieldTrialInvoicesSharing(mapContactId_DealerUserId);
            
            //update field trial participants application sharing for participants
            if(!mapContactId_ParticipantUserId.isEmpty())
                updateFieldTrialParticipantApplicationSharing(mapContactId_ParticipantUserId);
        }
    }
    
    public static Map<Id,Id> getUserContactDetails(Set<Id> setDealerUserIds, Set<Id> setParticipantUserIds){
        
        Map<Id,Id> mapContactId_UserId = new Map<Id,Id>();
        
        if(!setDealerUserIds.isEmpty() || !setParticipantUserIds.isEmpty()){
            
            List<User> lstUsers = [SELECT Id, ContactId 
                                    FROM User 
                                    WHERE Id IN :setDealerUserIds 
                                    OR Id IN :setParticipantUserIds];
                                    
            if(!lstUsers.isEmpty()){
                
                for(User usr :lstUsers){
                    
                    mapContactId_UserId.put(usr.ContactId, usr.Id);
                }
            }
        }
        
        return mapContactId_UserId;
    }
    
    public static void updateFieldTrialContactSharing(Map<Id,Id> mapContactId_UserId, Set<Id> setDealerUserIds){
        
        if(!mapContactId_UserId.isEmpty()){
            
            //query all Field trial contacts
            List<Field_Trial_Contacts__c> lstFieldTrialContacts = [SELECT Id,FT_Contact_Record__c,FT_Dealer__c,FT_Field_Trial__c,
                                                                            FT_Dealer__r.FT_Contact_Record__c
                                                                    FROM Field_Trial_Contacts__c 
                                                                    WHERE FT_Contact_Record__c IN :mapContactId_UserId.keySet()
                                                                    OR FT_Dealer__r.FT_Contact_Record__c IN :mapContactId_UserId.keySet()];
            
            List<Field_Trial_Contacts__Share> lstFTCNewShareRecords = new List<Field_Trial_Contacts__Share>();
            List<FT_Field_Trial__Share> lstNewFieldTrialShareRecords = new List<FT_Field_Trial__Share>();
            Set<Id> setProcessedFieldTrialIds = new Set<Id>();
            
            if(!lstFieldTrialContacts.isEmpty()){
                
                for(Field_Trial_Contacts__c fieldTrialContact : lstFieldTrialContacts){
                    
                    if(fieldTrialContact.FT_Contact_Record__c != null && 
                       mapContactId_UserId.containsKey(fieldTrialContact.FT_Contact_Record__c)){
                        
                        lstFTCNewShareRecords.add(new Field_Trial_Contacts__Share(
                            
                            ParentId = fieldTrialContact.Id,
                            UserOrGroupId = mapContactId_UserId.get(fieldTrialContact.FT_Contact_Record__c),
                            AccessLevel = 'Read',
                            RowCause = Schema.Field_Trial_Contacts__Share.RowCause.Manual
                        ));
                    } 
                    
                    if(fieldTrialContact.FT_Dealer__c != null
                        && fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c != null 
                        && mapContactId_UserId.containsKey(fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c)){
                        
                            Id dealerUserId = mapContactId_UserId.get(fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c);
                            
                            // Check whether user if of type Dealer, then only share Field Trial Contact records which refer the contact related to dealer record
                            if(setDealerUserIds.contains(dealerUserId)){
                                lstFTCNewShareRecords.add(new Field_Trial_Contacts__Share(
                                    
                                    ParentId = fieldTrialContact.Id,
                                    UserOrGroupId = mapContactId_UserId.get(fieldTrialContact.FT_Dealer__r.FT_Contact_Record__c),
                                    AccessLevel = 'Read',
                                    RowCause = Schema.Field_Trial_Contacts__Share.RowCause.Manual
                                ));
                            }
                    }
                    
                    if(!setProcessedFieldTrialIds.contains(fieldTrialContact.FT_Field_Trial__c) && 
                       mapContactId_UserId.containsKey(fieldTrialContact.FT_Contact_Record__c)){
                        
                        lstNewFieldTrialShareRecords.add(new FT_Field_Trial__Share(
                            
                            ParentId = fieldTrialContact.FT_Field_Trial__c,
                            UserOrGroupId = mapContactId_UserId.get(fieldTrialContact.FT_Contact_Record__c),
                            AccessLevel = 'Read',
                            RowCause = Schema.FT_Field_Trial__Share.RowCause.Manual
                        ));
                        
                        setProcessedFieldTrialIds.add(fieldTrialContact.FT_Field_Trial__c);
                    }
                }
                                
                try{
                    
                    if(!lstNewFieldTrialShareRecords.isEmpty())
                        INSERT lstNewFieldTrialShareRecords;
                    
                    if(!lstFTCNewShareRecords.isEmpty())
                      INSERT lstFTCNewShareRecords;
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public static void updateFieldTrialFormSharing(Map<Id,Id> mapContactId_UserId){
        
        if(!mapContactId_UserId.isEmpty()){
            
            //query all Field trial contacts
            List<FieldTrialForms__c> lstFieldTrialForms = [SELECT Id,FT_Field_Trial_Contacts__c,FT_Field_Trial_Contacts__r.FT_Contact_Record__c
                                                            FROM FieldTrialForms__c 
                                                            WHERE FT_Field_Trial_Contacts__r.FT_Contact_Record__c IN :mapContactId_UserId.keySet()];
            
            List<FieldTrialForms__Share> lstFTFNewShareRecords = new List<FieldTrialForms__Share>();
            
            if(!lstFieldTrialForms.isEmpty()){
                
                for(FieldTrialForms__c fieldTrialForm : lstFieldTrialForms){
                    
                    if(fieldTrialForm.FT_Field_Trial_Contacts__r.FT_Contact_Record__c != null 
                        && mapContactId_UserId.containsKey(fieldTrialForm.FT_Field_Trial_Contacts__r.FT_Contact_Record__c)){
                        
                        lstFTFNewShareRecords.add(new FieldTrialForms__Share(
                            
                            ParentId = fieldTrialForm.Id,
                            UserOrGroupId = mapContactId_UserId.get(fieldTrialForm.FT_Field_Trial_Contacts__r.FT_Contact_Record__c),
                            AccessLevel = 'Edit',
                            RowCause = Schema.FieldTrialForms__Share.RowCause.Manual
                        ));
                    }
                }
                
                try{
                    
                    if(!lstFTFNewShareRecords.isEmpty())
                        INSERT lstFTFNewShareRecords;
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public static void updateFieldTrialInvoicesSharing(Map<Id,Id> mapContactId_UserId){
        
        if(!mapContactId_UserId.isEmpty()){
            
            //query all Field trial contacts
            List<FT_Field_Trial_Invoices__c> lstFieldTrialInvoices = [SELECT Id,FT_Dealer__c,FT_Dealer__r.FT_Contact_Record__c
                                                                      FROM FT_Field_Trial_Invoices__c 
                                                                      WHERE FT_Dealer__r.FT_Contact_Record__c IN :mapContactId_UserId.keySet()];
            
            List<FT_Field_Trial_Invoices__Share> lstFTFNewShareRecords = new List<FT_Field_Trial_Invoices__Share>();
            
            if(!lstFieldTrialInvoices.isEmpty()){
                
                for(FT_Field_Trial_Invoices__c fieldTrialInvoice : lstFieldTrialInvoices){
                    
                    if(fieldTrialInvoice.FT_Dealer__r.FT_Contact_Record__c != null 
                        && mapContactId_UserId.containsKey(fieldTrialInvoice.FT_Dealer__r.FT_Contact_Record__c)){
                        
                        lstFTFNewShareRecords.add(new FT_Field_Trial_Invoices__Share(
                            
                            ParentId = fieldTrialInvoice.Id,
                            UserOrGroupId = mapContactId_UserId.get(fieldTrialInvoice.FT_Dealer__r.FT_Contact_Record__c),
                            AccessLevel = 'Edit',
                            RowCause = Schema.FT_Field_Trial_Invoices__Share.RowCause.Manual
                        ));
                    }
                }
                
                try{
                    
                    if(!lstFTFNewShareRecords.isEmpty())
                        INSERT lstFTFNewShareRecords;
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public static void updateFieldTrialParticipantApplicationSharing(Map<Id,Id> mapContactId_UserId){
        
        if(!mapContactId_UserId.isEmpty()){
            
            //query all Field trial contacts
            List<FT_Field_Trial_Participant_Application__c> lstFieldTrialPA = [SELECT Id,FT_Field_Trial_Contacts__c,
                                                                                    FT_Field_Trial_Contacts__r.FT_Contact_Record__c
                                                                                FROM FT_Field_Trial_Participant_Application__c 
                                                                                WHERE FT_Field_Trial_Contacts__r.FT_Contact_Record__c IN :mapContactId_UserId.keySet()];
            
            List<FT_Field_Trial_Participant_Application__Share> lstFTFNewShareRecords = new List<FT_Field_Trial_Participant_Application__Share>();
            
            if(!lstFieldTrialPA.isEmpty()){
                
                for(FT_Field_Trial_Participant_Application__c fieldTrialPA : lstFieldTrialPA){
                    
                    if(fieldTrialPA.FT_Field_Trial_Contacts__r.FT_Contact_Record__c != null 
                        && mapContactId_UserId.containsKey(fieldTrialPA.FT_Field_Trial_Contacts__r.FT_Contact_Record__c)){
                        
                        lstFTFNewShareRecords.add(new FT_Field_Trial_Participant_Application__Share(
                            
                            ParentId = fieldTrialPA.Id,
                            UserOrGroupId = mapContactId_UserId.get(fieldTrialPA.FT_Field_Trial_Contacts__r.FT_Contact_Record__c),
                            AccessLevel = 'Edit',
                            RowCause = Schema.FT_Field_Trial_Participant_Application__Share.RowCause.Manual
                        ));
                    }
                }
                
                try{
                    
                    if(!lstFTFNewShareRecords.isEmpty())
                        INSERT lstFTFNewShareRecords;
                }
                catch(Exception e){
                    system.debug(e.getMessage());
                }
            }
        }
    }
}