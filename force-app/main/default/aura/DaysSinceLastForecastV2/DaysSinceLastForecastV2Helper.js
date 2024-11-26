({
	setStatus: function(cmp, helper, val) {
        var status = 'error';
        
        if(val !== null) {
            if(val < 61) {
                status = 'success';
            } else if(val < 91) {
                status = 'warning';
            }
        }

        cmp.set('v.status', status);
    },
    
    setForecastValues: function(cmp, helper) {
        var today = +new Date(),
            account = cmp.get('v.account'),
            forecastDateInt,
            forecastDateOffset,
            forecastDate,
            daysSinceLastUpdate = null,
            percentageToForecast = 0,
            forecastAmount = 0;

        if(account.Forecast_Last_Modified_Date__c) {
            //Date fields are returned in UTC time.. we have to get the timezone offset in miliseconds and add it to
            //the forecast date integer to get the current user locale's correct date
            forecastDateOffset = new Date(+new Date(account.Forecast_Last_Modified_Date__c)).getTimezoneOffset() * 60000;
            forecastDateInt = +new Date(account.Forecast_Last_Modified_Date__c) + forecastDateOffset;
            forecastDate = new Date(forecastDateInt);
            daysSinceLastUpdate = Math.round((today - forecastDateInt)/(1000*60*60*24));
            percentageToForecast = account.SAP_YTD_Sales__c !== 0 && account.Current_Year_Sales_Forecast__c !== 0 ? Math.round((account.SAP_YTD_Sales__c / account.Current_Year_Sales_Forecast__c) * 100) : 0;
            forecastAmount = account.Current_Year_Sales_Forecast__c || 0;
            forecastAmount = forecastAmount > 1000 ? (forecastAmount / 1000).toFixed(0) + 'k' : forecastAmount.toFixed(0);
        }
        
        cmp.set('v.chartLabel', percentageToForecast + '%');
        cmp.set('v.chartSubLabel', 'to $' + forecastAmount);
        cmp.set('v.daysSinceLastUpdate', daysSinceLastUpdate);
        cmp.set('v.percentageToForecast', percentageToForecast);
        helper.setStatus(cmp, helper, daysSinceLastUpdate);
        
        cmp.set('v.isLoading', false);
    }
})