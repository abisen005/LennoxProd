@IsTest
public class AutoCompleteAddressCtrlTest {

    @testsetup
    private static void testData(){
        DV_Flow_AP__PlacesAPI__c config = new DV_Flow_AP__PlacesAPI__c();
        config.DV_Flow_AP__key__c = 'test';
        
        Insert config;
    }
    
    @IsTest
    private static void unitTest(){
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        string address = AutoCompleteAddressCtrl.getAddressAutoComplete('test', 'region');
        
        string addressDetail = AutoCompleteAddressCtrl.getPlaceDetail('12345');
        Test.stopTest();
    }
}