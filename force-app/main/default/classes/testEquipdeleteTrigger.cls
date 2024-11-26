@isTest(seeAllData=true)
private class testEquipdeleteTrigger {
    static testmethod void EquipStaticTestMethod(){
        
   Equipment_Data__c a = new Equipment_data__c(name='Tester');
            insert a;
    
        try {  
        
        test.startTest();
    delete a;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException e){  
    System.assert(false, 'Deletion failed appropriately');
    test.stopTest();
}}}