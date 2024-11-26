({
	getInitiative: function getInitiative(cmp) {
		var initiativeId = cmp.get('v.initiativeId'),
		    action = cmp.get('c.getInitiative');
		action.setParams({ initiativeId: initiativeId });
		action.setCallback(this, getInitiativeCallback);
		$A.enqueueAction(action);

		function getInitiativeCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var initiative = response.getReturnValue();
				cmp.set('v.initiative', initiative);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Initiative';
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
	getInitiativeSkills: function getInitiativeSkills(cmp) {
		console.log('getting skills');
		var action = cmp.get('c.getInitiativeSkills'),
		    initiativeId = cmp.get('v.initiativeId');
		action.setParams({ initiativeId: initiativeId });
		action.setCallback(this, getInitiativeSkillsCallback);
		$A.enqueueAction(action);

		function getInitiativeSkillsCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var skills = response.getReturnValue();
				cmp.set('v.skills', skills);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error getting the Initiative Skills';
				if (errors) {
					if (errors[0] && errors[0].message) {
						errorMsg = errors[0].message;
					}
				}
				if (errorResponse) errorMsg = errorResponse.message;
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
		/*
  TODO: Instead of doing this separately in 3 or 4 different components, do it in the container component and create
  	  an event to fire from here.
  */
		var initiative = cmp.get('v.initiative'),
		    userId = cmp.get('v.userId'),
		    userName = cmp.get('v.userName'),
		    user = {
			sobjectType: 'User',
			Id: userId,
			Name: userName
		};
		$A.createComponent('c:SC_NewCoachingSession', { initiative: initiative, users: [user] }, //must pass the coachee in an array
		function (coachingSessionCmp, status, errorMessage) {
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
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	},
	setNextCoachingSession: function setNextCoachingSession(cmp) {
		var initId = cmp.get('v.initiativeId'),
		    userId = cmp.get('v.userId'),
		    coachingInfo = cmp.get('v.coachingInfo'),
		    userCoachingSessions = [];
        console.log('failing here? ', coachingInfo);
		if (!initId || !userId || !coachingInfo) return;
		
		if (!!coachingInfo.upcomingSessions) userCoachingSessions = coachingInfo.upcomingSessions[userId];
		if (userCoachingSessions && userCoachingSessions.length > 0) {
			var scopedSessions = userCoachingSessions.filter(function (session) {
				return session.Initiative__c === initId;
			}),
			    nextSession = scopedSessions.length > 0 ? scopedSessions[scopedSessions.length - 1] : undefined; //last one is always the most recent
			cmp.set('v.nextCoachingSession', nextSession);
		};
	},
	setUserName: function setUserName(cmp) {
		//determine if the user is viewing their own scoped initiative view or
		//if the coach is viewing a coachee. If viewing their own, use coachingInfo.userName
		//otherwise, find name in coachingInfo.coachee list
		var userId = cmp.get('v.userId'),
		    coachingInfo = cmp.get('v.coachingInfo'),
		    isViewingOwn = void 0,
		    userName = void 0;
		if (!userId || !coachingInfo) return;
		isViewingOwn = userId === coachingInfo.userId;
		if (isViewingOwn) {
			userName = coachingInfo.userName;
		} else {
			var user = coachingInfo.coachees.find(function (coachee) {
				return coachee.Id === userId;
			});
			userName = user ? user.Name : '';
		}
		cmp.set('v.userName', userName);
	}
});