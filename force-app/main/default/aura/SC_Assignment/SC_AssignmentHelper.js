({
	getAssignment: function getAssignment(cmp) {
		var assignmentId = cmp.get('v.assignmentId');
		if (!assignmentId) return;
		console.log('get assignment');
		var action = cmp.get('c.getAssignment');
		action.setParams({ assignmentId: assignmentId });
		action.setCallback(this, getAssignmentCallback);
		$A.enqueueAction(action);

		function getAssignmentCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var assignment = response.getReturnValue();
				console.log('assignment ', assignment);
				cmp.set('v.assignment', assignment);
				cmp.set('v.assignmentProgress', assignment.Progress__c);
				cmp.set('v.assignmentNumberComplete', assignment.Complete__c);
				this.setAssignmentVisibility(cmp);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Assignment';
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


	/*
 * Set isAssignee and isCoach
 */
	setAssignmentVisibility: function setAssignmentVisibility(cmp) {
		var assignment = cmp.get('v.assignment'),
		    coachingInfo = cmp.get('v.coachingInfo'),
		    isAssignee = void 0,
		    isCoach = void 0;
		console.log('assignment: ', assignment);
		if (!assignment || !coachingInfo) return;
		isAssignee = assignment.Assignee__c === coachingInfo.userId;
		isCoach = assignment.OwnerId === coachingInfo.userId;
		cmp.set('v.isAssignee', isAssignee);
		cmp.set('v.isCoach', isCoach);
	},
	editAssignment: function editAssignment(cmp) {
		var recordId = cmp.get('v.assignmentId'),
		    editRecordEvt = $A.get('e.force:editRecord');
		if (editRecordEvt) {
			editRecordEvt.setParams({ recordId: recordId });
			editRecordEvt.fire();
		} else {
			console.log(document.location);
			document.location.href = '/' + recordId + '/e?retURL=%2F' + recordId;
		}
	},


	/*
 * Update the progress of the assignment by the provided updateBy value
 */
	updateAssignmentProgress: function updateAssignmentProgress(cmp, increment) {
		console.log('updateAssignmentProgress');
		var COMPLETE_STATUS = 'Complete';
		var INCOMPLETE_STATUS = 'Incomplete';
		var action = cmp.get('c.updateAssignmentProgress'),
		    assignment = cmp.get('v.assignment'),
		    updateBy = increment ? 1 : -1,
		    progress = (assignment.Complete__c + updateBy) / assignment.to_Complete__c * 100;

		if (progress === 100) {
			assignment.Status__c = COMPLETE_STATUS;
		} else {
			assignment.Status__c = INCOMPLETE_STATUS;
		}

		action.setParams({ assignment: assignment, increment: increment });
		action.setCallback(this, updateAssignmentProgressCallback);
		$A.enqueueAction(action);

		cmp.set('v.assignmentProgress', progress);
		cmp.set('v.assignmentNumberComplete', assignment.Complete__c + updateBy);

		function updateAssignmentProgressCallback(response) {
			var state = response.getState();

			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var _assignment = response.getReturnValue();
				//assignment.Progress__c = (assignment.Complete__c / assignment.to_Complete__c) * 100;
				console.log('assignment ', _assignment);
				cmp.set('v.assignment', _assignment);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error updating the Assignment',
				    _progress = assignment.Complete__c / assignment.to_Complete__c * 100;
				//there was an error saving, so set the progress back to what it was
				if (_progress === 100) {
					assignment.Status__c = COMPLETE_STATUS;
				} else {
					assignment.Status__c = INCOMPLETE_STATUS;
				}
				cmp.set('v.assigment', assignment);
				cmp.set('v.assignmentProgress', _progress);
				cmp.set('v.assignmentNumberComplete', assignment.Complete__c);
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
 * Mark the assignment as completed
 */
	completeAssignment: function completeAssignment(cmp) {
		var action = cmp.get('c.completeAssignment'),
		    assignment = cmp.get('v.assignment');
		action.setParams({ assignment: assignment });
		action.setCallback(this, completeAssignmentCallback);
		$A.enqueueAction(action);

		function completeAssignmentCallback(response) {
			var state = response.getState();

			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var _assignment2 = response.getReturnValue();
				cmp.set('v.assignmentProgress', 100);
				cmp.set('v.assignmentNumberComplete', _assignment2.Complete__c);
				cmp.set('v.assignment', _assignment2);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error updating the Assignment';
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
	updateFollowupNotes: function updateFollowupNotes(cmp) {
		var action = cmp.get('c.updateAssignment'),
		    followUpNotesVal = cmp.get('v.editingNoteValue'),
		    assignment = cmp.get('v.assignment'),
		    oldNote = cmp.get('v.assignment.Follow_Up_Notes__c');
		cmp.set('v.assignment.Follow_Up_Notes__c', followUpNotesVal);
		console.log('assignment ', assignment);
		action.setParams({ assignment: assignment });
		action.setCallback(this, updateFollowUpNotesCallback);
		$A.enqueueAction(action);
		cmp.set('v.isEditingNote', false);
		cmp.set('v.isLoading', false);
		function updateFollowUpNotesCallback(response) {
			var state = response.getState(),
			    isSuccess = response.getReturnValue();

			if (cmp.isValid() && state === 'SUCCESS' && isSuccess) {
				cmp.set('v.assignment', assignment);
			} else {
				alert('There was a problem saving the note.');
				cmp.set('v.assignment.Follow_Up_Notes__c', oldNote);
			}
		}
	}
});