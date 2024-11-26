({
	firePressEvent: function firePressEvent(cmp) {
		var pressEvent = $A.get('e.c:SC_ListItemActionPress');
		pressEvent.setParams({
			param: cmp.get('v.param'),
			label: cmp.get('v.label')
		});
		pressEvent.fire();
	}
});