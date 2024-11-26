({
	handleInit : function(component, event, helper) {
		console.log('smp idsfl0', component.get('v.recordId'));
        helper.getEventRecord(component, event, helper);
    },
    closeConfirmationModel : function(component, event, helper){
        component.set('v.confirmationModel', false);
    },
    addToCalendar : function(component, event, helper){
        var eventId = component.get('v.recordId');
        var selectedItem = event.currentTarget;
        var addtocal = selectedItem.dataset.addtocal;
        console.log('addtocal'+addtocal);
        
        var action = component.get('c.addtoCalendar');
        action.setParams({ eventId: eventId });
        action.setCallback(this, addtoCalendarCallback);
        $A.enqueueAction(action);
        
        function addtoCalendarCallback(response) {
            console.log('test === ', response.getReturnValue()); 
        }
        
        component.set('v.confirmationModel', false);
        if(addtocal == "true"){
            window.open(component.get('v.redirectURL'));
        }else{
            console.log('Dismiss Reminder');
        }
        
    }

})