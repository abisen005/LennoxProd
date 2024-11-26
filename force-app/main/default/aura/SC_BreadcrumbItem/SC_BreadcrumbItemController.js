({
	handleBreadcrumbClick: function handleBreadcrumbClick(cmp, evt, h) {
		evt.preventDefault();
		if (cmp.get('v.isLast')) {
			return;
		}
		h.changeRoute(cmp);
	}
});