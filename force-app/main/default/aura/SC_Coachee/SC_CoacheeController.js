({
	handleInit: function handleInit(cmp, evt, h) {
		h.setUpcomingSession(cmp);
	},
	handleCoachPress: function handleCoachPress(cmp, evt, h) {
        window.scrollTo(0,0);
        console.log('In Handle Coach Press');
		h.startCoaching(cmp);
	},
	handleCloseNewSessionEvent: function handleCloseNewSessionEvent(cmp, evt, h) {
		cmp.set('v.coachingSessionWizard', []);
	},
    fireViewTeamEvent : function fireViewTeamEvent(cmp, evt, h) {
        console.log('In coacheed fire event');
        var cochee = cmp.get('v.coachee');
        var ViewTeam = cmp.getEvent("ViewTeam");
        ViewTeam.setParams({
            "UserName" : cochee.FirstName + ' '+ cochee.LastName,
            "UserId" : cochee.Id 
        });
        ViewTeam.fire();
    }
});