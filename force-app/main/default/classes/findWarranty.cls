public class findWarranty {
    private List<Warranty__c> war;
    public String caseId {get;set;}
    public String subject {get;set;}

    public findWarranty() {
        
    }

    public List<Warranty__c> getWarranty() {
    war = [select Include_in_Template__c, Decline_Code__c,  Serial_Number__c,Days_Failure_to_File__c,    Warranty_Creation_Date__c,Warranty_Claim__c,Account__r.Name,Customer_Number__c,Decline_Code_Description__c, Model_Description__c,Open_space__c,Installation_Date__c,PO_Number__c,Line_Item__c, SAP_Order_Number__c,Store_Location__c,Billing_Doc_Number__c,Failed_Part__c, Case__c, Component_Failed_Date__c, Failure_Reason_Customer__c, Failure_Reason__c,Failed_Part_Description__c,Replacement_Part__c from Warranty__c where Case__c=:caseId AND Include_in_Template__c=true];
        return war;
    }
}