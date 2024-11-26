({
	handleInit: function handleInit(cmp, evt, h) {
		h.getAssessments(cmp);
	},
	handleShowMoreClick: function handleShowMoreClick(cmp, evt, h) {
		var offset = cmp.get('v.offset'),
		    limit = cmp.get('v.limit');
		offset += limit;
		cmp.set('v.offset', offset);
		h.getAssessments(cmp);
	}
});