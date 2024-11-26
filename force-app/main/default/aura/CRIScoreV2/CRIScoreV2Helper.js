({
    handleServerActionError: function(cmp, helper, actionName, error) {
        console.log(actionName, error);
    },

    handleGetRetentionHistoryData: function(cmp, helper, response) {
        var currentScore = parseInt(response.primaryValue) || null,
            previousScore = parseInt(response.secondaryValue) || null,
            status, secondaryStatus;

        if(currentScore) {
            cmp.set('v.currentCRIScore', currentScore);
            if(currentScore > 40) {
                status = 'success';
            } else if(currentScore > 20) {
                status = 'warning';
            } else {
                status = 'error';
            }
        }

        if(previousScore) {
            cmp.set('v.previousCRIScore', previousScore);

            if(cmp.get('v.previousCRIScore') < cmp.get('v.currentCRIScore')) {
                secondaryStatus = 'success';
                cmp.set('v.CRIScoreChange', (cmp.get('v.currentCRIScore') - cmp.get('v.previousCRIScore')));
            } else if (cmp.get('v.previousCRIScore') === cmp.get('v.currentCRIScore')) {
                secondaryStatus = 'warning';
            } else {
                secondaryStatus = 'error';
                cmp.set('v.CRIScoreChange', (cmp.get('v.currentCRIScore') - cmp.get('v.previousCRIScore')) * -1);
            }
        } else {
            secondaryStatus = 'warning';
            cmp.set('v.missingComparisonCRI', true);
            cmp.set('v.CRIScoreChange', 0);
        }
        
        cmp.set('v.status', status);
        cmp.set('v.secondaryStatus', secondaryStatus);
    },

    handleGetOpenRetentionOpportunities: function(cmp, helper, response) {
        cmp.set('v.isLoading', false);
        cmp.set('v.retentionOpps', response);
    },

    handleGetCurrentAccountPlan: function(cmp, helper, response) {
        var methodOptions;
        if(response) {
            methodOptions = {
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
    }
})