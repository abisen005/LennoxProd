({
	getUser: function getUser(cmp) {
		var action = cmp.get('c.getUser'),
		    userId = cmp.get('v.userId');
		action.setParams({ userId: userId });
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log('getUserCallback', response, state);
			if (cmp.isValid() && state === 'SUCCESS') {
				var user = response.getReturnValue();
				cmp.set('v.user', user);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the planning details';
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
		});
		$A.enqueueAction(action);
	},
	getPlanningHistory: function getPlanningHistory(cmp) {
		console.log('getPlanningHistory');
		var action = cmp.get('c.getPlanningHistory'),
		    userId = cmp.get('v.userId');
		console.log('userId ', userId);
		action.setParams({ userId: userId });
		action.setCallback(this, getPlanningHistoryCallback);
		$A.enqueueAction(action);

		function getPlanningHistoryCallback(response) {
			var state = response.getState();
			console.log('getPlanningHistoryCallback');
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var plans = response.getReturnValue();
				console.log('plans ', plans);
				cmp.set('v.plans', plans);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error getting the planning details';
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
	getPlanning: function getPlanning(cmp) {
		var planningId = arguments.length <= 1 || arguments[1] === undefined ? '' : arguments[1];

		console.log('getPlanning');
		var action = cmp.get('c.getPlanning'),
		    userId = cmp.get('v.userId');
		action.setParams({ userId: userId, planningId: planningId });
		action.setCallback(this, getPlanningCallback);
		$A.enqueueAction(action);

		function getPlanningCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var planTopics = response.getReturnValue() || [];
				console.log('planTopics ', planTopics);
				var readOnlyTopics = planTopics.filter(function (topic) {
					return !topic.Strategy_Planning_Topic__c;
				}),
				    planningTopics = planTopics.filter(function (topic) {
					return topic.Strategy_Planning_Topic__c;
				}),
				    planningYear = planTopics.length > 0 ? planTopics[0].Planning__r.Planning_Year__c : '';
				cmp.set('v.planningYear', planningYear);
				cmp.set('v.planningTopics', planningTopics);
				cmp.set('v.readOnlyTopics', readOnlyTopics);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error getting the planning details';
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
	newPlanning: function newPlanning(cmp, year) {
		var action = cmp.get('c.newPlanning'),
		    userId = cmp.get('v.userId');
		action.setParams({ userId: userId, year: year });
		action.setCallback(this, newPlanningCallback);
		$A.enqueueAction(action);

		function newPlanningCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var newPlanning = response.getReturnValue();
				console.log(newPlanning);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error creating the new plan.';
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
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	}
});