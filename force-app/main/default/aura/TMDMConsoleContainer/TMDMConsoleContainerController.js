({
    handleInit: function(cmp, event, helper) {
        var action = cmp.get('c.getAccount'),
            isSf1 = cmp.get('v.isSf1') || typeof sforce !== 'undefined';
        cmp.set('v.isSf1', isSf1);
        action.setParams({accountId: cmp.get('v.accountId')});
        action.setCallback(this, function(response) {
            console.log('handleInit callback');
            var state = response.getState();
            if(cmp.isValid() && state === 'SUCCESS') {
                console.log('handleInit callback success: ', response.getReturnValue());
                var acc = response.getReturnValue(),
                    uriEncodedName = encodeURIComponent(acc.Name);
                cmp.set('v.preCallPlannerLink', '/00U/e?what_id=' + acc.Id + '&retURL=%2Fapex%2FTMPreCallPlanner%3Faid=' + acc.Id + '&RecordType=012C0000000QW0R&00NC0000005E5nN=Meeting');
                cmp.set('v.newContactLink', '/003/e?retURL=%2F' + acc.Id + '&accid=' + acc.Id);
                console.log('set precallplanner link and new contact link');
                if(acc.Account_Plans__r) {
                    cmp.set('v.salesSummaryLink', '/apex/DealerAccountPlan?id=' + acc.Account_Plans__r[0].Id);
                    if(acc.Account_Plans__r.length === 2) {
                        cmp.set('v.pySalesSummaryLink', '/apex/DealerAccountPlan?id=' + acc.Account_Plans__r[1].Id);
                    }
                }
                console.log('set account plan links');
                cmp.set('v.lowesScorecardLink', '/apex/RetailScoreCard?level=dealer&type=lowes&id=' + acc.Id);
                cmp.set('v.costcoScorecardLink', '/apex/RetailScoreCard_Costco?level=dealer&type=costco&id=' + acc.Id);
                cmp.set('v.createScorecardLink', '/a06/e?RecordType=012800000006Tm8&CF00N80000002nJnk=' + uriEncodedName + '&CF00N80000002nJnk_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);
                console.log('set scorecard links');
                cmp.set('v.account', acc);
                console.log('acc', acc);
                helper.setAccountCategory(cmp, helper, acc);
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);

    },
    handleUpdateScorecardPress: function(cmp, event, helper) {
        var editRecordEvent = $A.get('e.force:editRecord');
        editRecordEvent.setParams({
            'recordId': cmp.get('v.account').Scorecards__r[0].Id
        });
        editRecordEvent.fire();
    },
    handlecreateScorecardPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            'entityApiName': 'Scorecard__c'
        });
        createRecordEvent.fire();
    },
    handleUpdateForecastPress: function(cmp, event, helper) {
        cmp.set('v.isUpdateForecast', true);
    },
    handleMapDealerPress: function(cmp, event, helper) {
        var acc = cmp.get('v.account'),
            mapLink = '/apex/MapDealer?address=' + acc.ShippingStreet + '+' + acc.ShippingCity + '+' + acc.ShippingState + '+' + acc.ShippingPostalCode,
            urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': mapLink
        });
        urlEvent.fire();
    },
    handleCallDealerPress: function(cmp, event, helper) {
        cmp.set('v.showCallDealerModal', true);
    },
    handleNewContactPress: function(cmp, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            'entityApiName': 'Contact'
        });
        createRecordEvent.fire();
    },
    handleSalesSummaryPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': cmp.get('v.salesSummaryLink')
        });
        urlEvent.fire();
    },
    handleOldDBRPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': '/apex/DealerBenefitReportHistoryWeb?id=' + cmp.get('v.account').Retention_Historys__r[0].Id
        });
        urlEvent.fire();
    },
    handleNewDBRPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': '/apex/DealerBenefitReportWeb?id=' + cmp.get('v.account').Retention___r[0].Id
        });
        urlEvent.fire();
    },
    handleLowesScorecardPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': cmp.get('v.lowesScorecardLink')
        });
        urlEvent.fire();
    },
    handleCostcoScorecardPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': cmp.get('v.costcoScorecardLink')
        });
        urlEvent.fire();
    }
})