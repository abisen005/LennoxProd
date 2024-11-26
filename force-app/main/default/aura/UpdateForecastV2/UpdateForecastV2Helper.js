({
    invokeServerAction: function(cmp, helper, methodOptions) {
        var action = cmp.get('c.' + methodOptions.name);

        if(methodOptions.params) {
            action.setParams(methodOptions.params);
        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(cmp.isValid() && state === 'SUCCESS') {
                methodOptions.callback(cmp, helper, response.getReturnValue());
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response);
                console.log(response.getError());
                helper.handleServerActionError(cmp, helper, methodOptions.name, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

	handleUpsertAccount: function(cmp, helper, response) {
        var modalAlert = $A.get('e.c:ModalAlert'),
            successMsg = 'Success!  The forecast was updated!',
            acc = cmp.get('v.account');

        modalAlert.setParams({ 
            alertType: 'success',
            alertMessage: successMsg
        });

        modalAlert.fire();

        acc.Forecast_Last_Modified_Date__c = new Date();
        acc.Current_Year_Sales_Forecast__c = response.Current_Year_Sales_Forecast__c;

        cmp.set('v.account', acc);
        cmp.set('v.isLoading', false);
        //Determine if a forecastUpdated event is needed or will components update based on account change
    },

    handleServerActionError: function(cmp, helper, actionName, error) {
        var modalAlert = $A.get('e.c:ModalAlert'),
            errorMsg;

        for(var prop in error[0].fieldErrors) {
            errorMsg = error[0].fieldErrors[prop][0].message;
            break;
        }

        modalAlert.setParams({ 
            alertType: 'error',
            alertMessage: errorMsg || 'There was a problem updating the Account.'
        });
        
        modalAlert.fire();
    }
})