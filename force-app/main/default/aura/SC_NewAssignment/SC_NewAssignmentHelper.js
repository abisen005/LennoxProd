({
	createAssignments: function createAssignments(cmp) {
		var action = cmp.get('c.createAssignments'),
		    assignment = cmp.get('v.assignment'),
		    userIds = cmp.get('v.assignees').filter(function (user) {
			return user.selected;
		}).map(function (user) {
			return user.Id;
		});
		action.setParams({ assignment: assignment, userIds: userIds });
		action.setCallback(this, createAssignmentsCallback);
		$A.enqueueAction(action);
		cmp.set('v.isLoading', true);
		function createAssignmentsCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var newAssignments = response.getReturnValue();
				this.toggleIsOpen(cmp);
				this.fireAssignmentCreatedEvent(cmp);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error creating the Assignments';
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
	fireAssignmentCreatedEvent: function fireAssignmentCreatedEvent(cmp) {
		var evt = cmp.getEvent('newAssignmentCreated');
		evt.fire();
	},
	toggleIsOpen: function toggleIsOpen(cmp) {
		var isOpen = cmp.get('v.isOpen');
		cmp.set('v.isOpen', !isOpen);
	},
	validateForm: function validateForm(cmp) {
		var dueDateInput = cmp.find('dueDate'),
		    descriptionInput = cmp.find('descriptionInput');
		if (this.hasAssignees(cmp) && this.hasValue(dueDateInput) && this.hasValue(descriptionInput)) {
			return true;
		} else {
			return false;
		}
	},
	hasValue: function hasValue(inputCmp) {
		var inputCmpVal = inputCmp.get('v.value');
		if (!inputCmpVal || !inputCmpVal.length) {
			inputCmp.set('v.errors', [{ message: 'This field is required' }]);
			return false;
		} else {
			inputCmp.set('v.errors', null);
			return true;
		}
	},
	hasAssignees: function hasAssignees(cmp) {
		var hasAssignees = cmp.get('v.assignees').some(function (assignee) {
			return assignee.selected;
		});
		if (!hasAssignees) {
			cmp.set('v.missingAssigneesError', 'Please select at least one User for this Assignment');
			return false;
		} else {
			cmp.set('v.missingAssigneesError', null);
			return true;
		}
	}
});