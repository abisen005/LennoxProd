({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true      
        component.set("v.isModalOpen", true);      
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
		component.set("v.isResultModal", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        var textVal = component.get("v.UnenrollmentReason");
        console.log('...',textVal);                
        
        var action = component.get("c.unenroll");
        action.setParams({ 
            "reason": textVal
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
				
				/*var action1 = component.get("c.deactivateUser");
                
				action1.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log(response.getReturnValue());                        
                    }                    
                });
                $A.enqueueAction(action1);*/
               // alert(name);
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    //"title": "Success!",
                    "duration":'10000',                   
                    "message": name
                });
                toastEvent.fire();*/
                component.set('v.modalText',name);
				
            }
        });
        
        component.set("v.isModalOpen", false);
		component.set("v.isResultModal", true); 
        $A.enqueueAction(action)
    }  
})