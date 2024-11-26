public class FT_FieldTrialParticipantAppController {
    public class defaultUserException extends Exception {}
    public string recordId {get;set;}
    public string message {get;set;}
    public boolean isSuccess {get;set;}
    public Response res {get;set;}
    public string resStr {get;set;}
    public List<SectionWrapper> participantAppFieldList {get;set;}
    public FT_Field_Trial_Participant_Application__c fieldParticipant {get;set;}
    public List<SectionWrapper> participantAppSystemFieldList {get;set;}
    public List<FT_Field_Trial_Participant_Applctn_Systm__c> fieldParticipantSystemList {get;set;}
    public String globalQuerySystem = '';
    //private ApexPages.StandardController controller;
    public FT_FieldTrialParticipantAppController(ApexPages.StandardController controller){
        //this.controller = controller;
        recordId = controller.getRecord().Id;
        String query = '', querySystem = '';
        participantAppFieldList = new List<SectionWrapper>();
        participantAppSystemFieldList = new List<SectionWrapper>();

        Map<String, Page_Layout_Field_Order_Setting__mdt> fieldOrderMap =
            getPageLayoutFieldsOrder();
        participantAppFieldList = getPageLayoutFields(
            'FT_Field_Trial_Participant_Application__c-Warning: Used in code. Altering will affect form',
            'FT_Field_Trial_Participant_Application__c', fieldOrderMap );
        participantAppSystemFieldList = getPageLayoutFields(
            'FT_Field_Trial_Participant_Applctn_Systm__c-Warning: Used in code. Altering will affect form',
            'FT_Field_Trial_Participant_Applctn_Systm__c', fieldOrderMap );

        //system.debug('participantAppFieldList ::'+ participantAppFieldList);
        //system.debug('participantAppFieldList ::'+ JSON.serialize(participantAppFieldList));
        //system.debug('recordId ::'+recordId);
        if(String.isNotBlank(recordId)){
            query = generateQueryStr(participantAppFieldList, recordId);
            querySystem = generateQuerySystemStr(participantAppSystemFieldList, recordId);
            globalQuerySystem = querySystem;
        }
        if(String.isNotBlank(query)) {
            try{
                fieldParticipant = Database.query(query);
                fieldParticipantSystemList = Database.query(querySystem);
                //system.debug('fieldParticipant::::'+fieldParticipant);

            }
            catch(Exception e) {
                //system.debug('field issue exception');
                createException(e);
            }
        }else{
            fieldParticipant = new FT_Field_Trial_Participant_Application__c();
            fieldParticipantSystemList = new List<FT_Field_Trial_Participant_Applctn_Systm__c>();
        }
        //System.debug('in controller instance');
        resStr = JSON.serialize(new Response(false, '', null));
    }

    public List<SectionWrapper> getPageLayoutFields(String layoutName, String objectName,
                                                    Map<String, Page_Layout_Field_Order_Setting__mdt> fieldOrderMap ){
        Map<String, Schema.SObjectField> fieldMap =
            Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap();

        List<Metadata.Metadata> layouts =
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout,
                                         new List<String> { layoutName });
        Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);
        List<Metadata.LayoutSection> layoutSections = layoutMd.layoutSections;
        List<SectionWrapper> sectionList = new List<SectionWrapper>();

        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            //System.debug('section ::'+section);
            SectionWrapper sectionWrp = new SectionWrapper();
            sectionWrp.sectionName = section.label;

            Map<String, FieldWrapper> fieldsMap =
                new Map<String, FieldWrapper>();
            Map<Integer, Map<Integer, FieldWrapper>> fieldsUiMap =
                new Map<Integer, Map<Integer, FieldWrapper>>();

            for (Metadata.LayoutColumn column : section.layoutColumns) {
                //System.debug('section column ::'+column);
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {

                        if( item <> null && item.field <> null ) {
                            //System.debug('item ::'+item);
                            //System.debug('item field ::'+item.field);
                            FieldWrapper fieldWrp = new FieldWrapper();
                            fieldWrp.fieldApiName = item.field;
                            fieldWrp.fieldBehaviour = String.valueOf(item.behavior);
                            fieldWrp.fieldOrder =
                                fieldOrderMap.containsKey( item.field ) ?
                                    (Integer) fieldOrderMap.get( item.field ).Field_Order_Index__c : 1;
                            fieldWrp.sectionOrder =
                                fieldOrderMap.containsKey( item.field ) ?
                                    (Integer) fieldOrderMap.get( item.field ).Section_Order_Index__c : 1;
                            //get field label
                            fieldWrp.fieldLabel = fieldMap.get(item.field).getDescribe().getLabel();
                            Schema.DisplayType dType = fieldMap.get(item.field).getDescribe().getType();
                            //System.debug('label::'+fieldWrp.fieldLabel);
                            //System.debug('dType::'+dType);
                            fieldWrp.fieldType = dType;
                            fieldsMap.put(item.field, fieldWrp);

                            if( !fieldsUiMap.containsKey( fieldWrp.sectionOrder ) ) {
                                fieldsUiMap.put(fieldWrp.sectionOrder,
                                    new Map<Integer, FieldWrapper>());
                            }

                            fieldsUiMap.get( fieldWrp.sectionOrder ).put( fieldWrp.fieldOrder, fieldWrp );
                        }
                    }
                }
            }
            sectionWrp.fieldsMap = fieldsMap;
            sectionWrp.fieldsCount = fieldsMap.size();
            sectionWrp.fieldsUiMap = sortFieldsBySection(fieldsUiMap);
            sectionList.add(sectionWrp);
        }

        System.debug('sectionList ::'+ JSON.serialize(sectionList));
        return sectionList;
    }

    private Map<Integer, List<FieldWrapper>> sortFieldsBySection( Map<Integer, Map<Integer, FieldWrapper>> fieldsUiMap ) {
        Map<Integer, List<FieldWrapper>> sortedfieldsUiMap = new Map<Integer, List<FieldWrapper>>();

        List<Integer> sortedKeyList = new List<Integer>( fieldsUiMap.keySet() );
        sortedKeyList.sort();

        for( Integer sectionIndex : sortedKeyList ) {
            List<FieldWrapper> sortedFieldList = new List<FieldWrapper>();

            List<Integer> sortedFieldIndexList = new List<Integer>( fieldsUiMap.get( sectionIndex ).keySet() );
            sortedFieldIndexList.sort();

            for( Integer fieldIndex : sortedFieldIndexList ) {
                sortedFieldList.add( fieldsUiMap.get( sectionIndex ).get( fieldIndex ) );
            }

            sortedfieldsUiMap.put( sectionIndex, sortedFieldList );
        }

        return sortedfieldsUiMap;
    }

    static Map<String, Page_Layout_Field_Order_Setting__mdt> getPageLayoutFieldsOrder(){

        Map<String, Page_Layout_Field_Order_Setting__mdt> fieldOrderMap =
            new Map<String, Page_Layout_Field_Order_Setting__mdt>();

        List<Page_Layout_Field_Order_Setting__mdt> fieldOrderSettingList;

        try {
            fieldOrderSettingList =
                [SELECT Field_API_Name__c, Field_Order_Index__c,
                Section_Order_Index__c, Require_Minimum_of_3_Characters__c,
                Required_Dependency_Field__c, Required_Dependency_Value__c
                FROM Page_Layout_Field_Order_Setting__mdt ];
        }
        catch( Exception exc ) {
            System.debug('Exception in Page Layout Field Order Custom Metadata -- ' +
                exc.getMessage() + ' at Line -- ' + exc.getLineNumber());
        }

        if( fieldOrderSettingList <> null && !fieldOrderSettingList.isEmpty() ) {
            for( Page_Layout_Field_Order_Setting__mdt fieldOrderSetting : fieldOrderSettingList ) {
                fieldOrderMap.put( fieldOrderSetting.Field_API_Name__c, fieldOrderSetting );
            }
        }

        return fieldOrderMap;
    }

    public string generateQueryStr(List<SectionWrapper> sectionList, string recordId){
        String query;
        if(String.isNotBlank(recordId) && sectionList != null && !sectionList.isEmpty()) {
            query = 'SELECT Id, ';

            for(SectionWrapper section : sectionList) {
                for (String field : section.fieldsMap.keySet()){
                    query += field + ', ';
                }
            }
            query = query.removeEnd(', ');

            query += ' FROM FT_Field_Trial_Participant_Application__c WHERE Id = \''+recordId+'\'';
            //System.debug('query ==' +query);
        }
        return query;
    }

    public string generateQuerySystemStr(List<SectionWrapper> sectionList, string recordId){
        String query;
        if(String.isNotBlank(recordId) && sectionList != null && !sectionList.isEmpty()) {
            query = 'SELECT Id, ';

            for(SectionWrapper section : sectionList) {
                for (String field : section.fieldsMap.keySet()){
                    query += field + ', ';
                }
            }
            query = query.removeEnd(', ');

            query +=  ' FROM FT_Field_Trial_Participant_Applctn_Systm__c ' +
                      'WHERE FT_Field_Trial_Participant_Application__c = \''+recordId+'\' ' +
                      'ORDER BY FT_System__c ASC';
            //System.debug('query ==' +query);
        }
        return query;
    }

    @RemoteAction
    public static Map<String,Map<String,Object>> fetchCustomValidations() {
        Map<String,Map<String,Object>> customValidations =
            new Map<String,Map<String,Object>>();

        Map<String, Page_Layout_Field_Order_Setting__mdt> fieldOrderMap =
            getPageLayoutFieldsOrder();

        for (String field : fieldOrderMap.keySet()) {
            Map<String,Object> customValidation = new Map<String,Object>();
            customValidation.put('requireMinimum3Characters',
                fieldOrderMap.get(field).Require_Minimum_of_3_Characters__c);
            customValidation.put('requiredDependencyField',
                fieldOrderMap.get(field).Required_Dependency_Field__c);
            customValidation.put('requiredDependencyValue',
                fieldOrderMap.get(field).Required_Dependency_Value__c);

            customValidations.put(field, customValidation);
        }

        return customValidations;
    }

    public static List<Object> removeElements( List<FT_Field_Trial_Participant_Applctn_Systm__c> input, Integer removeStartIdx ) {
        //System.debug('start: '+removeStartIdx);
        //System.debug('input: '+input);
        List<FT_Field_Trial_Participant_Applctn_Systm__c> output = input.clone();
        //System.debug('output: '+output);
        //System.debug('output: '+output.size());
        List<FT_Field_Trial_Participant_Applctn_Systm__c> outputToSend = new List<FT_Field_Trial_Participant_Applctn_Systm__c>();
        for( Integer i = 0; i < removeStartIdx; i++ ) {
            if( i <= output.size() - 1 ) {
                outputToSend.add( output[ i ] );
            }
        }
        //System.debug('outputToSend: '+outputToSend);
        return outputToSend;
    }

    public void getParticipantAppSystems() {
        //System.debug('in getParticipantAppSystems, fieldParticipant : '+fieldParticipant);
        //System.debug('fieldParticipant.FT_Number_of_Systems_in_the_home__c : '+fieldParticipant.FT_Number_of_Systems_in_the_home__c);
        if( fieldParticipant <> null && fieldParticipant.FT_Number_of_Systems_in_the_home__c <> null ) {

            Integer systemCount = Integer.valueOf( fieldParticipant.FT_Number_of_Systems_in_the_home__c );
            //fieldParticipantSystemList.clear();
            Integer fieldParticipantSystemListLen = fieldParticipantSystemList.size();

            //if changed system count is less than previously added systems then delete existing records
            if( String.isNotBlank( globalQuerySystem ) ) {

                if( systemCount < fieldParticipantSystemListLen ) { //remove additional systems from list
                    Integer removeStartIdx = fieldParticipantSystemListLen - ( fieldParticipantSystemListLen - systemCount );
                    fieldParticipantSystemList =
                        (List<FT_Field_Trial_Participant_Applctn_Systm__c>)
                            removeElements(fieldParticipantSystemList, removeStartIdx);
                } else { // assign old list and then add additional systems to fill information
                    fieldParticipantSystemList = Database.query( globalQuerySystem );
                    fieldParticipantSystemListLen = fieldParticipantSystemList.size();
                    fieldParticipantSystemList =
                        (List<FT_Field_Trial_Participant_Applctn_Systm__c>)
                            removeElements(fieldParticipantSystemList, systemCount);

                }
            } else {
                if( systemCount < fieldParticipantSystemListLen ) { //remove additional systems from list
                    Integer removeStartIdx = fieldParticipantSystemListLen - ( fieldParticipantSystemListLen - systemCount );
                    fieldParticipantSystemList =
                        (List<FT_Field_Trial_Participant_Applctn_Systm__c>)
                            removeElements(fieldParticipantSystemList,removeStartIdx);
                    fieldParticipantSystemListLen = fieldParticipantSystemList.size();
                }
            }
            for( Integer i = fieldParticipantSystemListLen; i < systemCount; i++ ) {

                fieldParticipantSystemList.add( new FT_Field_Trial_Participant_Applctn_Systm__c( FT_System__c = '' + (i + 1) ) );
            }
        }
        //System.debug('fieldParticipantSystemList : '+fieldParticipantSystemList);
        //return null;
    }

    public PageReference saveCustom() {

        try{
            //System.debug( 'in save try block' );
            //System.debug('fieldParticipant ::'+ fieldParticipant);
            String messageToDisplay = '';
            if( fieldParticipant.FT_Employee_ID__c != null  ) {
                //System.debug('employee id: '+fieldParticipant.FT_Employee_ID__c);
                String employeeId = fieldParticipant.FT_Employee_ID__c;
                String updatedEmployeeId = employeeId;
                Integer employeeIdLen = employeeId.length();
                //System.debug('employeeIdLen: '+employeeIdLen);
                if( employeeIdLen < 8 ) {
                    updatedEmployeeId = employeeId.leftPad( 8, '0' );
                }
                fieldParticipant.FT_Employee_ID__c = updatedEmployeeId;
                //System.debug('updated employee id: '+fieldParticipant.FT_Employee_ID__c);
            }
            //System.debug('fieldParticipantSystemList:::'+fieldParticipantSystemList);
            if(fieldParticipant.Id != null){
                //system.debug('in update');
                update fieldParticipant;
                resStr = JSON.serialize(new Response(true, 'Your application has been successfully submitted.',fieldParticipant));
                messageToDisplay = 'Your application has been successfully submitted.';
                //ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Your application has been successfully submitted.'));
                //system.debug('resStr ::' +resStr);
            }else{
                //system.debug('fieldParticipant.FT_Employee_ID__c ::'+ fieldParticipant.FT_Employee_ID__c != null);
                if(fieldParticipant.FT_Employee_ID__c != null){
                    //system.debug('employee id not null');
                    List<FT_Field_Trial_Participant_Application__c> existingRecordList =
                        [SELECT Id, OwnerId
                        FROM FT_Field_Trial_Participant_Application__c
                        WHERE FT_Employee_ID__c = :fieldParticipant.FT_Employee_ID__c
                        LIMIT 1];
                    if(existingRecordList.size() == 0){
                        //system.debug('employee id not present');
                        //System.debug('save fieldParticipant new record ::'+ JSON.serialize(fieldParticipant));

                        User u = [SELECT ID FROM User WHERE IsActive=True AND Name='Lennox Salesforce User' LIMIT 1];
                        if (u==null) { throw new defaultUserException('Default user named Lennox Salesforce User not found.'); }
                        fieldParticipant.OwnerId = u.Id;
                        insert fieldParticipant;
                        resStr = JSON.serialize(new Response(true, 'Your application has been successfully submitted.',fieldParticipant));
                        //ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Your application has been successfully submitted.'));
                        messageToDisplay = 'Your application has been successfully submitted.';
                        //system.debug('resStr ::' +resStr);
                    }else{
                        //system.debug('employee id present');
                        //System.debug('save fieldParticipant update record ::'+ JSON.serialize(fieldParticipant));
                        fieldParticipant.Id = existingRecordList[0].Id;
                        update fieldParticipant;
                        resStr = JSON.serialize(new Response(true, 'Your application has been successfully submitted.',fieldParticipant));
                        //ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Your application has been successfully submitted.'));
                        messageToDisplay = 'Your application has been successfully submitted.';
                        //system.debug('resStr ::' +resStr);
                    }
                }else{
                    //system.debug('employee id null');
                    insert fieldParticipant;
                    resStr = JSON.serialize(new Response(true, 'Your application has been successfully submitted.',fieldParticipant));
                    //ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Your application has been successfully submitted.'));
                    messageToDisplay = 'Your application has been successfully submitted.';
                    //system.debug('resStr ::' +resStr);
                }
            }
            if( fieldParticipant != null && fieldParticipant.Id != null && fieldParticipantSystemList != null
              && !fieldParticipantSystemList.isEmpty() ) {
                //get existing FT_Field_Trial_Participant_Applctn_Systm__c records
                String fieldParticipantId = fieldParticipant.Id;
                Map<Id, FT_Field_Trial_Participant_Applctn_Systm__c> FTParticipantAppSystems =
                    new Map<Id, FT_Field_Trial_Participant_Applctn_Systm__c>(
                        [SELECT Id FROM FT_Field_Trial_Participant_Applctn_Systm__c
                        WHERE FT_Field_Trial_Participant_Application__c =: fieldParticipantId]);
                Set<Id> FTParticipantAppSystemIds = new Set<Id>();
                if( FTParticipantAppSystems.size() > 0 ) {
                    FTParticipantAppSystemIds = FTParticipantAppSystems.keySet();
                }
                List<Id> updatedSystemRecIds = new List<Id>();
                for( FT_Field_Trial_Participant_Applctn_Systm__c systemRec : fieldParticipantSystemList ) {
                    if( systemRec.Id == null ) {
                        systemRec.FT_Field_Trial_Participant_Application__c = fieldParticipant.Id;
                    } else {
                        updatedSystemRecIds.add( systemRec.Id );
                    }
                }
                //iterate over existing records and delete if not there in to update list
                List<Id> toDeleteSystemRecIds = new List<Id>();
                for( Id FTParticipantAppSystemId : FTParticipantAppSystemIds ) {
                    if( !updatedSystemRecIds.contains( FTParticipantAppSystemId ) ) {
                        toDeleteSystemRecIds.add( FTParticipantAppSystemId );
                    }
                }

                upsert fieldParticipantSystemList;
                if( !toDeleteSystemRecIds.isEmpty() ) {
                    delete [SELECT Id FROM FT_Field_Trial_Participant_Applctn_Systm__c WHERE Id IN : toDeleteSystemRecIds ];
                }
                messageToDisplay += ' Participant application system records updated successfully.';
            } else { //check if any child entries present. If so delete them

            }
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO, messageToDisplay ));
        }catch(Exception ex){
            //System.debug( 'in save catch block' );
            resStr = JSON.serialize(new Response(false, ex.getMessage(),null));
            System.debug( 'Error message:'+ex.getMessage() );
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,ex.getMessage()));
            createException(ex);
        }

        return null;
        
    }

    public void resetForm(){
        fieldParticipant = null;
    }

    // Generate Exception message
    public void createException(Exception e) {

        System.debug('The following exception has occurred' + e.getMessage() +
                     'At line number :' + e.getLineNumber() + 'Error' +
                     e.getStackTraceString());
    }

    public class SectionWrapper {
        public string sectionName {get;set;}
        public Map<String, FieldWrapper> fieldsMap {get;set;}
        public Integer fieldsCount {get;set;}
        public Map<Integer, List<FieldWrapper>> fieldsUiMap {get;set;}
    }

    public class FieldWrapper {
        public string fieldApiName {get;set;}
        public string fieldBehaviour {get;set;}
        public string fieldLabel {get;set;}
        public Integer fieldOrder {get;set;}
        public Integer sectionOrder {get;set;}
        public Schema.DisplayType fieldType {get;set;}
    }

    public class Response{
        public String msg;
        public Boolean isSuccess;
        public Object data;

        public Response(Boolean isSuccess, String msg, Object data){
            this.isSuccess = isSuccess;
            this.data = data;
            this.msg = msg;
        }
    }
}