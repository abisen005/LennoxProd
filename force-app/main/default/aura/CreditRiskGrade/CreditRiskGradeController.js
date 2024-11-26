({
	handleAccountChange: function(cmp, event, helper) {
		var acc = cmp.get('v.account'),
            newEvtMethodOptions = {
                name: 'getNewEvent',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetNewEvent
            };
        if(acc.SAP_Customer_Group_Id__c !== '04' && (!acc.Risk_Grade__c || acc.Risk_Grade__c === '')) {
            cmp.set('v.rendered', false);
        } else {
            cmp.set('v.riskGrade', acc.Risk_Grade__c);
            helper.setStatus(cmp, helper, acc.Risk_Grade__c);
            helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
            cmp.set('v.isLoading', false);
        }
	},
    
    handlePlanCallPress: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    },
    
    handleSavePress: function(cmp, event, helper) {
        if(helper.validateFields(cmp)) {
            var newEvent = cmp.get('v.newEvent');
            newEvent.whatId = cmp.get('v.account').Id;
            cmp.set('v.newEvent', newEvent);
            cmp.set('v.isLoading', true);
            var methodOptions = {
                name: 'newEvent',
                params: {
                    evt: JSON.stringify(cmp.get('v.newEvent'))
                },
                callback: helper.handleNewEvent
            };
            helper.invokeServerAction(cmp, helper, methodOptions);
        } else {
            console.log('there are errors');
        }
    },
    
    handleCloseModalPress: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', false);
    }
    
})