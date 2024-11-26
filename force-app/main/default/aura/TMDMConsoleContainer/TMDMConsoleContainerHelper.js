({
	setAccountCategory: function(cmp, helper, acc) {
        var territoryNumber = parseInt(acc.SAP_Sales_Group__c),
            accountCategory;
        if(!isNaN(territoryNumber)) {
            if(territoryNumber >= 200 && territoryNumber <= 599) {
                
                if(acc.Segmentation__c && (acc.Segmentation__c.substring(0, 1) === 'K' || acc.Segmentation__c.substring(0, 1) === 'P')) {
                    //'Key and Priority Dealer';
                    accountCategory = 3;
                } else {
                    //'TM Owned Dealer';
                    accountCategory = 2;
                }
            } else {
                //'Other';
                accountCategory = 1;
            }
            cmp.set('v.accountCategory', accountCategory);
        }
	}
})