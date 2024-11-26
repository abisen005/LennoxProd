({
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
    fetchFTLTask : function(component, event, helper){
        helper.callApexAction(component, 'getFTLTasks', {})
        .then(function (response) {
            console.log('response',response);
            if(response && response.length){
                let currentDate = new Date();
                response.forEach((task, idx)=>{
                    let startDate = new Date(task.Start_Date__c);
                    let endDate = new Date(task.End_Date__c);
                    let programDate = task.Program_End_Date__c ? new Date(task.Program_End_Date__c) : null;
                    
                    if(startDate <= currentDate && endDate >= currentDate){
                        if(programDate && programDate < currentDate){
                        	component.set('v.isProgramDateNotOccured',false);
                        }
                    	component.set('v.ftlTask',task);
                	}
                });
                
            }
            
        });
    }
})