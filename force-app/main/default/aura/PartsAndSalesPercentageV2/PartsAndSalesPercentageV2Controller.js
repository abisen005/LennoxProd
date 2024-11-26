({
	handleAccountChange: function(cmp, event, helper) {
        var acc = cmp.get('v.account');

		cmp.set('v.chartLabel', (acc.Parts_YTD_Sales_of_Total_YTD_Sales__c || 0).toFixed(0) + '%');
        helper.setStatus(cmp, helper);
    },
    
    handleOpenModal: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    }
})