/*
* @ Purpose      : Handler for Contact Trigger              
* @ CreatedDate  : 03-04-2019
*/
public class Contact_Trgr_Handler {
        
    /*
    * @Purpose  : Restrict the contact in limit present on account
    * @Param    : List<Contact> contacts
    * @Return   : 
    */
    public static void allowNumberOfContact(List<Contact> contacts, Boolean isUpdate, Map<Id, Contact> oldContacts) {
        // Logged User Id
        Id loggedUserId = UserInfo.getUserId();
        
        // Logged User Details
        User currentLoggedUser = fetchUserDetails(loggedUserId);
        Account loggedUseraccountDetails;
        
        // logged user contact role = Managing Partner
        if(currentLoggedUser.Contact != NULL && String.isNotBlank(currentLoggedUser.Contact.FTL_Role__c) && currentLoggedUser.Contact.FTL_Role__c.equalsIgnoreCase('Managing Partner')) {
            if( currentLoggedUser.Contact.AccountId != NULL ) {
                // Account Details for current logged user
                loggedUseraccountDetails = fetchAccountDetails(currentLoggedUser.Contact.AccountId);                
                
                Set<Id> accountIds = new Set<Id>();
                for(Contact conRecord : contacts){
                    if(!isUpdate && conRecord.AccountId != NULL){
                        accountIds.add(conRecord.AccountId);
                    }else{
                        if(isUpdate && oldContacts.containsKey(conRecord.Id) 
                           && ( (conRecord.AccountId != NULL &&  (oldContacts.get(conRecord.Id).AccountId == NULL) ) || 
                               (conRecord.AccountId != oldContacts.get(conRecord.Id).AccountId)
                              )
                          ){
                              accountIds.add(conRecord.AccountId);
                          }
                    } 
                }
                
                Map<Id, Account> accounts = fetchAccounts(accountIds);
                if(!accounts.isEmpty()){
                    
                    restrictContactsWithinAllowedRange(contacts, accounts, loggedUseraccountDetails);
                } 
            }            
        }
    }
    
    /*
    * @Purpose  : Fetch account details for input account Id
    * @Param    : Id accountId
    * @Return   : Account
    */
    public static void restrictContactsWithinAllowedRange(List<Contact> contacts, Map<Id, Account> accounts, Account loggedUserAccount){
        for(Contact contact : contacts){
            // new Contact account equals logged account
            if(contact.AccountId != NULL ){
                if(accounts.containsKey(contact.AccountId)){
                    Account contactsAccount = accounts.get(contact.AccountId);
                    
                    // Number of allowed contacts on account
                    // If logged user and contact account is same then allowed contacts are other than that user.
                    Decimal allowedContacts = 0;
                    if(loggedUserAccount != NULL && contactsAccount.Id == loggedUserAccount.Id 
                       && loggedUserAccount.FTL_Number_of_Contacts_Allowed__c != NULL) {
                        allowedContacts = loggedUserAccount.FTL_Number_of_Contacts_Allowed__c + 1;
                    }else{
                        if(contactsAccount.FTL_Number_of_Contacts_Allowed__c != NULL){
                            allowedContacts = contactsAccount.FTL_Number_of_Contacts_Allowed__c;
                        }
                    }
                    
                    // Currently Present Contacts on account selected for inserting contact
                    Integer presentContactsOnAccount = 0;
                    if(contactsAccount.Contacts != NULL && !contactsAccount.Contacts.isEmpty()){
                        presentContactsOnAccount = contactsAccount.Contacts.size();
                    }
                    
                    // If present contacts less than that of the allowed contacts on the account 
                    if( presentContactsOnAccount < allowedContacts){
                        presentContactsOnAccount++;
                    } else{
                        // Else present contacts greater than that of the allowed contacts 
                        //on the account show error message
                        String errorMsg = 'You have reached the maximum number of'+
                            ' contacts that can be created. If you need to create additional contacts, please contact'+
                            ' the Feel the Love Program team.';
                        // Adding error message on record
                        contact.AddError(errorMsg);
                    }
                }
            }
        }        
    }
    
