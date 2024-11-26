@isTest
public class RetailScorecard_SalesPerfComponent_Test {
    public static testMethod void RetailScorecard_SalesPerfComponentCtrlTest() {
        
        Retail_Scorecard_Targets__c testTargets = new Retail_Scorecard_Targets__c();
        testTargets.Name = 'Lowe\'s';
        testTargets.Proposal_Rate_Success_Percentage__c = 5;
        testTargets.Proposal_Rate_Danger_Percentage__c = 5;
        testTargets.Lead_to_In_home_Spill_Rate_Target__c = 5;
        testTargets.Average_Sales_Store_Target__c = 5;
        testTargets.Average_Proposals_Closed_Store__c = 5;
        testTargets.X1_YTD_Sales_Store_Target__c = 5;
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

        insert testTargets;

        Account a = new Account(
            Name = 'Test Account',
            SAP_Customer_Number__c = String.valueOf(System.now().getTime()),
            SAP_Sales_Office_Desc__c = 'Test',
            SAP_Sales_Group__c = 'G',
            SAP_Sales_District__c = 'D'
        );
        try {
            insert a;
        } catch (DMLException e) {
            System.debug(e);
        }

        Retail_Sales_Tracker__c rts = new Retail_Sales_Tracker__c(
            Store_Division__c = 'D',
            Store_Region_Number__c = 'R',
            Dealer__c = a.Id,
            YTD_Sales__c = 1,
            PY_YTD_Sales__c = 1,
            YTD_Proposals_Closed__c = 1,
            Retailer__c = 'Lowe\'s',
            Sales_Curve_Period__c = '12',
            Year__c = System.today().year().format().remove(',')
        );
        try {
            insert rts;
        } catch(DmlException e) {
            System.debug(e);
        }
        
        Test.startTest();
        RetailScorecard_SalesPerfComponentCtrl ctrl = new RetailScorecard_SalesPerfComponentCtrl();
        ctrl.compLevel = 'dealer';
        ctrl.compId = a.Id;
        ctrl.compRetailLabel = 'Lowe\'s';
        ctrl.getTargets();
        ctrl.getSalesData();
        Test.stopTest();
        
    }
}