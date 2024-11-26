public class LightningButtons{

    public LightningButtons(){
    }
    //ActionPlanFromAccountOpportunity
    @AuraEnabled
    public static Account_Opportunty__c getAccountForActionPlan(String accOppId){
        List<Account_Opportunty__c> accOppList = [SELECT Id,Name,Proposal_Required__c,Dealer_Account_Plan__c,Opportunity_Scorecard__c,Opportunity_Type__c,Opportunity_Notes__c,isApproved__c,Opportunity_Status__c FROM Account_Opportunty__c WHERE Id =: accOppId];
        return accOppList[0];
    }
    
   /* //SiteLocationFromSiteVisit
    @AuraEnabled
    public static Site_Visits__c getSiteVisitForSiteLocation(String siteVisitId){
        List<Site_Visits__c> siteVisitList = [SELECT Id,Name FROM Site_Visits__c WHERE Id =: siteVisitId];
        return siteVisitList [0];
    }
    
    //LennoxQMIFromSiteVisit
    @AuraEnabled
    public static Site_Visits__c getSiteVisitForLennoxQMI(String siteVisitId){
        List<Site_Visits__c> siteVisitList = [SELECT Account__c,Case__c,Comments_from_Case__c,Home_Owner__c,Responsible_FTC__c,District_Manager__c,Regional_Director__c,Name,Case_Originator__c,Territory_Manager__c,FTC__c,FTC1__c,Summary_of_Site_Visit__c FROM Site_Visits__c WHERE Id =: siteVisitId];
        return siteVisitList[0];
    }
    
    
    //SiteLocationFromLennoxLSA
    @AuraEnabled
    public static Lennox_LSA__c getLennoxLSAForSiteLocation(String lennoxId){
        List<Lennox_LSA__c> lennoxLSAList = [SELECT Id,Name FROM Lennox_LSA__c WHERE Id =: lennoxId];
        return lennoxLSAList [0];
    }
    
    //SubmitQMIRequest
    @AuraEnabled
    public static Lennox_QMI__c updateLennoxQMIRecord(String lennoxId){
        Lennox_QMI__c lennox_QMIRecord = [SELECT SubmittedDate__c FROM Lennox_QMI__c WHERE Id =: lennoxId];
        lennox_QMIRecord.SubmittedDate__c = Date.today();
        update lennox_QMIRecord;
        Lennox_QMI__c lennox_QMIRecords = [SELECT SubmittedDate__c FROM Lennox_QMI__c WHERE Id =: lennoxId];
        return lennox_QMIRecord;
    }
    
    
    //SiteVisitFromLennoxQMI
    @AuraEnabled
    public static Lennox_QMI__c getLennoxForSiteVisit(String lennoxId){
        List<Lennox_QMI__c> lennoxQMIList = [SELECT Account__c,Case__c,Comments_from_Case__c,Name,FTC1__c,FTC__c,Responsible_FTC__c,Home_Owner__c FROM Lennox_QMI__c WHERE Id =: lennoxId];
        return lennoxQMIList [0];
    }
    
    //SiteLocationFromLennoxQMI
    @AuraEnabled
        public static Lennox_QMI__c getLennoxQMIForSiteLocation(String lennoxId){
            List<Lennox_QMI__c> lennoxQMIList = [SELECT Id,Name FROM Lennox_QMI__c WHERE Id =: lennoxId];
            return lennoxQMIList [0];
     }
     
    //ConvertLead
    @AuraEnabled
    public static Lead updateLeadRecord(String leadId){
        Lead leadRecord = [SELECT Status,Case__c FROM Lead WHERE Id =: leadId];
        leadRecord.Status = 'Conversion in progress'; 
        leadRecord.Case__c = true;
        update leadRecord;
        return leadRecord;
    }
    
    
    //LennoxLSAFromAccount
    @AuraEnabled
    public static Account getAccountForLennoxLSA(String accountId){
        List<Account> accountList = [SELECT Id, Name, SAP_Customer_Number__c, SAP_Sales_Office__c FROM Account WHERE Id =: accountId];
        return accountList[0];
    }
    
    
    //SiteVisitFromCase
    @AuraEnabled
    public static Case getCaseForSiteVisit(String caseId){
        List<Case> caseList = [SELECT AccountId,CaseNumber,Description,Regional_Director__c,FTC1__c,FTC__c,OwnerId,District_Manager__c,Responsible_FTC__c,Home_Owner__c FROM Case  WHERE Id =: caseId];
        return caseList[0];
    }
    
    //LennoxLSAFromCase
    @AuraEnabled
    public static Case getCaseForLennoxLSA (String caseId){
        List<Case> caseList = [SELECT CaseNumber,Regional_Director__c,District_Manager__c,FTC1__c,FTC__c,OwnerId,Description,Home_Owner__c,Reason,Territory_Manager1__c,AccountId,Responsible_FTC__c FROM Case WHERE Id =: caseId];
        return caseList[0];
    }
    
    //SiteLocationFromCase
    @AuraEnabled
    public static Case getCaseForSiteLocation (String caseId){
        List<Case> caseList = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseId];
        return caseList[0];
    }
    
    //LennoxQMIFromCase
    @AuraEnabled
    public static Case getCaseForLennoxQMI (String caseId){
        List<Case> caseList = [SELECT District_Manager__c,FTC1__c,FTC__c,Territory_Manager1__c,Regional_Director__c,Description,CaseNumber,AccountId,Home_Owner__c,Responsible_FTC__c FROM Case WHERE Id =: caseId];
        return caseList[0];
    }
    
    //ProposalAndCloseFromActionPlan
    @AuraEnabled
    public static Action_Plan__c getActionPlanForProposalAndClose(String actionPlanId){
        List<Action_Plan__c> actionPlanList = [SELECT Account_Plan__c,Id,Opportunity_Scorecard__c,Account_Opportunity__c FROM Action_Plan__c WHERE Id =: actionPlanId];
        return actionPlanList[0];
    }
    
    //LennoxProsWarrantyFromWarranty
    @AuraEnabled
    public static Warranty__c getLennoxProsWarrantyForWarranty(String warrantyId){
        List<Warranty__c> warrantyList = [SELECT Customer_Number__c FROM Warranty__c WHERE Id =: warrantyId];
        return warrantyList[0];
    }*/
}