({

	getScorecardConfig: function(cmp) {
		var action = cmp.get('c.getScorecardConfig');

		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === 'SUCCESS') {
				var result = response.getReturnValue();
				cmp.set('v.wrap', result.wrap);
				cmp.set('v.wrapList', result.wrapList);
				cmp.set('v.mode', result.mode);
				cmp.set('v.goalTableCaption', result.goalTableCaption);
				console.log('result: ', result);
			} else if (state === 'INCOMPLETE') {
				this._handleError('You are offline.');
			} else if (state === 'ERROR') {
				this._handleServerError(response);
			}
		});

		$A.enqueueAction(action);
	},

	/**
	* Handle server response and show error toast
	*/
	_handleServerError: function(response) {
		var errors = response.getError();
		if(errors) {
			if(errors[0] && errors[0].message) {
				this._showToast('Error', 'error', errors[0].message);
			}
		} else {
			this._showToast('Error', 'error', 'Unknown error');
		}
	},

	/**
	* Handle error messages
	*/
	_handleError: function(errorMsg) {
		this._showToast('Error', errorMsg, 'error');
	},

	/**
	* Handle success messages
	*/
	_handleSuccess: function(errorMsg) {
		this._showToast('Success', errorMsg, 'success');
	},

	/**
	* Display toast message
	*/
	_showToast: function(title, message, type) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type,
			mode: 'sticky'
		});
		toastEvent.fire();
	}

})