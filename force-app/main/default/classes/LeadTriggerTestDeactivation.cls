@isTest
public class LeadTriggerTestDeactivation {
    
    @isTest private static void leadTriggerTestDeact() {
        List<Lead> TestLeads = new List<Lead>();
        for (Integer i=0; i<10; i++){
            Lead ld = new Lead();
            ld.FirstName          = 'Test';
            ld.LastName           = 'LeadBulk' + i;
            ld.Company            = ld.LastName;
            ld.LeadSource         = 'Digital Marketing'; 
            ld.Role__c            = 'Owner/Principal';
            ld.Primary_Role__c    = 'Owner/Principal';
            ld.Lead_Assignment__c = 'Marketing';
            TestLeads.add(ld);
        }
        insert TestLeads;
        
        TestLeads = [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c from Lead];             
        for(Integer i = 0; i < TestLeads.size(); i++){ 
            TestLeads[i].Primary_Role__c = 'Owner/Principal';
        }
        update TestLeads;
    }
}