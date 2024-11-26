({
	handleInit: function(cmp, event, helper) {
        var firstDate = cmp.get('v.firstDate'),
            secondDate = cmp.get('v.secondDate') ? new Date(cmp.get('v.secondDate')) : new Date(),
			daysBetween;
        if(firstDate) {
            firstDate = new Date(cmp.get('v.firstDate'));
            daysBetween = Math.round((secondDate-firstDate)/(1000*60*60*24));
        } else {
            daysBetween = 0;
        }
        cmp.set('v.value', daysBetween);
	}
})