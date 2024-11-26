({
	getAssignments: function getAssignments(cmp) {
		console.log('userIds', cmp.get('v.userIds'));
		var action = cmp.get('c.getAssignments'),
		    userId = cmp.get('v.userId'),
		    userIds = cmp.get('v.userIds'),
		    initId = cmp.get('v.initiativeId'),
		    recordId = cmp.get('v.sessionId').length > 0 ? cmp.get('v.sessionId') : cmp.get('v.topicId'),
		    showCompleted = cmp.get('v.showCompleted'),
		    showAll = cmp.get('v.showAll'),
		    limit = cmp.get('v.limit'),
		    queryLimit = cmp.get('v.limit') + 1,
		    //query 1 additional row to know if there are more to load
		offset = cmp.get('v.offset');
		cmp.set('v.isLoading', true);
		userIds.push(userId);
		console.log('userIds', userIds);
		action.setParams({ userIds: userIds, initId: initId, recordId: recordId, showCompleted: showCompleted, showAll: showAll, queryLimit: queryLimit, offset: offset });
		action.setCallback(this, getAssignmentsCallback);
		$A.enqueueAction(action);

		function getAssignmentsCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var assignmentsResponse = response.getReturnValue(),
				assignments = cmp.get('v.assignments'),
				hasMoreRecords = assignmentsResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) assignmentsResponse.pop();
				console.log('assignmentsResponse'+assignmentsResponse);
				//assignments = assignments.concat(assignmentsResponse);
				//cmp.set('v.assignments', assignments);
				cmp.set('v.assignments', assignmentsResponse);

				/*
				var assignmentsResponse = response.getReturnValue(),
				    assignments = cmp.get('v.assignments'),
				    hasMoreRecords = assignmentsResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) assignmentsResponse.pop();
                console.log('assignmentsResponse'+assignmentsResponse);
				assignments = assignments.concat(assignmentsResponse);
				cmp.set('v.assignments', assignments);
				*/
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Assignments';
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