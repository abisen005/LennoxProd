({
	getAssessmentDetails: function getAssessmentDetails(cmp) {
		console.log('getAssessmentDetails invoked');
		var assessmentId = cmp.get('v.assessmentId');
		console.log('set assessment id var');
	    var action = cmp.get('c.getAssessmentDetails');
		console.log('assigned vars');
		action.setParams({ assessmentId: assessmentId });
		console.log('set params');
		action.setCallback(this, getAssessmentDetailsCallback);
		console.log('set cb');
		$A.enqueueAction(action);
		console.log('enqueued action');
		cmp.set('v.isLoading', true);
		console.log('set loading to true');

		function getAssessmentDetailsCallback(response) {
			console.log('cb invoked');
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var assessment = response.getReturnValue();
				console.log('got assessment', assessment);
				cmp.set('v.assessment', assessment);
				this.assignSkillsToLists(cmp);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error getting the Assessment';
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
	assignSkillsToLists: function assignSkillsToLists(cmp) {
		var assessment = cmp.get('v.assessment'),
		    skillsToMaster = [],
		    skillsAlreadyMastered = [];
		if (assessment.Assessment_Skills__r) {
			assessment.Assessment_Skills__r.forEach(function (skill) {
				if (skill.Complete__c) {
					skillsAlreadyMastered.push(skill);
				} else {
					skillsToMaster.push(skill);
				}
			});
		}
		console.log('assign skillsToMaster ', skillsToMaster);
		console.log('assign skillsAlreadyMastered ', skillsAlreadyMastered);
		cmp.set('v.skillsToMaster', skillsToMaster);
		cmp.set('v.skillsAlreadyMastered', skillsAlreadyMastered);
	}
});