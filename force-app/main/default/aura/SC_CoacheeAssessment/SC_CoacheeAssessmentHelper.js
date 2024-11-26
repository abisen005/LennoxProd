({
	getAssessment: function getAssessment(cmp) {
		var action = cmp.get('c.getAssessmentSkills'),
		    userId = cmp.get('v.user').Id,
		    initId = cmp.get('v.initiative').Id;
		if (userId.length && initId.length) {
			action.setParams({ userId: userId, initId: initId });
			action.setCallback(this, getAssessmentCallback);
			$A.enqueueAction(action);
		}

		function getAssessmentCallback(response) {
			var _this = this;

			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				(function () {
                  
					var assessmentSkills = response.getReturnValue(),
					    skillsToMaster = [],
					    skillsAlreadyMastered = [],
                        skillsOngoing = [];;
                    
                    cmp.set('v.alredyExistingSkills', response.getReturnValue());
                    
                    console.log('assessmentSkills FIRDTTTTTTTTT -- ',assessmentSkills);
                    
					assessmentSkills.forEach(function (skill) {
                        console.log('sikkkk -- ',skill.Session_Date_Time__c);
						skill.OwnerId__c = userId;
						if (skill.Complete__c) {
                            skill.resetMastery = false;
							skillsAlreadyMastered.push(skill);
                        } else if(skill.Session_Date_Time__c && Date.now() < Date.parse(skill.Session_Date_Time__c)){
                            skillsOngoing.push(skill);
                        } else {
                            skill.selected = false;
                            skill.alreadyMastered = false;
                            skillsToMaster.push(skill);
						}
					});
					console.log('skillsToMaster before: ', skillsToMaster);
					cmp.set('v.skillsToMaster', skillsToMaster);
                    cmp.set('v.skillsOngoing', skillsOngoing);
					console.log('skillsToMaster after: ', cmp.get('v.skillsToMaster'));
					cmp.set('v.skillsAlreadyMastered', skillsAlreadyMastered);
                    cmp.set('v.isLoading', false);
					_this.fireAssessmentSkillChangeEvent(cmp, skillsToMaster.concat(skillsAlreadyMastered).concat(skillsOngoing));
				})();
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
    
    AssessmentSaveClick: function AssessmentSaveClick(cmp, evt, h) {
        var _this = this;
        cmp.set('v.isLoading', true);
        var skillsToMaster = cmp.get('v.skillsToMaster'),
            skillsAlreadyMastered = cmp.get('v.skillsAlreadyMastered'),
            skillsOngoing = cmp.get('v.skillsOngoing');
        
        var masterskilllist = [];
        
        skillsAlreadyMastered.forEach(function (masterdskill) {
            if(masterdskill.resetMastery){
               // masterdskill.Complete__c = !masterdskill.resetMastery;
                var skill = {Complete__c: !masterdskill.resetMastery, 
                             Id:masterdskill.Id};
                masterskilllist.push(skill);
            }
            console.log('masterskilllist',masterskilllist);
        });
  
        if(masterskilllist.length > 0){
            var action = cmp.get('c.resetMasterySkills');
            action.setParams({ skillsJSON: JSON.stringify(masterskilllist)});
            action.setCallback(this, getAssessmentCallback);
            $A.enqueueAction(action);
            
            function getAssessmentCallback(response) {
                var _this = this;
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.isLoading', false);
                    _this.cancelNewSession(cmp);
                    console.log('Success' , state); 
                }else{
                    console.log('Fail' , state);  
                }
            }
        }else{
            cmp.set('v.isLoading', false);
            _this.cancelNewSession(cmp); 
        }
    },
    
    assessmentCancelClick: function assessmentCancelClick(cmp, evt, h) {

        var assessmentSkills = cmp.get('v.alredyExistingSkills');
        console.log('assessmentSkills -- ',assessmentSkills);
        _this.getAssessment(cmp);
    },
 
 	fireAssessmentSkillChangeEvent: function fireAssessmentSkillChangeEvent(cmp, assessmentSkills) {
		console.log('fireAssessmentSkillChangeEvent: ', assessmentSkills);
        
		var evt = cmp.getEvent('assessmentSkillChange');
		evt.setParams({ assessmentSkills: assessmentSkills });
		evt.fire();
	},
    cancelNewSession: function cancelNewSession(cmp) {
        var ANIMATION_DURATION = 200;
        var closeSessionEvent = $A.get('e.c:SC_CloseNewSession');
        cmp.set('v.isOpen', false);
        window.setTimeout($A.getCallback(function () {
            closeSessionEvent.fire();
        }), ANIMATION_DURATION);
    },
});