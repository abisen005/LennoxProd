@IsTest
public class SearchAccountCmpControllerTest {
    @testsetup
    private static void createTestData(){
        Account acc1 = createAccount('test1');
        Insert acc1;
        
        Account acc2 = createAccount('test2');
        Insert acc2;
        
        Contact con = createContact(acc2.Id);
        Insert con;
        
        SearchAccountConfiguraton__c config = createAccountConfiguraton();
        Insert config;
    }
    
    @IsTest
    private static void testSearchFunctionality(){
        string whereCondition = 'Name LIKE \'%ac%\' AND Phone LIKE \'%23%\'';
        
        SearchAccountCmpController.Response onloadRes =  SearchAccountCmpController.getOnloadData();
        SearchAccountCmpController.Response res =  SearchAccountCmpController.getAccountList(whereCondition, '23');
        
    }

    private static Account createAccount(String name){
        Account acc = new Account();
        acc.Name = name;
        acc.Phone = '1234567890';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Test';
        acc.ShippingState = 'test';
        acc.ShippingCountry = 'US';
        acc.ShippingPostalCode = '4321';
        
        return acc;
    }
    
    private static Contact createContact(String accountId){
        Contact con = new Contact();
        con.LastName = 'Test';
        con.FirstName = 'test';
        con.AccountId = accountId;
        con.Phone = '1234567890';
        
        return con;
    }
    
    private static SearchAccountConfiguraton__c createAccountConfiguraton(){
        SearchAccountConfiguraton__c config = new SearchAccountConfiguraton__c();
        config.Profile_Name__c = 'System Administrator';
        
        return config;
    }
}