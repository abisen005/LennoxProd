public class FindSCL {

    @AuraEnabled
    public static List <SupplyChainUpdate__c> getSCL() {
        List<SupplyChainUpdate__c> SCLList = new List<SupplyChainUpdate__c>();
        for(SupplyChainUpdate__c Acc : [SELECT id, Message1__c, PriorityMessage__c,Enabled__c,Material_s__c,Date__c,Description__c FROM SupplyChainUpdate__c where Enabled__c =true]){
            SCLList.add(Acc);
        }
        return SCLList;
    }
}