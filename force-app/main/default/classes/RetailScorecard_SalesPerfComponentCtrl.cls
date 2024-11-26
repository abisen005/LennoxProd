public class RetailScorecard_SalesPerfComponentCtrl {
    public String compLevel {get;set;}
    public String compId {get;set;}
    public String compRetailLabel {get;set;}
    String period;
    String yearVal;
    
    public Retail_Scorecard_Targets__c targets {get;set;}
    
    public RetailScorecard_SalesPerfComponentCtrl() {
        getTargets();
    }
    
    public void getTargets() {
        targets = Retail_Scorecard_Targets__c.getValues(compRetailLabel);
    }
    
    String currentYear() {
        AggregateResult year = [SELECT Year__c y 
                                FROM Retail_Sales_Tracker__c 
                                WHERE Retailer__c = :compRetailLabel AND Year__c != NULL 
                                GROUP BY Year__c 
                                ORDER BY Year__c DESC 
                                LIMIT 1];
        return (String)year.get('y');
    }
    
    String currentPeriod() {
        AggregateResult period = [SELECT Sales_Curve_Period__c p 
                                  FROM Retail_Sales_Tracker__c 
                                  WHERE Retailer__c = :compRetailLabel AND Sales_Curve_Period__c != NULL 
                                  GROUP BY Sales_Curve_Period__c 
                                  ORDER BY Sales_Curve_Period__c DESC 
                                  LIMIT 1];
        return (String)period.get('p');
    }
    
    public retailWrappers.summarySalesData getSalesData() {
        retailWrappers.summarySalesData salesData;
        period = currentPeriod();
        yearVal = currentYear();
        String targetFieldName = 'X' + period + '_YTD_Sales_Store_Target__c';
        Decimal curTargetPercentage = (Decimal)targets.get(targetFieldName);
        Decimal curAvgSalesStoreTarget = (targets.Average_Sales_Store_Target__c * curTargetPercentage) / 100;
        Decimal curAvgProposalsStoreTarget = (targets.Average_Proposals_Closed_Store__c * curTargetPercentage) / 100;
        if(compLevel == 'dealer') {
            AggregateResult[] retailData = [SELECT COUNT(Id)cnt, AVG(YTD_Sales__c)avg, SUM(YTD_Sales__c)sum, SUM(PY_YTD_Sales__c)pySUm, 
                                            AVG(YTD_Proposals_Closed__c)avgClosed, SUM(YTD_Change__c)ytdChange 
                                            FROM Retail_Sales_Tracker__c 
                                            WHERE Dealer__c = :compId AND Retailer__c = :compRetailLabel AND Year__c = :yearVal];
            Integer numStores = (Integer)retailData[0].get('cnt');
            Decimal avgYtdSales = (Decimal)retailData[0].get('avg');
            Decimal sumYtdSales = (Decimal)retailData[0].get('sum');
            Decimal sumPytdSales = (Decimal)retailData[0].get('pySum');
            Decimal avgClosed = (Decimal)retailData[0].get('avgClosed');
            Decimal ytdChange = (Decimal)retailData[0].get('ytdChange');
            salesData = new retailWrappers.summarySalesData(targets.Average_Sales_Store_Target__c, curAvgSalesStoreTarget, curAvgProposalsStoreTarget, numStores, avgYtdSales, sumYtdSales, avgClosed, ytdChange, sumPytdSales);
        }
        return salesData;        
    }
    
    
}