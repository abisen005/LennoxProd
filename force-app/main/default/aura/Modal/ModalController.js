({
    closeModal: function(cmp, event, helper) {
        cmp.set('v.isOpen', false);
        cmp.set('v.hasAlert', false);
        cmp.set('v.alertType', null);
        cmp.set('v.alertMessage', null);
    },
    handleModalAlert: function(cmp, event, helper) {
        var alertType = event.getParam('alertType'),
            alertMessage = event.getParam('alertMessage');
        if(cmp.get('v.isOpen')) {
            cmp.set('v.hasAlert', true);
            cmp.set('v.alertType', alertType);
            cmp.set('v.alertMessage', alertMessage);
        }
    },
    handleCloseAlert: function(cmp, event, helper) {
        if(cmp.get('v.isOpen')) {
            cmp.set('v.hasAlert', false);
            cmp.set('v.alertType', null);
            cmp.set('v.alertMessage', null);
        }
    }
})