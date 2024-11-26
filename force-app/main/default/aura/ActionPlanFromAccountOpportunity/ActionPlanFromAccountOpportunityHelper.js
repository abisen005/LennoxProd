({
    redirectToActionPlan : function(component, event) {
        var action = component.get("c.getAccountForActionPlan");
        action.setParams({ accOppId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountOpportunty",response.getReturnValue());
                var obj = component.get("v.AccountOpportunty");
                if(obj.isApproved__c){
                    var actionType = '';
                    if(obj.Proposal_Required__c == 'Yes'){
                        actionType = 'Create Proposal';
                    }
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Action_Plan__c",
                        "defaultFieldValues": {
                        'Action_Status__c' : obj.Opportunity_Status__c,
                        'Action_Notes__c' : obj.Opportunity_Notes__c,
                            'Action__c' : obj.Opportunity_Type__c,
                            'Action_Type__c' : actionType,
                            'Account_Opportunity__c' : obj.Id,
                            'Opportunity_Scorecard__c' : obj.Opportunity_Scorecard__c,
                            'Account_Plan__c' : obj.Dealer_Account_Plan__c 
                        }
                    });
                    createRecordEvent.fire();
                } else {
                    //$A.get("e.force:closeQuickAction").fire();
                    //window.alert('The Account Opportunity must be approved by the DM prior to creating a new Action Plan.');
                    component.set("v.errorTitle", "Cannot create a new Action Plan at this time.")
                    component.set("v.errorMessage", "The Account Opportunity must be approved by the DM prior to creating a new Action Plan.")
                }
            }
        });
        $A.enqueueAction(action);
    }
})