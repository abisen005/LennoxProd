({
	handleInit: function handleInit(cmp, evt, h) {
        
        var currentUserId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('init the coachee detail cmp');
        var userId = cmp.get('v.userId');
        cmp.set('v.isCoach', userId != currentUserId);
		console.log('is the user id set initially?', userId );
		if (userId) h.getUser(cmp);
	},
	handleUserIdChange: function handleUserIdChange(cmp, evt, h) {
		h.getUser(cmp);
	},
	routeHistoryChangeSuccessHandler: function routeHistoryChangeSuccessHandler(cmp, evt, h) {
		var routerName = evt.getParam('routerName'),
		    history = evt.getParam('history'),
		    historyIndex = evt.getParam('historyIndex'),
		    activeRouteName = history[historyIndex].name;
		if (routerName === 'coachee') {
			cmp.set('v.activeRouteName', activeRouteName);
		}
	},
	handleCoachPress: function handleCoachPress(cmp, evt, h) {
		h.startCoaching(cmp);
	},
	handleCloseNewSessionEvent: function handleCloseNewSessionEvent(cmp, evt, h) {
		cmp.set('v.coachingSessionWizard', []);
	},
	handleGiveBadgePress: function handleGiveBadgePress(cmp, evt, h) {
		cmp.set('v.isGivingBadge', true);
	}
});