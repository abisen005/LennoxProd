({
	handleInit: function handleInit(cmp, evt, h) {
		var userId = cmp.get('v.userId');
		if (userId) h.getBadges(cmp);
	},
	handleUserIdChange: function handleUserIdChange(cmp, evt, h) {
		h.getBadges(cmp);
	},
	handleBadgeGiven: function handleBadgeGiven(cmp, evt, h) {
		console.log('handle badge given');
		cmp.set('v.offset', 0);
		cmp.set('v.userBadges', []);
		h.getBadges(cmp);
	},
	handleShowMoreClick: function handleShowMoreClick(cmp, evt, h) {
		var offset = cmp.get('v.offset'),
		    limit = cmp.get('v.limit');
		offset += limit;
		cmp.set('v.offset', offset);
		h.getBadges(cmp);
	}
});