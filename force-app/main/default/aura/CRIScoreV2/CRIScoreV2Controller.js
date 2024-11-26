({
    handleInit: function(cmp, event, helper) {

        // This timeout has been added so that it does not execute before the attributes of the parent component are 
        // loaded.
        setTimeout(() => {

            var methodOptions = {
                name: 'getRetentionHistoryData',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetRetentionHistoryData
            };
            
            helper.invokeServerAction(cmp, helper, methodOptions);
        }, 1000);
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
    },

    handleNewRetentionOppPress: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', false);
        var accountId = cmp.get('v.account').Id;

        var action = cmp.get("c.getCurrentAccountPlan");
        action.setParams({ accountId : accountId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.accountPlan",response.getReturnValue());
                var obj = cmp.get("v.accountPlan");
                var createRecordEvent = $A.get('e.force:createRecord');
                createRecordEvent.setParams({
                    entityApiName: 'Retention_Opportunity__c',
                    "defaultFieldValues": {
                     'Dealer_Account_Plan__c' : obj.Id
                    }
                });
                createRecordEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    }
})