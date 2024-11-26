({
	handleGetOpportunityScorecard: function(cmp, helper, response) {
        var status,
            lastChangedDate,
            lastChangeUTCDate,
            today,
            todayUTC,
            daysSinceUpdate,
            account;
        
        if(response) {
            account = response.Account__r;
            lastChangedDate = new Date(response.Last_Changed_Date__c);
            lastChangeUTCDate = Date.UTC(lastChangedDate.getFullYear(), lastChangedDate.getMonth(), lastChangedDate.getDate());
            today = new Date();
            todayUTC = Date.UTC(today.getFullYear(), today.getMonth(), today.getDate());
            daysSinceUpdate = Math.floor((todayUTC - lastChangeUTCDate) / (1000 * 60 * 60 * 24));
            cmp.set('v.scorecardUpToDate', daysSinceUpdate < 90);
            cmp.set('v.scorecard', response);
            cmp.set('v.chartLabel', (response.Percent_of_Purchases_that_are_Lennox__c || 0).toFixed(0) + '%');
            cmp.set('v.shareOfWallet', response.Percent_of_Purchases_that_are_Lennox__c);
            cmp.set('v.createScorecardLink', '/a06/e?CF00N80000002nJnk=' + encodeURIComponent(account.Name) + '&CF00N80000002nJnk_lkid=' + account.Id + '&retURL=%2F' + account.Id)
            if(response.Percent_of_Purchases_that_are_Lennox__c >= 75) {
                status = 'success';
            } else if(response.Percent_of_Purchases_that_are_Lennox__c >= 50) {
                status = 'warning';
            } else {
                status = 'error';
            }
            cmp.set('v.status', status);
        } else {
            cmp.set('v.shareOfWallet', 0);
            cmp.set('v.chartLabel', '0%');
        }
	}
})