({
	handleInit: function handleInit(cmp, evt, h) {
		var Assignee = {
			init: function init(Id, Name, SmallPhotoUrl) {
				this.selected = false;
				this.Id = Id;
				this.Name = Name;
				this.SmallPhotoUrl = SmallPhotoUrl;
			}
		};

		var assignees = cmp.get('v.assignees').map(function (user) {
			var Id = user.Id;
			var Name = user.Name;
			var SmallPhotoUrl = user.SmallPhotoUrl;

			var assignee = Object.create(Assignee);
			assignee.init(Id, Name, SmallPhotoUrl);
			return assignee;
		}),
		    sessionId = cmp.get('v.sessionId'),
		    topicId = cmp.get('v.topicId');
		if (assignees.length === 1) assignees[0].selected = true;
		cmp.set('v.assignees', assignees);
		cmp.set('v.assignment.Coaching_Session__c', sessionId);
		cmp.set('v.assignment.Planning_Topic__c', topicId);
	},
	handleClosePress: function handleClosePress(cmp, evt, h) {
		h.toggleIsOpen(cmp);
	},
	handleCancelPress: function handleCancelPress(cmp, evt, h) {
		h.toggleIsOpen(cmp);
	},
	handleSavePress: function handleSavePress(cmp, evt, h) {
		if (h.validateForm(cmp)) h.createAssignments(cmp);
	}
});