({
	handleAccountChange: function(cmp, event, helper) {
        var escalationCode = cmp.get('v.account').Escalation_Code__c || '',
            newEvtMethodOptions = {
                name: 'getNewEvent',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetNewEvent
            };
        if(escalationCode.substring(0, 1) !== 'E') {
            cmp.set('v.rendered', false);
        } else {
            helper.setStatus(cmp, helper);
            helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
            cmp.set('v.isLoading', false);
        }
	},
    
    handleContactDealerPress: function(cmp, event, helper) {
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