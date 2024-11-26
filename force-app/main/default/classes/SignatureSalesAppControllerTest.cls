@isTest
private class SignatureSalesAppControllerTest {
    
    static testMethod void testSignatureSalesAppControllerMethods() {
        
        //create account
        Account testAcc = new Account(Name = 'Test');
        testAcc.Name = 'Test';
        testAcc.SAP_Customer_Number__c = 'abcd9786';
        testAcc.SAP_YTD_Sales__c = 500;
        insert testAcc;
        System.debug('testAcc: ' + testAcc);
        
        Signature_Sales_Console_Settings__c sscs = new Signature_Sales_Console_Settings__c();
        sscs.Dashboard_Folder_Name__c = 'test';
        sscs.Forecast_Report_Id__c = 'test';
        sscs.Report_Folder_Name__c = 'test';
        sscs.Roll_Up_Report_Page_Name__c = 'test';
        sscs.Sales_Goals_Report_Id__c = 'test';
        sscs.Update_Forecast_List_View_Id__c = 'test';
        sscs.User_Mode__c = 'No Match';
        sscs.Name = 'No Match';
        insert sscs;
        
            
        Signature_Sales_Console_Settings__c retrievedSscs = SignatureSalesAppController.getConsoleSetting('test');
        System.assertEquals(retrievedSscs.Name, sscs.Name);
        
        Account[] retrievedAccounts = SignatureSalesAppController.searchDealers('abcdefg089786');
        System.debug('retrievedAccounts: ' + retrievedAccounts);
        //System.assertEquals(retrievedAccounts.size(), 1);
        
        SignatureSalesAppController.getUserMode();
        SignatureSalesAppController.getDashboards('test');
        SignatureSalesAppController.getReports('test');
        
            
    }

}