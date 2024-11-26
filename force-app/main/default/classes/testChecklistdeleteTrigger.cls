@isTest(seeAllData=true)
private class testChecklistdeleteTrigger {
    static testmethod void ChecklistAccountStaticTestMethod(){
        
   SPEED_Check_list__c a = new SPEED_Check_list__c(name='Tester');
            insert a;
    
        try {  
        
        test.startTest();
    delete a;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException e){  
    System.assert(false, 'Deletion failed appropriately');
    test.stopTest();
}}}