@IsTest
public class LightningButtonsTest{
    
    @isTest static void buttonsTest(){
    
        LightningButtons lb= new LightningButtons();
        
        Account acc = new Account();
            acc.Name = 'TestAccount';
            insert acc;
        Site_Visits__c sv = new Site_Visits__c ();
            sv.Account__c = acc.Id;
            insert sv;
        Account_Planning__c ap = new Account_Planning__c();
            ap.Dealer__c = acc.Id;
            ap.Account_Plan_Year__c = '2018';
            ap.Name = 'TestAccountPlanning';
            insert ap;
        Account_Opportunty__c ao = new Account_Opportunty__c ();
            ao.Dealer_Account_Plan__c = ap.Id;
            ao.Proposal_Required__c = 'Yes';
            insert ao;
      /*  Lennox_LSA__c ll =new Lennox_LSA__c ();
            ll.Account__c = acc.Id;
            ll.Requested_Dollar_Amount__c = 10.1;
            ll.Application__c = 'Residential';
            ll.Reason_for_Reimbursement__c = 'Concession';
            ll.Order_Reason__c = 'Crane Charges';
            ll.Requestor_Comments__c = 'RC';
            insert ll;
        Lennox_QMI__c lm = new Lennox_QMI__c ();
            lm.Account__c = acc.Id;
            lm.Product_Application__c = 'Coils';
            insert lm;
        Lead l = new Lead ();
            l.Lead_Type__c = 'Dealer';
            l.Status = 'Open';
            l.LastName = 'LM';
            l.Company = 'c';
            l.Country = 'US';
            insert l;
        Case c = new Case ();
            c.Reason = 'Training';
            c.Status = 'Open';
            insert c;
        Action_Plan__c acp = new Action_Plan__c ();
            acp.Account_Plan__c = ap.Id;
            insert acp;*/
            
        Test.startTest();
        
        	LightningButtons.getAccountForActionPlan(ao.Id);
            
        	/*LightningButtons.getSiteVisitForSiteLocation(sv.Id);
            LightningButtons.getSiteVisitForLennoxQMI(sv.Id);
            LightningButtons.getLennoxLSAForSiteLocation(ll.Id);
            LightningButtons.updateLennoxQMIRecord(lm.Id);
            LightningButtons.getLennoxForSiteVisit(lm.Id);
            LightningButtons.getLennoxQMIForSiteLocation(lm.Id);
            LightningButtons.updateLeadRecord(l.Id);
            LightningButtons.getAccountForLennoxLSA(acc.Id);
            LightningButtons.getCaseForSiteVisit(c.Id);
            LightningButtons.getCaseForLennoxLSA(c.Id);
            LightningButtons.getCaseForSiteLocation(c.Id);
            LightningButtons.getCaseForLennoxQMI(c.Id);
            LightningButtons.getActionPlanForProposalAndClose(acp.Id);*/
        Test.stopTest();
    }
}