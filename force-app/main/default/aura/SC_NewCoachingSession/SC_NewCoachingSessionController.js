({
	handleInit: function handleInit(cmp, evt, h) {
       // window.scrollTo(0 0); 
		var init = cmp.get('v.initiative');
		h.setUpSteps(cmp);
		console.log('init:', init);
		if (init) h.getInitReports(cmp);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, evt, h) {
		var Coachee = {
			selected: false
		};
		var coachingInfo = evt.getParam('coachingInfo'),
		    coachees = coachingInfo.coachees.map(function (coachee) {
			var newCoachee = Object.create(Coachee);
			return Object.assign(newCoachee, coachee);
		});
		cmp.set('v.availableUsers', coachees);
        console.log('coachees ## ',coachees);
	},
	handleAssessmentSkillChange: function handleAssessmentSkillChange(cmp, evt, h) {
		h.updateAssessments(cmp, evt);
	},
	handleCancelPress: function handleCancelPress(cmp, evt, h) {
        var activestep = cmp.get('v.activeStep');
        console.log('step ----- ' ,activestep);
        //h.cancelNewSession(cmp);
        if(activestep.title == $A.get("$Label.c.SC_Assess")){
            if(!cmp.get('v.disgardChangesModule')){
                cmp.set('v.disgardChangesModule',true);
            }else{
                cmp.set('v.disgardChangesModule',false);
            }
        }else{
            console.log('else=== ');
            h.cancelNewSession(cmp);
        }
	},
    
    cancelPress: function cancelPress(cmp, evt, h) {
        h.cancelNewSession(cmp);
    },
    
    removeTheBox : function removeTheBox(cmp, evt, h) {
        var disgardChanges = cmp.find('disgardChangesModule');
        disgardChanges.toggleIsOpen();
    },
    
	handleInitiativeSelected: function handleInitiativeSelected(cmp, evt, h) {
		var init = cmp.get('v.initiative'),
		    initStep = cmp.get('v.activeStep');
		init.Id = evt.getParam('initiativeId');
		init.Name = evt.getParam('initiativeName');
		initStep.valid = true;
		cmp.set('v.activeStep', initStep);
		cmp.set('v.initiative', init);
		evt.stopPropagation();
	},
	handleInitCancelPress: function handleInitCancelPress(cmp, evt, h) {
		var init = cmp.get('v.initiative'),
		    initStep = cmp.get('v.activeStep');
		init.Id = '';
		init.Name = '';
		initStep.valid = false;
		cmp.set('v.activeStep', initStep);
		cmp.set('v.initiative', init);
	},
	handleCoacheeSelectedChange: function handleCoacheeSelectedChange(cmp, evt, h) {
		var hasSelectedCoachee = cmp.get('v.availableUsers').some(function (user) {
			return user.selected;
		}),
		    activeStep = cmp.get('v.activeStep');
		activeStep.valid = hasSelectedCoachee;
		cmp.set('v.activeStep', activeStep);
	},
	handleDashboardPress: function handleDashboardPress(cmp, evt, h) {
		var navEvt = $A.get('e.force:naviagteToSObject'),
		    recordId = cmp.get('v.dashboardId');
		if (navEvt) {
			navEvt.setParams(recordId);
			navEvt.fire();
		} else {
			window.open('/' + recordId);
		}
	},
	handleInitChange: function handleInitChange(cmp, evt, h) {
		h.getInitReports(cmp);
	},
	handleNextStepPress: function handleNextStepPress(cmp, evt, h) {
		h.nextStep(cmp);
	},
	handleBackPress: function handleBackPress(cmp, evt, h) {
		h.lastStep(cmp);
	},
	handleNextPress: function handleNextPress(cmp, evt, h) {
		h.nextStep(cmp);
	},
	handleEventInputChange: function handleEventInputChange(cmp, evt, h) {
		h.validateEventForm(cmp);
	},
	finishWizardPress: function finishWizardPress(cmp, evt, h) {
		var planningOnly = cmp.get('v.planningOnly');
		console.log('planningOnly', planningOnly);
		if (planningOnly) {
			h.createAssessments(cmp);
		} else {
			h.createCoachingSession(cmp);
		}
	}
});