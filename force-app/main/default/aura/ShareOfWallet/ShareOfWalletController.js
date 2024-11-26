({
	handleInit: function(cmp, event, helper) {
        var getScorecardMethodOptions = {
            name: 'getOpportunityScorecard',
            params: {
                accountId: cmp.get('v.accountId')
            },
            callback: helper.handleGetOpportunityScorecard
        };
        helper.invokeServerAction(cmp, helper, getScorecardMethodOptions);
	},
    handleOpenModal: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    },
    handleUpdateScorecardPress: function(cmp, event, helper) {
        var editRecordEvent = $A.get('e.force:editRecord');
        editRecordEvent.setParams({
            recordId: cmp.get('v.scorecard').Id
        });
        editRecordEvent.fire();
    }
})