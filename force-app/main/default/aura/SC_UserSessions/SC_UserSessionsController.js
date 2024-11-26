({
	handleInit: function handleInit(cmp, evt, h) {
		var userId = cmp.get('v.userId'),
		    ownerId = cmp.get('v.ownerId');
		if (userId) h.getCoachingSessions(cmp);
		console.log('ownerId have a val?', ownerId);
		if (ownerId) h.getSessionsByOwner(cmp);
        if(userId){
            cmp.set('v.Id',userId);
        }else{
             cmp.set('v.Id',ownerId);
        }
	},
	handleUserIdChange: function handleUserIdChange(cmp, evt, h) {
		h.getCoachingSessions(cmp);
	},
	handleOwnerIdChange: function handleOwnerIdChange(cmp, evt, h) {
		console.log('handleOwnerIdChange');
		h.getSessionsByOwner(cmp);
	},
	handleNewSessionsChange: function handleNewSessionsChange(cmp, evt, h) {
		cmp.set('v.sessions', []);
		h.getCoachingSessions(cmp);
	},
	handleShowMoreClick: function handleShowMoreClick(cmp, evt, h) {
		var offset = cmp.get('v.offset'),
		    limit = cmp.get('v.limit');
		offset += limit;
		cmp.set('v.offset', offset);
		h.getCoachingSessions(cmp);
	}
});