@isTest(seeAllData=true)
private class testAMSDeleteTrigger {
    static testmethod void AMSStaticTestMethod(){

               account a = new account(
                    SAP_Customer_Number__c='B9999',
               name='xxx');
               insert a;

vendor_direct__c v= new vendor_direct__c (
    recordtypeid='012C0000000kyANIAY',
           Vendor_Name__c='xx',
 Lennox_Purchase_Order__c='111',
 Reason_for_return__c='xxxx',
 Sales_Order__c='11111111',
    Dealer_Account__c='B9999'
 
          );
            insert v;



 
    
    
        try {  
            
            test.startTest();
           
    delete v;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException e){  
    System.assert(false, 'Deletion failed appropriately');
    test.stopTest();
    
}}}