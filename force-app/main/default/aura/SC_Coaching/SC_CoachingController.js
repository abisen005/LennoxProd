({
	handleInit: function handleInit(cmp, e, h) {
		h.requestCoachingInfo();
        window.setTimeout(function () {
            var tabCmp = cmp.find('c:SC_MyCoaching');
            h.toggleTabCmp(cmp, tabCmp);
        }, 1000);

	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.isLoading', false);
			cmp.set('v.coachingInfo', coachingInfo);
		}
	},
	handleInitiativeSelected: function handleInitiativeSelected(cmp, evt, h) {
		var label = evt.getParam('initiativeName'),
		    initId = evt.getParam('initiativeId');
		evt.stopPropagation();
		h.navigateToInitiative(initId, label);
	},
	handleTabSelect: function handleTabSelect(cmp, evt, h) {
		var tabCmp = evt.detail.selectedTab;
		h.toggleTabCmp(cmp, tabCmp);
	}
});