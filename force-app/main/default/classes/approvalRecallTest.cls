@isTest
public class approvalRecallTest {
    
    @isTest
    private static void testRecallApproval(){
        Opportunity opportunity = new Opportunity(Name = 'Opportunity',Type = 'New Customer',  District_Manager__c = UserInfo.getUserId(), 
                                                  StageName = '0 - Proposal Requested', CloseDate = System.today());
        insert opportunity;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(opportunity.id);
        
        Approval.ProcessResult processResult = Approval.process(req);
        
        approvalRecall.recallApproval(new List<Id>{opportunity.Id});
    }
}