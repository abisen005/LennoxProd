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
        
        
        setTimeout(function(){
            var getScorecardMethodOptions = {
                name: 'getOpportunityScorecard',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetOpportunityScorecard
            };
            
            helper.invokeServerAction(cmp, helper, getScorecardMethodOptions);
        }, 100);
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
    }
})