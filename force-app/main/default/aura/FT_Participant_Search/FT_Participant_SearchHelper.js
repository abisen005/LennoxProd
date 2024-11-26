({
	getMatchingRecords : function(component, event, helper) {
		var fieldTrialId = component.get('v.recordId');
        
        var action = component.get('c.getMatchingParticipantApplications');
        
        action.setParams({
            strFieldTrialId: fieldTrialId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var responseResult = response.getReturnValue();
                
                if(responseResult == 'noRecords'){
                    component.set('v.matchingApplications',[]);
                }
                else{
                    component.set('v.matchingApplications',responseResult);
                }
            }
            
            component.set('v.showSpinner',false);
        });
        
        $A.enqueueAction(action);
	},
    
    saveFieldTrialContactRecords : function(component, event, helper) {
        
		var fieldTrialId = component.get('v.recordId');
        const applicationDetails = JSON.parse(JSON.stringify(component.get('v.matchingApplications')));
        
        var action = component.get('c.createFieldTrialContacts');
        
        action.setParams({
            strFieldTrialId: fieldTrialId,
            lstApplicationDetails: applicationDetails
        });
        
        component.set('v.showSpinner',true);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var responseResult = response.getReturnValue();
                
                this.showToastMessage(component, 'success', 'Success', 'Records saved successfully.');
                
                this.getMatchingRecords(component, event, helper);
            }
            else{
                this.showToastMessage(component, 'error', 'Error', 'Something went wrong.');
                component.set('v.showSpinner',false);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    validateInput: function(component, event, helper) {
        component.set('v.showSpinner', true);
        var matchingApplications = component.get("v.matchingApplications");
        var isSuccess = true;
            
        for(var count = 0; count < matchingApplications.length; count++){
            //if(matchingApplications[count].numberOfParticipantsRequired && 
               //matchingApplications[count].numberOfParticipantsRequired != null && 
               //matchingApplications[count].numberOfParticipantsRequired != 0){
                
                if(matchingApplications[count].numberOfParticipants < matchingApplications[count].numberOfParticipantsRequired){
                    isSuccess = false;
                    break;
                }
            /*}
            else{
                isSuccess = false;
                break;
            }*/
        }
        
        return isSuccess;
    },
    
    showToastMessage: function (component, type, titleText, message) {
        var resultsToast = $A.get('e.force:showToast');
        resultsToast.setParams({
            'type': type,
            'title': titleText,
            'message': message
        });
        resultsToast.fire();
    }
})