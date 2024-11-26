({
	onButtonPressed: function(cmp, event, helper) {
       // Figure out which action was called
       var actionClicked = event.getSource().getLocalId();
    
       // Call that action
       var navigate = cmp.getEvent("navigateFlowEvent");
       navigate.setParam("action", "NEXT");
       navigate.fire();
    }
})