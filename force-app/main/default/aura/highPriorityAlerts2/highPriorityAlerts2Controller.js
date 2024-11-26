({
    openModal: function(component, event, helper) {
        var action = component.get('c.showPopup');
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        component.set("v.rowIndex", id_str);
        // var id_str2 = ctarget.dataset.value2;
        action.setParams({
            'rIndex': id_str
        });
        action.setCallback(this, function(response) {         
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.currentWrapper', response.getReturnValue());
                component.set("v.isOpen", true);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    doInit: function(component, event, helper) {
        /*var action = component.get('c.getHighPriorityList');

          action.setCallback(this, function(response) {         
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
              //set response value in wrapperList attribute on component.
              component.set('v.highPriorityList', response.getReturnValue());              
            }
          });
        $A.enqueueAction(action);*/
        helper.refreshP(component);
    },
    
    autoComplete: function(component, event, helper) {
        //call apex class method
        var action = component.get('c.autoCompleteT');
        var id_str = component.get('v.rowIndex');
        action.setParams({
            'rIndex': id_str
        });
        action.setCallback(this, function(response) {       	
            if(response.getState() === 'SUCCESS'){
                component.set("v.isOpen", false);
                helper.refreshP(component);
            } 
        });
        $A.enqueueAction(action);
    },
    
    createEvent: function(component, event, helper) {
        //call apex class method
        var action = component.get('c.createEventT');
        var id_str = component.get('v.rowIndex');
        action.setParams({
            'rIndex': id_str
        });
        action.setCallback(this, function(response) {         
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.navToR(component, response.getReturnValue());            
            }
        });
        $A.enqueueAction(action);
    },
    
    navigateToRec: function(component, event, helper) {
        //call apex class method
        var action = component.get('c.navigateToRecordT');
        var id_str = component.get('v.rowIndex');
        console.log(id_str);
        action.setParams({
            'rIndex': id_str
        });
        action.setCallback(this, function(response) {         
            //store state of response
            var state = response.getState();
            var chkM = response.getReturnValue();
            if (state === "SUCCESS") {
                if(chkM.indexOf("Record to navigate is not properly specified. Please contact your system administrator for help.") >= 0)
                	alert("Record to navigate is not properly specified. Please contact your system administrator for help.");
                else
                    helper.navToR(component, response.getReturnValue());     
            }
        });
        $A.enqueueAction(action);
    },
    
    
})