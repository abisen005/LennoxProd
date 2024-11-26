({
    doInIt : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        console.log('IN DOINIT');
        var recordId = component.get("v.recordId");
        
        if(recordId != null){
            helper.callApexAction(component, 'getOnloadPageData', {strRecordId:recordId})
        .then(function (result) {
            if (result.isSuccess) {
                component.set("v.homeOwner", result.data);
                console.log('result@@@@', result);
                helper.hideSpinner(component, event, helper);
            }
            else {
                helper.hideSpinner(component, event, helper);
                component.set('v.errorMsg', result.msg);
                //helper.showMsg(component, event, 'Error', 'error', result.msg );
            }
        });
        }
        else{
            helper.hideSpinner(component, event, helper);
            component.set('v.errorMsg', 'Record Id not found.');
            //$A.get("e.force:closeQuickAction").fire();
            //helper.showMsg(component, event, 'Error', 'error', 'Record Id not found.' );
        }
        
    },
    
    save: function(component, event, helper) {
        
        helper.showSpinner(component, event, helper);
        
        var formFields = component.find("formFieldToValidate");
        // Initialize the counter to zero - used to check validity of fields
        var allValid;
        // If there are more than 1 fields
        if(formFields.length!=undefined) {
            // Iterating all the fields
             allValid = formFields.reduce(function (validSoFar, inputCmp) {
                // Show help message if single field is invalid
                inputCmp.showHelpMessageIfInvalid();
                // return whether all fields are valid or not
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }
        
        console.log('allValid ', allValid);
        
            if(allValid){
                console.log('after validation ');
                var homeOwner  = component.get('v.homeOwner');
                helper.callApexAction(component, 'updateProgramStatusRecord', {programStatus:homeOwner})
                .then(function (result) {
                    if (result.isSuccess) {
                        
                        console.log('result@@@@', result);
                        helper.hideSpinner(component, event, helper);
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                        helper.showMsg(component, event, 'Success', 'success', 'Program Status record Updated successfully.' );
                    }
                    else {
                        helper.hideSpinner(component, event, helper);
                        component.set('v.errorMsg', result.msg);
                        //helper.showMsg(component, event, 'Error', 'error', result.msg );
                    }
                });
            }
            else{
                helper.hideSpinner(component, event, helper);
            }
            
        },
            
    /*validateNumberField: function(component, event, helper){
        var homeOwner  = component.get('v.homeOwner');
        console.log('In validateNumberField');
        var element = event.getSource();
        console.log('element ', element.get("v.value"));
        
        if(isNaN(element.get("v.value"))) {
            var zipcodeLength = element.get("v.value").length;
            var zipCode = helper.removeByIndex(element.get("v.value"),zipcodeLength-1);
            component.set('v.homeOwner.Nominee_Zip_Code__c',zipCode);
            event.preventDefault();
        } 
        
    }*/
    })