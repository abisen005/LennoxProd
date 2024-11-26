@isTest
public class RetailScorecard_HeaderController_Test {

    public static testMethod void getScoreCardDataTest() {

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
            Year__c = System.today().year().format().remove(',')
        );
        try {
            insert rts;
        } catch(DmlException e) {
            System.debug(e);
        }

        Test.startTest();
        RetailScorecard_HeaderController ctrl = new RetailScorecard_HeaderController();
        ctrl.headerLevel = 'dealer';
        ctrl.headerId = a.Id;
        ctrl.getScorecardData();
        Test.stopTest();

    }

}