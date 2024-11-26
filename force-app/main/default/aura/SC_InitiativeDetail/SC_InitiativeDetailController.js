({
	handleInit: function handleInit(cmp, e, h) {
		var initId = cmp.get('v.initiativeId');
		h.requestCoachingInfo();
		if (initId) h.getInitiative(cmp);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
		}
	},
	handleInitiativeIdChange: function handleInitiativeIdChange(cmp, e, h) {
		h.getInitiative(cmp);
	},
	handleViewDashboardPress: function handleViewDashboardPress(cmp, e, h) {
		h.navigateToDashboard(cmp);
	},
	handleCoachPress: function handleCoachPress(cmp, evt, h) {
		h.startCoaching(cmp);
	}
});