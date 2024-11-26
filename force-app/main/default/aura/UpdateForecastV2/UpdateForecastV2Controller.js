({
    handleAccountChange: function(cmp, event, helper) {
        var account = cmp.get('v.account');
        cmp.set('v.forecastAmountCopy',  account.Current_Year_Sales_Forecast__c || 0);
    },

	handleUpdateForecastPress: function(cmp, event, helper) {
        var newForecast = numeral().unformat(cmp.get('v.forecastAmountCopy')),
            account = cmp.get('v.account');

        account.Forecast_Last_Modified_Date__c = new Date();
        account.Current_Year_Sales_Forecast__c = newForecast;

        var options = {
            name: 'upsertAccount',
            params: {
                acc: account
            },
            callback: helper.handleUpsertAccount
        };
        
        cmp.set('v.isLoading', true);
        helper.invokeServerAction(cmp, helper, options);
    }
})