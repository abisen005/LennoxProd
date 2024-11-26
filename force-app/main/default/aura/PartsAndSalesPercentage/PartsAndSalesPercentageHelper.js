({
	setStatus: function(cmp, helper) {
		var val = cmp.get('v.account').Parts_YTD_Sales_of_Total_YTD_Sales__c,
            status;
        if(val > 20) {
            status = 'success';
        } else if(val >= 10) {
            status = 'warning';
        } else {
            status = 'error';
        }
        cmp.set('v.status', status);
	}
})