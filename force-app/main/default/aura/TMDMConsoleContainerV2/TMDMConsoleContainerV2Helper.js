({
	setAccountCategory: function(cmp, helper, acc) {
        var territoryNumber = parseInt(acc.SAP_Sales_Group__c),
            accountCategory;

        if(!isNaN(territoryNumber)) {
            if(territoryNumber >= 200 && territoryNumber <= 599) {
                if(acc != null 
                   && acc != undefined 
                   && acc.Segmentation__c != null 
                   && acc.Segmentation__c != undefined 
                   && (acc.Segmentation__c.substring(0, 1) === 'K' || acc.Segmentation__c.substring(0, 1) === 'P')) {
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
	},
    
    fetchAccountCurrentYearPlan :function(cmp,helper){
        console.log(cmp.get('v.recordId'));
        var currentAccountPlanAction = cmp.get('c.getCurrentAccountPlan');
        
        currentAccountPlanAction.setParams({accountId: cmp.get('v.recordId')});
        currentAccountPlanAction.setCallback(this, function(response) {
            console.log('handleInit callback');
            var state = response.getState();
            if(cmp.isValid() && state === 'SUCCESS') {
                console.log('handleInit callback success: ', response.getReturnValue());
                var currentYrPlan = response.getReturnValue();
                console.log('currentYrPlan::',currentYrPlan);
                if(currentYrPlan != null &&  typeof currentYrPlan !== 'undefined' ){
                    console.log('currentYrPlan1321::',currentYrPlan);
                    cmp.set('v.isAccountPlanExist',true);                    
                    cmp.set('v.currentYearPlan',response.getReturnValue());
                    var planLabel = currentYrPlan.Account_Plan_Year__c + ' Account Plan';
                    cmp.set('v.currentYearPlanLabel',planLabel);
                    
                    
                }else{
                    cmp.set('v.currentYearPlanLabel','No Account Plan');
                    
                }
                
                
                
                
                
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(currentAccountPlanAction);
        
    },
    
    fetchCurrentUserInfo : function(cmp, helper){
    	var getCurrentUserInfoAction = cmp.get('c.getCurrentUserInfo');
        
        getCurrentUserInfoAction.setCallback(this, function(response) {
            
            var state = response.getState();
            if(cmp.isValid() && state === 'SUCCESS') {
                
                var currentUser = response.getReturnValue();
                
                if(currentUser != null &&  typeof currentUser !== 'undefined' ){
                    cmp.set('v.currentUser',currentUser);
                    console.log('Profile.Name', currentUser.Profile.Name);
                }
                
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response.getError());
            }
        });
        
        $A.enqueueAction(getCurrentUserInfoAction);
	}
})