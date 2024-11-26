@IsTest
public class AlertComponentControllerTest {
    @testSetup
    public static void testData(){
        Account acc = createAccount();
        Insert acc;
        
        Home_Owners__c hm = createSiteLocation();
        Insert hm;
        
        Case c = createCase(acc.Id, hm.Id);
        Insert c;
    }
    
    private static testmethod void testCustomerAlertController(){
        List<case> caseList = [SELECT Id, AccountId 
                               FROM Case
                              ];
                
        Test.startTest();
        
        AlertComponentController.response result = AlertComponentController.getOnloadData(caseList[0].Id);
        System.assertEquals(true, result.isSuccess);
        test.stopTest();
    }
    
    private static testmethod void negativeUnitTest(){
        
        AlertComponentController.response result = AlertComponentController.getOnloadData('');
        System.assertEquals(false, result.isSuccess);
        
        AlertComponentController.response result1 = AlertComponentController.getOnloadData('invalidId');
        System.assertEquals(false, result1.isSuccess);
    }
    
    private static Case createCase(String accountId, string homeOwnerId){
        Case c = new Case();
        c.Status='New';
        c.subject='Test'; 
        
        if(String.isNotBlank(accountId)){
            c.AccountId = accountId;
        }
        if(String.isNotBlank(homeOwnerId)){
            c.Home_Owner__c = homeOwnerId;
        }
        return c;
    }
    
    private static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'test';
        return acc;
    }
    
    private static Home_Owners__c createSiteLocation(){
        Home_Owners__c hm = new Home_Owners__c();
        hm.Name = 'Test';
        return hm;
    }
    
    private static Contact createContact(String accountId){
        Contact con = new Contact();
        con.LastName = 'test';
        con.accountId = accountId;
        return con;
    }
}