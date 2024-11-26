({
	doInIt : function(component, event, helper) {
        console.log('IN DOINIT');
		var recordId = component.get("v.recordId");
        
        helper.callApexAction(component, 'getOnloadData', {strRecordId:recordId})
                .then(function (result) {
                    if (result.isSuccess) {
                        component.set("v.pagedata", result);
                        console.log('customer@@@@', result);
                    }
                    else {
                        component.set("v.errorMsg", result.message);
                    }
                });
	}
})