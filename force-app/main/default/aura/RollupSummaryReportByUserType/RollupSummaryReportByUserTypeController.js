({
    handleInit: function(cmp, event, helper) {
        helper.getVFPageName(cmp);
        cmp.set('v.isSf1', typeof $A.get('e.force:navigateToObjectHome') !== 'undefined');
    },
    handleTerritoryRollupPress: function(cmp, event, helper) {
        var currentYear = new Date().getFullYear(),
            rollupUrl = '/apex/' + cmp.get('v.reportVFPageName') + '?year=' + currentYear;
        helper.navigateTo(cmp, rollupUrl);
    }
})