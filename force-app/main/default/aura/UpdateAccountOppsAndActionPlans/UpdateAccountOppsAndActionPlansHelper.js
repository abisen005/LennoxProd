({
	handleGetCurrentAccountPlan: function(cmp, helper, response) {
        var getAccountOppsMethodOptions,
            getActionPlansMethodOptions;
        if(response) {
            getAccountOppsMethodOptions = {
                name: 'getAccountOpps',
                params: {
                    accountPlanId: response.Id
                },
                callback: helper.handleGetAccountOpps
            };
            getActionPlansMethodOptions = {
                name: 'getActionPlans',
                params: {
                    accountPlanId: response.Id
                },
                callback: helper.handleGetActionPlans
            };
            cmp.set('v.accountPlan', response);
            cmp.set('v.newAccountOppLink', '/a0A/e?CF00NC0000005Eeoa=' + encodeURIComponent(response.Name) + '&CF00NC0000005Eeoa_lkid=' + response.Id + '&retURL=%2F' + response.Id);
            cmp.set('v.newActionPlanLink', '/a0J/e?CF00NC0000005Eeob=' + encodeURIComponent(response.Name) + '&CF00NC0000005Eeob_lkid=' + response.Id + '&retURL=%2F' + response.Id);
            
            helper.invokeServerAction(cmp, helper, getActionPlansMethodOptions);
            helper.invokeServerAction(cmp, helper, getAccountOppsMethodOptions);
        } else {
            cmp.set('v.isLoading', false);
        }
    },
    handleGetAccountOpps: function(cmp, helper, response) {
        console.log('handleGetAccountOpps', response);
        cmp.set('v.isLoading', false);
        cmp.set('v.accountOpps', response);
    },
    handleGetActionPlans: function(cmp, helper, response) {
        console.log('handleGetActionPlans', response);
        cmp.set('v.isLoading', false);
        cmp.set('v.actionPlans', response);
    },
    invokeServerAction: function(cmp, helper, methodOptions) {
        var action = cmp.get('c.' + methodOptions.name);
        if(methodOptions.params) action.setParams(methodOptions.params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === 'SUCCESS') {
                methodOptions.callback(cmp, helper, response.getReturnValue());
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response);
                console.log(response.getError());
                helper.handleServerActionError(cmp, helper, methodOptions.name, response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    handleServerActionError: function(cmp, helper, actionName, error) {},
    editRecord: function(recordId) {
    	var editRecordEvent = $A.get('e.force:editRecord');
        editRecordEvent.setParams({
            recordId: recordId
        });
        editRecordEvent.fire();
	}
})