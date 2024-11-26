@isTest
public class OpportunityScoreCardTest {
	
    @testSetup
    public static void initData(){
    	// insert Account
    	List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i < 2; i++){
            
            Account account = new Account();
            account.Name = 'Test'+i;
            account.Phone = '7867687676';
            account.ShippingCity = 'Test';
            account.ShippingCountry = 'United States';
            account.SAP_Customer_Number__c = '1123'+i;
            
            accList.add(account);
        }
        insert accList;
        
        Scorecard__c oppScored = new Scorecard__c();
        oppScored.Account__c = accList[0].Id;
        oppScored.Name = 'Test';
        oppScored.Scorecard_Stage__c = '3 - TM: Under Review';
        oppScored.Estimated_annual_HVAC_purchases__c = 1;
        oppScored.Total_Number_of_Employees__c = 5;
        oppScored.Total_Number_of_Retail_Sales_People__c = 5;
        oppScored.Years_with_current_supplier__c = '50';
        oppScored.Existing_or_past_Lennox_relationship__c = 'Yes';
        oppScored.Distance_to_the_closest_Lennox_warehouse__c = 50;
        oppScored.Would_participate_in_Lennox_promotions__c = 'Yes';
        oppScored.Estimated_annual_HVAC_purchases__c = 100000;
        
        insert oppScored;
    }
    
    public static testMethod void testTrigger(){
    	
        List<Account> accList = [SELECT Id FROM Account Order By Name DESC];
        
        List<Scorecard__c> oppScoreCardList = new List<Scorecard__c>();
        
        for(Integer i = 0; i < 3; i++){
            Scorecard__c oppScored = new Scorecard__c();
            oppScored.Account__c = i < 2 ?
                				   accList[0].Id :
            					   accList[1].Id;
            oppScored.Name = 'Test';
            oppScored.Scorecard_Stage__c = '3 - TM: Under Review';
            oppScored.Estimated_annual_HVAC_purchases__c = 1;
            oppScored.Total_Number_of_Employees__c = 5;
            oppScored.Total_Number_of_Retail_Sales_People__c = 5;
            oppScored.Years_with_current_supplier__c = '50';
            oppScored.Existing_or_past_Lennox_relationship__c = 'Yes';
            oppScored.Distance_to_the_closest_Lennox_warehouse__c = 50;
            oppScored.Would_participate_in_Lennox_promotions__c = 'Yes';
            oppScored.Estimated_annual_HVAC_purchases__c = 100000;
            oppScored.Dealer_has_a_Storefront__c = 'Yes';
            oppScored.Dealer_has_experienced_recent_change__c = 'Yes';
            oppScored.Dealer_has_Partnership_Mentality__c = 'Yes';
            oppScored.Has_a_clear_vision_of_their_goals__c = 'Yes';
            oppScored.Satisfied_with_their_current_supplier__c = '2';
            oppScored.Customer_leadership_support_at_all_level__c = 'Yes';
            oppScored.Understands_Lennox_value_proposition__c = 'Yes';
            oppScored.Established_a_decision_deadline__c = 'Yes';
            oppScored.Does_the_customer_inventory_product__c = 'Yes';
            oppScored.Will_Cust_participate_in_Stocking_Prgms__c = 'Yes';
            oppScored.Overall_rating_of_experience_w_Lennox__c = '2';
            oppScored.Does_Customer_have_a_bank_line_of_credit__c = 'Yes';
            oppScored.Do_we_have_a_current_financial_statement__c = 'Yes';
            oppScored.Is_the_Account_current_with_Lennox__c = 'Yes';
            oppScored.Does_Account_have_credit_line_w_Lennox__c = 'Yes';
            oppScored.What_is_the_amount_of_the_Credit_line__c = 10;
            oppScored.Does_Customer_have_a_letter_of_credit__c = 'Yes';
            oppScored.We_have_personal_guarantees_w_principal__c = 'Yes';
            
            oppScoreCardList.add(oppScored);
        }
        test.startTest();
        try{
            insert oppScoreCardList;
        }catch(Exception e){
            System.debug('Exception:::'+e.getMessage());            
        }
        
        List<Scorecard__c> finalOppScoreCardList = [SELECT Id
                                               FROM Scorecard__c];
        test.stopTest();
        System.assertEquals(1, finalOppScoreCardList.size());
    }
}