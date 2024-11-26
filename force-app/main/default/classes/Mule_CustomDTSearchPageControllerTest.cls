@isTest
public class Mule_CustomDTSearchPageControllerTest {
    static testMethod void testMethod1() 
    {
        Test.StartTest(); 
        String str  = '[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Registration Date":"01-05-2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]';
        
        PageReference pageRef = Page.Mule_CustomDTSearchPage;
        Test.setCurrentPage(pageRef);
        Cache.Org.put('local.MulesoftExternalData.displayText', str);
        pageRef.getParameters().put('displayText', str);
        pageRef.getParameters().put('Type', 'Equipment');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan = new Mule_CustomDTSearchPageController();
        
        
        String str2  = '[{"Order_Number__c":"0031936936","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Completion Date":"01-05-2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BJB21","Last_Changed_On__c":"01/05/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/05/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"i./JEFF%20FLEISHER","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"5538.00","rfc_number":"HDR"},{"Order_Number__c":"0031952976","CDQ_Usage__c":"No","Created_by__c":"NHHYBRISCON","Created_on__c":"01/08/2021","Customer_Number_Search__c":"A85500","Delivery_status__c":"Completely%20processed","Last_Changed_By__c":"BTCCORSD","Last_Changed_On__c":"01/11/2021","Order_Currency__c":"USD","Order_Document_Date__c":"01/08/2021","Overall_Order_status__c":"Completely%20processed","PO_Number__c":"service%20stock","Sales_Document_Type__c":"OR","Total_Value_Net_Value__c":"62.95","rfc_number":"HDR"}]';
        Cache.Org.put('local.MulesoftExternalData.displayText', str2);
        pageRef.getParameters().put('Type', 'Items');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan2 = new Mule_CustomDTSearchPageController();
        
          String str3 =    '[{"AccountName":"Mtn Valley Home Comfort Inc","CustomerNumber":"A85500"}]';
        Cache.Org.put('local.MulesoftExternalData2.displayText', str3);
        pageRef.getParameters().put('Type', 'Learning');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan3 = new Mule_CustomDTSearchPageController();
        
        pageRef.getParameters().put('Type', 'OrderHeaders');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan4 = new Mule_CustomDTSearchPageController();
        
        pageRef.getParameters().put('Type', 'Order');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan5 = new Mule_CustomDTSearchPageController();
        
        pageRef.getParameters().put('Type', 'Warranty');
        pageRef.setRedirect(false);
        Mule_CustomDTSearchPageController  testAccPlan6 = new Mule_CustomDTSearchPageController();
        
        
        Test.StopTest();
    }
    
   
}