({
	doInit : function(component, event, helper) {
        helper.getRecordList(component, event, helper);
    },
    
    createRecord: function (component,event,helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var objectType = component.get("v.objectApiName") == 'ContentDocumentLink' ? 'Files' : component.get("v.objectApiName");
        var defaultValues = {};
        
        if(component.get("v.objectApiName") == 'FieldTrialForms__c'){
            var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
            
            if(selectedRecordTypeId != null && 
           	   selectedRecordTypeId != 'undefined'){
                
                var recordId = component.get('v.parentId');
            	defaultValues.FT_Field_Trial_Contacts__c = recordId;  
                component.set("v.showRecordTypes", false);
                
                createRecordEvent.fire({
                    "entityApiName": objectType,
                    "defaultFieldValues": defaultValues,
                    "recordTypeId": selectedRecordTypeId
                });
                
                component.set("v.selectedRecordTypeId", null);
            } 
            else{
                helper.getFieldTrialRecordTypes(component,event,helper);
            }
        }
        else{
            var recordId = component.get('v.parentId');
            //defaultValues.FT_Field_Trial_Contacts__c = recordId;  
            
        	createRecordEvent.fire({
                "entityApiName": objectType,
                "defaultFieldValues": defaultValues
            });    
        }
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.fire({
                    "recordId": row.Id
                });
                break;
            case 'view':
                /*component.set('v.previewFileId',row.Id);
                component.set('v.previewFileDescription', row.Title || row.Name);
                component.set('v.showPreview', true);*/
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [row.ContentDocumentId] //'069R0000000YvlzIAC'
                });
                break;
            case 'view_details':
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [row.ContentDocumentId] //'069R0000000YvlzIAC'
                });
                break;
            case 'detail':
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.Id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
        }
    },
    updateColumnSorting: function (component, event, helper) {
        var field = component.get('v.headers').filter(function(e){
            return e.name == 'Name' || e.name == 'Title';
        });
        var fieldName = event.getParam('fieldName') == 'link' ? field[0].name : event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    handleUploadFinished: function (component, event,helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log('record Id ::', component.get('v.parentId'));
        helper.getRecordList(component, event, helper);
    }, 
    
    hideRecordTypeSelection: function (component, event,helper){
        component.set("v.selectedRecordTypeId", null);
        component.set("v.showRecordTypes", false);
    }
})