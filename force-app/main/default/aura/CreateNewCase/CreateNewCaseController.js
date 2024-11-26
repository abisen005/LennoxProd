({
    doInit : function(component, event, helper) {
        helper.showSpinner(component);
        
        helper.callApexAction(component, 'getCaseRecordTypeId', {})
        .then(function (result) {
            if (result.isSuccess) {
                console.log('recordTypeid ',result.data);
                component.set('v.recordTypeId', result.data);
            }
            else {
                helper.showToast(component, 'Error', result.msg, 'error');
                helper.hideSpinner(component);
            }
        });
        
        var recordId = component.get("v.recordId");
        //alert('recordId--- ',recordId);        
        
        if( recordId ){
            helper.callApexAction(component, 'getContacts', {"accountId": recordId})
            .then(function (result) {
                if (result.isSuccess) {
                    console.log('Contacts--- ',result.data);
                    component.set('v.options', result.data);
                }
                else {
                    helper.showToast(component, 'Error', result.msg, 'error');
                    helper.hideSpinner(component);
                }
            });
        } 
    },
    
    handleSaveContact: function(component, event, helper) {
        helper.showSpinner(component);
        
        if(helper.validateContactForm(component)) {
            var recordId = component.find("accountLookup").get("v.value");
            
            component.find("accountLookup1").set("v.value", recordId);
            
            component.find("ContactRecordCreator").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // handle the successful create
                    component.set("v.showCreateContact", false);
                    $A.enqueueAction(component.get('c.onAccountChange')); 
                    helper.hideSpinner(component);
                    component.set("v.showNewContactCreated", true);
                    component.find("contactLookup2").set("v.value", saveResult.recordId);	
                } else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                    helper.hideSpinner(component);
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
                    helper.hideSpinner(component);
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    helper.hideSpinner(component);
                }
            });            
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.showCreateContact", false);
    },
    
    handleOnload : function(component, event, helper) {
                
        //helper.showSpinner(component);
        var recordId = component.get("v.recordId");
        var sObjectName = component.get("v.sObjectName");
        console.log('In handleOnload', recordId+' '+sObjectName);
        var recordUiParams = event.getParam('recordUi');
        var fields = Object.keys(recordUiParams.record.fields);
        component.set('v.origin' , '');
        $A.util.removeClass(component.find("OriginField"), "none");
        if(recordId != undefined && sObjectName != undefined && 
           recordId != null && sObjectName != null){
            console.log('test');
            if(sObjectName == 'Account'){
                component.find("accountLookup").set("v.value", recordId);
                helper.hideSpinner(component);
            }
            if(sObjectName == 'Contact'){
                helper.callApexAction(component, 'getAccountRecordId', {contactId:recordId})
                .then(function (result) {
                    if (result.isSuccess) {
                        console.log('recordTypeid ',result.data);
                        component.find("accountLookup").set("v.value", result.data);
                        component.find("contactLookup").set("v.value", recordId);
                        helper.hideSpinner(component, helper);
                    }
                    else {
                        helper.showToast(component, 'Error', result.msg, 'error');
                        helper.hideSpinner(component);
                    }
                });
                
            }
        }
        
        //component.find("accountLookup").set("v.value", '0015C00000M7HknQAF');
        
        helper.hideSpinner(component);
    },
    
    handleOnSubmit : function(component, event, helper) {
        helper.showSpinner(component);
        event.preventDefault(); // Prevent default submit
        
        var fields = JSON.parse(JSON.stringify(event.getParam("fields")));        
        
        if( !fields["ContactId"] ){
            fields["ContactId"] = component.get("v.selectedValue");
        }
        
        if( fields["ContactId"] == 'None' ){
            fields["ContactId"] = '';
        }
        console.log('fields--' , fields);
        
        if( fields["Origin"] == null || fields["Origin"] == 'None' || fields["Origin"] == '' ){
            
            $A.util.addClass(component.find("OriginField"), "slds-has-error");
             
            helper.hideSpinner(component); 
            
        }else{
        	
        	component.find('createAccountCase').submit(fields); 
		//helper.hideSpinner(component);    
		}    
    },
    removeError : function(component){
        var Origin = component.get('v.origin');
        if( !Origin == null || !Origin == 'None' || !Origin == '' ){
             $A.util.removeClass(component.find("OriginField"), "slds-has-error");
        }
    },
    
    handleOnSuccess : function(component, event, helper) {
        helper.showSpinner(component);
        console.log('handleOnSuccess ');
        var caseRecord = event.getParams().response;
        console.log('caseRecord.id ', caseRecord.id);
        helper.showToast(component, 'Success', 'The record has been created successfully.', 'success');
        $A.get("e.force:closeQuickAction").fire();
        helper.navigateToRecord(component, caseRecord.id);
        helper.hideSpinner(component);
        
    },
    
    onAccountChange : function(component, event, helper) {
        console.log('test here if Account field is changed programatically');
        //alert('In onAccountChange() method');
        
        var recordId = component.find("accountLookup").get("v.value");
        //alert('recordId in onAccountChange--- ',recordId);        
        
        if( recordId ){
            helper.callApexAction(component, 'getContacts', {"accountId": recordId})
            .then(function (result) {
                if (result.isSuccess) {
                    console.log('Contacts--- ',result.data);
                    component.set('v.options', result.data);
                }
                else {
                    helper.showToast(component, 'Error', result.msg, 'error');
                    helper.hideSpinner(component);
                }
            });
        }    
    },
    
    createNewContact : function(component, event, helper) {
        //alert('In createNewContact() method');
        
        if( component.get("v.selectedValue") == 'Create New Contact'){
            
            component.set("v.showCreateContact", true);
            
            // Prepare a new record from template
            component.find("ContactRecordCreator").getNewRecord(
                "Contact", // sObject type 
                null,      // recordTypeId
                false,     // skip cache?
                $A.getCallback(function() {
                    var rec = component.get("v.newContact");
                    var error = component.get("v.newContactError");
                    if(error || (rec === null)) {
                        console.log("Error initializing record template: " + error);
                        return;
                    }
                    console.log("Record template initialized: " + rec.sobjectType);
                })
            );
            
           /* var createRecordEvent = $A.get('e.force:createRecord');
            
            var recordId = component.find("accountLookup").get("v.value");
            var windowRedirect = window.location.href;
            
            if ( createRecordEvent ) {
                createRecordEvent.setParams({
                    'entityApiName': 'Contact',
                    'defaultFieldValues': {
                        'AccountId' : recordId,
                    },
                    "panelOnDestroyCallback": function(event) {
                        //window.location.href = windowRedirect; // Return to the page where the record was created
                        //Assign newly created record to Contact picklist as a selected value 
                        $A.enqueueAction(component.get('c.onAccountChange'));
                    }
                });
                createRecordEvent.fire();
            } else {
                alert("Contact creation not supported");
            } */            
        }
    }
})