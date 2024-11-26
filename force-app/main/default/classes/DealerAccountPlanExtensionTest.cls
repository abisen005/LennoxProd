@isTest
public class DealerAccountPlanExtensionTest {
    
    @IsTest
    static void methodName(){
        
        Test.startTest();
        //insert custom setting
        AggregateReportsSettings__c custSet = New AggregateReportsSettings__c();
        custSet.District_Access__c = 'Lennox - Res Sales DM;Lennox - Res Sales DM Pilot;Lennox - Res Sales ASM;Lennox - Res Sales - BDM';
        custSet.Region_Access__c = 'Lennox - Res Sales - Corporate User;Lennox - Res Sales AM;Lennox - Res Sales BDM;Lennox - Res Sales RBM;Res Area BD Manager;Lennox - Res Sales - BDM';
        custSet.Executive_Access__c = 'Lennox - Res Sales - EXE;Lennox Business Administrator;Lennox Business Administrator Super;Res Area BD Manager;Lennox - Res Sales - BDM';
        custSet.Territory_Access__c = 'Lennox - Res Sales TM;Lennox - Res Sales TM Pilot;Res Area BD Manager;Lennox - Res Sales - BDM';
        insert custSet;
         
        //String currentYearField = 'X' + System.today().year() + '_Sales_Forecast__c';
        String currentYearField = 'X2022_Sales_Forecast__c';
        
        Account a = new Account(Current_Year_Sales_Forecast__c = 1000, Name = 'Test Account', ShippingCity = 'city',ShippingStreet='Street',ShippingState = 'state',shippingCountry='USA',ShippingPostalCode='56665',Phone='444-343-3434',Prior_Year_YTD_Sales__c = 125,SAP_YTD_Sales__c=200, SAP_Sales_Group__c = '214', SAP_Customer_Number__c = '123', Pricing_Zone__c = 'NY');
        //a.put(currentYearField, 1000);
        insert a; 
        
        Date today = Date.today();
        
        Account_Planning__c ap = new Account_Planning__c();
        ap.Name = 'testAp';
        ap.Current_Year__c = '2022';
        ap.Account_Plan_Year__c = String.valueOf(today.year() - 1);
        ap.Dealer__c = a.Id;
        ap.PY_YTD_Sales__c = 2018;
        ap.YTD_Sales__c = 2015;
        ap.Unique_AP_Value__c = 'Test1';
        insert ap;
        Id apid = ap.id;
        ApexPages.StandardController con = new ApexPages.StandardController(ap); 
        DealerAccountPlanExtension dapExt = new DealerAccountPlanExtension(con);
        System.Debug(dapExt.salesForecast);
        
        Date currentDate = System.today();
        Integer currentYear = currentDate.year();
        String query;
        if(String.valueOf(ap.Current_Year__c) == String.valueOf(currentYear)) {
            query = 'SELECT (Dealer__r.Current_Year_Sales_Forecast__c) amt FROM Account_Planning__c WHERE Id = :apid';
        }else if (String.valueOf(ap.Current_Year__c) == String.valueOf(currentYear - 1)){
            query = 'SELECT (Dealer__r.Prior_Year_Sales_Forecast__c ) amt FROM Account_Planning__c WHERE Id = :apid';
        } else{
            query = 'SELECT ' + currentYearField + ' FROM Account_Planning__c WHERE Id = : apid';
        }
        //String query = 'SELECT ' + currentYearField + ' FROM Account_Planning__c WHERE Id = : apid';
        Account_Planning__c apResult = Database.Query(query);
        System.assert(dapExt.salesForecast == apResult.get(currentYearField));
        Test.stopTest();
        
    }
}