({
	handleInit: function handleInit(cmp, evt, h) {
		var user = cmp.get('v.user'),
		    init = cmp.get('v.initiative');
		console.log('user in assessment', user);
		console.log('init in assessment', init);
		if (user && init) h.getAssessment(cmp);
	},
    disgardChanges: function disgardChanges(cmp, evt, h) {
        
        if(cmp.get('v.buttonDiv')){
            console.log('Method Called --- ');   
            var disgardChanges = cmp.find('disgard');
            disgardChanges.toggleIsOpen();
        }else{
            h.cancelNewSession(cmp);
        }
        
    },
    disgardResetMastery: function disgardChanges(cmp, evt, h) {
        console.log('In disgardResetMastery');
        h.cancelNewSession(cmp);
    },
	handleUserChange: function handleUserChange(cmp, evt, h) {
		var user = cmp.get('v.user');
		if (user) h.getAssessment(cmp);
	},
	handleInitChange: function handleInitChange(cmp, evt, h) {
		var init = cmp.get('v.initiative');
		if (init) h.getAssessment(cmp);
	},
	handleCompleteChange: function handleCompleteChange(cmp, evt, h) {
		var skillsToMaster = cmp.get('v.skillsToMaster'),
		    skillsAlreadyMastered = cmp.get('v.skillsAlreadyMastered'),
            skillsOngoing = cmp.get('v.skillsOngoing');
        
        var showbuttons = false;
        
        skillsAlreadyMastered.forEach(function (skill) {
            if(skill.resetMastery){
                showbuttons = true;
            }
        });
                                      
        cmp.set('v.buttonDiv', showbuttons);        
        
		h.fireAssessmentSkillChangeEvent(cmp, skillsToMaster.concat(skillsAlreadyMastered).concat(skillsOngoing));
    },
    
    handleAssessmentSaveClick: function handleAssessmentSaveClick(cmp, evt, h) {
        h.AssessmentSaveClick(cmp, evt, h);
    },
    
    handleAssessmentCancelClick: function handleAssessmentCancelClick(cmp, evt, h) {
        console.log("Assemeement Cancel Click ----- ");
        cmp.set('v.isLoading', true);
        var user = cmp.get('v.user'),
            init = cmp.get('v.initiative');
        console.log('user in assessment', user);
        console.log('init in assessment', init);
        if (user && init) h.getAssessment(cmp);
    },
});