({
	changeRoute: function changeRoute(cmp) {
		var routeChangeEvt = $A.get('e.c:routeNavHistoryChange'),
		    routerName = cmp.get('v.routerName'),
		    historyIndex = cmp.get('v.historyIndex');
		routeChangeEvt.setParams({ routerName: routerName, historyIndex: historyIndex });
		routeChangeEvt.fire();
	}
});