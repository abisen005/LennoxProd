({
    handleSearchEnterPress: function(cmp, helper, query) {
        var action = cmp.get('c.searchDealers');
        cmp.set('v.dealers', []);
        cmp.set('v.isLoading', true);
        action.setParams({
            query: query
        })
        action.setCallback(this, function(response) {
            helper.handleSearchDealers(cmp, response);
        });
        $A.enqueueAction(action);
    },
    handleSearchDealers: function(cmp, response) {
        var state = response.getState();
        cmp.set('v.isLoading', false);
        if(cmp.isValid() && state === 'SUCCESS') {
            var dealers = response.getReturnValue();
            cmp.set('v.dealers', dealers);
            if(dealers.length > 0) {
                cmp.set('v.isEmpty', false);
            } else {
                cmp.set('v.isEmpty', true);
            }
            	
        } else {
            var errors = response.getError();
            alert('There was a problem: ' + errors);
        }
	}
})