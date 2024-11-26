({
	getCoachingSession: function getCoachingSession(cmp) {
		var sessionId = cmp.get('v.id'),
		    action = cmp.get('c.getCoachingSession');
		cmp.set('v.isLoading', true);
		action.setParams({ sessionId: sessionId });
		action.setCallback(this, getCoachingSessionCallback);
		$A.enqueueAction(action);

		function getCoachingSessionCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var session = response.getReturnValue();
				cmp.set('v.session', session);
				this.setIsCoach(cmp);
				this.setSessionNotes(cmp);
				this.setIsInPast(cmp);
				this.setHasAssessments(cmp);
                
                if(session.Is_Rescheduled_by_Cochee__c && cmp.get("v.isCoach")){
                    var rescheduledInviteModal = cmp.find('rescheduledInviteModal');
                    rescheduledInviteModal.toggleIsOpen();
                }                
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Coaching Session';
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
	getInitiativeQuestions: function getInitiativeQuestions(cmp) {
		var session = cmp.get('v.session'),
		    initiativeId = session ? session.Initiative__c : null,
		    isCoach = cmp.get('v.isCoach'),
		    isCoachee = !isCoach,
		    action = cmp.get('c.getInitiativeQuestions');
		action.setParams({ initiativeId: initiativeId, isCoach: isCoach, isCoachee: isCoachee });
		action.setCallback(this, getInitiativeQuestionsCallback);
		$A.enqueueAction(action);

		function getInitiativeQuestionsCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS') {
				var questions = response.getReturnValue();
				cmp.set('v.questions', questions);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the initiative questions';
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
	requestCoachingInfo: function requestCoachingInfo() {
		var evt = $A.get('e.c:SC_CoachingInfoRequest');
		evt.fire();
	},
	setIsCoach: function setIsCoach(cmp) {
		var coachingInfo = cmp.get('v.coachingInfo'),
		    session = cmp.get('v.session'),
		    coachUserId = session.Owner.Id,
		    currentUserId = void 0;
		if (coachingInfo) {
			currentUserId = coachingInfo.userId;
            console.log('coachUserId',coachUserId);
            console.log('currentUserId',currentUserId);
            cmp.set('v.UserId', coachingInfo.userId);

            var coachUserId = coachUserId.substring(0, 15);
            var currentUserId = currentUserId.substring(0, 15);
            
            console.log('coachUserId',coachUserId);
            console.log('currentUserId',currentUserId);
            
			cmp.set('v.isCoach', coachUserId === currentUserId);
            
		} else {
			this.requestCoachingInfo();
		}
	},


	/*
 	Structure session notes for the UI
 */
	setSessionNotes: function setSessionNotes(cmp) {
		var FOLLOW_THROUGH = 'Follow Through';
		var session = cmp.get('v.session'),
		    userId = cmp.get('v.coachingInfo.userId'),
		    isCoach = cmp.get('v.isCoach'),
		    sessionNotes = session.Coaching_Session_Notes__r || [],
		    sessionNoteCategories = void 0,
		    structuredSessionNotes = void 0,
		    followThroughNote = void 0;
		if (!isCoach) {
			sessionNotes = sessionNotes.filter(function (note) {
				return note.Type__c === 'Coach' || note.OwnerId === userId;
			});
			console.log('sessionNotes after filtering: ', sessionNotes);
		}
		sessionNoteCategories = sessionNotes.reduce(function (prevVal, curVal) {
			var category = curVal.Category__c;
			if (prevVal.indexOf(category) === -1) prevVal.push(category);
			return prevVal;
		}, []);
		structuredSessionNotes = sessionNoteCategories.map(function (category) {
			//structure the notes like this:
			// [{category: 'Objectives', notes: [note1, note2]}, ...]
			var noteObj = {};
			noteObj.category = category;
			noteObj.notes = sessionNotes.filter(function (note) {
				return note.Category__c === category;
			});
			return noteObj;
		}, []);
		structuredSessionNotes.forEach(function (note, index, arr) {
			if (note.category === FOLLOW_THROUGH) {
				followThroughNote = note;
				arr.splice(index, 1);
			}
		});
		cmp.set('v.followThroughNote', followThroughNote);
		console.log(followThroughNote);
		cmp.set('v.sessionNotes', structuredSessionNotes);
	},
	newAssignment: function newAssignment(cmp) {
		var COMPONENT_NAME = 'c:SC_NewAssignment';
		var isOpen = true,
		    assignees = cmp.get('v.session.Coaching_Session_Attendees__r').map(function (attendee) {
			return attendee.User__r;
		}),
		    sessionId = cmp.get('v.session.Id');
		$A.createComponent(COMPONENT_NAME, { isOpen: isOpen, assignees: assignees, sessionId: sessionId }, newAssignmentHandler);

		function newAssignmentHandler(newCmp) {
			if (cmp.isValid()) {
				var body = cmp.get('v.newAssignment');
				cmp.set('v.newAssignment', newCmp);
			}
		}
	},
	updateSessionDate: function updateSessionDate(cmp) {
		var action = cmp.get('c.updateCoachingSession'),
		    oldStartDate = cmp.get('v.session.Start_Date__c'),
		    oldDuration = cmp.get('v.session.Duration__c'),
		    newStartDate = cmp.get('v.sessionStartDate'),
		    newDuration = cmp.get('v.sessionDuration');
		
        if(oldStartDate == newStartDate && oldDuration == newDuration){
            alert('Please select different date or time than previous one');
            return;
        }
        
        if(!cmp.get("v.isCoach")){
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', true);            
        }else{
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', false);
        }
        cmp.set('v.session.Start_Date__c', newStartDate);
		cmp.set('v.session.Duration__c', newDuration);
        

        action.setParams({ session: cmp.get('v.session'), IsReschedule : true });
		action.setCallback(this, updateCoachingSessionCallback);
		$A.enqueueAction(action);
        var _this = this;
		function updateCoachingSessionCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var rescheduleModalCmp = cmp.find('rescheduleModal');
				rescheduleModalCmp.toggleIsOpen();
                if(!cmp.get("v.isCoach")){                    
                    _this.updateAttendeeStatus(cmp, 'Rescheduled', false);
                }else{
                    _this.updateAttendeeStatus(cmp,"Hasn't Responded", true);
                }
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error updating the Note';
				cmp.set('v.session.Start_Date__c', oldStartDate);
				cmp.set('v.session.Duration__c', oldDuration);
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
	validateRescheduleForm: function validateRescheduleForm(cmp) {
		var dateInputCmp = cmp.find('sessionDate'),
		    durationInputCmp = cmp.find('sessionDuration');
		return this.hasValue(dateInputCmp) && this.hasValue(durationInputCmp);
	},
	hasValue: function hasValue(inputCmp) {
		var inputCmpVal = inputCmp.get('v.value');
		if (typeof inputCmpVal === 'number') inputCmpVal = inputCmpVal.toString();
		if (!inputCmpVal || !inputCmpVal.length) {
			inputCmp.set('v.errors', [{ message: 'This field is required' }]);
			return false;
		} else {
			inputCmp.set('v.errors', null);
			return true;
		}
	},
	deleteCoachingSession: function deleteCoachingSession(cmp) {
		var action = cmp.get('c.deleteCoachingSession'),
		    sessionId = cmp.get('v.session.Id');
            dateTime = cmp.get('v.session.Start_Date__c');
            var dateTime = dateTime.replace("T", " ").replace("Z"," ");
           console.log('date tie -- '+dateTime);
        action.setParams({ sessionId: sessionId, sessionStartDate: dateTime  });
		action.setCallback(this, deleteCoachingSessionCallback);
		$A.enqueueAction(action);

		function deleteCoachingSessionCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				this.navigateBack();
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error deleting the Coaching Session';
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


/*
 	Set isInPast to true or false based on session start date
 */
	setIsInPast: function setIsInPast(cmp) {
		var NOW = +new Date(),
		    SESSION_DATE = +new Date(cmp.get('v.session.Start_Date__c')),
		    IS_IN_PAST = false;
        
        var currentDate = new Date();
        var parsedSessionDate = Date.parse(cmp.get('v.session.Start_Date__c'));
        var Sessiondate = new Date(parsedSessionDate); 
        
        if(Sessiondate.getYear() <= currentDate.getYear() && 
           Sessiondate.getMonth() <= currentDate.getMonth() &&
           Sessiondate.getDate() <= currentDate.getDate())
        {
            IS_IN_PAST= true;
        }
        
		cmp.set('v.isInPast', IS_IN_PAST);
	},
    
	setHasAssessments: function setHasAssessments(cmp) {
		var ASSESSMENTS = cmp.get('v.session.Assessments__r'),
		    HAS_ASSESSMENTS = !$A.util.isUndefinedOrNull(ASSESSMENTS);
		console.log({ session: cmp.get('v.session'), ASSESSMENTS: ASSESSMENTS, HAS_ASSESSMENTS: HAS_ASSESSMENTS });
		cmp.set('v.hasAssessments', HAS_ASSESSMENTS);
	},
	navigateBack: function navigateBack() {
		var routeChangeEvt = $A.get('e.c:routeNavBack'),
		    routerName = '';
		routeChangeEvt.setParams({ routerName: routerName });
		routeChangeEvt.fire();
	},
	fireStartNewSessionEvent: function fireStartNewSessionEvent(cmp, hidePlanningSteps, planningOnly) {
		var users = cmp.get('v.session.Coaching_Session_Attendees__r').map(function (attendee) {
			return attendee.User__r;
		}),
		    initiative = cmp.get('v.session.Initiative__r'),
		    session = cmp.get('v.session'),
		    evt = $A.get('e.c:SC_StartNewCoachingSession');
		console.log({ users: users, initiative: initiative, hidePlanningSteps: hidePlanningSteps, planningOnly: planningOnly, session: session });
		evt.setParams({ initiative: initiative, users: users, hidePlanningSteps: hidePlanningSteps, planningOnly: planningOnly, session: session });
		evt.fire();
	},
	checkIfAssigneeHasAccepted: function checkIfAssigneeHasAccepted(cmp) {
		var userId = cmp.get('v.coachingInfo').userId,
		    sessionAttendees = cmp.get('v.session').Coaching_Session_Attendees__r.map(function (attendee) {
			return attendee.User__c;
		});
        
       /* for(index = 0; index < sessionAttendees.length; index++){
            sessionAttendees[index] = sessionAttendees[index].substr(0, 15);
        }*/
        
		if (sessionAttendees.indexOf(userId) > -1) {
			var action = cmp.get('c.checkIfAttendeeAccepted'),
			    sessionId = cmp.get('v.id');
			action.setParams({ sessionId: sessionId, userId: userId });
			action.setCallback(this, checkIfAttendeeAcceptedCallback);
			$A.enqueueAction(action);
		};
		function checkIfAttendeeAcceptedCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var returnVal = response.getReturnValue();
                console.log('returnVal', returnVal);
                console.log('returnVal.length ', returnVal.length );
				if (returnVal.length > 0) {
                    console.log('returnVal.length INNN ', returnVal.length );
					var acceptInviteModal = cmp.find('acceptInviteModal');
					acceptInviteModal.toggleIsOpen();
					cmp.set('v.relationId', returnVal);
				}
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error delchecking if you have accepted or declined the invite.';
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
	respondToInvite: function respondToInvite(cmp, isAccepted) {
		var action = cmp.get('c.respondToInvite'),
		    relationId = cmp.get('v.relationId'),
            sessionId = cmp.get('v.id'),
		    acceptInviteModal = cmp.find('acceptInviteModal');
        action.setParams({ isAccepted: isAccepted, relationId: relationId, sessionId: sessionId});
		$A.enqueueAction(action);
         console.log('Action Completed');
		acceptInviteModal.toggleIsOpen();
	},
    updateAttendeeStatus: function updateAttendeeStatus(cmp, status, isUpdateAll) {
        
        if( status == 'Rescheduled and Accepted by Coach'){
            var action = cmp.get('c.updateAttendeeStatus'),
                sessionId = cmp.get('v.session.Id');
            var userId = cmp.get('v.coachingInfo').userId;
            action.setParams({ status: status, sessionId: sessionId, userId:userId, isUpdateAll:isUpdateAll });
            $A.enqueueAction(action);
        }
	},

    
    updateSession: function updateSession(cmp) {
		var action = cmp.get('c.updateCoachingSession');
        
        if(!cmp.get("v.isCoach")){
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', true);
        }else{
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', false);
        }
        
        console.log('session'+ cmp.get('v.session'));
        action.setParams({ session: cmp.get('v.session'), IsReschedule : false });
		action.setCallback(this, updateCoachingSessionCallback);
		$A.enqueueAction(action);
        var _this = this;
		function updateCoachingSessionCallback(response) {
			var state = response.getState();
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				console.log('state'+ state);
                _this.updateAttendeeStatus(cmp, 'Rescheduled and Accepted by Coach', true);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error updating the Note';
				cmp.set('v.session.Start_Date__c', oldStartDate);
				cmp.set('v.session.Duration__c', oldDuration);
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
});