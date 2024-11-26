({

	loadInstructions : function(cmp) {
		let action = cmp.get('c.getInstructions'),
			formType = cmp.get('v.formType');
		action.setParams({formType: formType});
		action.setCallback(this, function(response) {
			let state = response.getState();
			if(state == 'SUCCESS') {
				let result = response.getReturnValue();
				if(result) {
					console.log('instructions loaded: ' + formType);
					cmp.set('v.data', result);
					cmp.set('v.isLoading', false);
				} else {
					//this._showToast(cmp, 'Error', response, 'error');
					cmp.set('v.isLoading', false);
				}
			} else {
				//this._showToast(cmp, 'Server Error', response, 'error');
				cmp.set('v.isLoading', false);
			}
		});
		$A.enqueueAction(action);
	},
	
})