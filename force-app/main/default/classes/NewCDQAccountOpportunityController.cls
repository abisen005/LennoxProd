public class NewCDQAccountOpportunityController {

    public Account_Opportunty__c accountOpp {get;set;}
    public Boolean isSubmitted {get;set;}
    public String accountPlanId {get;set;}

    public NewCDQAccountOpportunityController() {

        isSubmitted = false;
        accountOpp = new Account_Opportunty__c();
        accountOpp.Dealer_Account_Plan__c = accountPlanId;
        accountOpp.Opportunity_Scorecard__c = ApexPages.currentPage().getParameters().get('scorecardid');
        accountOpp.Opportunity_Type__c = 'CDQ Request';
        accountOpp.Opportunity_Status__c = 'In Progress';
    }

    public void saveAndSubmitForApproval() {
        try {
            insert accountOpp;
            isSubmitted = true;
        } catch(DMLException e) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addmessage(msg);
        }
    }

    public PageReference returnToCDQ() {
        PageReference pr = Page.VendavoLandingPage;
        return pr;
    }

    public void createAccountPlan() {
        try {
            String accountPlanId = ApexPages.currentPage().getParameters().get('accplanid');
            if(accountPlanId == 'undefined') {
                Account_Planning__c accPlan = new Account_Planning__c();
                accPlan.Dealer__c = ApexPages.currentPage().getParameters().get('accountId');
                accPlan.Name = ApexPages.currentPage().getParameters().get('accountId'); //a trigger handles updating the acc plan
                accPlan.Account_Plan_Year__c = String.valueOf(System.Today().year());
                accPlan.Opportunity_Scorecard__c = ApexPages.currentPage().getParameters().get('scorecardid');
                insert accPlan;
                accountPlanId = accPlan.Id;
                accountOpp.Dealer_Account_Plan__c = accPlan.Id;
            } else {
                accountOpp.Dealer_Account_Plan__c = accountPlanId;
            }
        } catch(DMLException e) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addmessage(msg);
        }
    }

}