({
	updateSessionNote: function updateSessionNote(cmp) {
		var sessionNote = cmp.get('v.note'),
		    oldNoteValue = sessionNote.Note__c,
		    newNoteValue = cmp.get('v.editingNoteValue'),
		    action = cmp.get('c.updateSessionNote');
        
        console.log('sessionNote',sessionNote);
        console.log('oldNoteValue',oldNoteValue);
        console.log('newNoteValue',newNoteValue);
        
		cmp.set('v.note.Note__c', newNoteValue);
		sessionNote = cmp.get('v.note');
		action.setParams({ sessionNote: sessionNote });
		action.setCallback(this, updateSessionNoteCallback);
		$A.enqueueAction(action);

		function updateSessionNoteCallback(response) {
			var state = response.getState();
            
            console.log('response.getReturnValue()',response.getReturnValue());
            
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var _sessionNote = response.getReturnValue();
				cmp.set('v.note', _sessionNote.Note__c);
				cmp.set('v.editingNoteValue', _sessionNote.Note__c);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error updating the Note';
				cmp.set('v.note.Note__c', oldNoteValue);
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
			cmp.set('v.note', sessionNote);
			cmp.set('v.isEditing', false);
			cmp.set('v.isLoading', false);
		}
	}
});