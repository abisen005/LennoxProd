({
	//generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            console.log( 'params-' , params);
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
                    console.log( 'callbackResult.getReturnValue---' , callbackResult.getReturnValue());
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
    
    validateContactForm: function(component) {
        var validContact = true;
        // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            return(validContact);            
        }  
    },
    
    showSpinner: function (component) {
        
            component.set("v.isSpinner", true);
        
    },
    
    hideSpinner: function (component) {
        //component.set("v.isSpinner", false);
        setTimeout(function(){ component.set("v.isSpinner", false); }, 100);
    },
    
    navigateToRecord : function (component, recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
            
        });
        navEvt.fire();
    },
    
    showToast : function(component, title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type" : type
        });
        toastEvent.fire();
    }
    
})