({
	getAsssessment: function getAsssessment(cmp) {
		var initId = cmp.get('v.initiativeId'),
		    userId = cmp.get('v.userId'),
		    action = cmp.get('c.getAssessment');
		if (initId && userId) {
			action.setParams({ userId: userId, initId: initId });
			action.setCallback(this, getAssessmentCallback);
			$A.enqueueAction(action);
		}

		function getAssessmentCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var assessment = response.getReturnValue();
				cmp.set('v.assessment', assessment);
				this.setProgressItems(cmp);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Assessment';
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
	setProgressItems: function setProgressItems(cmp) {

		var ProgressItem = {
			init: function init(isComplete) {
				this.isComplete = isComplete;
			},

			isComplete: false
		};

		var assessment = cmp.get('v.assessment'),
		    numCompleted = assessment.of_Skills_Completed__c,
		    progressItems = [];

		for (var i = 1; i <= assessment.of_Skills_to_Complete__c; i++) {
			var progressItem = Object.create(ProgressItem);
			progressItem.init(i <= numCompleted);
			progressItems.push(progressItem);
		}
		cmp.set('v.progressItems', progressItems);
	}
});