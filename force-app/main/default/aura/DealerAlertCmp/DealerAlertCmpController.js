({
	doInIt : function(component, event, helper) {
        console.log('IN DOINIT');
		var recordId = component.get("v.recordId");
        
        helper.callApexAction(component, 'getOnloadData', {})
                .then(function (result) {
                    console.log('customer@@@@', result);
                    if (result.isSuccess) {
                        component.set("v.programForm", result.data.programForm);
                        component.set("v.startDateTime", result.data.startDateTime);
                        
                        component.set("v.endDateTime", result.data.endDateTime);
                        component.set("v.subjectString", result.data.taskSubject);
                        component.set("v.FTLTaskId", result.data.taskId);

                        console.log('customer@@@@', result);
                    }
                    else {
                        component.set("v.errorMsg", result.message);
                    }
                });
	},
    
    goToFTLTask : function(component,event, helper) {
        var recordId = component.get('v.FTLTaskId');
        var navEvt;
        navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParam("recordId", recordId);
        navEvt.fire();

    } 
})