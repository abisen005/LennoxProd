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
				console.log(initiative);
				cmp.set('v.initiative', initiative);
				if (initiative.Dashboard_Initiatives__r) cmp.set('v.dashboardId', initiative.Dashboard_Initiatives__r[0].Dashboard__c);
				if (initiative.Initiative_Reports__r) {
					var reportIds = initiative.Initiative_Reports__r.map(function (report) {
						return report.Report__c;
					}).join(),
					    formFactor = $A.get('$Browser.formFactor');
					console.log('reportIds ', reportIds);
					cmp.set('v.reportIds', reportIds);
					cmp.set('v.reviewIframeSrc', '/apex/SC_DashboardReports?reportId=' + reportIds + '&formFactor=' + formFactor);
				}
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
	navigateToDashboard: function navigateToDashboard(cmp) {
		var recordId = cmp.get('v.dashboardId'),
		    navEvent = $A.get('e.force:navigateToSObject');
		if (navEvent) {
			navEvent.setParams(recordId);
		} else {
			window.open('/' + recordId);
		}
	},
	startCoaching: function startCoaching(cmp) {
		console.log('startCoaching');
		var initiative = cmp.get('v.initiative'); //must pass the coachee in an array
		console.log('initiative: ', initiative);
		$A.createComponent('c:SC_NewCoachingSession', { initiative: initiative }, function (coachingSessionCmp, status, errorMessage) {
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
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	}
});