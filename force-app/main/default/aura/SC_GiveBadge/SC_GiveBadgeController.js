({
	handleIsOpenChange: function handleIsOpenChange(cmp, evt, h) {
		var isOpen = cmp.get('v.isOpen');
		if (isOpen) {
			h.getBadges(cmp);
		} else {
			h.resetGiveBadge(cmp);
		}
	},
	handleQueryKeyup: function handleQueryKeyup(cmp, evt, h) {
		var value = evt.srcElement.value;
		console.log('handleQueryKeyup', value);
		cmp.set('v.badgeQueryString', value);
	},
	handleBadgeQueryStringChange: function handleBadgeQueryStringChange(cmp, evt, h) {
		var isFiltering = cmp.get('v.isFiltering');
		console.log('handleBadgeQueryStringChange', isFiltering);
		if (!isFiltering) {
			cmp.set('v.isFiltering', true);
			window.setTimeout($A.getCallback(function () {
				if (cmp.isValid()) {
					h.filterBadges(cmp);
					cmp.set('v.isFiltering', false);
				}
			}), 500);
		}
	},
	handleBadgePress: function handleBadgePress(cmp, evt, h) {
		console.log('handleBadgePress');
		evt.preventDefault();
		var badgeId = void 0,
		    activeBadge = void 0;
		console.log(evt.target.dataset.badgeId);
		badgeId = evt.target.dataset.badgeId;
		activeBadge = cmp.get('v.badges').find(function (badge) {
			return badge.Id === badgeId;
		});
		console.log('badgeId', badgeId);
		console.log('activeBadge', activeBadge);
		cmp.set('v.activeBadge', activeBadge);
	},
	handleBackPress: function handleBackPress(cmp, evt, h) {
		cmp.set('v.activeBadge', undefined);
	},
	handleCancelPress: function handleCancelPress(cmp, evt, h) {
		cmp.set('v.isOpen', false);
	},
	handleDonePress: function handleDonePress(cmp, evt, h) {
		cmp.set('v.isOpen', false);
	},
	handleGiveBadgePress: function handleGiveBadgePress(cmp, evt, h) {
		h.giveBadge(cmp);
	}
});