({
    getVFPageName : function(cmp) {

        var action = cmp.get('c.getVFPageName');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.reportVFPageName', result);
                cmp.set('v.isLoading', false); 
            } else {
                console.log('Error', response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    navigateTo: function(cmp, url, useChildWindow) {
        var urlEvent = $A.get('e.force:navigateToURL');
        if(cmp.get('v.isSf1')) {
            if(useChildWindow) {
                window.open(url);
            } else {
                urlEvent.setParams({url: url, isredirect: true});
                urlEvent.fire();
            }
        } else {
            document.location = url;
        }
    }
})