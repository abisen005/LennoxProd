/*
 * @purpose     : test class for AcctPathNCController
 * Created Date : 16 Jan 2020
*/
@isTest
public class AcctPathNCControllerTest {

    /*
     * 	@Purpose : create test data
	 */
	@testSetup 
    static void createTestData() {
        
        Account dealerAccount = new Account(Name = 'Dealer Account',
                                            SAP_Customer_Number__c  = 'CustNum');
        insert dealerAccount;
        
        // create Scorecard Record
        Scorecard__c scorecard = new Scorecard__c(Name = 'Test Scorecard',
                                                  Account__c = dealerAccount.Id);
        insert scorecard;
        
        // create Account Plan Record
        Account_Planning__c accountPlan = new Account_Planning__c(Name = 'Test Account Plan',
                                                                  Opportunity_Scorecard__c = scorecard.Id,
                                                                  Dealer__c = dealerAccount.Id);
        insert accountPlan;
        
        // create Opportunity Record
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity',
                                                  StageName = '1 - Proposal Prepared', 
                                                  CloseDate = Date.today());
        insert opportunity;
        
        // create Conversion Velocity
        Conversion_Velocity__c conversionVelocity = new Conversion_Velocity__c(Name = 'Test Conversion Velocity',
                                                                               Dealer__c = dealerAccount.Id, 
                                                                               Conversion_Start_Date__c = Date.today());
        insert conversionVelocity;
        
        // create Account Record
        Account account = new Account(Name = 'Test Account',
                                      Opportunity_Scorecard__c = scorecard.Id,
                                      Account_Plan__c = accountPlan.Id,
                                      Proposal_Close__c = opportunity.Id,
                                      Conversion__c = conversionVelocity.Id,
                                      SAP_Customer_Number__c  = 'CustNo1');
        insert account;
    }
    
    public static testmethod void testPositive(){
        Test.startTest();
        
        	Account account = [SELECT Id from Account WHERE Name = 'Test Account' LIMIT 1];
        	AcctPathNCController.Response response = AcctPathNCController.getRecords(account.Id);
        
        	system.assertEquals(response.isSuccess, true);
            system.assertNotEquals(response.data, null);
        
        Test.stopTest();
    }
    
    public static testmethod void testNegative(){
        Test.startTest();
        
        	AcctPathNCController.Response response = AcctPathNCController.getRecords(Null);
        
        	system.assertEquals(response.isSuccess, false);
            system.assertEquals(response.data, null);
        
        Test.stopTest();
    }
}