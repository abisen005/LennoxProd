({
	handleSearchKeyup: function(cmp, event, helper) {
        var keyCode = event.getParams().keyCode,
            inputCmp = event.getSource(),
            searchVal = cmp.get('v.query');
        if(keyCode === 13) {
            if(searchVal.length === 0) {
                inputCmp.set('v.errors', [{message: 'Please enter a value.'}]);
            } else {
                inputCmp.set('v.errors', null);
                helper.handleSearchEnterPress(cmp, helper, searchVal);
            }
            
        }
	},
    
    handleAccountBtnPress: function(cmp, event, helper) {
        var recordId = event.getSource().get('v.param'),
            dealers = cmp.get('v.dealers'),
            selectedDealer = dealers.find(function(d) {return d.Id === recordId});
        var accName = event.getSource().getElement().innerText;
        cmp.set('v.isLoading', true);
        cmp.set('v.dealers', []);
        cmp.set('v.selectedDealer', selectedDealer);
        $A.createComponent('c:TMDMConsoleContainer', {accountId: recordId, isSf1: cmp.get('v.isSf1')}, function(consoleCmp) {
            if(cmp.isValid()) {
                var body = cmp.get('v.body');
                console.log(consoleCmp.get('v.accountId'));
                if(body[0]) {
                    body[0] == consoleCmp;
                } else {
                    body.push(consoleCmp);
                }
                cmp.set("v.body", body);
                cmp.set('v.isLoading', false);
            }
        })
        
    },
    
    handleViewDealerPress: function(cmp, event, helper) {
        var navEvt = $A.get('e.force:navigateToSObject'),
            recordId = cmp.get('v.selectedDealer').Id;
        if(navEvt) {
            navEvt.setParams({
                'recordId': recordId,
            });
            navEvt.fire();
        } else {
            document.location = '/' + recordId;
        }
    }
})