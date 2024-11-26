({
	getBadges: function getBadges(cmp) {
		var action = cmp.get('c.getBadges');
		action.setCallback(this, getBadgesCallback);
		$A.enqueueAction(action);
		cmp.set('v.isLoading', true);

		function getBadgesCallback(response) {

			var Badge = {
				Id: '',
				Name: '',
				Description: '',
				ImageUrl: '',
				isHidden: false,
				isSelected: false,
				init: function init(Id, Name, Description, ImageUrl) {
					this.Id = Id;
					this.Name = Name;
					this.Description = Description;
					this.ImageUrl = ImageUrl;
				},
				setIsHidden: function setIsHidden(isHidden) {
					this.isHidden = isHidden;
				},
				setIsSelected: function setIsSelected(isSelected) {
					this.isSelected = isSelected;
				}
			};

			var state = response.getState();
			cmp.set('v.isLoading', false);
			console.log('state: ', state);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var badges = response.getReturnValue();
				badges = badges.map(function (badge) {
					var newBadge = Object.create(Badge);
					newBadge.init(badge.Id, badge.Name, badge.Description, badge.ImageUrl);
					return newBadge;
				});
				cmp.set('v.badges', badges);
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
	},
	giveBadge: function giveBadge(cmp) {
		var action = cmp.get('c.giveBadge'),
		    badgeId = cmp.get('v.activeBadge.Id'),
		    recipientId = cmp.get('v.userId'),
		    thanksMsg = cmp.get('v.thanksMsg');
		action.setParams({ badgeId: badgeId, recipientId: recipientId, thanksMsg: thanksMsg });
		action.setCallback(this, giveBadgeCallback);
		$A.enqueueAction(action);

		cmp.set('v.isLoading', true);

		function giveBadgeCallback(response) {
			var state = response.getState();
			cmp.set('v.isLoading', false);
			console.log('state: ', state);
			if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
				var giveBadgeEvt = $A.get('e.c:SC_EvtBadgeGiven');
				cmp.set('v.isDone', true);
				console.log('fire giveBadgeEvt: ', giveBadgeEvt);
				giveBadgeEvt.fire();
			} else {
				var errorEvent = $A.get('e.force:showToast'),
				    errors = response.getError(),
				    errorResponse = response.getReturnValue(),
				    errorMsg = 'There was an unknown error giving the Badge';
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
	},
	filterBadges: function filterBadges(cmp) {
		var query = cmp.get('v.badgeQueryString'),
		    badges = cmp.get('v.badges');
		if (query.length > 0) {
			badges.forEach(function (badge, i) {
				var isAMatch = badge.Name.toUpperCase().indexOf(query.toUpperCase()) !== -1;
				badge.setIsHidden(!isAMatch);
			});
		} else {
			badges.forEach(function (badge, i) {
				badge.setIsHidden(false);
			});
		}
		cmp.set('v.badges', badges);
	},
	resetGiveBadge: function resetGiveBadge(cmp) {
		cmp.set('v.badges', []);
		cmp.set('v.activeBadge', undefined);
		cmp.set('v.isDone', false);
		cmp.set('v.badgeQueryString', '');
		cmp.set('v.thanksMsg', '');
	}
});