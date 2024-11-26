public class VendavoDealTriggerHandler {

    /*******************************************************************************************************
* @description Find related account opportunity for a new deal.
* @param deals List of deal sobjects
* @return void
* @example
* VendavoDealTriggerHandler.findRelatedAccountOpportunity(Trigger.new);
*/
    public static void findRelatedAccountOpportunity(List<Vendavo__Deal__c> deals) {
        Set<String> accountIds = new Set<String>();
        Map<String, Id> accountAccountOpps = new Map<String, Id>();

        System.debug('deals: ' + deals);

        for(Vendavo__Deal__c d : deals) {
            if(d.Account_Opportunity__c == null && d.Vendavo__VSoldTo__c != null) {
                accountIds.add(String.valueOf(d.Vendavo__VSoldTo__c).substring(0, 15));
            }
        }

        System.debug('accountIds: ' + accountIds);

        for(Account_Opportunty__c ao : [SELECT Id, Dealer_Account_Plan__r.Dealer__c
                                        FROM Account_Opportunty__c
                                        WHERE Id NOT IN (SELECT Account_Opportunity__c FROM Vendavo__Deal__c WHERE Vendavo__VSoldTo__c IN :accountIds)
                                            AND Dealer_Account_Plan__r.Dealer__c in :accountIds
                                            AND Connected_to_Deal__c = FALSE
                                            AND Opportunity_Type__c = 'CDQ Request' 
                                        ORDER BY CreatedDate DESC]) {
                                            System.debug(ao);
                                            String accId = String.valueOf(ao.Dealer_Account_Plan__r.Dealer__c).substring(0, 15);
                                            if(accountAccountOpps.get(accId) == NULL) {
                                            	accountAccountOpps.put(accId, ao.Id);
                                            }
                                        }

        if(!accountAccountOpps.isEmpty()) {
            for(Vendavo__Deal__c d : deals) {
                d.Account_Opportunity__c = accountAccountOpps.get(String.valueOf(d.Vendavo__VSoldTo__c).substring(0, 15));
            }
        }
    }

    /*******************************************************************************************************
* @description Update related account opportunity status when deal status changes
* @param deals List of deal sobjects
* @param oldMap Map of deal ids and old versions of deals.  Used to compare previous value of
* @return void
* @example
* VendavoDealTriggerHandler.updateAccountOpportunityStatus(Trigger.new, Trigger.oldMap);
*/
    public static void updateAccountOpportunityStatus(List<Vendavo__Deal__c> deals, Map<Id, Vendavo__Deal__c> oldMap) {
        Map<Id, String> accountOppIds = new Map<Id, String>(); // Account Opp Id => New Account Opp Status
        List<Account_Opportunty__c> accountOppsToUpdate = new List<Account_Opportunty__c>();
        Map<String, String> dealStatusMap = new Map<String, String>(); // Vendavo Status => New Account Opp Status
        dealStatusMap.put('approved', 'Completed');
        dealStatusMap.put('denied', 'Cancelled');
        for(Vendavo__Deal__c d : deals) {
            if(oldMap.get(d.Id).Vendavo__Status__c.toLowerCase() != d.Vendavo__Status__c.toLowerCase() && //status has changed
               dealStatusMap.containsKey(d.Vendavo__Status__c.toLowerCase()) && //status is approved or denied
               d.Account_Opportunity__c != null) { //account opp exists
                   accountOppIds.put(d.Account_Opportunity__c, dealStatusMap.get(d.Vendavo__Status__c));
               }
        }
        accountOppsToUpdate = [SELECT Id FROM Account_Opportunty__c WHERE Id IN :accountOppIds.keySet()];
        if(!accountOppsToUpdate.isEmpty()) {
            for(Account_Opportunty__c ao : accountOppsToUpdate) {
                ao.Opportunity_Status__c = accountOppIds.get(ao.Id);
            }
            try {
                update accountOppsToUpdate;
            } catch(DmlException e) {
                system.debug(e.getMessage());
            }

        }

    }


}