public with sharing class SCLAlerts {
List<SupplyChainUpdate__c> chains = [Select id, message1__c, prioritymessage__c, enabled__c from SupplyChainUpdate__c where enabled__c= TRUE];

    ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(chains);



public List<SupplyChainUpdate__c> getchains() {
return (List<SupplyChainUpdate__c>) ssc.getRecords();
}}