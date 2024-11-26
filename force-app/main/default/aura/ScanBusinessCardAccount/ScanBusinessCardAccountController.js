({
	handleAccountPress: function(cmp, evt, h) {
		evt.preventDefault();

		var selectedEvt = $A.get('e.c:ScanBusinessCardEvent'),
			account = cmp.get('v.account');
		selectedEvt.setParams({
			type: 'ACCOUNT_SELECTED',
			payload: {
				account: account
			}
		});
		selectedEvt.fire();

	}
})