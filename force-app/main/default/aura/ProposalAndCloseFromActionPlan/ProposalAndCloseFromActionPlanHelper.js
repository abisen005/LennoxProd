({
	redirectToOpportunity : function(component, event) {
        var action = component.get("c.getActionPlanForProposalAndClose");
        action.setParams({ actionPlanId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ActionPlan",response.getReturnValue());
                var obj = component.get("v.ActionPlan");
                console.log(obj);
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Opportunity",
                        "defaultFieldValues": {
                        'Account_Plan__c' : obj.Account_Plan__c,
                        'Action_Plan__c' : obj.Id,
                        'Opportunity_Scorecard__c' : obj.Opportunity_Scorecard__c,
                        'Account_Opportunity__c' : obj.Account_Opportunity__c,
                        'AccountId' : obj.Id
                        }
                    });
                    createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire(); 
            }
        });
        $A.enqueueAction(action);
    }
})