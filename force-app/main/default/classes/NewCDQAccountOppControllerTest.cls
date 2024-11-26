@isTest(SeeAllData=true)
public class NewCDQAccountOppControllerTest {
    public static testMethod void testNewCDQAccountOpportunityController() {
        
        Id dmProfileId = [SELECT Id FROM Profile WHERE Name = 'Lennox - Res Sales DM - Lightning'].Id;
        Id tmProfileId = [SELECT Id FROM Profile WHERE Name = 'Lennox - Res Sales TM - Lightning'].Id;
        Id tmRoleId = [SELECT Id FROM UserRole WHERE Name = 'Lennox System Admin'].Id;

        User dmUser = new User(Alias = 'standt', Email='dm@lennoxintl.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = dmProfileId, 
            TimeZoneSidKey='America/Los_Angeles', UserName='1234abcd1234@1234abcd1234.com');
            
        User tmUser = new User(Alias = 'standt', Email='dm@lennoxintl.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = tmProfileId, UserRoleId = tmRoleId,
            TimeZoneSidKey='America/Los_Angeles', UserName='1234abcd1234fdas@asdf1234abcd1234.com');
            
        insert dmUser;
        insert tmUser;
            
        
        
        Test.startTest();
        System.runAs(tmUser) {
        
            Account acc = new Account(Name = 'Test Account', SAP_Customer_Number__c = 'TEST1234567890');
            insert acc;
            
            Account_Planning__c accPlan = new  Account_Planning__c(Name = 'test', Account_Plan_Year__c = String.valueOf(System.Today().year()), Dealer__c = acc.Id);
            insert accPlan;
            
            Account_Opportunty__c accountOpp = new Account_Opportunty__c();
            accountOpp.Dealer_Account_Plan__c = accPlan.Id;
            accountOpp.Opportunity_Type__c = 'CDQ Request';
            accountOpp.Opportunity_Status__c = 'In Progress';
            accountOpp.isApproved__c = TRUE;
            accountOpp.Approver__c = dmUser.Id;
            insert accountOpp;
        
            PageReference pageRef = Page.NewCDQAccountOpportunity;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('accplanid', accPlan.Id);
          //  ApexPages.currentPage().getParameters().put('accplanid', null); // Commented by Anand 
            
            NewCDQAccountOpportunityController ctrl = new NewCDQAccountOpportunityController();
            ctrl.accountOpp.Approver__c = dmUser.Id; // Added by Anand to assign next approver before submitting for approval.
            ctrl.saveAndSubmitForApproval();
            ctrl.returnToCDQ();
            ctrl.createAccountPlan();
            ApexPages.currentPage().getParameters().put('accplanid', 'undefined');
            ctrl.createAccountPlan();
        }
        test.stopTest();

    }
}