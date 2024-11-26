@IsTest
public class NewAccountLightningCtrlTest {
    @IsTest
    static void createAccountTest() {
        // Given there is a JSON string
        String accountJson = '{"name":"Test Account",' +
        '"phone":"5554434323",' +
        '"website":"www.google.com",' +
        '"fax":"8883432359"}';
        
        String placeDetailsJson = '[{"label":"street_number","value":"1614"},' + 
            '{"label":"route","value":"South Walnut Street"},' + 
            '{"label":"locality","value":"Coffeyville"},' + 
            '{"label":"administrative_area_level_2","value":"Montgomery County"},' + 
            '{"label":"administrative_area_level_1","value":"KS"},' + 
            '{"label":"country","value":"US"},' + 
            '{"label":"postal_code","value":"67337"}]';
        
        // When createAccount is called with the JSON string
        String res = NewAccountLightningCtrl.createAccount(accountJson, placeDetailsJson);
        
        // Then the response should be 'SUCCESS'
        System.assert(res.contains('SUCCESS'), 'It should have returned SUCCESS but was ' + res);
        // And a new account should be created
        List<Account> testAccounts = [
            SELECT 
                Id, 
                Name, 
                Phone, 
                Fax, 
                ShippingStreet, 
                ShippingCity, 
                ShippingState, 
                ShippingPostalCode, 
                ShippingCountry 
            FROM Account];
        System.assertEquals(1, 
                            testAccounts.size(), 
            				'There should be 1 account but there were ' + 
                            String.valueOf(testAccounts.size()));
        String testAcctId = res.split(':')[1];
        System.assertEquals(testAcctId, 
                            testAccounts[0].Id, 
                            'It should have returned the Id of the newly created account but returned ' + 
                            testAcctId);
    }
    @IsTest
    static void createAccountExceptionTest() {
        // Given there is a malformed JSON string
        String json = '{}';

        // When createAccount is called with the JSON string
        String res = NewAccountLightningCtrl.createAccount(json,json);
        
        // Then the response NOT should be 'SUCCESS'
        System.assertNotEquals('SUCCESS', res, 'It should NOT have returned SUCCESS but did');

        // And a new account should NOT be created
        List<Account> testAccounts = [
            SELECT 
                Id, 
                Name, 
                Phone, 
                Fax, 
                ShippingStreet, 
                ShippingCity, 
                ShippingState, 
                ShippingPostalCode, 
                ShippingCountry 
            FROM Account];
        System.assertEquals(0, testAccounts.size(), 
            'There should be 1 account but there were ' + 
            String.valueOf(testAccounts.size()));    }
}