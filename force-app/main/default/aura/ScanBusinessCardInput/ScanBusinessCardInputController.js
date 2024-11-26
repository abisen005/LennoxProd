({
	wordsChangeHandler: function(cmp, evt, h) {
		var type = cmp.get('v.type'),
			words = cmp.get('v.words'),
			word = words.find(function(word) {
				console.log('iterating over word ', word.type === type);
				return word.type === type;
			});
		if(word) cmp.set('v.value', word.value);
	},
	handleShowAvailableWordsPress: function(cmp, evt, h) {
		// var selectCmp = cmp.find('selectCmp').getElement(),
		// 	formFactor = cmp.get('v.formFactor');
		// console.log(selectCmp);
		cmp.set('v.isSelecting', true);
		// if(formFactor !== 'DESKTOP') {
		// 	selectCmp.focus();
		// } else {
		// 	cmp.set('v.isSelecting', true);
		// }
	},
	handleMenuSelect: function(cmp, evt, h) {
		var menuItem = evt.getSource();
		//cmp.set('v.value', menuItem.get('v.value'));

	},
	handleSelectChange: function(cmp, evt, h) {
		var selectVal = cmp.find('selectCmp').getElement().value;
		cmp.set('v.value', selectVal);
	},
	handleCloseModalPress: function(cmp, evt, h) {
		cmp.set('v.isSelecting', false);
	},
	handleWordButtonPress: function(cmp, evt, h) {
		var wordVal = evt.getSource().get('v.value'),
			val = cmp.get('v.value') || '';
		cmp.set('v.value', wordVal);
		cmp.set('v.isSelecting', false);
	},
	handleClearInputPress: function(cmp, evt, h) {
		cmp.set('v.value', '');
	}
})