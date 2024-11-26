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
    
    removeByIndex : function (str,index){
   if(index==0){
            return  str.slice(1)
   }else{
            return str.slice(0,index-1) + str.slice(index);
         } 
   }
})