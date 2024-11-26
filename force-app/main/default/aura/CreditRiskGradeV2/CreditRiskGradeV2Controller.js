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
		var sdt = cmp.get('v.newEvent.StartDateTime');
        
        if(sdt =='' || sdt == null || sdt == 'undefined'){
            cmp.set("v.showEMOne","true");
        }

	    var sub = cmp.get('v.newEvent.Subject');
        
        if(sub =='' || sub == null || sub == 'undefined'){
            cmp.set("v.showEMTwo","true");
        }

        if(sdt !='' && sdt != null && sdt != 'undefined' && sub !='' && sub != null && sub != 'undefined'){
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
        }
    },
    
    handleCloseModalPress: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', false);
    },

    changeOne: function(cmp, event, helper) {
        cmp.set("v.showEMOne","false");
    },

    changeTwo: function(cmp, event, helper) {
        cmp.set("v.showEMTwo","false");
    }
})