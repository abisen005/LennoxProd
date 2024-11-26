({
	routeHistoryChangeSuccessHandler: function routeHistoryChangeSuccessHandler(cmp, e, h) {
		var routerName = e.getParam('routerName'),
		    history = e.getParam('history'),
		    historyIndex = e.getParam('historyIndex'),
		    activePath = history[historyIndex].path;
		if (routerName === 'consoleContainer') {
			cmp.set('v.activePath', activePath);
		}
	}
});