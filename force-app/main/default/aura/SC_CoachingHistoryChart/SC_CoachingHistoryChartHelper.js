({
	getAssessments: function getAssessments(cmp) {
		var initiativeId = cmp.get('v.initiativeId'),
		    userId = cmp.get('v.userId'),
		    action = cmp.get('c.getAssessments');
		action.setParams({ userId: userId, initiativeId: initiativeId });
		action.setCallback(this, getAssessmentsCallback);
		console.log();
		if (userId && initiativeId) {
			$A.enqueueAction(action);
		}

		function getAssessmentsCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var assessments = response.getReturnValue();
				this.setAssessmentHistory(cmp, assessments);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Assessments';
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
	setAssessmentHistory: function setAssessmentHistory(cmp, assessments) {
		var ChartItem = {
			init: function init(yPos, createdDate, index, numItems) {
				this.yPos = yPos * 100 - 4;
				this.createdDate = new Date(createdDate);
				this.xPos = index / (numItems - 1) * 100 - (numItems - 1 === index ? 2 : 0);
			},

			xPos: 0,
			yPos: 0,
			createdDate: undefined
		};

		var skillLengths = assessments.map(function (assessment) {
			return assessment.of_Skills_to_Complete__c;
		}),
		    numSkills = Math.max.apply(null, skillLengths); //Math.max(...skillLengths);

		if (numSkills) this.setChartLinePositions(cmp, numSkills + 1);

		var assessmentHistory = assessments.map(function (assessment, i) {
			var historyItem = Object.create(ChartItem);
			historyItem.init(assessment.Complete__c, assessment.CreatedDate, i, assessments.length);
			return historyItem;
		});

		cmp.set('v.assessmentHistory', assessmentHistory);
	},
	setChartLinePositions: function setChartLinePositions(cmp, numLines) {
		var chartLinePositions = [];
		for (var i = 0; i < numLines; i++) {
			chartLinePositions.push(Math.round(i / (numLines - 1) * 100));
		}
		console.log('chartLinePositions ', chartLinePositions);
		cmp.set('v.chartLinePositions', chartLinePositions);
	}
});