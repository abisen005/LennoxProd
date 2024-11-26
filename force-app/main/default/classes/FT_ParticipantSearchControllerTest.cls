@isTest 
private class FT_ParticipantSearchControllerTest {
    
    @testSetup 
    static void createTestData() {
        
        FT_Field_Contact_Trigger_Test.testData();
        
        FT_Field_Trial__c fieldTrial = new FT_Field_Trial__c();
        insert fieldTrial;
        
        Field_Trial_Contacts__c fieldTrialContact = [ SELECT Id FROM Field_Trial_Contacts__c LIMIT 1 ];
        
        FT_Field_Trial_Participant_Application__c application1 = new FT_Field_Trial_Participant_Application__c(FT_First_Name__c = 'Test1', 
                                                                                                               FT_Last_Name__c = 'Test2',
                                                                                                               FT_Employee_ID__c = '1234',
                                                                                                               FT_Email__c = 'test@test.com',
                                                                                                               FT_Field_Trial_Contacts__c = fieldTrialContact.Id,
                                                                                                               FT_State_Province__c = 'AK',
                                                                                                               FT_Number_of_Systems_in_the_home__c = '1');
        insert application1;
        
        FT_Field_Trial_Participant_Application__c application2 = new FT_Field_Trial_Participant_Application__c(FT_First_Name__c = 'Test3', 
                                                                                                               FT_Last_Name__c = 'Test4',
                                                                                                               FT_Employee_ID__c = '12345',
                                                                                                               FT_Email__c = 'test2@test.com',
                                                                                                               FT_Field_Trial_Contacts__c = fieldTrialContact.Id,
                                                                                                               FT_State_Province__c = 'AK',
                                                                                                               FT_Number_of_Systems_in_the_home__c = '1');
        insert application2;
        
        FT_Field_Trial_Participant_Applctn_Systm__c system1 = new FT_Field_Trial_Participant_Applctn_Systm__c( FT_Field_Trial_Participant_Application__c = application1.Id );
        insert system1;
        
        FT_Field_Trial_Participant_Applctn_Systm__c system2 = new FT_Field_Trial_Participant_Applctn_Systm__c( FT_Field_Trial_Participant_Application__c = application2.Id );
        insert system2;
            
        Account account = new Account(Name = 'Test account',
                                      ShippingStreet = 'test',
                                      ShippingCity = 'test',
                                      ShippingState = 'test',
                                      ShippingCountry = 'test',
                                      ShippingPostalCode = 'test',
                                      Phone = '1234567890',
                                      SAP_Customer_Number__c  = '12345');
        insert account;
        
        Contact contact = new Contact(Lennox_Employee_ID__c = '12345',
                                      FirstName = 'Test',
                                      LastName = 'Contact',
                                      Email = 'test@abc.com',
                                      AccountId = account.Id);
        insert contact;
    }
    
    static testMethod void testParticipantApplicationSearch() {
        //FT_Field_Trial__c fieldTrial = [SELECT Id FROM FT_Field_Trial__c LIMIT 1];
        FT_Field_Trial__c fieldTrial = new FT_Field_Trial__c( FT_Number_of_Systems_in_the_home__c = '1' );
        insert fieldTrial;
        
        List<FT_ParticipantSearchController.ApplicationDetail> lstApplicationDetails = new List<FT_ParticipantSearchController.ApplicationDetail>();
        lstApplicationDetails = (List<FT_ParticipantSearchController.ApplicationDetail>) FT_ParticipantSearchController.getMatchingParticipantApplications(fieldTrial.Id);
        
        lstApplicationDetails[0].numberOfParticipantsRequired = 1;
        
        
        FT_ParticipantSearchController.createFieldTrialContacts(fieldTrial.Id, lstApplicationDetails);
    }
}