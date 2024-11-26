({
	handleInit: function handleInit(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		h.getAssignment(cmp);
		h.requestCoachingInfo();
	},
	handleAssignmentIdChange: function handleAssignmentIdChange(cmp, evt, h) {
		h.getAssignment(cmp);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
			h.setAssignmentVisibility(cmp);
		}
	},
	handleEditPress: function handleEditPress(cmp, evt, h) {
		var deleteModalCmp = cmp.find('editAssignmentModal');
		deleteModalCmp.toggleIsOpen();
	},
	handleCancelEditPress: function handleCancelEditPress(cmp, evt, h) {
		var deleteModalCmp = cmp.find('editAssignmentModal');
		deleteModalCmp.toggleIsOpen();
	},
	handleSavePress: function handleSavePress(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		cmp.find('editAssignment').get('e.recordSave').fire();
	},
	handleRecordSaveSuccess: function handleRecordSaveSuccess(cmp, evt, h) {
		var deleteModalCmp = cmp.find('editAssignmentModal');
		h.getAssignment(cmp);
		deleteModalCmp.toggleIsOpen();
	},
	handleIncrementPress: function handleIncrementPress(cmp, evt, h) {
		h.updateAssignmentProgress(cmp, true);
	},
	handleDecrementPress: function handleDecrementPress(cmp, evt, h) {
		h.updateAssignmentProgress(cmp, false);
	},
	handleCompletePress: function handleCompletePress(cmp, evt, h) {
		h.completeAssignment(cmp);
	},
	handleEditNotePress: function handleEditNotePress(cmp, evt, h) {
		evt.preventDefault();
		var isEditingNote = cmp.get('v.isEditingNote'),
		    note = cmp.get('v.assignment.Follow_Up_Notes__c');
		console.log('note: ', note);
		cmp.set('v.isEditingNote', !isEditingNote);
		if (note) cmp.set('v.editingNoteValue', note);
	},
	handleSaveNotePress: function handleSaveNotePress(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		h.updateFollowupNotes(cmp);
	}
});