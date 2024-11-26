({
	handleInit: function handleInit(cmp, evt, h) {
		h.getAssessments(cmp);
	},
	handleInitiativeIdChange: function handleInitiativeIdChange(cmp, e, h) {
		h.getAssessments(cmp);
	},
	handleUserIdChange: function handleUserIdChange(cmp, e, h) {
		h.getAssessments(cmp);
	}
});