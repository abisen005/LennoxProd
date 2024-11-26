({
	getInitiatives: function getInitiatives(cmp) {
		var action = cmp.get('c.getInitiatives'),
		    parentId = cmp.get('v.parentId'),
		    type = cmp.get('v.coachingInfo').type,
		    actionParams = { type: type, parentId: parentId };
		cmp.set('v.isLoading', true);
		action.setParams(actionParams);
		action.setStorable();
		action.setCallback(this, getInitiativesCallback);
		$A.enqueueAction(action);

		function getInitiativesCallback(response) {
			var state = response.getState(),
			    breadcrumbs = cmp.get('v.breadcrumbs'),
			    label = cmp.get('v.selectedInitiativeLabel') || 'Initiatives';
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS') {
				var initiatives = response.getReturnValue();
				if (initiatives.length > 0) {
					var _parentId = initiatives[0].Parent_Initiative__c;
					cmp.set('v.initiatives', response.getReturnValue());
					breadcrumbs.push({ parentId: _parentId, label: label });
					cmp.set('v.breadcrumbs', breadcrumbs);
				} else {
					var initiativeId = parentId,
					    initiativeName = label,
					    initEvt = cmp.getEvent('initiativeSelected');
					initEvt.setParams({ initiativeId: initiativeId, initiativeName: initiativeName });
					initEvt.fire();
				}
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error getting the Initiatives';
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
	}
});