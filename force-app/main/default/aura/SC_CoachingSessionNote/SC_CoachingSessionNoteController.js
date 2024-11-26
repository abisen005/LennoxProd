({
	handleInit: function handleInit(cmp, evt, h) {
		var note = cmp.get('v.note');
        var userId = cmp.get('v.userId'); 
       // var noteOwner = cmp.get('v.note.OwnerId').substring(0, 15);
        var noteOwner = cmp.get('v.note.OwnerId');
        cmp.set('v.noteOwner', noteOwner);
        cmp.set('v.isMyNote', userId === noteOwner);
		if (!note.Note__c) {
			note.Note__c = '';
			cmp.set('v.note', note);
		}
	},
	handleEditPress: function handleEditPress(cmp, evt, h) {
		evt.preventDefault();
		var isEditing = cmp.get('v.isEditing'),
		    note = cmp.get('v.note');
		console.log('note: ', note);
		cmp.set('v.isEditing', !isEditing);
		if (note.Note__c) cmp.set('v.editingNoteValue', note.Note__c);
	},
	handleSavePress: function handleSavePress(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		h.updateSessionNote(cmp);
	}
});