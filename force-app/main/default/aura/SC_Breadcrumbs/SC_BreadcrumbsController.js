({
	routeHistoryChangeSuccess: function routeHistoryChangeSuccess(cmp, evt, h) {
		var routerName = evt.getParam('routerName'),
		    history = evt.getParam('history'),
		    historyIndex = evt.getParam('historyIndex'),
		    breadcrumbs = history.slice(0, historyIndex + 1); //make sure last item in breadcrumbs is the active one
		if (routerName === cmp.get('v.routerName')) cmp.set('v.breadcrumbs', breadcrumbs);
	}
});