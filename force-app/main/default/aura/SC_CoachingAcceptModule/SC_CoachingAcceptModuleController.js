({
    handleInit : function handleInit(cmp, evt, h) {
        
        var sessionId = cmp.get('v.recordId');
        cmp.set('v.session', sessionId);
        console.log('sessionId :: ', sessionId);
		if (sessionId) h.getCoachingSession(cmp);
        //h.getRelationId(cmp);
        //var acceptInviteModal = cmp.find('rescheduleModal');
        //acceptInviteModal.toggleIsOpen();
    },
    
    handleRescheduleForCochee : function handleRescheduleForCochee(cmp, evt, h) {
        var acceptInviteModal = cmp.find('acceptInviteModal');
        acceptInviteModal.toggleIsOpen();
        var rescheduleModalCmp = cmp.find('rescheduleModal'),
            sessionStartDate = cmp.get('v.session.Start_Date__c'),
            sessionDuration = cmp.get('v.session.Duration__c');
        cmp.set('v.sessionStartDate', sessionStartDate);
        cmp.set('v.sessionDuration', sessionDuration);
        rescheduleModalCmp.toggleIsOpen();
    },
    
    handleAcceptInvitePress: function handleAcceptInvitePress(cmp, evt, h) {
        h.respondToInvite(cmp, true);
        window.location.replace(cmp.get("v.BaseUrl")+"lightning/n/Coaching_Console_VF");
    },
    
    handleCancelReschedulePress: function handleCancelReschedulePress(cmp, evt, h) {
        var rescheduleModalCmp = cmp.find('rescheduleModal');
        rescheduleModalCmp.toggleIsOpen();
       window.location.replace(cmp.get("v.BaseUrl")+"lightning/n/Coaching_Console_VF");
    },
    
    handleSaveReschedulePress: function handleSaveReschedulePress(cmp, evt, h) {
        if (h.validateRescheduleForm(cmp)) {
            h.updateSessionDate(cmp);
       window.location.replace(cmp.get("v.BaseUrl")+"lightning/n/Coaching_Console_VF");
        }
    },
    
    handleRescheduleInviteForCoach : function handleAcceptInvitePress(cmp, evt, h) {
        console.log('In Choch Reschedule === ');
        var acceptInviteModal = cmp.find('rescheduledInviteModal');
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
       // window.location.replace("https://lennox--staging.lightning.force.com/lightning/n/Coaching_Console_VF");
    }
})