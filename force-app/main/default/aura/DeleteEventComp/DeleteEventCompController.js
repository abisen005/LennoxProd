({
    delete : function(component, event, helper) {
    var recordId = component.get('v.recordId');
    
    console.log("v.title", window.location.href);
    helper.callApexAction(component, 'deleteEvt', {evtId: recordId})
	.then(function (result) {
    console.log('result'+result);
    if(result){
        console.log('test ==',window.location.href.includes(recordId));
        
        if(window.location.href.includes(recordId)){
            console.log('test == On Event Page');
            
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": result,
                "slideDevName": "related"
            });
            navEvt.fire();
           // location.reload();
            //$A.get('e.force:refreshView').fire();
           // window.history.back();
           // $A.get("e.force:closeQuickAction").fire(); 
        }else{
            console.log('test == On other Page');
            location.reload();
            //setTimeout(()=>{ let quickActionClose = $A.get("e.force:closeQuickAction"); quickActionClose.fire(); },1000);
           // $A.enqueueAction('c.close');
        }
    }else{
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: 'Error While Deleting the Record',
            type: 'error'
        });
        toastEvent.fire();
    }
});
},
    close : function(component, event, helper) {
        console.log('Test --- Close');
        $A.get("e.force:closeQuickAction").fire();    
    }    
})