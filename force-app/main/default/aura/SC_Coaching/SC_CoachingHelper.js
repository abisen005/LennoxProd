({
	navigateToInitiative: function navigateToInitiative(initiativeId, label) {
		var routeChangeEvt = $A.get('e.c:routeChangeAttempt'),
		    routerName = '',
		    path = '/initiative/' + initiativeId;
		routeChangeEvt.setParams({ routerName: routerName, path: path, label: label });
		routeChangeEvt.fire();
	},
	toggleTabCmp: function toggleTabCmp(cmp, tabCmp) {
		var tabId = tabCmp.get('v.id'),
		    params = {};
		switch (tabId) {
			case 'c:SC_MyCoaching':
				params.userId = cmp.get('v.coachingInfo').userId;
            case 'c:SC_People':
                params.serchkey = cmp.get('v.serchkey');
				break;
		}
		console.log('params: ', params);
		if (tabId) {
			tabCmp.set('v.body', []);
			$A.createComponent(tabId, params, function (newCmp, status, errorMessage) {
				if (status === 'SUCCESS') {
					var body = tabCmp.get('v.body');
					body.push(newCmp);
					tabCmp.set('v.body', body);
					//cmp.set('v.coachingSessionWizard', body);
				} else if (status === 'INCOMPLETE') {
					console.log('No response from server or client is offline.');
					// Show offline error
				} else if (status === 'ERROR') {
					console.log('Error: ' + errorMessage);
					// Show error message
				}
			});
		}
	},
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	}
});