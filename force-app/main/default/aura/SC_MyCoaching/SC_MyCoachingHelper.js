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
				var user = response.getReturnValue();
				cmp.set('v.user', user);
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
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	}
});