@isTest
public class RetailScorecardController_Test {
    public static testMethod void RetailScorecardControllerTest() {
        
        Retail_Scorecard_Targets__c testTargets = new Retail_Scorecard_Targets__c();
        testTargets.Proposal_Rate_Success_Percentage__c = 5;
        testTargets.Proposal_Rate_Danger_Percentage__c = 5;
        testTargets.Lead_to_In_home_Spill_Rate_Target__c = 5;
        testTargets.Lead_to_In_Home_Conversion_Rate_Target__c = 5;
        testTargets.Average_Sales_Store_Target__c = 5;
        testTargets.Average_Proposals_Closed_Store__c = 5;
        testTargets.X1_YTD_Sales_Store_Target__c = 5.0;
        testTargets.X2_YTD_Sales_Store_Target__c = 10;
        testTargets.X3_YTD_Sales_Store_Target__c = 15;
        testTargets.X4_YTD_Sales_Store_Target__c = 25;
        testTargets.X5_YTD_Sales_Store_Target__c = 35;
        testTargets.X6_YTD_Sales_Store_Target__c = 45;
        testTargets.X7_YTD_Sales_Store_Target__c = 55;
        testTargets.X8_YTD_Sales_Store_Target__c = 65;
        testTargets.X9_YTD_Sales_Store_Target__c = 75;
        testTargets.X10_YTD_Sales_Store_Target__c = 85;
        testTargets.X11_YTD_Sales_Store_Target__c = 95;
        testTargets.X12_YTD_Sales_Store_Target__c = 100;

        Retail_Scorecard_Targets__c lowesTargets = testTargets.clone();
        lowesTargets.Name = 'Lowe\'s';
        Retail_Scorecard_Targets__c costcoTargets = testTargets.clone();
        costcoTargets.Name = 'Costco';
        insert lowesTargets;
        insert costcoTargets;
        
        Account a = new Account(
            Name = 'Test Account',
            SAP_Customer_Number__c = String.valueOf(System.now().getTime()).substring(0, 9),
            SAP_Sales_Office_Desc__c = 'Test',
            SAP_Sales_Office__c = 'Test',
            SAP_Sales_Group__c = 'G',
            SAP_Sales_District__c = 'D',
            Costco_Escalation_to_Lead_Ratio__c = 5,
            Costco_Mix_Index__c = 2
        );
        
        insert a;
        

        Retail_Sales_Tracker__c rst = new Retail_Sales_Tracker__c(
            Store_Division__c = 'D',
            Dealer__c = a.Id,
            Last_Updated__c = System.today(),
            Year__c = System.today().year().format().remove(','),
            Store_Name__c = 'Test Store',
            Store_Number__c = 'abc123',
            YTD_Leads__c = 5,
            YTD_In_Homes__c = 5,
            YTD_Proposals__c = 5,
            YTD_Proposals_Closed__c = 5,
            YTD_Sales__c = 5,
            PY_YTD_Sales__c = 5,
            Self_Generated_Leads__c = 5,
            Installs__c = 5,
            Total_Leads__c = 6,
            Annual_Store_Goal__c = 5,
            Store_District__c = 'SD',
            Store_Region_Number__c = 'SR',
            Sales_Curve_Period__c = '1');
        Retail_Sales_Tracker__c lowesRst = rst.clone();
        lowesRst.Retailer__c = 'Lowe\'s';
        lowesRst.Period__c = 'Fiscal YTD';
        lowesRst.Dealer__c = a.Id;
        
        Retail_Sales_Tracker__c costcoPeriodRst = rst.clone();
        costcoPeriodRst.Retailer__c = 'Costco';
        costcoPeriodRst.Period__c = 'Period 1';
        costcoPeriodRst.Dealer__c = a.Id;
        
        Retail_Sales_Tracker__c costcoYTDRst = rst.clone();
        costcoYTDRst.Retailer__c = 'Costco';
        costcoYTDRst.Period__c = 'Fiscal YTD';
        costcoYTDRst.Dealer__c = a.Id;
        
        insert lowesRst;
        insert costcoPeriodRst;
        insert costcoYTDRst;
        
        test.startTest();
        PageReference lowesPageRef = Page.RetailScorecard;
        test.setCurrentPage(lowesPageRef);
        ApexPages.currentPage().getParameters().put('level', 'dealer');
        ApexPages.currentPage().getParameters().put('id', a.Id);
        ApexPages.currentPage().getParameters().put('type', 'lowes');
        RetailScorecardController ctrl = new RetailScorecardController();
        
        PageReference costcoPageRef = Page.RetailScorecard_Costco;
        test.setCurrentPage(costcoPageRef);
        ApexPages.currentPage().getParameters().put('level', 'dealer');
        ApexPages.currentPage().getParameters().put('id', a.Id);
        ApexPages.currentPage().getParameters().put('type', 'costco');
        RetailScorecardController ctrl2 = new RetailScorecardController();
        ctrl2.getCostcoSalesData();
        ctrl2.getCostcoLeadInstallRateData();
        ctrl2.getLastUpdated();
        ctrl2.getPeriodInfo();
        test.stopTest();
    }
}