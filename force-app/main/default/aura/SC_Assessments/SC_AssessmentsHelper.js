({
	getAssessments: function getAssessments(cmp) {
		var action = cmp.get('c.getAssessments'),
		    userId = cmp.get('v.userId'),
		    initId = cmp.get('v.initiativeId'),
		    sessionId = cmp.get('v.sessionId'),
		    limit = cmp.get('v.limit'),
		    queryLimit = cmp.get('v.limit') + 1,
		    //query 1 additional row to know if there are more to load
		offset = cmp.get('v.offset');

		cmp.set('v.isLoading', true);
		action.setParams({ userId: userId, initId: initId, sessionId: sessionId, queryLimit: queryLimit, offset: offset });
		action.setCallback(this, getAssessmentsCallback);
		$A.enqueueAction(action);

		function getAssessmentsCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var assessmentsResponse = response.getReturnValue(),
				    assessments = cmp.get('v.assessments'),
				    hasMoreRecords = assessmentsResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) assessmentsResponse.pop();
				assessments = assessments.concat(assessmentsResponse);
				cmp.set('v.assessments', assessments);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Asessments';
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