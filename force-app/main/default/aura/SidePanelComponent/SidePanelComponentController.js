({
	handleInit : function(cmp, evt, h) {
		h.loadInstructions(cmp);
	},

	hidePanel : function(cmp, evt, h) {
		cmp.set('v.isOpen', false);
	}
})