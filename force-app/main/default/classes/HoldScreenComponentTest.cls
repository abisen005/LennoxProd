/**
* @Purpose : Test class for HoldScreenComponentController 
**/
@isTest
public class HoldScreenComponentTest {
	
    /**
    * Initialize data
    */
    @testSetup
    public static void initData(){
    	
        //insert Account
        Account account = new Account();
        account.Name = 'Test';
        
        insert account;
        
        //insert Case
        Case caseRec = new Case();
        caseRec.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Initial Case').getRecordTypeId();
		caseRec.AccountId = account.Id;
        caseRec.Reason = 'CEP';
        
        insert caseRec;
    }
    
    /**
    * Test GetCase method 
    */
    public static testMethod void testGetCase(){
        
        List<Case> caseList = [SELECT Id
                               FROM Case];
    
        Test.startTest();
        
        Case caseRec = HoldScreenComponentController.getCase(caseList[0].Id);
        Case caseRec2 = HoldScreenComponentController.getCase('');
        
        Test.stopTest();
        System.assertNotEquals(null, caseRec);
        System.assertEquals(null, caseRec2);
    }
}