({
	 refreshP: function(component) {
          var action = component.get('c.getHighPriorityList');

          action.setCallback(this, function(response) {         
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
              //set response value in wrapperList attribute on component.
              component.set('v.highPriorityList', response.getReturnValue());              
            }
          });
        $A.enqueueAction(action);
     },
    
     navToR: function(component, url) {     
         var urlEvent = $A.get("e.force:navigateToURL");
         if(urlEvent) {
             urlEvent.setParams({
                 "url": url
             });
             
             urlEvent.fire();
         } else {
             window.location = url
         }
     },
})