({
	handleAccountChange: function(cmp, event, helper) {
		var acc = cmp.get('v.account'),
            currentYear = new Date().getFullYear().toString();
        cmp.set('v.isLoading', false);
        cmp.set('v.newAccountPlanLink', '/a0C/e?00NC0000005FsWr=' + currentYear + '&CF00NC0000005Eep4=' + encodeURIComponent(acc.Name) + '&CF00NC0000005Eep4_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);
        if(acc.Submit_for_NC_Program__c && !acc.NC_Commitment__c && !acc.NC_Load_Date__c) cmp.set('v.isSubmitted', true);
        if(acc.Qualifies_for_NC_Program__c === 'No') cmp.set('v.rendered', false);
	},
    handleOpenModal: function(cmp, event, helper) {
        var account = cmp.get('v.account'),
            methodOptions = {
                name: 'getCurrentAccountPlan',
                params: {
                    accountId: account.Id
                },
                callback: helper.handleGetCurrentAccountPlan
            };
        cmp.set('v.isModalOpen', true);
        cmp.set('v.isLoading', true);
        if(account.Qualifies_for_NC_Program__c === 'Currently Enrolled') {
            helper.invokeServerAction(cmp, helper, methodOptions);
        }
    },
    handleSubmitForEnrollment: function(cmp, event, helper) {
        var account = cmp.get('v.account'),
        options = {
            name: 'upsertAccount',
            params: {
                acc: account
            },
            callback: helper.handleUpsertAccount
        };
        account.Submit_for_NC_Program__c = true;
        cmp.set('v.isLoading', true);
        helper.invokeServerAction(cmp, helper, options);
    },
    handleNewRetentionOppPress: function(cmp, event, helper) {
        var navEvt = $A.get('e.force:createRecord');
        if(navEvt) {
            navEvt.setParams({
                entityApiName: 'Retention_Opportunity__c'
            });
            navEvt.fire();
        }
    },
    handleNewAccountPlanPress: function(cmp, event, helper) {
        var navEvt = $A.get('e.force:createRecord');
        if(navEvt) {
            navEvt.setParams({
                entityApiName: 'Account_Planning__c'
            });
            navEvt.fire();
        }
    }
})