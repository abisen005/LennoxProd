({
	handleInit: function handleInit(cmp, evt, h) {
		var userId = cmp.get('v.userId');
		if (userId) {
			h.getUser(cmp);
		}
		h.requestCoachingInfo();
        console.log(cmp.get('v.CoachingInfo'));
	},
	handleUserIdChange: function handleUserIdChange(cmp, evt, h) {
		h.getUser(cmp);
	},
	handleToggleShowCompletedAssignments: function handleToggleShowCompletedAssignments(cmp, evt, h) {
		evt.preventDefault();
		var showCompletedAssignments = cmp.get('v.showCompletedAssignments');
		cmp.set('v.showCompletedAssignments', !showCompletedAssignments);
	},
	handleToggleShowNewSessions: function handleToggleShowNewSessions(cmp, evt, h) {
		evt.preventDefault();
		var showNewSessions = cmp.get('v.showNewSessions');
        console.log('@@@@@@@@@@@@@showNewSessions',showNewSessions);
		cmp.set('v.showNewSessions', !showNewSessions);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		console.log('coachingInfo: ', coachingInfo);
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
		}
	}
});