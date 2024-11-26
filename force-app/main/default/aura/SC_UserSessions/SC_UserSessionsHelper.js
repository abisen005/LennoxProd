({
	getCoachingSessions: function getCoachingSessions(cmp) {
		var action = cmp.get('c.getCoachingSessions'),
		    userId = cmp.get('v.userId'),
		    initId = cmp.get('v.initiativeId'),
		    showAll = cmp.get('v.showAll'),
		    newSessions = cmp.get('v.newSessions'),
		    limit = cmp.get('v.limit'),
		    queryLimit = cmp.get('v.limit') + 1,
		    //query 1 additional row to know if there are more to load
		offset = cmp.get('v.offset');

		cmp.set('v.isLoading', true);
		action.setParams({ userId: userId, initId: initId, newSessions: newSessions, showAll: showAll, queryLimit: queryLimit, offset: offset });
		action.setCallback(this, getCoachingSessionsCallback);
		$A.enqueueAction(action);

		function getCoachingSessionsCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var sessionsResponse = response.getReturnValue(),
				    sessions = cmp.get('v.sessions'),
				    hasMoreRecords = sessionsResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) sessionsResponse.pop();
				sessions = sessions.concat(sessionsResponse);
				cmp.set('v.sessions', sessions);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Coaching Sessions';
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
	getSessionsByOwner: function getSessionsByOwner(cmp) {
		var action = cmp.get('c.getSessionsByOwner'),
		    ownerId = cmp.get('v.ownerId'),
		    returnFutureSessions = cmp.get('v.newSessions'),
		    returnPastSessions = !returnFutureSessions,
		    limit = cmp.get('v.limit'),
		    queryLimit = cmp.get('v.limit') + 1,
		    //query 1 additional row to know if there are more to load
		offset = cmp.get('v.offset');

		cmp.set('v.isLoading', true);

		action.setParams({ ownerId: ownerId, returnFutureSessions: returnFutureSessions, returnPastSessions: returnPastSessions, queryLimit: queryLimit, offset: offset });
		action.setCallback(this, getSessionsByOwnerCallback);
		$A.enqueueAction(action);

		function getSessionsByOwnerCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var sessionsResponse = response.getReturnValue(),
				    sessions = cmp.get('v.sessions'),
				    hasMoreRecords = sessionsResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) sessionsResponse.pop();
				sessions = sessions.concat(sessionsResponse);
				cmp.set('v.sessions', sessions);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Coaching Sessions';
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

	/*
 @param	Array	arr	Array of objects with a date property
 @param	String	dateProp	name of the date property to sort by
 @param	String	sortBy	Sort ASC or DESC
 */
	sortByDate: function sortByDate(arr, dateProp, sortBy) {
		return arr.sort(function (a, b) {
			return sortBy === 'DESC' ? new Date(b[dateProp]) - new Date(a[dateProp]) : 'ASC';
		});
	}
});