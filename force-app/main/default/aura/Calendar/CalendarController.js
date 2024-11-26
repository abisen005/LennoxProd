({
	doInit : function(component, event, helper) {
		setTimeout(()=>{ let quickActionClose = $A.get("e.force:closeQuickAction"); quickActionClose.fire(); },1000);
	}
})