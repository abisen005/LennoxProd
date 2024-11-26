({
	toggleIsOpen: function toggleIsOpen(cmp) {
		var isOpen = cmp.get('v.isOpen');
		cmp.set('v.isOpen', !isOpen);
	}
});