({

init : function(component) {
       
       var flow = component.find('flowData');
       flow.startFlow('Resource_Case');
    },

    
    clickAdd: function(component, event, helper) {
     var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Success",
            "message": "Your case is created"
        });
        resultsToast.fire();
   var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
    


})