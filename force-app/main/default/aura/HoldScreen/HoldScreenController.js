({
	doInit : function(component, event, helper) {
        
        component.set("v.displayLoader",true);
        var availableActions = ["NEXT"];
        component.set("v.availableActions",availableActions);
        
        setTimeout(function(){component.set("v.errorMsg",'Case is not modified.');
                              helper.displayErrorMessage(component, event, helper);}, 10000);
        
        helper.getCaseInfo(component, event, helper);        
	}
})