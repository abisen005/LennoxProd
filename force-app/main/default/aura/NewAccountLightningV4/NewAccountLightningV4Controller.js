({
    handleCancel : function(component, event, helper) {
        component.set('v.showSpinner', true);
        window.location='/lightning/o/Account/list?filterName=Recent';
    },

    handleCreate : function(component, event, helper) {
        component.set('v.showSpinner', true);
        let reqJson = {
            name        : component.get("v.name"),
            phone       : component.get("v.phone"),
            website     : component.get("v.website"),
            fax         : component.get("v.fax")
        }
        let reqAccountData = JSON.stringify(reqJson);
        let placeDetails = component.get("v.placeDetails");
        if (!placeDetails) {
            helper.showToast(component, 'error', 'Error', 'Please complete all required fields.');
            component.set('v.showSpinner', false);
            return;
        }
        let reqPlaceDetails = JSON.stringify(placeDetails);
        let action = component.get("c.createAccount");
        action.setParams({newAccountDataJson: reqAccountData,placeDetailsJson:reqPlaceDetails});
        action.setCallback(this, function(response){
            component.set('v.showSpinner', false);
            let state = response.getState();
            if (state === "SUCCESS") {
                let resBody = response.getReturnValue();
                if (resBody.includes('SUCCESS')) {
                    let accountId = resBody.split(':').pop();
                    window.location = '/' + accountId;
                } else {
                    helper.showToast(component, 'error', 'Error', resBody);
                }
            } else {
                helper.showToast(component, 'error', 'Error', response.getErrors()[0].message);
            }
        });

        $A.enqueueAction(action);
    }
})