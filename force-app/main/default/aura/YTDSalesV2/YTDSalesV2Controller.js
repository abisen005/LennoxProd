({
    handleAccountChange: function(cmp, event, helper) {
        var acc = cmp.get('v.account'),
        	showYTDSalesInThousands = acc.SAP_YTD_Sales__c >= 1000,
            showDeltaYTDSalesInThousands = acc.Delta_YTD_Sales_Year_to_Year__c >= 1000 || acc.Delta_YTD_Sales_Year_to_Year__c <= -1000,
            percentageChange =  acc.Prior_Year_YTD_Sales__c && parseFloat(acc.Prior_Year_YTD_Sales__c) > 0 ? Math.round((acc.Delta_YTD_Sales_Year_to_Year__c / acc.Prior_Year_YTD_Sales__c) * 100) : 0;

        cmp.set('v.YTDSales', acc.SAP_YTD_Sales__c || 0);
        cmp.set('v.deltaYTDSales', acc.Delta_YTD_Sales_Year_to_Year__c);
        cmp.set('v.showYTDSalesInThousands', showYTDSalesInThousands);
        cmp.set('v.showDeltaYTDSalesInThousands', showDeltaYTDSalesInThousands);
        cmp.set('v.percentageChange', percentageChange);
        helper.setStatus(cmp, helper, percentageChange);
    },
    
    handleOpenModal: function(cmp, event, helper) {
        cmp.set('v.isModalOpen', true);
    }
})