({
	handleInit: function handleInit(cmp, e, h) {
		h.requestCoachingInfo();
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			h.requestCoachingInfo();
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
			h.getInitiatives(cmp);
		}
	},

	handleListItemActionPress: function handleListItemActionPress(cmp, e, h) {
		cmp.set('v.parentId', e.getParam('param'));
		cmp.set('v.selectedInitiativeLabel', e.getParam('label'));
		h.getInitiatives(cmp);
	},
	handleBreadcrumbClick: function handleBreadcrumbClick(cmp, e, h) {
		e.preventDefault();
		var breadcrumbs = cmp.get('v.breadcrumbs'),
		    breadcrumbIndex = breadcrumbs.findIndex(function (item) {
			return item.label === e.srcElement.textContent;
		}),
		    breadcrumb = breadcrumbs[breadcrumbIndex];
		breadcrumbs.splice(breadcrumbIndex);
		cmp.set('v.selectedInitiativeLabel', breadcrumb.label);
		cmp.set('v.parentId', breadcrumb.parentId || null);
		cmp.set('v.breadcrumbs', breadcrumbs);
		h.getInitiatives(cmp);
	}
});