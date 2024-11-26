Global class SetContactSyncToPardotFlag implements Database.Batchable<sObject> {
    // The logic to Sync Contacts to Pardot sits on the 
    // Contact field pi_Formula_Sync_To_Pardot__c
    // non-deterministic formula fields cannot be used  
    // directly on Marketing Data Sharing Rules
    // This class upates a boolean pi_Sync_To_Pardot__c from the formula field
    
    // Create an empty collection of Contacts to update
    List<Contact> ContactsToUpdate = new List<Contact>();

	// Build the query string to select ONLY those Contacts that are out of sync
    String Query  = 'SELECT Id, pi_Sync_To_Pardot__c, pi_Formula_Sync_To_Pardot__c FROM Contact WHERE pi_Need_To_Sync__c = true';
     
    // Run the query and select the Contacts out of sync
    global Database.queryLocator start(Database.BatchableContext BatchCtx ) {
        return Database.getQueryLocator(Query);
    }
    
    // Loop through all the Contacts selected and set the Sync_To_Pardot flag
    // to match the formula field
    global void execute(Database.BatchableContext BatchCtx, List<Contact> ContactList) {
 		for(Contact C : ContactList){
        	C.pi_Sync_To_Pardot__c = C.pi_Formula_Sync_To_Pardot__c;
            ContactsToUpdate.add(C);
        }
        update ContactsToUpdate;
    }
    global void finish(Database.BatchableContext BatchCtx) {   
    }
}