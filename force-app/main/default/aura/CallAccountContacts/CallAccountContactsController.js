({
	handledRenderedChange: function(cmp, event, helper) {
        var acc = cmp.get('v.account');
        if(cmp.get('v.rendered') && acc) {
            var action = cmp.get('c.getAccountContacts');
            cmp.set('v.isLoading', true);
            action.setParams({accountId: acc.Id});
            action.setCallback(this, function(response) {
                var state = response.getState();
                cmp.set('v.isLoading', false);
                if(cmp.isValid() && state === 'SUCCESS') {
                    cmp.set('v.contacts', response.getReturnValue());
                } else if(cmp.isValid() && state === 'ERROR') {
                    var error = response.getError();
                    var modalAlert = $A.get('e.c:ModalAlert'),
                        errorMsg;
                    errorMsg = error[0].message;
                    modalAlert.setParams({
                        alertType: 'error',
                        alertMessage: errorMsg || 'There was a problem.'
                    });
                    modalAlert.fire();
                }
            });
            $A.enqueueAction(action);
        }
	},
    handlePhonePress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL'),
            phone = event.getSource().get('v.param');
        urlEvent.setParams({
            'url': 'tel:' + phone
        });
        urlEvent.fire();
    }
})