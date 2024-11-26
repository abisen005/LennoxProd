@IsTest
public class CustomerAlertControllerTest {
    @testSetup
    public static void testData(){
        Account acc = createAccount();
        Insert acc;
        
        Contact con = createContact(acc.Id);
        Insert con; 
        
      
        
        List<case> caseList = new List<case>();
        Case c1 = createCase(acc.Id, null);
        caseList.add(c1);
        Case c2 = createCase(null, con.Id);
        caseList.add(c2);
        
        geo_mapping__c  g = new geo_mapping__c (
            region_director__c='MCA05',
            district_manager__c='JAA19',
            ftc_1__c='JWA01',
            ftc_2__c='AXA20',
            district__c='U432');
        insert g;
        
        Insert caseList;
    }
    
    private static testmethod void testCustomerAlertController(){
        List<case> caseList = [SELECT Id, AccountId 
                               FROM Case
                              ];
        
        Account acc = [Select Id FROM Account LIMIT 1];
        Contact con = [Select Id FROM Contact LIMIT 1];
        
        Test.startTest();
        
        for(case c : caseList){
            CustomerAlertController.response caseResult = CustomerAlertController.getOnloadData(c.Id);
        }
        
        CustomerAlertController.response accResult = CustomerAlertController.getOnloadData(acc.Id);
        CustomerAlertController.response conResult = CustomerAlertController.getOnloadData(con.Id);
        
        test.stopTest();
    }
    
    private static testmethod void negativeUnitTest(){
        
        CustomerAlertController.response result = CustomerAlertController.getOnloadData('');
        System.assertEquals(false, result.isSuccess);
        
        CustomerAlertController.response result1 = CustomerAlertController.getOnloadData('invalidId');
        System.assertEquals(false, result1.isSuccess);
    }
    
    private static Case createCase(String accountId, string contactId){
        Case c = new Case();
        c.Status='New';
        c.subject='Test'; 
        c.reason='Excessive Calls';
       
        c.bypass_logic__c = true;
        
        if(String.isNotBlank(accountId)){
            c.AccountId = accountId;
        }
        if(String.isNotBlank(contactId)){
            c.contactId = contactId;
        }
        return c;
    }
    
    private static Account createAccount(){
        Account acc = new Account();
        acc.ShippingCity = 'City';
        acc.ShippingCountry = 'US';
        acc.ShippingPostalCode = '123456';
        acc.ShippingState = 'TX';
        acc.ShippingStreet = 'street';
        acc.Phone = '123';
        acc.Name = 'test';
        acc.Name = 'test';
        return acc;
    }
    
    private static Contact createContact(String accountId){
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Email = 'test@test.com';
            con.Phone = '123';
        con.accountId = accountId;
        return con;
    }
}