({
	handleInit: function(cmp, event, helper) {
        var methodOptions = {
            name: 'getRetentionHistoryData',
            params: {
                accountId: cmp.get('v.accountId')
            },
            callback: helper.handleGetRetentionHistoryData
        };
		helper.invokeServerAction(cmp, helper, methodOptions);
	},
    handleOpenModal: function(cmp, event, helper) {
        var acc =  cmp.get('v.account'),
            currentYear = new Date().getFullYear().toString(),
			methodOptions = {
                name: 'getCurrentAccountPlan',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetCurrentAccountPlan
            };
        cmp.set('v.isModalOpen', true);
        cmp.set('v.isLoading', true);
        cmp.set('v.newAccountPlanLink', '/a0C/e?00NC0000005FsWr=' + currentYear + '&CF00NC0000005Eep4=' + encodeURIComponent(acc.Name) + '&CF00NC0000005Eep4_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);
		helper.invokeServerAction(cmp, helper, methodOptions);
    },
    handleNewAccountPlanPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            entityApiName: 'Account_Planning__c'
        });
        createRecordEvent.fire();
    }
})