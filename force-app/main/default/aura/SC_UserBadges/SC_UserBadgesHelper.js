({
	getBadges: function getBadges(cmp) {
		var action = cmp.get('c.getUserBadges'),
		    userId = cmp.get('v.userId'),
		    limit = cmp.get('v.limit'),
		    queryLimit = cmp.get('v.limit') + 1,
		    //query 1 additional row to know if there are more to load
		offset = cmp.get('v.offset');

		cmp.set('v.isLoading', true);
		action.setParams({ userId: userId, queryLimit: queryLimit, offset: offset });
		action.setCallback(this, getBadgesCallback);
		$A.enqueueAction(action);

		function getBadgesCallback(response) {

			var state = response.getState();
			cmp.set('v.isLoading', false);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var badgesResponse = response.getReturnValue(),
				    badges = cmp.get('v.userBadges'),
				    hasMoreRecords = badgesResponse.length - offset > limit;
				cmp.set('v.hasMoreRecords', hasMoreRecords);
				if (hasMoreRecords) badgesResponse.pop();
				badges = badges.concat(badgesResponse);
				console.log('badges', badges);
				cmp.set('v.userBadges', badges);
				console.log('get v.userBadges: ', cmp.get('v.userBadges'));
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error getting the Badges';
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
	}
});