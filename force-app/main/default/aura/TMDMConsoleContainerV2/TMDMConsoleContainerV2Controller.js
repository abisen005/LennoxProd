({
    handleInit: function(cmp, event, helper) {
         helper.fetchAccountCurrentYearPlan(cmp, helper);
        helper.fetchCurrentUserInfo(cmp, helper);
        var action = cmp.get('c.getAccount'), isSf1 = cmp.get('v.isSf1') || typeof sforce !== 'undefined';
        //cmp.set('v.isSf1', isSf1);

        var createRecordEvent = $A.get('e.force:createRecord');
        if(createRecordEvent === null || createRecordEvent == undefined){
            isSf1 = false;
        }else{
            isSf1 = true;
        }
        
        cmp.set('v.isSf1', isSf1);
        
        if(cmp.get('v.recordId') !== null && cmp.get('v.recordId') !== undefined){
            action.setParams({accountId: cmp.get('v.recordId')});
            cmp.set("v.accountId", cmp.get('v.recordId'));
        }

        if(cmp.get('v.accountId') !== null && cmp.get('v.accountId') !== undefined){
            action.setParams({accountId: cmp.get('v.accountId')});
        }
        
        /*if(isSf1 !== 'undefined'){
            action.setParams({accountId: cmp.get('v.recordId')});
        }else{
        	action.setParams({accountId: cmp.get('v.accountId')});    
        }*/
        
        
        
        action.setCallback(this, function(response) { 
            var state = response.getState();

            if(cmp.isValid() && state === 'SUCCESS') {
                var acc = response.getReturnValue(),
                uriEncodedName = encodeURIComponent(acc.Name);
                cmp.set('v.preCallPlannerLink', '/00U/e?what_id=' + acc.Id + '&retURL=%2Fapex%2FTMPreCallPlanner%3Faid=' + acc.Id + '&RecordType=012C0000000QW0R&00NC0000005E5nN=Meeting');	
                cmp.set('v.newContactLink', '/003/e?retURL=%2F' + acc.Id + '&accid=' + acc.Id);	

                if(acc.Account_Plans__r) {	
                    cmp.set('v.salesSummaryLink', '/apex/DealerAccountPlan?id=' + acc.Account_Plans__r[0].Id);	
                    if(acc.Account_Plans__r.length === 2) {	
                        cmp.set('v.pySalesSummaryLink', '/apex/DealerAccountPlan?id=' + acc.Account_Plans__r[1].Id);	
                    }	
                }	

                cmp.set('v.lowesScorecardLink', '/apex/RetailScoreCard?level=dealer&type=lowes&id=' + acc.Id);	
                //cmp.set('v.costcoScorecardLink', '/apex/RetailScoreCard_Costco?level=dealer&type=costco&id=' + acc.Id);	
                cmp.set('v.createScorecardLink', '/a06/e?RecordType=012800000006Tm8&CF00N80000002nJnk=' + uriEncodedName + '&CF00N80000002nJnk_lkid=' + acc.Id + '&retURL=%2F' + acc.Id);	
                cmp.set('v.account', acc);	
                helper.setAccountCategory(cmp, helper, acc);
                
                //get opportunity scorecard
                var getScorecardAction = cmp.get("c.getOpportunityScorecard");
                getScorecardAction.setParams({ accountId : cmp.get("v.accountId") });
                
                getScorecardAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
    					var oppscorecardResponse = response.getReturnValue();
                        if(oppscorecardResponse && oppscorecardResponse != null && oppscorecardResponse.Id != null ){
                            cmp.set("v.opportunityScorecardId", oppscorecardResponse.Id);
                        }
                    }
                });
                
                $A.enqueueAction(getScorecardAction);
                                   
            }else if(cmp.isValid() && state === 'ERROR'){	
                    console.log(response.getError());	
            }
        });	

        $A.enqueueAction(action);	
        //console.log("testmaster : window.innerHeight", window.innerHeight, 'Header: ',window.document.getElementById('oneHeader'), "headerHeight: ", window.document.getElementsByClassName('slds-modal__container')[0]);
    },

    closeModal:function(component,event,helper){
    component.set('v.ismodalClicked', false);
         component.set('v.ismodalClickedWarranty', false);
        component.set('v.ismodalClickedSerial', false);
         component.set('v.ismodalClickedContact', false);
    var cmpTarget = component.find('Modalbox');
    var cmpBack = component.find('Modalbackdrop');
    $A.util.removeClass(cmpBack,'slds-backdrop--open');
    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
},
    
    openmodal: function(component,event,helper) {
    
        var flowName = event.getSource().get("v.labelClass");
        component.set("v.flowname", flowName);
        console.log('FlowName',flowName);
        console.log('Record ID1',component.get("v.recordId"));
        
         //console.log('sapCustomerNumber',component.get("v.recordId").SAP_Customer_Number__c);
      if(flowName == 'Order_Search_Mulesoft_Screen_Flow'){
           component.set('v.ismodalClicked', true);}
       else  if(flowName == 'Warranty_Search_Mulesoft_Screen_FlowV2'){
            component.set('v.ismodalClickedWarranty', true);}
           else if (flowName == 'Equipment_Search_Mulesoft_Screen_FlowV2'){
            component.set('v.ismodalClickedSerial', true);}
               else if (flowName == 'Learning_Mulesoft'){
               component.set('v.ismodalClickedContact', true);}
    var cmpTarget = component.find('Modalbox');
    var cmpBack = component.find('Modalbackdrop');
    $A.util.addClass(cmpTarget, 'slds-fade-in-open');
    $A.util.addClass(cmpBack, 'slds-backdrop--open');
        
},
    
    
    handleUpdateScorecardPress: function(cmp, event, helper) {	
     /*   var editRecordEvent = $A.get('e.force:editRecord');	
       editRecordEvent.setParams({	
            'recordId': cmp.get('v.account').Scorecards__r[0].Id	
        });	
        editRecordEvent.fire();	*/
        var flow = cmp.find("flowData");
    flow.startFlow("Order_Search_Mulesoft_Screen_Flow");
  
    },	
    
     handleUpdateSerialSearch: function(cmp, event, helper) {	
     /*   var editRecordEvent = $A.get('e.force:editRecord');	
       editRecordEvent.setParams({	
            'recordId': cmp.get('v.account').Scorecards__r[0].Id	
        });	
        editRecordEvent.fire();	*/
        var flow = cmp.find("flowData");
    flow.startFlow("Equipment_Search_Mulesoft_Screen_Flow");
  
    },	

    handlecreateScorecardPress: function(cmp, event, helper) {
        var account = cmp.get('v.account');
        var createRecordEvent = $A.get('e.force:createRecord');
        
        createRecordEvent.setParams({
                    entityApiName: 'Scorecard__c',
                    "defaultFieldValues": {
                     'Account__c' : account.Id
                    }
                });
        
        createRecordEvent.fire();
    },

    handleUpdateForecastPress: function(cmp, event, helper) {	
        //cmp.set('v.isUpdateForecast', true);	
        $A.get("e.force:refreshView").fire()
             var flow = cmp.find("flowData");
    flow.startFlow("Warranty_Search_Mulesoft_Screen_Flow");
  
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
        var accountId = cmp.get('v.account').Id;
        var action = cmp.get("c.getAccount");
        
        action.setParams({accountId: cmp.get('v.recordId')});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.accountObj",response.getReturnValue());
                var obj = cmp.get("v.accountObj");
                var createRecordEvent = $A.get('e.force:createRecord');	
                createRecordEvent.setParams({
                    entityApiName: 'Contact',
                    "defaultFieldValues": {
                        'AccountId' : obj.Id,
                        'Phone' : obj.Phone
                    }
                });

                createRecordEvent.fire();
            }
        });

        $A.enqueueAction(action);
    }, 

    handleSalesSummaryPress: function(cmp, event, helper) {	
        var urlEvent = $A.get('e.force:navigateToURL');	
        urlEvent.setParams({	
            'url': cmp.get('v.salesSummaryLink')	
        });
        urlEvent.fire();
    },

    handlePySalesSummaryPress: function(cmp, event, helper) {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': cmp.get('v.pySalesSummaryLink')
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
       /* var urlEvent = $A.get('e.force:navigateToURL');	
        urlEvent.setParams({	
            'url': cmp.get('v.costcoScorecardLink')	
        });	
        urlEvent.fire();	*/
         var qLikSURL = $A.get("$Label.c.Lennox_QLik_URL") ;
        window.open(qLikSURL);
        console.log('qLinkURL is Success');
    },

	handlePreCallPlannerPress: function(cmp, event, helper) {
        var accountId = cmp.get('v.account').Id;
        var action = cmp.get("c.getAccount");
        
        action.setParams({accountId: cmp.get('v.recordId')});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.accountObj",response.getReturnValue());
                var obj = cmp.get("v.accountObj");
                var createRecordEvent = $A.get('e.force:createRecord');

                createRecordEvent.setParams({
                    "entityApiName": 'Event',
                    "recordTypeId" : '012C0000000QW0R',
                    "defaultFieldValues": {
                        'WhatId' : obj.Id,
                        'Event_Type__c' : 'Meeting'
                    }
                });

                createRecordEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    },

    gotoSalesSummary : function(cmp, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
        "url": cmp.get("v.salesSummaryLink")
    });
    urlEvent.fire(); }
})