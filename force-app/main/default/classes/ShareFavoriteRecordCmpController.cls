/*
 * @purpose : This class will reponsible for the insertion of share object and deleting of share object record
 * @createdDate : 13 Apr 2018
 */ 
Public with sharing class ShareFavoriteRecordCmpController {
    
   /*
    * @purpose     : This will return already shared records as well records of users, roles and groups
    * @param       : 1) favRecordId : Take the current record id
    * @return      : 1) Response : response of the class
    */ 
    @AuraEnabled  
    Public static Response getUserRecords(String favRecordId){
        Response response;
        System.debug('favRecordId' + favRecordId);
        if(String.isNotBlank(favRecordId)){
            //get already shared records
            System.debug('response before :: ' +  response);
            response = getAlreadySharedRecords(favRecordId);
             System.debug('response' + response);
            if(response.isSuccess){
                SharedOrUsersWrapper shareWrapperObj = (SharedOrUsersWrapper) response.data;
                 try{
                     //created custom map to store users, groups and roles
                    Map<String, List<PicklistWrapper>> objNametoPicklistWrappers = new Map<String, List<PicklistWrapper>>{'User' => new List<PicklistWrapper>(),
                                                                                                                          'UserRole' => new List<PicklistWrapper>(),
                                                                                                                          'RoleAndSubordinates'=>new List<PicklistWrapper>(),
                                                                                                                          'RoleAndSubordinatesInternal'=>new List<PicklistWrapper>(),
                                                                                                                          'PublicGroups'=>new List<PicklistWrapper>()};
              
                    Map<String, String> groupTypeMap = new Map<String, String>{'Regular'=>'PublicGroups',
                                                                               'RoleAndSubordinatesInternal'=>'RoleAndSubordinatesInternal',
                                                                               'RoleAndSubordinates'=>'RoleAndSubordinates'
                                                                               };                                                
                    Set<String> unUsrWantedProfiles = restrictedProfileUsers();
                    PicklistWrapper picklistWrapper;
                    //get users records
                    for(User usrRecord : [SELECT Id, Name, IsPortalEnabled 
                                           FROM User 
                                           WHERE Profile.Name NOT IN : unUsrWantedProfiles AND isActive = true AND Id NOT IN : shareWrapperObj.sharedUserIds
                                           ORDER By Name ASC]){
                        picklistWrapper = new PicklistWrapper(usrRecord.id, usrRecord.Name, usrRecord.IsPortalEnabled);
                        objNametoPicklistWrappers.get('User').add(picklistWrapper);
                    }
                    //get user's roles records
                    for(UserRole userRole : [SELECT Id, Name, PortalType, PortalRole 
                                             FROM UserRole 
                                             WHERE ((PortalRole = null OR Portaltype = 'Partner') AND Id NOT IN : shareWrapperObj.sharedUserIds)
                                             Order By Name ASC]){
                        picklistWrapper = new PicklistWrapper(userRole.id, userRole.Name, userRole.PortalType, userRole.PortalRole);
                        objNametoPicklistWrappers.get('UserRole').add(picklistWrapper);
                    }
                     //get grup's records
                     for(Group groupRecord : [SELECT Id, Type, Name, DeveloperName 
                                              FROM Group
                                              WHERE Id NOT IN : shareWrapperObj.sharedUserIds
                                              Order By DeveloperName ASC]){
                        if(groupTypeMap.containskey(groupRecord.Type)){
                            picklistWrapper = new PicklistWrapper(groupRecord.Id, String.isNotBlank(groupRecord.Name) ? groupRecord.Name : groupRecord.DeveloperName, groupRecord.Type);
                            objNametoPicklistWrappers.get(groupTypeMap.get(groupRecord.Type)).add(picklistWrapper);
                        }
                    }
                    shareWrapperObj.strToPicklistWrappers = objNametoPicklistWrappers;
                    shareWrapperObj.sharedUserIds = null;
                     System.debug('response' + response);
                    response = new Response(true, shareWrapperObj, 'Success');
             }catch(Exception e){
                 System.debug('e.getMessage()' + e.getMessage());
                 throw new AuraHandledException('Something went wrong: '+ e.getMessage());
             }
            }else{
                return response;
            }
        }else{
            response = new Response(false,null,'Salesforce id not found. Contact your system admin!!');
        }
        return response;
    }

    /*
    * @purpose     : This will return already shared records as well records of users, roles and groups.  This is generic method you can
    * @param       : favRecordId : Take the current record id
    * @return      : 1) Response : response of the class
    */
    @AuraEnabled
    public static Response getAlreadySharedRecords(String objectRecordId){
        Response response;
        System.debug('getAlreadySharedRecords');
        String shareObjName = getShareObjectName(objectRecordId);
        System.debug('shareObjName ++ ' + shareObjName);
        if(String.isNotBlank(objectRecordId) && String.isNotBlank(shareObjName)){
            
            SharedOrUsersWrapper wrapperObject = new SharedOrUsersWrapper();
            
            List<ShareRecordWrapper> shareRecordWrapperList = new List<ShareRecordWrapper>();
            ShareRecordWrapper shareRecordObj;
            Map<String, String> accessLevelMap = new Map<String, String>{'Read'=>'Read Only',
                                                                         'Edit'=>'Read/Write'};
            Map<Id, List<SObject>> usrRoleIdtoShareRecords = new Map<Id, List<SObject>>();
            Map<Id, List<User>> userMap = new Map<Id, List<User>>();
            Set<Id> sharedUserIds = new Set<Id>();
            Set<Id> nameNotAvailableIds = new Set<Id>();
            List<SObject> shareObjectList = new List<SObject>();
            List<SObject> SObjectList = new List<SObject>();
            
            //get dynamic share records
            String query = 'SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, UserOrGroup.UserRoleId, UserOrGroup.Name, UserOrGroup.UserRole.Name'+
                           ' FROM '+shareObjName+
                           ' WHERE ParentId = \''+objectRecordId+'\' AND ( RowCause = \'Manual\' OR RowCause = \'Owner\') AND UserOrGroup.UserRoleId != null '+
                           ' LIMIT '+LIMITS.getLimitQueryRows();
            
            try{
                SObjectList = Database.query(query);
                System.debug('SObjectList ++' + SObjectList);
            }catch(Exception e){
               throw new AuraHandledException('This object is not supported for manual sharing.  Contact your system admin'); 
            }
            
            
            for(SObject shareObjectRecord : SObjectList){
                Id userOrGrpId = (Id) shareObjectRecord.get('UserOrGroupId');
                sharedUserIds.add(userOrGrpId);
                
                SObject userObj = shareObjectRecord.getSObject('UserOrGroup');
                Id userRoleId = (Id) userObj.get('UserRoleId');
                String groupName = (String) userObj.get('Name');
                
                if(String.isNotBlank(userRoleId) && shareObjectRecord.get('RowCause') != 'Owner'){
                    if(!usrRoleIdtoShareRecords.containskey(userRoleId)){
                        usrRoleIdtoShareRecords.put(userRoleId, new List<SObject>());
                    }
                    usrRoleIdtoShareRecords.get(userRoleId).add(shareObjectRecord); 
                }else{
                    shareObjectList.add(shareObjectRecord);
                }
                
                //check whether group's name is blank or not
                if(String.isBlank(groupName)){
                    nameNotAvailableIds.add(userOrGrpId);
                }
                
            } 
            
            Map<Id, String> grpIdtoDevNameMap = getIdtoDevNameMap(nameNotAvailableIds);
            
            if(!shareObjectList.isEmpty()){
                for(SObject sObjectShareRecord : shareObjectList){
                    shareRecordObj = new ShareRecordWrapper();
                    SObject userObj = sObjectShareRecord.getSObject('UserOrGroup');
                    String groupName = (String) userObj.get('Name');
                    shareRecordObj.id = (String) sObjectShareRecord.get('Id');
                    shareRecordObj.name = grpIdtoDevNameMap.containskey( 
                        (Id) sObjectShareRecord.get('UserOrGroupId')) ? grpIdtoDevNameMap.get((Id) sObjectShareRecord.get('UserOrGroupId')) : groupName;
                    shareRecordObj.accessLevel = accessLevelMap.get( (String) sObjectShareRecord.get('AccessLevel'));
                    shareRecordObj.reason = (String) sObjectShareRecord.get('RowCause');
                    shareRecordObj.parentId = (String) sObjectShareRecord.get('ParentId');
                    shareRecordWrapperList.add(shareRecordObj);
                }
            }
            
            //get users to share role
            for(User user : [SELECT Id, UserRoleId
                             FROM User
                             WHERE isActive = true 
                             AND (UserRole.PortalRole = null OR UserRole.Portaltype = 'Partner') 
                             AND UserRoleId IN : usrRoleIdtoShareRecords.keyset()]){
                //map to put user id and list of user
                if(!userMap.containskey(user.UserRoleId)){
                    userMap.put(user.UserRoleId, new List<User>());
                } 
                userMap.get(user.UserRoleId).add(user);
            }   
            
            for(Id userRoleId : usrRoleIdtoShareRecords.keySet()){
                shareRecordObj = new ShareRecordWrapper();
                if(userMap.containskey(userRoleId) && usrRoleIdtoShareRecords.get(userRoleId).size() == userMap.get(userRoleId).size()){
                    sharedUserIds.add(userRoleId);
                    shareRecordObj.id = userRoleId;
                    SObject userObj = usrRoleIdtoShareRecords.get(userRoleId)[0].getSObject('UserOrGroup').getSObject('UserRole');
                    String userRoleName = (String) userObj.get('Name');
                    shareRecordObj.name = userRoleName;
                    shareRecordObj.accessLevel = accessLevelMap.get((String) usrRoleIdtoShareRecords.get(userRoleId)[0].get('AccessLevel'));
                    shareRecordObj.reason = (String) usrRoleIdtoShareRecords.get(userRoleId)[0].get('RowCause');
                    shareRecordObj.parentId = (String) usrRoleIdtoShareRecords.get(userRoleId)[0].get('ParentId');
                    shareRecordObj.isRole = true;
                    shareRecordWrapperList.add(shareRecordObj); 
                }else{
                    //else iterate over the share user id
                    for(SObject favoriteShareObj : usrRoleIdtoShareRecords.get(userRoleId)){
                        shareRecordObj = new ShareRecordWrapper();
                        shareRecordObj.id = favoriteShareObj.Id;
                        SObject userObj = favoriteShareObj.getSObject('UserOrGroup');
                        String userName = (String) userObj.get('Name');
                        shareRecordObj.name = userName;
                        shareRecordObj.accessLevel = accessLevelMap.get((String)favoriteShareObj.get('AccessLevel'));
                        shareRecordObj.parentId = (String) favoriteShareObj.get('ParentId');
                        shareRecordObj.reason = (String) favoriteShareObj.get('RowCause');
                        shareRecordWrapperList.add(shareRecordObj);
                    } 
                }
            }
            
            wrapperObject.shareRecordWrapperList = shareRecordWrapperList;
            wrapperObject.sharedUserIds = sharedUserIds;
            //send wrapper of data to client side
            response = new Response(true, wrapperObject, 'successs');
            
        }else{
            response = new Response(false, null, 'fail');
        }
        return response;
    }
    
    /*
    * @purpose     : This method will share the saved records from client side
    * @param       : 1) resultJsonString : take the jsonString from the client side
    * @return      : 1) Response : response of the class
    */
    @AuraEnabled
    Public static Response saveShareRecord(String resultJsonString){
        Response response;
        if(String.isNotBlank(resultJsonString)){
            try{
                List<SObject> ShareObjectList = new List<SObject>();
                Set<Id> userOrGroupIds = new Set<Id>();
                Set<Id> userRoleIds = new Set<Id>();
                //deserialize json string
                ClientResponseWrapper responseWrapper = (ClientResponseWrapper) JSON.deserialize(resultJsonString, ClientResponseWrapper.class);
                //check whether response must not be null
                
                if( responseWrapper != null ){
                    //get the owner ID of the favorite Record
                    Id ownerId = [Select OwnerId FROM Favorites__c WHERE Id = :responseWrapper.sfid LIMIT 1].OwnerId;
                    SObject sObjShare;
                    String shareObjectName = getShareObjectName( (Id) responseWrapper.sfid);
                    if(String.isNotBlank(shareObjectName)){
                        for( cls_records responseRecord : responseWrapper.records ){
                            if( String.isNotBlank(responseRecord.value) ){
                                if( responseRecord.isRole != null && responseRecord.isRole ){
                                    userRoleIds.add(responseRecord.value);
                                }else{
                                    if(!userOrGroupIds.contains(responseRecord.value)){
                                        sObjShare = Schema.getGlobalDescribe().get(shareObjectName).newSObject();
                                        sObjShare.put('ParentId', responseWrapper.sfid);
                                        sObjShare.put('AccessLevel', responseWrapper.accessLevel);
                                        sObjShare.put('UserOrGroupId', responseRecord.value);
                                        userOrGroupIds.add(responseRecord.value);
                                        ShareObjectList.add(sObjShare);
                                    }
                                }
                            }
                        }
                        
                        if(!userRoleIds.isEmpty()){
                            for(User usrObj : [SELECT Id
                                               FROM User
                                               WHERE UserRoleId IN : userRoleIds AND isActive = true AND Id != :ownerId
                                               LIMIT :LIMITS.getLimitQueryRows()]){
                            //create favoire share object and added in list
                                sObjShare = Schema.getGlobalDescribe().get(shareObjectName).newSObject();
                                sObjShare.put('ParentId', responseWrapper.sfid);
                                sObjShare.put('AccessLevel', responseWrapper.accessLevel);
                                sObjShare.put('UserOrGroupId', usrObj.Id);
                                ShareObjectList.add(sObjShare);
                            }
                        }
                        
                        if(!ShareObjectList.isEmpty()){
                            INSERT ShareObjectList;
                            return response = new Response(true, null, 'Record Shared Successfully!!');
                        }
                    }else{
                        return response = new Response(false,null,'Share object name not found.  Contact your system Admin!!');
                    }
                    response = new Response(true, null, 'Record Shared Successfully');
                }
                else{
                    response = new Response(false, null, 'Response wrapper not found. Contact your system admin!!'); 
                }
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }else{
            response = new Response(false, null, 'Records Not found to save. Contact your system admin!!');
        }
       return response;
    }
    
   /*
    * @purpose     : This method will delte the already shared record
    * @param       : 1) deleteRecordJson : It will take the JSON string to delete the record
    * @return      : 1) Response : response of the class
    */
    @AuraEnabled
    public static Response deleteShareRecordFrmServer(String deleteRecordJson){
        Response response;
        if(String.isNotBlank(deleteRecordJson)){
            try{
                //deserlize the list of delete share record
                List<ShareRecordWrapper> shareRecordWrapperList = (List<ShareRecordWrapper>) JSON.deserialize(deleteRecordJson, List<ShareRecordWrapper>.class);
                
                Set<Id> userRoleIds = new Set<Id>();
                Set<Id> shareObjIds = new Set<Id>();
                Set<Id> userIds = new Set<Id>();
                SObject SObjectRec;
                Id favoriteShareId = shareRecordWrapperList[0].parentId;
                String shareObjName = getShareObjectName((Id) shareRecordWrapperList[0].parentId);
                //whether record is role or not
                if(String.isNotBlank(shareObjName)){
                    List<SObject> SObjectShareList = new List<SObject>();
                    if(shareRecordWrapperList != null && !shareRecordWrapperList.isEmpty()){
                        for(ShareRecordWrapper shareWrapperObj : shareRecordWrapperList){
                            if(shareWrapperObj.isRole != null && shareWrapperObj.isRole){
                                userRoleIds.add(shareWrapperObj.id);
                            }else{
                                shareObjIds.add(shareWrapperObj.id);
                            }
                        }
                    }
                    
                    //get all user's under role to delete user's role sharing access
                    if(!userRoleIds.isEmpty()){
                        for(User userId : [SELECT Id, UserRoleId
                                           FROM User
                                           WHERE UserRoleId IN : userRoleIds]){
                            userIds.add(userId.Id);
                        }
                    }
                    
                    //dynamic query on custom object share 
                    String query = 'SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause'+
                                    ' FROM '+shareObjName+
                                    ' WHERE ParentId = \''+favoriteShareId+'\''+
                                    ' AND (Id IN :shareObjIds OR UserOrGroupId IN :userIds)'+
                                    ' LIMIT '+LIMITS.getLimitQueryRows(); 
                    
                    List<SObject> shareObjectList = Database.query(query);
                    
                    if(!shareObjectList.isEmpty()){
                        Database.Delete(shareObjectList);
                    }
                }
                else{
                    return response = new Response(false, null, 'Share object name not found.  Contact your system admin!!');
                }
                response = getUserRecords(favoriteShareId);
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }else{
            response = new Response(false, null, 'Sharing cannot be revoked. Contact your system admin.');
        }
        return response;
    }
    
    /*
    * @purpose     : This method will return the share object name of using id
    * @param       : 1) recordId : record id
    * @return      : 1) String   : share object name
    */
    private static String getShareObjectName(Id recordId){
        //get map of custom object name and share object name
        //
        System.debug('getShareObjectName');
        Map<String, String> sObjectMap = getSObjectMap();
        String shareObjectName;
        if(!sObjectMap.isEmpty() && String.isNotBlank(recordId)){
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            shareObjectName = sObjectMap.containskey(sObjName) ? sObjectMap.get(sObjName) : null ;
        }
        return shareObjectName;
    }
    
    private static Map<String, String> getSObjectMap(){
        System.debug('getSObjectMap');
        Map<String, String> sObjectMap = new Map<String, String>();
        Integer count=0;
        for ( Schema.SObjectType objectType : Schema.getGlobalDescribe().values() )
        {
            System.debug('In for:: count' + count);
            Schema.DescribeSObjectResult objResult = objectType.getDescribe();
            System.debug('Before IF :: objResult' + objResult);
            String sObjectname = objectType.getDescribe().getName();
             System.debug('Before IF :: sObjectname' + sObjectname);
            if(!sObjectname.containsignorecase('scratchOrg') && !sObjectname.containsignorecase('Namespace') && !sObjectname.containsignorecase('WebLink')){
                if(!objResult.isCustomSetting() && objResult.getRecordTypeInfos().size() > 0 && objResult.isCreateable() 
                   && !sObjectname.containsignorecase('history') && !sObjectname.containsignorecase('tag') && !sObjectname.containsignorecase('feed')
                   && !sObjectname.containsignorecase('kav') ){
						System.debug('Inside IF :: sObjectname' + sObjectname);                       
                       if(objResult.isCustom()){
                           sObjectMap.put(sObjectname, sObjectname.removeEnd('__c') + '__Share');
                       }else{
                           sObjectMap.put(sObjectname, sObjectname + 'Share');
                       }
                   }
            }
            System.debug('End for:: count++' + count++);
            
        }
        return sObjectMap;
    }
    
    /*
     * @purpose : get map of group id to developer name
     * @param   : 1) Set<Id> nameNotAvailableIds : Ids of the group
     * @return  : 1) Map<Id, String> grpIdtoDevNameMap : Id of the group and developer name
     */ 
    Private static Map<Id, String> getIdtoDevNameMap(Set<Id> nameNotAvailableIds){
        Map<Id, String> grpIdtoDevNameMap = new Map<Id, String>();
        if(!nameNotAvailableIds.isEmpty()){
            for(Group grpRecord : [SELECT Id, Name, DeveloperName
                                   FROM Group 
                                   WHERE Id IN : nameNotAvailableIds]){
                grpIdtoDevNameMap.put(grpRecord.Id, grpRecord.DeveloperName);              
            }
        }
        return grpIdtoDevNameMap;
    }
    
    //wrapper for the picklist and share records
    Public Class SharedOrUsersWrapper{
        @AuraEnabled
        Public Map<String, List<PicklistWrapper>> strToPicklistWrappers = new Map<String, List<PicklistWrapper>>();
        @AuraEnabled
        Public List<ShareRecordWrapper> shareRecordWrapperList = new List<ShareRecordWrapper>();
        Public Set<Id> sharedUserIds = new Set<Id>();
    }
    
    //wrapper of the picklist
    Public class PicklistWrapper{
        @AuraEnabled Public String id;
        @AuraEnabled Public String name;
        @AuraEnabled Public String type;
        @AuraEnabled Public Boolean isPortalEnabledUsr;
        @AuraEnabled Public String portalTypeUsrRole;
        @AuraEnabled Public String portalRoleUsrRole;
        //constructor for user
        Public PicklistWrapper(String id, String name, String type){
            this.id = id;
            this.name = name;
            this.type = type;
        }
        //constructor for userrole
        Public PicklistWrapper(String id, String name, Boolean isPortalEnabledUsr){
            this.id = id;
            this.name = name;
            this.isPortalEnabledUsr = isPortalEnabledUsr;
        }
        //constructor for group
        Public PicklistWrapper(String id, String name, String portalTypeUsrRole, String portalRoleUsrRole){
            this.id = id;
            this.name = name;
            this.portalTypeUsrRole = portalTypeUsrRole;
            this.portalRoleUsrRole = portalRoleUsrRole;
        }
    }
    
    //wrapper of the client response.  (record save string)
    public class ClientResponseWrapper{
        Public String sfid;
        Public String accessLevel;
        Public List<cls_records> records;
    }
    //records wraper
    public class cls_records {
        public String value;    
        public String label;    
        public boolean isRole;
    }
    //wrapper to save users, roles and groups
    public class ShareRecordWrapper{
        @AuraEnabled Public String id;
        @AuraEnabled Public String name;
        @AuraEnabled Public String accessLevel;
        @AuraEnabled Public String parentId;
        @AuraEnabled Public String reason;
        @AuraEnabled Public Boolean isRole;
    }
    
    //method to create profile name as well some system define users
    //at the time of query, it will not fetch following profile's users or names
    Private static Set<String> restrictedProfileUsers(){
        return new Set<String>{'System Administrator',
                               'Chatter External User',
                               'Chatter Free User',
                               'Chatter Moderator User',
                               'Contract Manager',
                               'Force.com - One App User',
                               'Marketing User',
                               'Partner Community User',
                               'Read Only',
                               'Service Cloud User',
                               'Automated Process',
                               'System'};
   }
}