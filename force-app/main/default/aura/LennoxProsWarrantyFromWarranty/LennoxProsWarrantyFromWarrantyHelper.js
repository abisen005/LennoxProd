({
	redirectToLennoxpros : function(component, event) {
        var action = component.get("c.getLennoxProsWarrantyForWarranty");
        action.setParams({ warrantyId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Warranty",response.getReturnValue());
                var customerNumber = component.get("v.Warranty").Customer_Number__c;
                var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": 'https://www.lennoxpros.com/#=' + customerNumber
                    });
                urlEvent.fire();    
               $A.get("e.force:closeQuickAction").fire();  
            }
        });
        $A.enqueueAction(action);
    }
})