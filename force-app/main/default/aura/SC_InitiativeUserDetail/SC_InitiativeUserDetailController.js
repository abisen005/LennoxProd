({
	handleInit: function handleInit(cmp, evt, h) {
		var init = cmp.get('v.initiativeId'),
		    isCoach = cmp.get('v.isCoach');
		if (init) {
			h.getInitiative(cmp);
			if (!isCoach) h.getInitiativeSkills(cmp);
		}
		h.requestCoachingInfo();
	},
	handleInitiativeIdChange: function handleInitiativeIdChange(cmp, e, h) {
		h.getInitiative(cmp);
		h.setNextCoachingSession(cmp);
		h.getInitiativeSkills(cmp);
	},
	handleUserIdChange: function handleUserIdChange(cmp, e, h) {
		h.setNextCoachingSession(cmp);
		h.setUserName(cmp);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
            console.log('coachingInfo ', coachingInfo);
            cmp.set('v.isCoach',coachingInfo.isCoach);
			cmp.set('v.coachingInfo', coachingInfo);
			h.setUserName(cmp);
		}
	},
	handleCoachPress: function handleCoachPress(cmp, evt, h) {
		h.startCoaching(cmp);
	}
});