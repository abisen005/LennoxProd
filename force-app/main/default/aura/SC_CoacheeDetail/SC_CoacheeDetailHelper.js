({
	getUser: function getUser(cmp) {
		var userId = cmp.get('v.userId'),
		    action = cmp.get('c.getUser');
		action.setParams({ userId: userId });
		action.setCallback(this, getUserCallback);
		$A.enqueueAction(action);

		function getUserCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var coachee = response.getReturnValue();
				cmp.set('v.coachee', coachee);
				/*
    	Temproary fix until router support initially rendered routes with route params
    */
				var label = coachee.Name,
				    coacheeId = coachee.Id,
				    routeChangeEvt = $A.get('e.c:routeChangeAttempt'),
				    routerName = 'coachee',
				    path = 'coachee/sessions/' + coacheeId;
				routeChangeEvt.setParams({ routerName: routerName, path: path, label: label });
				routeChangeEvt.fire();
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Coachee';
				if (errors) {
					if (errors[0] && errors[0].message) {
						errorMsg = errors[0].message;
					}
				}
				if (errorEvent) {
					errorEvent.setParams({
						title: 'Error',
						message: errorMsg,
						type: 'error'
					});
					errorEvent.fire();
				} else {
					alert(errorMsg);
				}
			}
		}
	},
	startCoaching: function startCoaching(cmp) {
		var users = [cmp.get('v.coachee')]; //must pass the coachee in an array
		$A.createComponent('c:SC_NewCoachingSession', { users: users }, function (coachingSessionCmp, status, errorMessage) {
			if (status === 'SUCCESS') {
				var body = cmp.get('v.coachingSessionWizard');
				body.push(coachingSessionCmp);
				cmp.set('v.coachingSessionWizard', body);
			} else if (status === 'INCOMPLETE') {
				console.log('No response from server or client is offline.');
				// Show offline error
			} else if (status === 'ERROR') {
				console.log('Error: ' + errorMessage);
				// Show error message
			}
		});
	}
});