    /*
    * @Purpose  : Fetch User details for input user Id
    * @Param    : Id loggedInUser
    * @Return   : User
    */
    public static User fetchUserDetails(Id loggedInUser){
        User userRecord = [SELECT Id, Contact.FTL_Role__c, Contact.AccountId, Contact.Name
                           FROM User 
                           WHERE Id = :loggedInUser ];
        return userRecord;
    }
    
    /*
    * @Purpose  : Fetch account details for input account Id
    * @Param    : Id accountId
    * @Return   : Account
    */
    public static Account fetchAccountDetails(Id accountId){
        Account accountRecord = [SELECT Id, FTL_Number_of_Contacts_Allowed__c, (SELECT Id FROM Contacts)
                                 FROM Account 
                                 WHERE Id = :accountId ];
        return accountRecord;
    }
    
    /*
    * @Purpose  : Fetch account details for input account Ids
    * @Param    : Set<Id> accountIds
    * @Return   : Map<Id, Account>
    */
    public static Map<Id, Account> fetchAccounts(Set<Id> accountIds){
        Map<Id, Account> accountRecords = new Map<Id, Account>([SELECT Id, FTL_Number_of_Contacts_Allowed__c, (SELECT Id FROM Contacts)
                                                                FROM Account 
                                                                WHERE Id IN :accountIds ]);
        return accountRecords;
    }
    
    public static void provisionCommUsers(List<Contact> oldCons, Map<Id,Contact> newConMap){
        
        Set<Id> acntIds = New Set<Id>();
        Map<Id,Contact> vettedCons = New Map<Id,Contact>();
        
        //iterate over contacts and see if it has been updated in such a way that it should be provisioned
        for(Contact c : oldCons){
            Contact newCon = New Contact();
            System.debug('iterating dan');
            System.debug('iterating contact '+c);
            newCon = newConMap.get(c.Id);
            if(newCon.FTL_Program_Status__c == 'Request to Enroll' && newCon.FTL_Dealer_Signup_Status__c == 'Approved' && (newCon.FTL_Dealer_Signup_Status__c != c.FTL_Dealer_Signup_Status__c) && c.FTL_Provisioned__c == false){
                system.debug('dan here is the id ' + newCon.AccountId);
                if(String.valueOf(newCon.AccountId).contains('00')){
                    acntIds.add(newCon.AccountId);
                    vettedCons.put(c.Id,newCon);
                } 
            }
        }
        
        if(acntIds.size()==0){
            return;
        }
        
        Map<Id,Account> acntMap = New Map<Id,Account>([Select Id, IsPartner, isCustomerPortal, DS_Completion_Date__c FROM Account WHERE Id IN :acntIds]);
        if(acntMap.size() == 0){
            return;
        }
        
        Boolean needsUpdate = false;
        
        //iterate over accounts and remove any that don't have a completion date of this year
        for(Account a : acntMap.values()){
            String curyear = String.valueOf(System.Today().year());
                    
            String comDate = String.valueOf(a.DS_Completion_Date__c);
            
            if(String.isBlank(comDate) || (String.isNotBlank(comDate) && comDate.contains(curYear) == false)){
                acntMap.remove(a.Id);
            }
            
            //check if already is customer and if not provision
            //if(!a.IsCustomerPortal){  //changed from isPartner 7/5
                //a.IsCustomerPortal = true;  //changed from isPartner 7/5
                //needsUpdate = true;
           // }
        }
        
        for(Contact c : vettedCons.values()){
            if(acntMap.containsKey(c.AccountId) == false){
                vettedCons.remove(c.Id);
            }
        }
        
        if(needsUpdate){
            update acntMap.values();
        }
        
        if(vettedCons.size()>0){
            //iterate over vetted contacts and update to provisioned
            for(Contact c : vettedCons.values()){
                c.FTL_Provisioned__c = true;
                c.FTL_Program_Status__c = 'Enrolled';
            }
            
            //call account trigger handler to insert the User
            AccountTriggerHandler handler = New AccountTriggerHandler();
            handler.createUser(vettedCons.values());
        }
    }
}