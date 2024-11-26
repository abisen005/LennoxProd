({
	doInit : function(component, event, helper) {
		helper.showSpinner(component, event, helper);
        var recordId = component.get('v.recordId');
        console.log('recordId', recordId);
        if(recordId){
            helper.callApexAction(component,
                                  'fetchRelatedListObjects',
                { recordId: recordId}).then(function (result) {
                console.log('metadata@@@@', result);
                if (result.isSuccess) {
                    component.set('v.recordId', recordId);
                    component.set("v.metaData", result.data);
                    helper.hideSpinner(component, event, helper);
                }
                else {
                    helper.hideSpinner(component, event, helper);
                    helper.showMsg(component, event, 'Error', 'error', result.msg );
                }
            });
        }
	}
})