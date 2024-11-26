@isTest
public class OSDataTableControllerTest {
    static testMethod void testMethod1() {
        
        Test.StartTest(); 
        //ApexPages.currentPage().getParameters().put('data','[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/05/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]');
        //ApexPages.currentPage().getParameters().put('data2','[{"Order_Document_Create_Date__c":"03/05/2021","Purchase_Order_No__c":"81582978-001","Total_Value__c":"208.00","Freight_charge__c":"0.00","Delivery_status__c":"Fully delivered","Overall_Order_status__c":"Completed","Order_Number__c":"0212163235","CustomerNumber":"B23151","AccountName":"Nelson Comfort"}]');
        
        //ApexPages.currentPage().getParameters().put('Type','Items');
        //OSDataTableController  testAccPlan = new OSDataTableController();
        
        PageReference pageRef = Page.OSDataTable;
        Test.setCurrentPage(pageRef);
        
        String str1  = '[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Completion Date":"01-05-2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]';
        String str2  = '[{"Order_Document_Create_Date__c":"03/05/2021","Purchase_Order_No__c":"81582978-001","Total_Value__c":"208.00","Freight_charge__c":"0.00","Delivery_status__c":"Fully delivered","Overall_Order_status__c":"Completed","Order_Number__c":"0212163235","CustomerNumber":"B23151","AccountName":"Nelson Comfort"}]]';
        
        Cache.Org.put('local.MulesoftExternalData.displayText', str1);
        Cache.Org.put('local.MulesoftExternalData2.displayText', str2);
        pageRef.getParameters().put('Type', 'Items');
        pageRef.setRedirect(false);
        OSDataTableController  testAccPlan1 = new OSDataTableController();
        
        
        pageRef.getParameters().put('Type', 'Order');
        pageRef.setRedirect(false);
        OSDataTableController  testAccPlan2 = new OSDataTableController();
        pageRef.getParameters().put('Type', 'Warranty');
        pageRef.setRedirect(false);
        OSDataTableController  testAccPlan3 = new OSDataTableController();  
        pageRef.getParameters().put('Type', 'OrderHeaders');
        pageRef.setRedirect(false);
        OSDataTableController  testAccPlan4 = new OSDataTableController();          
        
        Test.StopTest();
    }
    
    /*  static testMethod void testMethod2() {
Test.StartTest(); 
ApexPages.currentPage().getParameters().put('data','[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/05/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]');
ApexPages.currentPage().getParameters().put('data2','[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/05/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]');

ApexPages.currentPage().getParameters().put('Type','OrderHeaders');
OSDataTableController  testAccPlan = new OSDataTableController();
Test.StopTest();
}

static testMethod void testMethod3() {
Test.StartTest(); 
ApexPages.currentPage().getParameters().put('data','[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/05/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]');
ApexPages.currentPage().getParameters().put('data2','[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/05/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]');

ApexPages.currentPage().getParameters().put('Type','Warranty');
OSDataTableController  testAccPlan = new OSDataTableController();
Test.StopTest();
}*/
}