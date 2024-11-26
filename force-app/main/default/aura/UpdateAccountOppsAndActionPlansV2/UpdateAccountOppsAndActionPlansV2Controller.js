({
    handleIsRenderedChange: function(cmp, event, helper) {
        var isClassic = cmp.get('v.isClassic');
        var isRendered = cmp.get('v.isRendered'),
            acc, 
            methodOptions, 
            //isSf1 = typeof sforce !== 'undefined',
            isSf1 = cmp.get("v.isSf1"),
            currentYear = new Date().getFullYear().toString();

        var createRecordEvent = $A.get("e.force:createRecord");
        if(createRecordEvent === undefined){
            isSf1 = false;
        }
        
        cmp.set('v.isSf1', isSf1);
        
        if(isRendered) {
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

    handleNewAccountOppPress: function(cmp, event, helper) {
		var accountId = cmp.get('v.account').Id;
        var action = cmp.get("c.getCurrentAccountPlan");
        
        action.setParams({ accountId : accountId });
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.accountPlan",response.getReturnValue());
                var obj = cmp.get("v.accountPlan");
                var createRecordEvent = $A.get("e.force:createRecord");

                createRecordEvent.setParams({
                entityApiName: 'Account_Opportunty__c',
                    "defaultFieldValues": {
                        'Dealer_Account_Plan__c' : obj.Id,
                        'Dealer_Name__c' : accountId,
                        'Opportunity_Scorecard__c' : cmp.get("v.opportunityScorecardId")
                    }
                });

            createRecordEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    },

    handleNewActionPlanPress: function(cmp, event, helper) {
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
                    entityApiName: 'Action_Plan__c',
                    "defaultFieldValues": {
                        'Account_Plan__c' : obj.Id,
                        'Opportunity_Scorecard__c' : cmp.get("v.opportunityScorecardId")
                    }
                });

                createRecordEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    },

	handleNewAccountPlanPress: function(cmp, event, helper) {
		var appEvent = $A.get("e.c:CloseModalEvent");
		var currentYear = new Date().getFullYear().toString();
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
                    entityApiName: 'Account_Planning__c',
                    "defaultFieldValues": {
                        'Dealer__c' : accountId,
                        'Account_Plan_Year__c': currentYear,
                        'Opportunity_Scorecard__c' : cmp.get("v.opportunityScorecardId")
                    }
                });

                createRecordEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
        appEvent.fire();
    }
})