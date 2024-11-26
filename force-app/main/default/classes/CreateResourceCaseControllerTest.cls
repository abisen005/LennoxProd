/*
* @Purpose         : CreateResourceCaseController Test class
* @since           : 31 Dec 2018
* @date            : 31 Dec 2018 - 
* @see      
*/
@isTest
public class CreateResourceCaseControllerTest {
    
    @testSetup
    static void testDataSetup() {
        
        //Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Record Type').getRecordTypeId();
        Case caseRecord = new Case(bypass_logic__c = true,
                                   Status = 'Open');
        Insert caseRecord;
        
    }
    private static testMethod void testPositiveCase() {
        Test.startTest();
        User userRec = getUser('CS Resource');
        System.runAs(userRec){
            Case testCaseRecord = [SELECT Id FROM Case LIMIT 1];
            CreateResourceCaseController.createCaseResource(testCaseRecord.Id);
            CreateResourceCaseController.createCSChildCase(testCaseRecord.Id);
        }
        
        User userRec1 = getUser('CS Agent P&S');
        System.runAs(userRec1){
            Case testCaseRecord = [SELECT Id FROM Case LIMIT 1];
            CreateResourceCaseController.createCaseResource(testCaseRecord.Id);
            CreateResourceCaseController.createCSChildCase(testCaseRecord.Id);
        }
        User userRec2 = getUser(null);
        System.runAs(userRec2){
            Case testCaseRecord = [SELECT Id FROM Case LIMIT 1];
            CreateResourceCaseController.createCaseResource(testCaseRecord.Id);
            CreateResourceCaseController.createCSChildCase(testCaseRecord.Id);
        }
        Test.stopTest();        
    }
    
    private static User getUser(String picklistVal){
        
        User u = new User(
            ProfileId = userinfo.getProfileId(),
            LastName = 'last',
            Email = 'abc@abctest.com',
            Username = 'abc@abctest.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Technical_Support__c = picklistVal
        );
        
        return u;
    }
}