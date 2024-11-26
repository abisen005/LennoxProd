({
	handleGetOpenRetentionOpportunities: function(cmp, helper, response) {
        cmp.set('v.isLoading', false);
        cmp.set('v.retentionOpps', response);
    },

    handleGetCurrentAccountPlan: function(cmp, helper, response) {
        var methodOptions;

        if(response) {
            methodOptions = methodOptions = {
                name: 'getOpenRetentionOpportunities',
                params: {
                    accountPlanId: response.Id
                },
                callback: helper.handleGetOpenRetentionOpportunities
            };

            cmp.set('v.accountPlan', response);
            cmp.set('v.newRetentionOppLink', '/a0K/e?CF00NC0000005Eeoc=' + encodeURIComponent(response.Name) + '&CF00NC0000005Eeoc_lkid=' + response.Id + '&retURL=%2F' + cmp.get('v.account').Id);
            helper.invokeServerAction(cmp, helper, methodOptions);
        } else {
            cmp.set('v.isLoading', false);
        }
    },

    handleServerActionError: function(cmp, helper, actionName, error) {
        var modalAlert = $A.get('e.c:ModalAlert'),
            errorMsg;

        if(error[0].message) {
            errorMsg = error[0].message;
        } else {
            for(prop in error[0].fieldErrors) {
                errorMsg = error[0].fieldErrors[prop][0].message;
                break;
            }
        }

        modalAlert.setParams({ 
            alertType: 'error',
            alertMessage: errorMsg || 'There was a problem.'
        });
        
        cmp.set('v.isLoading', false);
        modalAlert.fire();
    }
})