({
	 initialize: function(component, event, helper) {
       
    },
    
    onKeyUp: function(component,event,helper){
        if (event.getParam('keyCode')===13) {
            helper.checkCustomerId(component,event,helper);
        }
    },
    
    checkCustomerId: function(component, event, helper){
        
        helper.checkCustomerId(component,event,helper);
    },
    

    handleSubmit: function(component, event, helper) {
        
        //console.log("# handleSubmit");
        event.preventDefault();
         helper.setMaxLengthVals(component,event);
        var didHaveError = helper.validateReqFields(component,event);
        //console.log("# didHaveError: ", didHaveError);
        if(didHaveError == false){
            helper.validateContact(component, event);
            component.set('v.Spinner',true);
        }
        
    },
    
    goBack: function(component,event,helper){
        component.set('v.alreadyProv', false);
    },
    
    setval: function(component, event, helper){
       
        component.set('v.form.Point_of_Contact_First_Name__c',component.find('firstName').get('v.value'));
    }

})