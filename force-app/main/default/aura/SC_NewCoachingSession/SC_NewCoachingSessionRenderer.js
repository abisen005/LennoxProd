({
	render: function render(cmp, helper) {
		var ret = this.superRender();
		setTimeout(function () {
			return cmp.set('v.isOpen', true);
		}, 0);
		return ret;
	}
});