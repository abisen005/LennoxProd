@isTest
public class NominationFormControllerTest {
    
    @testSetup
    public static void setup(){
        Account a = new Account(Name = 'Test Account1', BillingCity = 'city',
                                BillingState = 'state',Prior_Year_YTD_Sales__c = 125, 
                                SAP_YTD_Sales__c=200,SAP_Sales_Group__c = '215', 
                                SAP_Customer_Number__c = '1234', Pricing_Zone__c = 'NY', 
                                location__longitude__s=41.85159683, location__latitude__s=-87.88715363,
                                SAP_Premier_Dealer__c='Yes');
     insert a;   
    }
    
    public static testmethod void TestNominationFormController(){
        Account a = [SELECT Id, Name, SAP_Customer_Number__c
                    FROM Account 
                    LIMIT 1];
        
        FTL_Program_Form__c ftl = new FTL_Program_Form__c();
        ftl.Nominator_Name__c = 'Test';
        insert ftl;
        
        NominationFormController.getAccountDetailsApex(a.SAP_Customer_Number__c,'');
        NominationFormController.getAccountDetailsApex('',a.Name);
        NominationFormController.getAccountDetailsApex('789I','');
        NominationFormController.updateNominationStory(ftl.Id, 'TestStory');
        NominationFormController.getNominationFormRecordType();
        
        try{
            insert new contact();
        }catch(exception e){
            NominationFormController.getExceptionString(e);
        }
    }

}