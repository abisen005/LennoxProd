@isTest(seeAllData=true)
private class  testSCLDelete {
    static testmethod void SCLStaticTestMethod(){
        
   SupplyChain__c a = new  SupplyChain__c(
   ShortDescriptionofRequest__c='xxx');  

            insert a;
    
        try {  
    delete a;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException em){  
    System.assert(false, 'Deletion failed appropriately');
}}}