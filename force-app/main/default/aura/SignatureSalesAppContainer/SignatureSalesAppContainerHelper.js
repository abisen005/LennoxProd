({
    handleGetUserMode: function(cmp, helper, response) {
        var state = response.getState(),
            userMode;
        if (cmp.isValid() && state === 'SUCCESS') {
            userMode = response.getReturnValue();
            cmp.set('v.userMode', userMode);
            helper.getConsoleSetting(cmp, helper, userMode);
        } else {
            var errors = response.getError();
            console.log('error', errors);
        }
    },
    
    /* Get the console setting record based on userMode
     * @param {Object} cmp component in scope
     * @param {Object} helper helper resource in scope
     * @param {String} userMode User mode based on the current user
     */
    getConsoleSetting: function(cmp, helper, userMode) {
        var action = cmp.get('c.getConsoleSetting'),
            callback = function(response) {
                var state = response.getState();
                cmp.set('v.isLoading', false);
                if(cmp.isValid() && state === 'SUCCESS') {
                    cmp.set('v.consoleSetting', response.getReturnValue());
                    console.log(cmp.get('v.consoleSetting'));
                } else {
                    var errors = response.getError();
                    alert('There was a problem: ' + errors);
                }
            };
        action.setParams({
            userMode: userMode
        });
        action.setCallback(this, callback);
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
    },
    handleGetDashboards: function(cmp, response) {
        var state = response.getState(),
            errors;
        cmp.set('v.isLoading', false);
        if (cmp.isValid() && state === 'SUCCESS') {
            cmp.set('v.dashboards', response.getReturnValue());
            cmp.set('v.showDashboards', true);
        } else {
            errors = response.getErrors();
            console.log('error', errors);
        }
    },
    handleGetReports: function(cmp, response) {
         var state = response.getState(),
            errors;
        cmp.set('v.isLoading', false);
        if (cmp.isValid() && state === 'SUCCESS') {
            cmp.set('v.reports', response.getReturnValue());
            cmp.set('v.showReports', true);
        } else {
            errors = response.getErrors();
            console.log('error', errors);
        }
    },
    shouldShowMainConsole: function(cmp, helper) {
        var showingReports = cmp.get('v.showReports'),
            showingDashboards = cmp.get('v.showDashboards'),
            showingSearchDealers = cmp.get('v.showSearchDealers'),
            showMainConsole = showingReports || showingDashboards || showingSearchDealers;
       return shouldShowMainConsole;
    }
})