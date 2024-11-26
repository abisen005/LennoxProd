({
	handleInit: function handleInit(cmp, evt, h) {
		var userId = cmp.get('v.userId'),
		    sessionId = cmp.get('v.sessionId'),
		    topicId = cmp.get('v.topicId');
		if (userId || sessionId || topicId) h.getAssignments(cmp);
	},
	handleSessionIdChange: function handleSessionIdChange(cmp, evt, h) {
		var sessionId = cmp.get('v.sessionId');
		if (sessionId) h.getAssignments(cmp);
	},
	handleTopicIdChange: function handleTopicIdChange(cmp, evt, h) {
		var topicId = cmp.get('v.topicId');
		if (topicId) h.getAssignments(cmp);
	},
	handleUserIdChange: function handleUserIdChange(cmp, evt, h) {
		h.getAssignments(cmp);
	},
	handleShowCompletedChange: function handleShowCompletedChange(cmp, evt, h) {
		cmp.set('v.assignments', []);
		h.getAssignments(cmp);
	},
	handleShowMoreClick: function handleShowMoreClick(cmp, evt, h) {
		var offset = cmp.get('v.offset'),
		    limit = cmp.get('v.limit');
		offset += limit;
		cmp.set('v.offset', offset);
		h.getAssignments(cmp);
	},
	handleRefresh: function handleRefresh(cmp, evt, h) {
		cmp.set('v.assignments', []);
		h.getAssignments(cmp);
	}
});