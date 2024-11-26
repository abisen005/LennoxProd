({
	handleInit: function handleInit(cmp, evt, h) {
		var sessionId = cmp.get('v.id');
		if (sessionId) h.getCoachingSession(cmp);
		h.requestCoachingInfo();
        //handleSessionChange(cmp, evt, h);
	},
	handleIdChange: function handleIdChange(cmp, evt, h) {
		var sessionId = cmp.get('v.id');
		if (sessionId) {
			h.getCoachingSession(cmp);
		}
	},
	handleIsCoachChange: function handleIsCoachChange(cmp, evt, h) {
		console.log('invoke getInitiativeQuestions from cnt');
		h.getInitiativeQuestions(cmp);
	},
	handleSessionChange: function handleSessionChange(cmp, evt, h) {
        console.log('cmp.get("v.isCoach")', cmp.get("v.isCoach"));
        console.log('cmp.session.Is_Rescheduled_by_Cochee__c' , cmp.get("v.session.Is_Rescheduled_by_Cochee__c"));
        if(!cmp.get("v.isCoach") && !cmp.get("v.session.Is_Rescheduled_by_Cochee__c")){
            h.checkIfAssigneeHasAccepted(cmp);
        }
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
		}
	},

	/*
 * isCoach should already be set, but on the off chance that the session
 * comes back before the coachingInfo is set, make sure to set the value of
 * isCoach when it comes in.
 */
	handleCoachingInfoChange: function handleCoachingInfoChange(cmp, e, h) {
		var session = cmp.get('v.session');
		if (session) {
			h.setIsCoach(cmp);
		}
	},
	handleNewAssignmentPress: function handleNewAssignmentPress(cmp, evt, h) {
		h.newAssignment(cmp);
	},
	handleAssignmentCreated: function handleAssignmentCreated(cmp, evt, h) {
		var userAssignmentsCmp = cmp.find('userAssignments');
		userAssignmentsCmp.refresh();
	},
	handleReschedulePress: function handleReschedulePress(cmp, evt, h) {
		var rescheduleModalCmp = cmp.find('rescheduleModal'),
		    sessionStartDate = cmp.get('v.session.Start_Date__c'),
		    sessionDuration = cmp.get('v.session.Duration__c');
		cmp.set('v.sessionStartDate', sessionStartDate);
		cmp.set('v.sessionDuration', sessionDuration);
		rescheduleModalCmp.toggleIsOpen();
	},
	handleCancelReschedulePress: function handleCancelReschedulePress(cmp, evt, h) {
		var rescheduleModalCmp = cmp.find('rescheduleModal');
		rescheduleModalCmp.toggleIsOpen();
	},
	handleSaveReschedulePress: function handleSaveReschedulePress(cmp, evt, h) {
		if (h.validateRescheduleForm(cmp)) {
			h.updateSessionDate(cmp);
		}
	},
	handlePromptDeletePress: function handlePromptDeletePress(cmp, evt, h) {
		var deleteModalCmp = cmp.find('deleteModal');
		deleteModalCmp.toggleIsOpen();
	},
	handleCancelDeletePress: function handleCancelDeletePress(cmp, evt, h) {
		var deleteModalCmp = cmp.find('deleteModal');
		deleteModalCmp.toggleIsOpen();
	},
	handleDeletePress: function handleDeletePress(cmp, evt, h) {
		h.deleteCoachingSession(cmp);
	},
	handleScheduleNextSessionPress: function handleScheduleNextSessionPress(cmp, evt, h) {
		var scheduleNewModal = cmp.find('scheduleNewModal');
		scheduleNewModal.toggleIsOpen();
	},
	handleScheduleWithPlanningPress: function handleScheduleWithPlanningPress(cmp, evt, h) {
		var scheduleNewModal = cmp.find('scheduleNewModal');
		h.fireStartNewSessionEvent(cmp, false, false);
		scheduleNewModal.toggleIsOpen();
	},
	handleScheduleWithoutPlanningPress: function handleScheduleWithoutPlanningPress(cmp, evt, h) {
		var scheduleNewModal = cmp.find('scheduleNewModal');
		h.fireStartNewSessionEvent(cmp, true, false);
		scheduleNewModal.toggleIsOpen();
	},
	handlePlanNowPress: function handlePlanNowPress(cmp, evt, h) {
		h.fireStartNewSessionEvent(cmp, false, true);
	},
	handleDeclineInvitePress: function handleDeclineInvitePress(cmp, evt, h) {
		h.respondToInvite(cmp, false);
	},
	handleAcceptInvitePress: function handleAcceptInvitePress(cmp, evt, h) {
		h.respondToInvite(cmp, true);
        h.updateAttendeeStatus(cmp, 'Accepted', false);
	},    
    handleRescheduleForCochee : function handleAcceptInvitePress(cmp, evt, h) {
        var acceptInviteModal = cmp.find('acceptInviteModal');
        acceptInviteModal.toggleIsOpen();
        var rescheduleModalCmp = cmp.find('rescheduleModal'),
            sessionStartDate = cmp.get('v.session.Start_Date__c'),
            sessionDuration = cmp.get('v.session.Duration__c');
        cmp.set('v.sessionStartDate', sessionStartDate);
        cmp.set('v.sessionDuration', sessionDuration);
        rescheduleModalCmp.toggleIsOpen();
    },
    
    handleAcceptRescheduledInviteForCoach : function handleAcceptInvitePress(cmp, evt, h) {
        var acceptInviteModal = cmp.find('rescheduledInviteModal');
        acceptInviteModal.toggleIsOpen();
        h.updateSession(cmp);
    },
    handleRescheduleInviteForCoach : function handleAcceptInvitePress(cmp, evt, h) {
        var acceptInviteModal = cmp.find('rescheduledInviteModal');
        acceptInviteModal.toggleIsOpen();
        var rescheduleModalCmp = cmp.find('rescheduleModal'),
            sessionStartDate = cmp.get('v.session.Start_Date__c'),
            sessionDuration = cmp.get('v.session.Duration__c');
        cmp.set('v.sessionStartDate', sessionStartDate);
        cmp.set('v.sessionDuration', sessionDuration);
        rescheduleModalCmp.toggleIsOpen();
    }
});