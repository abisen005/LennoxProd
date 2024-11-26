({
	startCoaching: function startCoaching(cmp) {
        console.log('In Handle Coach Press helpwr');
		var users = [cmp.get('v.coachee')]; //must pass the coachee in an array
        console.log('users'+users);
		$A.createComponent('c:SC_NewCoachingSession', { users: users }, function (coachingSessionCmp, status, errorMessage) {
			console.log('status: ', status);
			if (status === 'SUCCESS') {
                console.log('Success ',status);
				var body = cmp.get('v.coachingSessionWizard');
				body.push(coachingSessionCmp);
				cmp.set('v.coachingSessionWizard', body);
                console.log('## ',cmp.get('v.coachingSessionWizard'));
                console.log('Success ',status);
			} else if (status === 'INCOMPLETE') {
				console.log('No response from server or client is offline.');
				// Show offline error
			} else if (status === 'ERROR') {
				console.log('Error: ' + errorMessage);
				// Show error message
			}
		});
	},
	setUpcomingSession: function setUpcomingSession(cmp) {
		var allUpcomingSessions = cmp.get('v.upcomingSessions'),
		    userId = cmp.get('v.coachee.Id'),
		    userUpcomingSessions = allUpcomingSessions[userId]; //list of sessions for the user.
		if (userUpcomingSessions && userUpcomingSessions.length > 0) cmp.set('v.upcomingSession', userUpcomingSessions[userUpcomingSessions.length - 1]);
	}
});