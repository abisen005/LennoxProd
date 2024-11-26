@isTest (SeeAllData=true)
private class testMaterialdeleteTrigger {
    static testmethod void MaterialStaticTestMethod(){
    
             supplychain__c obj = new supplychain__c(
             bypass_triggers__c=true,
                SupplyPlanners__c='Rebecca Grigg',
            locationdescription__c='x',
            status__c='Closed',
            ShortDescriptionofRequest__c='xxx');  
            insert obj;
        
   SCSkus__c a = new  SCSkus__c(
   supplychain__c=obj.id,
   Has_store_opened_in_last_12_months__c='N/A',
    Typeofrequest__c='N/A',
       ReasonforRequest__c='x',
        material__c = '15Y30',
        storea__c='a12',
        materialdescription__c='coil',
        ProductDivision__c = 'N/A',
        name='15Y30');
            insert a;
    
        try {  
    delete a;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException em){  
    System.assert(false, 'Deletion failed appropriately');
}}}