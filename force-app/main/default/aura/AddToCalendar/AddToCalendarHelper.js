({
    getEventRecord : function(component, event, helper) {
        var action = component.get('c.getEventRecord');
        action.setParams({ eventId: component.get('v.recordId') });
        action.setCallback(this, getEventRecordCallback);
        $A.enqueueAction(action);
        
        function getEventRecordCallback(response) {
            var data = response.getReturnValue()
            console.log('ersgf ',data.evt);
            console.log('ersgf ',data.evt.Added_to_Calendar__c);
            component.set('v.redirectURL', data.redirectURL);
            
            if(!data.evt.Added_to_Calendar__c){
                component.set('v.confirmationModel', true);
            }
          
        }
    }
})