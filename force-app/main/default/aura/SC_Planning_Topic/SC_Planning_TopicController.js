({
	handleInit: function handleInit(cmp, evt, h) {
		var assigneeIds = cmp.get('v.assignees') || [].map(function (assignee) {
			return assignee.Id;
		});
		cmp.set('v.assigneeIds', assigneeIds);
		h.parseTopics(cmp);
	},
	handleEditStrategyPress: function handleEditStrategyPress(cmp, evt, helper) {
		evt.preventDefault();
		var isEditingNote = cmp.get('v.isEditingNote'),
		    strategy = cmp.get('v.strategy');
		cmp.set('v.isEditingNote', !isEditingNote);
		if (strategy) cmp.set('v.editingStrategyValue', strategy);
	},
	handleSaveStrategyPress: function handleSaveStrategyPress(cmp, evt, h) {
		cmp.set('v.isLoadingNote', true);
		h.saveStrategy(cmp);
	},
	handleNewAssignmentPress: function handleNewAssignmentPress(cmp, evt, h) {
		h.newAssignment(cmp);
	},
	handleAssignmentCreated: function handleAssignmentCreated(cmp, evt, h) {
		var userAssignmentsCmp = cmp.find('userAssignments');
		userAssignmentsCmp.refresh();
	}
});