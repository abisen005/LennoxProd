({
    doInit: function(component, event, helper) {

        let accountId = component.get("v.recordId");

        let action = component.get("c.getRecords");
        let params = {
            "accountId": accountId
        };
        action.setParams(params);
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                
                let returnValue = response.getReturnValue();

                if (returnValue.isSuccess) {

                    if (returnValue.message) {

                        helper.showToast("Warning!", returnValue.message, "warning");
                    }
                    
                    component.set("v.recordIdCollection", returnValue.data);
                  
                    component.set("v.currentStep", returnValue.data.Account.NC_Path__c);
                     let currentStep = 0;
                    console.log(returnValue.data.Account.NC_Path__c);
                    if(returnValue.data.Account.NC_Path__c){
                        if(returnValue.data.Account.NC_Path__c == 'Scorecard'){
                           currentStep = 1;
                        }else if(returnValue.data.Account.NC_Path__c == 'Account Plan'){
                            currentStep = 2;
                        }else if(returnValue.data.Account.NC_Path__c == 'Proposal'){
                            currentStep = 3;
                        }else if(returnValue.data.Account.NC_Path__c == 'Conversion'){
                            currentStep = 4;
                        }
                    }

                    for(let i=1;i<=4;i++){
                        var cmpTarget = component.find(i);

                        if (cmpTarget) {
                            $A.util.removeClass(cmpTarget, 'slds-is-active');
                            $A.util.removeClass(cmpTarget, 'slds-is-current');
                            $A.util.removeClass(cmpTarget, 'slds-is-incomplete');
                            $A.util.removeClass(cmpTarget, 'slds-is-complete');
                        }

                        if (i == currentStep){
                            if (cmpTarget) {
                                $A.util.addClass(cmpTarget, 'slds-is-active');
                                $A.util.addClass(cmpTarget, 'slds-is-current');
                            }
                        } else if(i < currentStep){
                            $A.util.addClass(cmpTarget, 'slds-is-complete');
                        } else if(i > currentStep){
                            $A.util.addClass(cmpTarget, 'slds-is-incomplete');
                        }

                    }
                } else {

                    helper.showToast("Error!", returnValue.message, "error");
                }
            } else {

                helper.showToast("Error!", "Error occurred. Please try again.", "error");
            }
        });

        $A.enqueueAction(action);
    },

    handleSelect: function(component, event, helper) {

        let stepName = event.currentTarget.dataset.object;
        let recordIdCollection = component.get("v.recordIdCollection");

        if (recordIdCollection.hasOwnProperty(stepName)) {

            window.open('/' + recordIdCollection[stepName], "_blank");
        } else {

            helper.showToast("", "Record not yet available. Please follow the Lennox Sales Process.", "info");
        }
    },
})