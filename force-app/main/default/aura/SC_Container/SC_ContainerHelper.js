({
	getCoachingInfo: function getCoachingInfo(cmp) {
		var action = cmp.get('c.getCoachingInfo');
		action.setCallback(this, getCoachingInfoCallback);
		action.setStorable();
		$A.enqueueAction(action);

		function getCoachingInfoCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var coachingInfo = response.getReturnValue();
                console.log('coachingInfo::::',coachingInfo);
				cmp.set('v.coachingInfo', coachingInfo);
                
                // 29-07
                
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error retrieving your Coaching Role';
				cmp.set('v.coachingInfo', {});
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
	sendCoachingInfo: function sendCoachingInfo(coachingInfo) {
		var evt = $A.get('e.c:SC_CoachingInfoResponse');
		evt.setParams({ coachingInfo: coachingInfo });
		evt.fire();
	},
	openNewCoachingSession: function openNewCoachingSession(cmp, evt) {
		var _evt$getParams = evt.getParams();

		var users = _evt$getParams.users;
		var initiative = _evt$getParams.initiative;
		var hidePlanningSteps = _evt$getParams.hidePlanningSteps;
		var planningOnly = _evt$getParams.planningOnly;
		var session = _evt$getParams.session;
        console.log('evt Params',_evt$getParams);
		/*var pageReference = cmp.get("v.pageReference");
		var session = pageReference.state.c__id;*/

		console.log('session from openNewCoachingSession', session);
		$A.createComponent('c:SC_NewCoachingSession', { users: users, initiative: initiative, hidePlanningSteps: hidePlanningSteps, planningOnly: planningOnly, session: session }, function (coachingSessionCmp, status, errorMessage) {
			console.log('status: ', status);
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
	},
    
    sendRefreshedCoachingInfo : function sendRefreshedCoachingInfo(cmp, evt, h){
        var action = cmp.get('c.getCoachingInfo');
		action.setCallback(this, getCoachingInfoCallback);
		action.setStorable();
		$A.enqueueAction(action);

		function getCoachingInfoCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var coachingInfo = response.getReturnValue();
				cmp.set('v.coachingInfo', coachingInfo);
                var evt = $A.get('e.c:SC_CoachingInfoResponse');
                evt.setParams({ coachingInfo: coachingInfo });
                evt.fire();
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error retrieving your Coaching Role';
				cmp.set('v.coachingInfo', {});
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
    }
});