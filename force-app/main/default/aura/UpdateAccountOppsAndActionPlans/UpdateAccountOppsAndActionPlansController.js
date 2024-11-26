({
    handleIsRenderedChange: function(cmp, event, helper) {
        var isRendered = cmp.get('v.isRendered'),
            acc, 
            methodOptions, 
            isSf1 = typeof sforce !== 'undefined',
            currentYear = new Date().getFullYear().toString();
        cmp.set('v.isSf1', isSf1);
        if(isRendered) {
            console.log('am i logged?');
            acc =  cmp.get('v.account');
            methodOptions = {
                name: 'getCurrentAccountPlan',
                params: {
                    accountId: acc.Id
                },
                callback: helper.handleGetCurrentAccountPlan
            };
            cmp.set('v.newAccountPlanLink', '/a0C/e?00NC0000005FsWr=' + currentYear + '&CF00NC0000005Eep4=' + encodeURIComponent(acc.Name) + '&CF00NC0000005Eep4_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);
            cmp.set('v.isLoading', true);
            helper.invokeServerAction(cmp, helper, methodOptions);
        } else {
            cmp.set('v.accountPlan', null);
            cmp.set('v.accountOpps', []);
            cmp.set('v.actionPlans', []);
        }
        
    },
    handleAccountOppUpdatePress: function(cmp, event, helper) {
        var recordId = event.getSource().get('v.param');
        helper.editRecord(recordId);
    },
    handleActionPlanUpdatePress: function(cmp, event, helper) {
        var recordId = event.getSource().get('v.param');
        helper.editRecord(recordId);
    },
    handleNewAccountPlanPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            entityApiName: 'Account_Planning__c'
        });
        createRecordEvent.fire();
    },
    handleNewAccountOppPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            entityApiName: 'Account_Opportunty__c'
        });
        createRecordEvent.fire();
    },
    handleNewActionPlanPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            entityApiName: 'Action_Plan__c'
        });
        createRecordEvent.fire();
    },
})