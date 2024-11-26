({
	handleAccountChange: function(cmp, event, helper) {
		var acc = cmp.get('v.account'),
            currentYear = new Date().getFullYear().toString(),
            percentToCommitment,
        	subLabel,
            NCStartDate,
            NCUTCDate,
            today,
            todayUTC,
            daysInProgram;

        if(acc.Qualifies_for_NC_Program__c === 'Currently Enrolled') {
            if(acc.NC_Load_Date__c) {
                NCStartDate = new Date(acc.NC_Load_Date__c);
                NCUTCDate = Date.UTC(NCStartDate.getFullYear(), NCStartDate.getMonth(), NCStartDate.getDate());
                today = new Date();
                todayUTC = Date.UTC(today.getFullYear(), today.getMonth(), today.getDate());
                daysInProgram = Math.floor((todayUTC - NCUTCDate) / (1000 * 60 * 60 * 24));
                cmp.set('v.daysInProgram', daysInProgram);
            }

            percentToCommitment = Math.round((acc.SAP_YTD_Sales__c / acc.NC_Commitment__c) * 100);
            subLabel = acc.NC_Commitment__c > 999 ? 'to ' + (acc.NC_Commitment__c / 1000) + 'k' : 'to ' + (acc.NC_Commitment__c / 1000);

            cmp.set('v.percentToCommitment', percentToCommitment);
            cmp.set('v.percentToCommitmentLabel', percentToCommitment + '%');
            cmp.set('v.percentToCommitmentSubLabel', subLabel);
            cmp.set('v.showUpdateConversion', daysInProgram < 120 && acc.Conversion__r);
            cmp.set('v.newAccountPlanLink', '/a0C/e?00NC0000005FsWr=' + currentYear + '&CF00NC0000005Eep4=' + encodeURIComponent(acc.Name) + '&CF00NC0000005Eep4_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);
        } else {
            cmp.set('v.rendered', false);
        }
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
        helper.invokeServerAction(cmp, helper, methodOptions);
    },

    //handleNewRetentionOppPress: function(cmp, event, helper) {
        //var navEvt = $A.get('e.force:createRecord');
        //if(navEvt) {
            //navEvt.setParams({
                //entityApiName: 'Retention_Opportunity__c'
            //});
            //navEvt.fire();
        //}
    //},
    
    handleNewRetentionOppPress: function(cmp, event, helper) {
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
    },
    
    handleNewAccountPlanPress: function(cmp, event, helper) {
        var navEvt = $A.get('e.force:createRecord');

        if(navEvt) {
            navEvt.setParams({
                entityApiName: 'Account_Planning__c'
            });

            navEvt.fire();
        }
    },
    
    handleUpdateConversionPress: function(cmp, event, helper) {
        var recordId = cmp.get('v.account').Conversion__r[0].Id;
        helper.editRecord(recordId);
    }
})