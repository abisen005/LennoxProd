({
	afterRender: function afterRender(cmp, h) {
		this.superAfterRender(), $A.util.removeClass(cmp, 'uiButton--default uiButton');
	}
});