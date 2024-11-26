({
    handleAccountChange: function(cmp, event, helper) {
        helper.setForecastValues(cmp, helper);
    },
    
    handleOpenModal: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    }
})