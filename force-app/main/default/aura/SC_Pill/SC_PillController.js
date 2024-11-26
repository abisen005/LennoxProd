({
	handleToggleSelectedPress: function handleToggleSelectedPress(cmp, evt, h) {
		var isSelected = cmp.get('v.selected');
		cmp.set('v.selected', !isSelected);
	}
});