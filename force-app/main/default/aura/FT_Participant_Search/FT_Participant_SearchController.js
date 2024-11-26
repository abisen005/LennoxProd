({
	getMatchingApplications : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        //get parameter from state
        var recordId = myPageRef.state.c__recordId;
        component.set("v.recordId", recordId);  
        helper.getMatchingRecords(component, event, helper);
	},
    
    createFieldTrialContact : function(component, event, helper) {    
		// Validate each number of participant entered    
        if(helper.validateInput(component, event, helper)){
        	helper.saveFieldTrialContactRecords(component, event, helper);
        }
        else{
            helper.showToastMessage(component, 'warning', 'Warning', 'Please enter valid number of participants.');
            component.set('v.showSpinner', false);
        }
	}, 
    
})