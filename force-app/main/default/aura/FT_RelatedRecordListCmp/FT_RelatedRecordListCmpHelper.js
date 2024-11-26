({
	//generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
                    resolve(callbackResult.getReturnValue());
                }
                if (callbackResult.getState() === 'ERROR') {
                    console.log('ERROR', callbackResult.getError());
                    reject(callbackResult.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    },
    
    showSpinner: function (component, event, helper) {
       component.set("v.isSpinner", true);
       console.log('In Showspinner', component.get("v.isSpinner"));
    },
    
    hideSpinner: function (component, event, helper) {
        component.set("v.isSpinner", false);
        console.log('In hideSpinner', component.get("v.isSpinner"))
    },
    
    showMsg : function(component, event, title, type, message ) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    },
    sortData: function (component, fieldName, sortDirection) {
        this.showSpinner(component);
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.data", data);
        this.hideSpinner(component);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    gotoRelatedList: function (component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Files",
            "parentRecordId": component.get("v.parentId")
        });
        relatedListEvent.fire();
    },
    getRowActions: function (component, event, helper){
        var actions = [];
        var objectApiName = component.get('v.objectApiName');
        if (objectApiName == 'ContentDocumentLink') {
            actions.push({ label: 'View', name: 'view' });
        } else {
            actions.push({ label: 'Edit', name: 'edit', disabled: !component.get('v.isUpdatable')});
        }

        return actions;
    },
    getRecordList: function (component, event, helper) {
        var recordId = component.get('v.parentId');
        var objectApiName = component.get('v.objectApiName');
        if (recordId) {
            helper.showSpinner(component, event, helper);
            helper.callApexAction(component, 'fetchSObjectRecordList',
                {
                    parentId: recordId,
                    objectApiName: objectApiName
                }).then(function (result) {
                    console.log('customer@@@@', result);
                    var recordsList = [];
                    var columns = [];
                    if (result && result.isSuccess) {
                        component.set("v.objectName", result.data.objectName);
                        component.set("v.headers", result.data.headers);
                        component.set("v.isCreatable", result.data.isCreateable);
                        component.set("v.isUpdatable", result.data.isUpdateable);
                        var headers = result.data.headers;
                        var records = result.data.recordList;

                        if (!records.length) {
                            for (var i = 0; i < 1; i++) {
                                var recordLst = [];
                                var obj = {
                                    Name: 'No items to display',
                                    Title: 'No items to display'
                                };
                                recordLst.push(obj);
                                headers.forEach(function (header, ind) {
                                    if (i == 0) {
                                        if (header.name != 'Id' && header.name != 'ContentDocumentId') {
                                            var col = {
                                                label: header.label, fieldName: header.name, type: 'text', sortable: false, editable: component.get("v.isUpdatable")
                                            };
                                            columns.push(col);
                                        }
                                    }
                                });
                            }
                            recordsList = recordLst;
                            //component.set("v.recordList", recordsList);
                            component.set("v.columns", columns);
                            component.set("v.data", recordsList);
                            component.set("v.recordListLength", recordsList.length);
                            helper.hideSpinner(component, event, helper);
                            return;
                        }

                        records.forEach(function (rec, idx) {
                            var recordLst = [];
                            /*if (window.location.pathname.indexOf('/r/') > -1){
                                rec['link'] = '/lightning/r/' + rec.Id;
                            } else if (window.location.pathname.indexOf('/s/') > -1){
                                rec['link'] = '/fieldtrial/s/detail/' + rec.Id;
                            }*/
                            
                            headers.forEach(function (header, ind) {
                                /*var obj = {
                                    key: '',
                                    value: '',
                                    recordId: ''
                                };
                                if (rec[header.name]) {
                                    obj.key = header.name;
                                    obj.value = rec[header.name];
                                    obj.recordId = rec['Id'];
                                } else {
                                    obj.key = header.name;
                                    obj.value = '';
                                    obj.recordId = rec['Id'];
                                }
                                recordLst.push(obj);*/
                                if (idx == 0) {
                                    if (header.name != 'Id' && header.name != 'ContentDocumentId') {
                                        var col = {};
                                        if (header.name == 'Name' || header.name == 'Title') {
                                            if (objectApiName == 'ContentDocumentLink'){
                                                col = {
                                                    label: header.label,
                                                    fieldName: header.name,
                                                    type: 'button',
                                                    sortable: false,
                                                    typeAttributes: {
                                                        label: { fieldName: header.name }, variant:"base", class: "customBtn", name:'view_details'
                                                    }, editable: component.get("v.isUpdatable")
                                                };
                                            }else{
                                                col = {
                                                    label: header.label,
                                                    fieldName: header.name,
                                                    type: 'button',
                                                    sortable: false,
                                                    typeAttributes: {
                                                        label: { fieldName: header.name }, variant: "base", class: "customBtn", name: 'detail'
                                                    }, editable: component.get("v.isUpdatable")
                                                };
                                            }
                                            
                                        } else if (header.name == "CreatedDate") {
                                            col = {
                                                label: header.label,
                                                fieldName: header.name,
                                                type: "date",
                                                typeAttributes: {
                                                    year: "numeric",
                                                    month: "numeric",
                                                    day: "numeric",
                                                    hour: "2-digit",
                                                    minute: "2-digit",
                                                    hour12: false
                                                }, editable: component.get("v.isUpdatable")
                                            };
                                        } else {
                                            col = {
                                                label: header.label,
                                                fieldName: header.name,
                                                type: 'text',
                                                sortable: false, editable: component.get("v.isUpdatable")
                                            };
                                        }

                                        columns.push(col);
                                        if (ind == headers.length - 1) {
                                            columns.push({ type: 'action', typeAttributes: { rowActions: helper.getRowActions(component, event, helper) } });
                                        }
                                    }

                                }
                            });

                            recordsList.push(recordLst);
                        });
                        console.log('recordList ::', recordsList);
                        //component.set("v.recordList", records);
                        component.set("v.columns", columns);
                        component.set("v.data", records);
                        component.set("v.recordListLength", records.length);
                        helper.hideSpinner(component, event, helper);
                    }
                    else {
                        helper.hideSpinner(component, event, helper);
                        helper.showMsg(component, event, 'Error', 'error', result.msg);
                    }
                });
        }

    }, 
    
    getFieldTrialRecordTypes: function(component, event, helper){ 
        var action = component.get("c.getRecordTypes");
        action.setParams({ objectName : component.get("v.objectApiName")}); 
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var recordTypes = [];
                var data = JSON.parse(response.getReturnValue().data);                
                for (let key in data) {
                    recordTypes.push({'label' : data[key], 'value' : key});
                } 
                
                if(recordTypes && recordTypes.length > 0){
                    component.set("v.selectedRecordTypeId", recordTypes[0].value); 
                    component.set("v.recordTypes", recordTypes); 
                    component.set("v.showRecordTypes", true);
                }   
                else{
                    var createRecordEvent = $A.get("e.force:createRecord");
                    var objectType = component.get("v.objectApiName") == 'ContentDocumentLink' ? 'Files' : component.get("v.objectApiName");
                    var defaultValues = {};
                    var recordId = component.get('v.parentId');
                    defaultValues.FT_Field_Trial_Contacts__c = recordId;  
                    component.set("v.showRecordTypes", false);
                    
                    createRecordEvent.fire({
                        "entityApiName": objectType,
                        "defaultFieldValues": defaultValues
                    });
                }
            }
            else if (state === "INCOMPLETE") { 
            }
                else if (state === "ERROR") { 
                    var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                }
        });
        
        $A.enqueueAction(action);
		
    }
})