({
	doInit : function(component, event, helper) {
        helper.component = component;
        helper.loadInitialData();
    },	
    
    handleCompleteChange  : function(component, event, helper) {
        component.set("v.ShowSaveBtn", true);
    },
    
    save  : function(component, event, helper) {
        console.log(' save');   
        helper.saveSkillData();
    },
    
    cancel  : function(component, event, helper) {
        console.log(' cancel');   
        if(component.get("v.ShowSaveBtn")){
            helper.loadInitialData();
            component.set("v.ShowSaveBtn", false);
        }
    },	

})