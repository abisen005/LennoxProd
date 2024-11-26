({
    handleInit: function(cmp, event, helper) {
        var isSf1 = cmp.get('v.isSf1') || typeof sforce !== 'undefined';
        var createRecordEvent = $A.get('e.force:createRecord');
        if(createRecordEvent === null || createRecordEvent == undefined){
            isSf1 = false;
        }else{
            isSf1 = true;
        }
        cmp.set('v.isSf1', isSf1);
    },
	handleAccountChange: function(cmp, event, helper) {
        var account = cmp.get('v.account'),
            getScorecardMethodOptions = {
                name: 'getOpportunityScorecard',
                params: {
                    accountId: account.Id
                },
                callback: helper.handleGetOpportunityScorecard
            },
            scorecardLink = '/a06/e?CF00N80000002nJnk=' + encodeURIComponent(account.Name) + '&CF00N80000002nJnk_lkid=' + account.Id + '&retURL=%2F' + account.Id;

        cmp.set('v.newScorecardLink', scorecardLink);
        helper.invokeServerAction(cmp, helper, getScorecardMethodOptions);
    },
    
    handleOpenModal: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    },

    handlecreateScorecardPress: function(cmp, event, helper) {
        var account = cmp.get('v.account');
        var createRecordEvent = $A.get('e.force:createRecord');
        
        createRecordEvent.setParams({
                    entityApiName: 'Scorecard__c',
                    "defaultFieldValues": {
                     'Account__c' : account.Id
                    }
                });
        
        createRecordEvent.fire();
    },
    
    handleUpdateScorecard: function(cmp, event, helper) {
        var scorecard = cmp.get('v.scorecard'),
            editRecordEvent = $A.get('e.force:editRecord');

        editRecordEvent.setParams({
            recordId: scorecard.Id
        });

        editRecordEvent.fire();
    }
})