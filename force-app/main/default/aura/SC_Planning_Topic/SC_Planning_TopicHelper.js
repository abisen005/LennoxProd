({
	saveStrategy: function saveStrategy(cmp) {
		var action = cmp.get('c.updateTopicStrategy'),
		    topicId = cmp.get('v.topicId'),
		    strategy = cmp.get('v.editingStrategyValue');
		action.setParams({ topicId: topicId, strategy: strategy });
		action.setCallback(this, saveStrategyCallback);
		$A.enqueueAction(action);

		function saveStrategyCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoadingNote', false);
			if (cmp.isValid() && state === 'SUCCESS' && response.getReturnValue()) {
				cmp.set('v.strategy', strategy);
				cmp.set('v.isEditingNote', false);
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorMsg = 'There was an unknown error updating the strategy.';
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
	newAssignment: function newAssignment(cmp) {
		var COMPONENT_NAME = 'c:SC_NewAssignment';
		var isOpen = true,
		    user = cmp.get('v.user'),
		    currentUser = { selected: true, Id: user.Id, Name: user.Name, SmallPhotoUrl: '' },
		    assignees = cmp.get('v.assignees').map(function (assignee) {
			var newAssignee = { selected: false, Id: assignee.Id, Name: assignee.Name, SmallPhotoUrl: assignee.SmallPhotoUrl };
			return newAssignee;
		}),
		    topicId = cmp.get('v.topicId');
		assignees.unshift(currentUser);
		$A.createComponent(COMPONENT_NAME, { isOpen: isOpen, assignees: assignees, topicId: topicId }, newAssignmentHandler);

		function newAssignmentHandler(newCmp) {
			console.log('new assignment callback');
			if (cmp.isValid()) {
				var body = cmp.get('v.newAssignment');
				cmp.set('v.newAssignment', newCmp);
			}
		}
	},
	parseTopics: function parseTopics(cmp) {
		var content = cmp.get('v.content');
            if(content){
              var textContent = content.filter(function (item) {
			return item.Type__c === 'Text';
		}),
		    urlContent = content.filter(function (item) {
			return item.Type__c === 'Url';
		});
		cmp.set('v.textContent', textContent);
		cmp.set('v.urlContent', urlContent);
            }
		    
	}
});