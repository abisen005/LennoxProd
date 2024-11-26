({
	handleGetOpportunityScorecard: function(cmp, helper, response) {
        var gradeStatusMap = {
            'No Grade - Incomplete': 'error',
            'A': 'success',
            'B': 'success',
            'C': 'warning',
            'D': 'error',
            'F': 'error'
        };

        cmp.set('v.scorecard', response);

        if(response) {
            var daysBetween = cmp.find('daysSinceUpdate').get('v.value');
            cmp.set('v.status', gradeStatusMap[response.Scorecard_Grade__c]);
            cmp.set('v.daysSinceUpdate', daysBetween);
            
            if(daysBetween <= 60) {
                cmp.set('v.secondaryStatus', 'success');
            } else if(daysBetween <= 90) {
                cmp.set('v.secondaryStatus', 'warning');
            } else {
                cmp.set('v.secondaryStatus', 'error');
            }
        } else {
            cmp.set('v.status', 'error');
        }
	}
})