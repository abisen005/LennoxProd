public with sharing  class FT_SObjectRelatedListController {
	public static String DEALER_PERMISSION_SET = 'FT_Field_Trial_Community_Dealer';
    public static String PARTICIPANT_PERMISSION_SET = 'FT_Field_Trial_Community_Participant';
    
    
    public static List<String> permissions = new List<String>{DEALER_PERMISSION_SET,PARTICIPANT_PERMISSION_SET};
    public static Map<String, Map<String, List<String>>> permissionToSObjectListMap;
    public static Map<String,List<String>> objectToRelatedListMap;
    public static Map<String, List<String>> objectToFieldMap;
    /*public static Map<String,List<String>> permissionToSObjectListMap = new Map<String,List<String>>{
      DEALER_PERMISSION_SET => new List<String>{'ContentDocumentLink','Field_Trial_Contacts__c','Equipment_Data__c'},
                //DEALER_PERMISSION_SET => new Map<String,List<String>>{'FieldTrial'=>'ContentDocumentLink','Field_Trial_Contacts__c','Equipment_Data__c'},
      PARTICIPANT_PERMISSION_SET => new List<String>{'Field_Trial_Contacts__c','Equipment_Data__c'}
    };*/
    /*public static Map<String, Map<String, List<String>>> permissionToSObjectListMap = new Map<String, Map<String,List<String>>>{
        DEALER_PERMISSION_SET => new Map<String, List<String>>{
            'FT_Field_Trial__c' => new List<String>{'ContentDocumentLink','Field_Trial_Contacts__c','Equipment_Data__c'},
            'Field_Trial_Contacts__c' => new List<String>{'Home_Owners__c','ServiceRecord__c'},
            'Home_Owners__c' => new List<String>{'ContentDocumentLink','Equipment_Data__c','ServiceRecord__c'},
            'ServiceRecord__c' => new List<String>{'ContentDocumentLink'},
            'Equipment_Data__c' => new List<String>{'ContentDocumentLink','ServiceRecord__c'},
            'FT_Field_Trial_Invoices__c' => new List<String>{'ContentDocumentLink'}
        },
        PARTICIPANT_PERMISSION_SET => new Map<String, List<String>>{
            'FT_Field_Trial__c' => new List<String>{'Field_Trial_Contacts__c','Equipment_Data__c'},
            'Field_Trial_Contacts__c' => new List<String>{'Home_Owners__c','ServiceRecord__c'},
            'Home_Owners__c' => new List<String>{'Equipment_Data__c','ServiceRecord__c'},
            'ServiceRecord__c' => new List<String>{'ContentDocumentLink'},
            'Equipment_Data__c' => new List<String>{'ServiceRecord__c'}
        }
    };     
    public static Map<String, List<String>> objectToFieldMap = new Map<String, List<String>>{
        'ContentVersion' => new List<String>{'Id','Title','Description','CreatedDate'},
        'Field_Trial_Contacts__c' => new List<String>{'Id','Name','CreatedDate'},
        'Equipment_Data__c' => new List<String>{'Id','Name','FT_Status__c','CreatedDate'},
        'Home_Owners__c' => new List<String>{'Id','Name','FT_Field_Trial_Contact__c','FirstName__c','LastName__c'},
        'ServiceRecord__c' => new List<String>{'Id','Name','FT_Service_Event_Status__c'}
    };*/
    
    @AuraEnabled
    public static Response fetchRelatedListObjects(Id recordId){
        String userId = UserInfo.getUserId();
        Response res;
        MetaDataWrapper metaData = new MetaDataWrapper();
        permissionToSObjectListMap = getPermissionMap();
        system.debug('permissionToSObjectListMap ::'+ JSON.serialize(permissionToSObjectListMap));
        String objectName = recordId.getSObjectType().getDescribe().getName();
        try{
            system.debug('userId ::'+userId);
            List<PermissionSetAssignment> permissionSetList = [SELECT Id, PermissionSet.Name, AssigneeId 
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId=:userId
                                                                AND PermissionSet.Name IN : permissionToSObjectListMap.keySet()];
            
            System.debug('permissionSetList ::'+ JSON.serialize(permissionSetList));
            Map<String,List<String>> permissionToObjectMap;
            if(permissionSetList.size() > 0){
                
                for(PermissionSetAssignment permission : permissionSetList){
                    //permissionToObjectMap = permissionToSObjectListMap.get(DEALER_PERMISSION_SET);
                    
                    if(permission.PermissionSet.Name == DEALER_PERMISSION_SET){
                        metaData.objectApiList = permissionToSObjectListMap.get(DEALER_PERMISSION_SET).get(objectName);
                    }else{
                        metaData.objectApiList = permissionToSObjectListMap.get(PARTICIPANT_PERMISSION_SET).get(objectName);
                    }
                }
            }else{
				// Internal_User set in metadata to access related objects without permissions.
                metaData.objectApiList = permissionToSObjectListMap.get('Internal_User').get(objectName);
            }
            //metaData.objectApiList = permissionToSObjectListMap.get(DEALER_PERMISSION_SET);
            res = new Response(true,'Fetched data.',metaData);
        }catch(Exception ex){
            res = new Response(false,'',null);
        }
        return res;
    }
    
    @AuraEnabled
    public static Response fetchSObjectRecordList(Id parentId, String objectApiName){
        Response res;
        system.debug('parentId ::'+parentId);
        system.debug('objectApiName ::'+objectApiName);
        if(String.isNotBlank(parentId)){
            objectToFieldMap = getHeadersMap();
            List<String> fields = objectApiName == 'ContentDocumentLink' ? objectToFieldMap.get('ContentVersion') : objectToFieldMap.get(objectApiName);
            system.debug('fields str ::'+ String.join(fields,','));
            String fieldStr = String.join(fields,',');
            String objectName = parentId.getSObjectType().getDescribe().getName();
            List<ColumnHeaders> headers = objectApiName == 'ContentDocumentLink' ? generateHeaders('ContentVersion') : generateHeaders(objectApiName);
            if(objectApiName == 'ContentDocumentLink'){
                system.debug('files ::');
                res = getFiles(parentId,objectApiName, headers, fieldStr);
            }else if(objectApiName == 'Field_Trial_Contacts__c'){
                res = getFTContacts(parentId,objectApiName, headers, fieldStr);
            }else if(objectApiName == 'Equipment_Data__c'){
                if(objectName == 'FT_Field_Trial__c'){
                    res = getFieldTrialEquipmentData(parentId,objectApiName, headers, fieldStr);
                }else if(objectName == 'Home_Owners__c'){
                    res = getSiteLocationEquipmentData(parentId,objectApiName, headers, fieldStr);
                }
            }else if(objectApiName == 'Home_Owners__c'){
                res = getSiteLocations(parentId,objectApiName, headers, fieldStr);
            }else if(objectApiName == 'ServiceRecord__c'){
                if(objectName == 'Field_Trial_Contacts__c'){
                    res = getFieldTrialContactServiceEvents(parentId,objectApiName, headers, fieldStr);
                }else if(objectName == 'Equipment_Data__c'){
                    res = getEquipmentServiceEvents(parentId,objectApiName, headers, fieldStr);
                }else if(objectName == 'Home_Owners__c'){
                    res = getSiteLocationServiceEvents(parentId,objectApiName, headers, fieldStr);
                }
            }else if(objectApiName == 'FieldTrialForms__c'){
                res = getFieldTrialForms(parentId,objectApiName, headers, fieldStr);
            }else if(objectApiName == 'FT_Field_Trial_Invoices__c'){
                res = getServiceEventInvoices(parentId,objectApiName, headers, fieldStr);
            }else {
                res = new Response(true, 'Success', null);
            }
        }else{
            res = new Response(false, 'Invalid Record Id.', null);
        }
        return res;
    }
    
    public static List<ColumnHeaders> generateHeaders(String objectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectApiName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        System.debug('objectApiName ::'+objectApiName);
        objectToFieldMap = getHeadersMap();
        List<String> fieldList = objectToFieldMap.get(objectApiName);
        List<ColumnHeaders> headerList = new List<ColumnHeaders>();
        for (String fieldName: fieldList) {  
            ColumnHeaders header = new ColumnHeaders();
            //if(fieldMap.get(fieldName) != null){
                header.label = fieldMap.get(fieldName).getDescribe().getLabel();
                header.name = fieldName;
            /*}else{
                if(fieldName.indexOf('#') > -1){
                    List<String> fieldNameList = fieldName.split('#');
                    header.label = String.valueOf(fieldNameList[0]).replace('#',' ');
                    header.name = String.valueOf(fieldNameList[1]);
                }
            }*/
            headerList.add(header);
        }
        
        return headerList;
    }

    public static Map<String,Map<String, List<String>>> getPermissionMap(){
        List<Related_List_Setting__mdt> relatedListMdt = [SELECT Id, SObject_Name__c, Sobject_Related_Object_Name__c,Permission_Set_Name__c
                                                             FROM Related_List_Setting__mdt];

        
        Map<String, Map<String, List<String>>> permissionToSObjectListMap = new Map<String, Map<String, List<String>>>();
        for(Related_List_Setting__mdt rec : relatedListMdt){
            objectToRelatedListMap = new Map<String, List<String>>();
            List<String> relatedObjectList;
            if(!permissionToSObjectListMap.containsKey( rec.Permission_Set_Name__c )){
                relatedObjectList = rec.Sobject_Related_Object_Name__c != null ? rec.Sobject_Related_Object_Name__c.split(',') : new List<String>();
                objectToRelatedListMap.put(rec.SObject_Name__c, relatedObjectList);
                permissionToSObjectListMap.put(rec.Permission_Set_Name__c, objectToRelatedListMap );

            }else{
                objectToRelatedListMap = permissionToSObjectListMap.get(rec.Permission_Set_Name__c);
                relatedObjectList = rec.Sobject_Related_Object_Name__c != null ? rec.Sobject_Related_Object_Name__c.split(',') : new List<String>();
                objectToRelatedListMap.put(rec.SObject_Name__c,relatedObjectList);
            }
        }

        return permissionToSObjectListMap;
    }

    public static Map<String, List<String>> getHeadersMap(){
        List<Sobject_Related_List_Header__mdt> headerListMdt = [SELECT Id, SObject_Name__c, Sobject_Related_Object_Name__c
                                                             FROM Sobject_Related_List_Header__mdt];
        Map<String, List<String>> objectToFieldMap = new Map<String, List<String>>();
        for(Sobject_Related_List_Header__mdt rec : headerListMdt){
            if(!objectToFieldMap.containsKey(rec.SObject_Name__c)){
                List<String> relatedObjectList = rec.Sobject_Related_Object_Name__c != null ? rec.Sobject_Related_Object_Name__c.split(',') : new List<String>();
                objectToFieldMap.put(rec.SObject_Name__c, relatedObjectList);
            }
        }
        return objectToFieldMap;
    }

    public static String getObjectLabel(String objectApiName){
        String label = '';
        if(objectApiName == 'ContentDocumentLink'){
            label = 'Files';//Schema.SObjectType.ContentDocumentLink.getLabel();
        }else if(objectApiName == 'Field_Trial_Contacts__c'){
            label = Schema.SObjectType.Field_Trial_Contacts__c.getLabel();
        }else if(objectApiName == 'Equipment_Data__c'){
            label = Schema.SObjectType.Equipment_Data__c.getLabel();
        }else if(objectApiName == 'Home_Owners__c'){
            label = Schema.SObjectType.Home_Owners__c.getLabel();
        }else if(objectApiName == 'ServiceRecord__c'){
            label = Schema.SObjectType.ServiceRecord__c.getLabel();
        }else if(objectApiName == 'FieldTrialForms__c'){
            label = Schema.SObjectType.FieldTrialForms__c.getLabel();
        }else if(objectApiName == 'FT_Field_Trial_Invoices__c'){
            label = Schema.SObjectType.FT_Field_Trial_Invoices__c.getLabel();
        }
        return label;
    }

    public static Boolean isRecordCreatable(String objectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectApiName);
        Boolean isCreateable = leadSchema.getDescribe().isCreateable();
        return isCreateable;
    }

    public static Boolean isRecordUpdatable(String objectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectApiName);
        Boolean isUpdatable = leadSchema.getDescribe().isUpdateable();
        return isUpdatable;
    }

    public static Response getFiles(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        String query='';
        try{
            List<ContentDocumentLink> contentDocumentLinkList = [SELECT Id, 
                                                                 ContentDocumentId 
                                                                 FROM ContentDocumentLink 
                                                                 WHERE LinkedEntityId = :parentId 
                                                                ];
            
            Set<Id> docLinkSet = new Set<Id>();
            
            if(contentDocumentLinkList != null && !contentDocumentLinkList.isEmpty()){
                
                for( ContentDocumentLink docLink : contentDocumentLinkList ){
                    docLinkSet.add(docLink.ContentDocumentId);
                }
            }
            
            if(docLinkSet != null && !docLinkSet.isEmpty()){
                query = 'SELECT '+fieldStr+' FROM ContentVersion WHERE ContentDocumentId IN : docLinkSet';
                contentVersionList = Database.query(query);
            }
            RelatedListWrapper recordWrapper = new RelatedListWrapper();

            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = contentVersionList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        return res;
    }
        
    public static Response getFTContacts(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query='';
        List<Field_Trial_Contacts__c> fieldTrialContactList = new List<Field_Trial_Contacts__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+ ' WHERE FT_Field_Trial__c=\''+parentId+'\'';
            system.debug('query ::'+query);
            fieldTrialContactList = Database.query(query);
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = fieldTrialContactList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        
        return res;
    }
    
    public static Response getFieldTrialEquipmentData(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query='';
        List<Equipment_Data__c> equipmentDataList = new List<Equipment_Data__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+' WHERE FT_Field_Trial__c=\''+parentId+'\'';
            equipmentDataList = Database.query(query);/*[SELECT Id, Name, FT_Status__c, CreatedDate 
                                 FROM Equipment_Data__c
                                 WHERE FT_Field_Trial__c =: parentId];*/
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = equipmentDataList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        
        return res;
    }

    public static Response getSiteLocationEquipmentData(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query = '';
        List<Equipment_Data__c> equipmentDataList = new List<Equipment_Data__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+' WHERE Home_Owner__c=\''+parentId+'\'';
            equipmentDataList = Database.query(query);
            /*equipmentDataList = [SELECT Id, Name, FT_Status__c, CreatedDate 
                                 FROM Equipment_Data__c
                                 WHERE Home_Owner__c =: parentId];*/
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = equipmentDataList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        
        return res;
    }

    public static Response getSiteLocations(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query = '';
        List<Home_Owners__c> siteLocationList = new List<Home_Owners__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+' WHERE FT_Field_Trial_Contact__c=\''+parentId+'\'';
            siteLocationList = Database.query(query);/*[SELECT Id,Name,FT_Field_Trial_Contact__c,FirstName__c,
                                 LastName__c 
                                 FROM Home_Owners__c
                                 WHERE FT_Field_Trial_Contact__c =: parentId];*/
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = siteLocationList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        return res;
    }

    public static Response getFieldTrialContactServiceEvents(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query = '';
        List<ServiceRecord__c> serviceEventList = new List<ServiceRecord__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+' WHERE FT_Dealer__c=\''+parentId+'\' OR FT_Participant__c=\''+parentId+'\'';
            serviceEventList = Database.query(query);/*[SELECT Id,Name,FT_Service_Event_Status__c 
                                 FROM ServiceRecord__c
                                 WHERE FT_Dealer__c =: parentId OR FT_Participant__c =: parentId];*/
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = serviceEventList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        return res;
    }

    public static Response getSiteLocationServiceEvents(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query = '';
        List<ServiceRecord__c> serviceEventList = new List<ServiceRecord__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+' WHERE FT_Site_Location__c=\''+parentId+'\'';
            serviceEventList = Database.query(query);/*[SELECT Id,Name,FT_Service_Event_Status__c 
                                 FROM ServiceRecord__c
                                 WHERE FT_Site_Location__c =: parentId];*/
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = serviceEventList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        return res;
    }

    public static Response getEquipmentServiceEvents(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        List<ServiceRecord__c> serviceEventList = new List<ServiceRecord__c>();
        try{
            serviceEventList = [SELECT Id,Name,FT_Service_Event_Status__c 
                                 FROM ServiceRecord__c
                                 WHERE EquipmentData__c =: parentId];
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = serviceEventList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        return res;
    }
    
    public static Response getFieldTrialForms(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query='';
        List<FieldTrialForms__c> fieldTrialFormsList = new List<FieldTrialForms__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+ ' WHERE FT_Field_Trial_Contacts__c=\''+parentId+'\'';
            system.debug('query ::'+query);
            fieldTrialFormsList = Database.query(query);
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = fieldTrialFormsList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        
        return res;
    }
    
    public static Response getServiceEventInvoices(String parentId, String objectApiName, List<ColumnHeaders> headers, String fieldStr){
        Response res;
        String query='';
        List<FT_Field_Trial_Invoices__c> fieldTrialInvoiceList = new List<FT_Field_Trial_Invoices__c>();
        try{
            query = 'SELECT '+fieldStr+' FROM '+objectApiName+ ' WHERE FT_Service_Event__c=\''+parentId+'\'';
            system.debug('query ::'+query);
            fieldTrialInvoiceList = Database.query(query);
            
            RelatedListWrapper recordWrapper = new RelatedListWrapper();
            recordWrapper.objectName = getObjectLabel(objectApiName);
            recordWrapper.isCreateable = isRecordCreatable(objectApiName);
            recordWrapper.isUpdateable = isRecordUpdatable(objectApiName);
            recordWrapper.headers = headers;
            recordWrapper.recordList = fieldTrialInvoiceList;
            res = new Response(true, 'Success', recordWrapper);
        }catch(Exception ex){
            res = new Response(false, 'Error', null);
        }
        
        return res;
    }
    
    @AuraEnabled
    public static Response getRecordTypes(String objectName){
        Response response;
    	Map<String, String> recordTypes = new Map<String, String>();
        
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        for(RecordTypeInfo info: objectType.getDescribe().getRecordTypeInfos()) { 
            if(info.isAvailable() && !info.isMaster()) {
                recordTypes.put(info.getRecordTypeId(), info.getName());
            }
        }   
        response = new Response(true, 'Success', JSON.serialize(recordTypes));
        return response;
    }
    
    public class MetaDataWrapper{
        @AuraEnabled
        public List<String> objectApiList;
    }
    
    public class RelatedListWrapper{
        @AuraEnabled
        public string objectName;
        @AuraEnabled
        public boolean isCreateable;
        @AuraEnabled
        public boolean isUpdateable;
        @AuraEnabled
        public List<SObject> recordList;
        @AuraEnabled
        public List<ColumnHeaders> headers;
    }
    
    public class ColumnHeaders{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string name;
    }
    
    public class Response{
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public Object data;
        
        public Response(Boolean isSuccess, String msg, Object data){
            this.isSuccess = isSuccess;
            this.data = data;
            this.msg = msg;
        }
    }
    
}