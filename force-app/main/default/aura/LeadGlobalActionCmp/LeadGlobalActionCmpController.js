({
    doInit : function(component, event, helper) {
        
        component.set("v.isOpen", true);
        
        helper.callApexAction(component, 'getOnloadData', {})
        
        .then(function (result) {
            
            console.log('customer@@@@', result);
            
            if (result.isSuccess) {
                
                component.set("v.showButton", result.data);
                console.log('result', result);
                //helper.hideSpinner(component, event, helper);
            }
            else {
                console.log('Error ', result.msg);
               // helper.hideSpinner(component, event, helper);
            }
        });
    },
    
	Next : function(component, event, helper) {
		
         component.set("v.isOpen", false);
        
         $A.get("e.force:closeQuickAction").fire(); 
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead"
        });
        createRecordEvent.fire();
	},
    
    Cancel : function(component, event, helper) {
		
        component.set("v.isOpen", false);
        $A.get("e.force:closeQuickAction").fire();
        
	}
})