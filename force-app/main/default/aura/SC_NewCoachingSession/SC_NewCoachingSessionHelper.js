({
	changeStep: function changeStep(cmp, isNext) {
		var steps = cmp.get('v.wizardSteps'),
		    activeIndex = void 0,
		    activeTitle = void 0,
		    nextIndex = void 0;
		steps.some(function (step) {
			if (step.active) {
				activeIndex = step.index;
				activeTitle = step.title;
				step.setActive(false);
				return true;
			}
			return false;
		});
		switch (activeTitle) {
			case $A.get('$Label.c.SC_SelectEmployees'):
				this.setUsers(cmp);
				break;
		}
		nextIndex = isNext ? activeIndex + 1 : activeIndex - 1;
		steps[nextIndex].setActive(true);
		cmp.set('v.wizardSteps', steps);
		this.setActiveStep(cmp);
	},
	nextStep: function nextStep(cmp) {
		this.changeStep(cmp, true);
	},
	lastStep: function lastStep(cmp) {
		this.changeStep(cmp, false);
	},
	cancelNewSession: function cancelNewSession(cmp) {
		var ANIMATION_DURATION = 200;
		var closeSessionEvent = $A.get('e.c:SC_CloseNewSession');
		cmp.set('v.isOpen', false);
		window.setTimeout($A.getCallback(function () {
			closeSessionEvent.fire();
		}), ANIMATION_DURATION);
	},
	setUpSteps: function setUpSteps(cmp) {

		var Step = {
			init: function init(title, description) {
				var valid = arguments.length <= 2 || arguments[2] === undefined ? false : arguments[2];

				this.title = title;
				this.description = description;
				this.valid = valid;
			},

			active: false,
			valid: false,
			index: undefined,
			setActive: function setActive(isActive) {
				this.active = isActive;
			}
		};

		var initiativeStep = Object.create(Step),
		    usersStep = Object.create(Step),
		    reviewStep = Object.create(Step),
		    assessStep = Object.create(Step),
		    scheduleStep = Object.create(Step);
		reviewStep.init($A.get('$Label.c.SC_Review'), $A.get('$Label.c.SC_ReviewDescription'), true);
		assessStep.init($A.get('$Label.c.SC_Assess'), $A.get('$Label.c.SC_AssessDescription'), true);
		scheduleStep.init($A.get('$Label.c.SC_Schedule'), $A.get('$Label.c.SC_ScheduleDescription'), false);

		var init = cmp.get('v.initiative'),
		    users = cmp.get('v.users'),
		    steps = [],
		    hidePlanningSteps = cmp.get('v.hidePlanningSteps'),
		    planningOnly = cmp.get('v.planningOnly');

		if (users.length === 0) {
			usersStep.init($A.get('$Label.c.SC_SelectEmployees'), $A.get('$Label.c.SC_SelectEmployeesDescription'), false);
			steps.unshift(usersStep);
			this.getCoachingInfo(); //coachinginfo has the coachees.. user will need to select from this list to proceed
		}

		if (init.Id === '') {
			initiativeStep.init($A.get('$Label.c.SC_SelectInitiative'), $A.get('$Label.c.SC_SelectInitiativeDescription'), false);
			steps.unshift(initiativeStep);
		}

		if (!hidePlanningSteps) steps.push(reviewStep, assessStep);
		if (!planningOnly) steps.push(scheduleStep);
		steps[0].setActive(true);
		cmp.set('v.wizardSteps', steps);
		this.setActiveStep(cmp);
	},
	setActiveStep: function setActiveStep(cmp) {

		var activeIndex = void 0,
		    activeStep = cmp.get('v.wizardSteps').find(function (step, index) {
			if (step.active) {
				activeIndex = index;
				return true;
			} else {
				return false;
			}
		});
		activeStep.index = activeIndex;

		cmp.set('v.activeStep', activeStep);
	},
	updateAssessments: function updateAssessments(cmp, evt) {

		//only sending data for one user at a time. need to update the ones for a single user
		//console.log(evt.getParam('assessmentSkills'));
		var newAssessmentSkills = evt.getParam('assessmentSkills'),
		    userId = newAssessmentSkills[0].OwnerId__c,
		    assessmentSkills = cmp.get('v.assessmentSkills'),
		    hasSkills = false;
        
        var isSkillSelectedforSchedule = false;
        var isSkillsModified = false;
        
		assessmentSkills.forEach(function (skill, i) {
			//newAssessmentSkill already in list, just need to be updated
			if (skill.OwnerId__c === userId) {
				hasSkills = true;
				newAssessmentSkills.forEach(function (newSkill) {
					if (newSkill.Description__c === skill.Description__c) {
						skill.Complete__c = newSkill.Complete__c;
					}
				});
			}
            if(skill.selected && !skill.alreadyMastered){
                isSkillSelectedforSchedule = true;
            }
            if(skill.selected || skill.alreadyMastered || skill.resetMastery){
                isSkillsModified = true;
            }
		});
		if (!hasSkills) {
			assessmentSkills = assessmentSkills.concat(newAssessmentSkills);
		}
        
        var wizardSteps = cmp.get('v.wizardSteps');
        if(isSkillsModified){
            wizardSteps[wizardSteps.length - 1].valid = !isSkillSelectedforSchedule;
        }else{
            wizardSteps[wizardSteps.length - 1].valid = false;
        }
        cmp.set('v.wizardSteps', wizardSteps);
        
        //console.log('assessmentSkills = ', assessmentSkills);
		cmp.set('v.assessmentSkills', assessmentSkills);
	},
      
	validateEventForm: function validateEventForm(cmp) {
		var dtVal = cmp.find('evtDateTime').get('v.value'),
		    durationVal = cmp.find('evtDuration').get('v.value'),
		    wizardSteps = cmp.get('v.wizardSteps');
		wizardSteps[wizardSteps.length - 1].valid = !$A.util.isEmpty(dtVal) && !$A.util.isEmpty(durationVal);
		cmp.set('v.wizardSteps', wizardSteps);
		this.setActiveStep(cmp);
	},
	createAssessments: function createAssessments(cmp) {
		console.log('createAssessments');
		console.log('cmp.get(session)', cmp.get('v.session'));
		var action = cmp.get('c.createAssessments'),
		    skillsJSON = JSON.stringify(cmp.get('v.assessmentSkills')),
		    sessionId = cmp.get('v.session.Id');
		cmp.set('v.isLoading', true);
		action.setParams({ skillsJSON: skillsJSON, sessionId: sessionId });
		action.setCallback(this, createAssessmentsCallback);
		$A.enqueueAction(action);

		function createAssessmentsCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var _sessionId = cmp.get('v.session.Id'),
				    sessionName = cmp.get('v.session.Name');
				cmp.set('v.isOpen', false);
				this.navigateToCoachingSession(_sessionId, sessionName);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error creating the Assessments';
				if (errors) {
					if (errors[0] && errors[0].message) {
						errorMsg = errors[0].message;
					}
				}
				if (errorResponse) errorMsg = errorResponse.message;
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
    
	createCoachingSession: function createCoachingSession(cmp) {
		var action = cmp.get('c.createCoachingSession'),
		    evt = JSON.stringify(cmp.get('v.sessionEvent')),		    
		    init = cmp.get('v.initiative'),
		    createAssessments = !cmp.get('v.hidePlanningSteps');

        // remove extra attributes from Sobject list
        this.removeExtraAttributes(cmp);
        var listSkills = cmp.get('v.assessmentSkills');
        var skills = JSON.stringify(listSkills);

		if (init.Initiative_Reports__r || init.Dashboard_Initiatives__r) {
			var newInit = {};
			newInit.Id = init.Id;
			newInit.Name = init.Name;
			init = newInit;
		}
		init = JSON.stringify(init);
		cmp.set('v.isLoading', true);
		action.setParams({ evt: evt, skills: skills, init: init, createAssessments: createAssessments });
		action.setCallback(this, createCoachingSessionCallback);
		$A.enqueueAction(action);

		function createCoachingSessionCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				//TODO: When a new session is created, update the upcomginSessions property of the
				//		coachingInfo object (or force it to be refreshed)

				var newSession = response.getReturnValue();
				console.log('newSession: ', newSession);
				cmp.set('v.isOpen', false);
				this.navigateToCoachingSession(newSession.Id, newSession.Name);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error creating the coaching session.';
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
    
    removeExtraAttributes : function(cmp){
        var listSkills = cmp.get('v.assessmentSkills');
        var selectedSessionDateTime = cmp.get('v.sessionEvent').StartDateTime;
        var _this = this;
        listSkills.forEach(function(skill){ 
            
            if(skill.selected){
                skill.Session_Date_Time__c = selectedSessionDateTime;
                //console.log('selectedSessionDateTime', selectedSessionDateTime);
            }
            if(skill.alreadyMastered){
                skill.Complete__c = true;
                skill.Session_Date_Time__c = null;
                skill.Date_Mastery_Achieved__c = _this.getTodayDate();
            }
            if(skill.resetMastery){
                skill.Complete__c = false;
                skill.Session_Date_Time__c = null;
                skill.Date_Last_Coached__c = skill.Date_Mastery_Achieved__c;
            }
            if(skill.selected || skill.alreadyMastered || skill.resetMastery){
                skill.Modified_for_Coaching_Session__c = true;
            }
            delete skill.selected;
            delete skill.alreadyMastered;
            delete skill.resetMastery;
        });
        cmp.set('v.assessmentSkills', listSkills);
    },
    
    
	navigateToCoachingSession: function navigateToCoachingSession(sessionId, label) {
		var routeChangeEvt = $A.get('e.c:routeChangeAttempt'),
		    routerName = '',
		    path = '/session/' + sessionId;
		routeChangeEvt.setParams({ routerName: routerName, path: path, label: label });
		routeChangeEvt.fire();
	},
	getInitReports: function getInitReports(cmp) {
        console.log('test --- getInitReports ');
		var initId = cmp.get('v.initiative').Id,
		    action = cmp.get('c.getInitReports'),
		    hidePlanningSteps = cmp.get('v.hidePlanningSteps');
		if (initId.length > 0 && !hidePlanningSteps) {
			action.setParams({ initId: initId });
			action.setCallback(this, getInitReportsCallback);
			$A.enqueueAction(action);
		}

		function getInitReportsCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var initiative = response.getReturnValue();
				if (initiative.Initiative_Reports__r) {
					var reportIds = initiative.Initiative_Reports__r.map(function (report) {
						return report.Report__c;
					}).join(),
					    formFactor = $A.get("$Browser.formFactor");
					cmp.set('v.reportIds', reportIds);
					cmp.set('v.reviewIframeSrc', '/apex/SC_DashboardReports?reportId=' + reportIds + '&formFactor=' + formFactor);
				}
				if (initiative.Dashboard_Initiatives__r) {
					var dashboardId = initiative.Dashboard_Initiatives__r[0].Dashboard__c;
					cmp.set('v.dashboardId', dashboardId);
				}
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Initiative reports';
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
	getCoachingInfo: function getCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	},
	setUsers: function setUsers(cmp) {
		var selectedUsers = cmp.get('v.availableUsers').filter(function (user) {
			return user.selected;
		});
		cmp.set('v.users', selectedUsers);
	},
    getTodayDate: function(){
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; 
        
        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        } 
        if (mm < 10) {
            mm = '0' + mm;
        } 
        return yyyy + '-' + mm + '-' + dd;
    }
});