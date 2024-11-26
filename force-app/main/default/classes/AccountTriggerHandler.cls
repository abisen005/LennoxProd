public without sharing class AccountTriggerHandler {

    /*
* @description Insert a custom sales area record if none exist already based on the value of SAP Sales org
* @param accounts List of accounts in scop
*/
    public static void insertCustomerSalesArea(List<Account> accounts) {

        Vendavo__SalesArea__c[] salesAreas = new List<Vendavo__SalesArea__c>();
        Vendavo__CustomerSalesArea__c[] insertCustomerSalesAreas = new List<Vendavo__CustomerSalesArea__c>();
        Map<String, Id> salesAreaLabelIdMap = new Map<String, Id>();
        Map<Id, List<Vendavo__CustomerSalesArea__c>> accIdSalesAreasMap = new Map<Id, List<Vendavo__CustomerSalesArea__c>>();
        String[] accSalesAreas = new List<String>();
        Id[] accIds = new List<Id>();

        //loop through accounts in scope and get ids and sap sales org values
        for(Account a :accounts) {
            accSalesAreas.add(a.SAP_Sales_Org__c);
            accIds.add(a.Id);
            accIdSalesAreasMap.put(a.Id, new List<Vendavo__CustomerSalesArea__c>());
        }

        //iterate through all related custom sales area records for accounts in scope, add to a map so we can know later if the account has a
        //csa record or not
        for(Vendavo__CustomerSalesArea__c csa :[SELECT Vendavo__Customer__c FROM Vendavo__CustomerSalesArea__c WHERE Vendavo__Customer__c IN :accIds]) {
            accIdSalesAreasMap.get(csa.Vendavo__Customer__c).add(csa);
        }

        //Get list of sales area records whose sales org id value is in any of the accounts in scope
        salesAreas = [SELECT Id, Vendavo__SalesOrgID__c FROM Vendavo__SalesArea__c WHERE Vendavo__SalesOrgID__c IN :accSalesAreas];

        //only need to continue if there are sales areas to add
        if(!salesAreas.isEmpty()) {
            //create map of org id to sales area object id so we can create the csa record with the right relationship
            for(Vendavo__SalesArea__c sa :salesAreas) {
                salesAreaLabelIdMap.put(sa.Vendavo__SalesOrgID__c, sa.Id);
            }

            for(Account a :accounts) {
                //checking to see if the account already has a csa record
                if(accIdSalesAreasMap.get(a.Id).isEmpty()) {
                    Vendavo__CustomerSalesArea__c csa = new Vendavo__CustomerSalesArea__c();
                    csa.Vendavo__Customer__c = a.Id;
                    csa.Vendavo__SalesArea__c = salesAreaLabelIdMap.get(a.SAP_Sales_Org__c);
                    insertCustomerSalesAreas.add(csa);
                }
            }

        }

        try {
            insert insertCustomerSalesAreas;
        } catch(DMLException e) {
            system.debug(e.getMessage());
        }

    }

    //checks if the relevant fields on account were updated and if so provisions a new community user
    public void provisionFTLUser(List<Account> oldAccounts, Map<Id,Account> newAccMap){
        //modified accounts list
        Map<Id,Account> modAccounts = New Map<Id,Account>();
        Map<Id, Account> mastersChildAccountMap = new Map<Id, Account>();
        User integrationUser = [Select id,name from user where lastname='Intgrtduser'];
        Set<Id> parentAccountIds = new Set<Id>();
        //iterate over accounts and see if it was updated to meet provisioning criteria
        for(Account a : oldAccounts){

            if(newAccMap.get(a.Id).DS_Completion_Date__c != null && newAccMap.get(a.Id).DS_Completion_Date__c != a.DS_Completion_Date__c){
                String curyear = String.valueOf(System.Today().year());

                String comDate = String.valueOf(newAccMap.get(a.Id).DS_Completion_Date__c);

                if(String.isNotBlank(comDate) && comDate.contains(curYear)){
                    // if(!newAccMap.get(a.Id).isCustomerPortal){
                    //     newAccMap.get(a.Id).isCustomerPortal = true;
                    // }
                    if(newAccMap.get(a.Id).FTL_Eligibility__c != 'Enrolled'){
                        newAccMap.get(a.Id).FTL_Eligibility__c = 'Enrolled';
                    }
                    modAccounts.put(a.Id, newAccMap.get(a.Id));
                }
            }
        }
        //done iterating over accounts; grab associated contacts
        if(modAccounts.size() == 0){
            return;
        }
        System.debug('modAccounts ::::: ::::::: ' + modAccounts);
        List<Contact> cons = New List<Contact>([Select Id, FirstName, LastName, Email, AccountId, FTL_Program_Status__c, FTL_Dealer_Signup_Status__c
                                                FROM Contact
                                                WHERE (AccountId IN :modAccounts.keySet())
                                                // OR AccountId IN :mastersChildAccountMap.keySet())
                                                AND FTL_Program_Status__c = 'Request to Enroll'
                                                AND FTL_Dealer_Signup_Status__c = 'Approved'
                                                AND FTL_Provisioned__c = false]);
        if(cons.size() == 0){
            return;
        }

        //now make sure that the accounts in question are enabled for the community and if not update them
        for(Contact c : cons){
            if(newAccMap.get(c.AccountId) != NULL && newAccMap.get(c.AccountId).IsCustomerPortal == false){   //replacedisPartner with IsCustomerPortal 6/6
               if(!test.isRunningTest()) newAccMap.get(c.AccountId).IsCustomerPortal = true; //replacedisPartner with IsCustomerPortal 6/6
            }

            //also update provisioned flag
            c.FTL_Provisioned__c = true;
            c.FTL_Program_Status__c = 'Enrolled';
            c.FTL_Dealer_Signup_Status__c = 'Enrolled';
            c.OwnerId = integrationUser.Id;
        }

        update cons;
        //finally, call the creatUser function passing the list of validated contacts
        createUser(cons);
    }

    public static void UpdateChildAccounts(List<Account> accounts){
        for(Account record: accounts){
            record.DS_Completion_Date__c = record.FTL_Master_Agreement_Account__r.DS_Completion_Date__c;
            //record.DS_Dealer_Agreement_Response__c = record.FTL_Master_Agreement_Account__r.DS_Dealer_Agreement_Response__c;
        }
        update accounts;
    }

    /******************************************************************************************************************************/
    /*Begin Sharing*/
    //Note: since this is rarely done, and with very few records, this is not batched.

    public static void processShares() {
        List<Account> dealerAccounts = new List<Account>();
        List<Account> dealerAccounts_removeShares = new List<Account> ();
        set<Id> dealerAccountIdsToResync = new set<Id>();

        for(Account newAccount : (List<Account>)trigger.new) {
            Account oldAccount = (Account) trigger.oldMap.get(newAccount.Id);

            if(newAccount.FTL_Master_Agreement_Account__c != null) {
                if(newAccount.FTL_Master_Agreement_Account__c != oldAccount.FTL_Master_Agreement_Account__c) {
                    dealerAccounts.add(newAccount);
                    dealerAccountIdsToResync.add(newAccount.Id);
                    if (oldAccount.FTL_Master_Agreement_Account__c!=null) {
                        dealerAccounts_removeShares.add(oldAccount);
                        dealerAccountIdsToResync.add(oldAccount.Id);
                    }
                }
            }
            else if(oldAccount.FTL_Master_Agreement_Account__c!=null) {
                dealerAccounts_removeShares.add(oldAccount);
                dealerAccountIdsToResync.add(oldAccount.Id);
            }
        }

        if (!dealerAccounts_removeShares.isEmpty()) { deleteSharingRecords(dealerAccounts_removeShares); }
        if (!dealerAccounts.isEmpty()) { createNewSharingRecords(dealerAccounts); }
        if (!dealerAccountIdsToResync.isEmpty()) { processFormShares(dealerAccountIdsToResync); }
    }

    public static void processFormShares(set<Id> dealerAccountIds) {
        if (System.isBatch()) {
            processFormSharesLogic(dealerAccountIds);
        } else {
            processFormSharesAsync(dealerAccountIds);
        }
    }

    @future
    private static void processFormSharesAsync(Set<Id> dealerAccountIds) {
        processFormSharesLogic(dealerAccountIds);
    }

    private static void processFormSharesLogic(Set<Id> dealerAccountIds) {
        //Being there are very few forms per account, and very few contacts, simplest approach is to wipe and reload shares using existing logic in place on the form trigger
        List<FTL_Program_Form__c> ftlPrograms = [SELECT Id, Assigned_Dealer__c from FTL_Program_Form__c WHERE Assigned_Dealer__c IN :dealerAccountIds];
        if (!ftlPrograms.isEmpty()) {
            FTL_Program_Form_TrgrHandler.deleteSharingRecords(ftlPrograms); //Wipe all
            FTL_Program_Form_TrgrHandler.createNewSharingRecords(ftlPrograms); //Resync all
        }
    }

    /*
    * @Purpose  : Delete the form sharings related to the form Ids
    * @Param    : List<Account> dealerAccounts_removeShares
    */
    public static void deleteSharingRecords(List<Account> dealerAccounts_removeShares) {
        List<AccountShare> shares = [SELECT Id FROM AccountShare WHERE AccountId IN :dealerAccounts_removeShares AND RowCause = 'Manual'];
        delete shares;
    }

    /*
    * @Purpose  : Insert sharing records.
    * @Param    : List<Account> dealerAccounts
    */
    public static void createNewSharingRecords(List<Account> dealerAccounts) {
        system.debug('in future create share');
        set<Id> masterAccountIds = new set<Id>();
        for(Account a: dealerAccounts) { masterAccountIds.add(a.FTL_Master_Agreement_Account__c); }
        Map<Id, Account> masterAccounts = new Map<Id, Account> ([SELECT Id, (SELECT Id, Name FROM Contacts WHERE FTL_Program_Status__c = 'Enrolled'
                                                                  AND FTL_Provisioned__c=TRUE) FROM Account WHERE Id IN :masterAccountIds]); //Populate dealer accounts with contacts into a map so we can lookup the accountId's contacts to generate shares
        List<Contact> allContacts = getContacts(masterAccounts.values()); //Get a list of all Contacts so we can query a list of users
        Map<Id, User> contactIdToUser = createContactToUserMap(allContacts); //Query users and set the lookup key to the Contact Id to lookup users by Contact Id
        system.debug('allContacts ::'+allContacts);
        List<AccountShare> allSharings = new List<AccountShare>();
        for(Account dealer : dealerAccounts) {
            if(masterAccounts.containsKey(dealer.FTL_Master_Agreement_Account__c)) {
                Account master = masterAccounts.get(dealer.FTL_Master_Agreement_Account__c);
                List<Contact> acctContacts = master.Contacts;
                if(acctContacts != NULL && !acctContacts.isEmpty()) {
                    allSharings.addAll(createNewSharingsRecs(dealer, acctContacts, contactIdToUser));
                }
            }
        }
        system.debug(allSharings);
        insert allSharings;

        system.debug('allSharings ::'+allSharings);
    }

    /*
    * @Purpose  : Create new sharing records.
    * @Param    : Account dealerAccount, List<Contact> contacts, Map<Id, User> contactIdToUser
    * @Return   : List<Account>
    */
    public static List<AccountShare> createNewSharingsRecs(Account dealerAccount, List<Contact> contacts, Map<Id, User> contactIdToUser) {
        Map<Id, AccountShare> shares = new Map<Id, AccountShare>();

        for(Contact c : contacts) {
            if(shares.containsKey(c.Id)) {continue;}

            if(contactIdToUser.containsKey(c.Id)){
                User u = contactIdToUser.get(c.Id);

                shares.put(c.Id,
                    new AccountShare(
                        AccountId = dealerAccount.Id,
                        UserOrGroupId = u.Id,
                        AccountAccessLevel = 'Edit',
                        CaseAccessLevel = 'none',
                        //ContactAccessLevel = 'read',
                        OpportunityAccessLevel = 'none',
                        RowCause = Schema.AccountShare.RowCause.Manual
                )
              );
            }
        }
        return shares.values();
    }

    /*
    * @Purpose  : Create Contact Map
    * @Param    : List<Account> accounts
    * @Return   : List<Contact>
    */

    public static List<Contact> getContacts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();

        for(Account a : accounts) {
            if(a.contacts != NULL && !a.contacts.isEmpty()) {
                contacts.addAll(a.contacts);
            }
        }

        return contacts;
    }

    /*
    * @Purpose  : Create Contact Id to User Map
    * @Param    : List<Contact> contacts
    * @Return   : Map<Contact Id, User>
    */
    public static Map<Id, User> createContactToUserMap(List<Contact> contacts) {
        List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId IN :contacts AND IsActive = true AND Customer__c = true];
        Map<Id, User> contactIdUserMap = new Map<Id, User>();
        for(User u : users) { contactIdUserMap.put(u.ContactId, u); }
        return contactIdUserMap;
    }

    /*End Sharing*/
    /******************************************************************************************************************************/

    public static void afterUpdate(List<Account> oldAccounts, Map<Id,Account> newAccMap){
        processShares();
        Map<Id, Account> mastersChildAccountMap = new Map<Id, Account>();
        Map<Id, Account> modAccounts = new Map<Id, Account>();
        for(Account accountRec : newAccMap.values()) {
            if(accountRec.DS_Completion_Date__c != null){ //accountRec.DS_Dealer_Agreement_Response__c == 'Accept' &&
                modAccounts.put(accountRec.Id, newAccMap.get(accountRec.Id));
            }
        }

        if(modAccounts.size() == 0){
            return;
        }
        mastersChildAccountMap = new Map<Id, Account>([SELECT Id, DS_Completion_Date__c, FTL_Master_Agreement_Account__c,
                                                       FTL_Master_Agreement_Account__r.DS_Completion_Date__c
                                                       FROM Account
                                                       WHERE FTL_Master_Agreement_Account__c IN :modAccounts.keySet()
                                                      ]);
        if(!mastersChildAccountMap.isEmpty()){
           // UpdateChildAccounts(mastersChildAccountMap.values()); (Logic has been implemeneted in Record Triggered Flow)
        }
    }

   /* public static void processNomCount(List<Account> acctList){
        Map<Id, Account> acctsMap = new Map<Id, Account>();
        /*for (Account acc : acctList){
            if(acc.FTL_Nomination_Count__c == 0) {
                acctsMap.put(acc.id, acc);
            }
        }

        if(acctsMap.size() > 0){
            acctsMap = FTL_findDealerController.getNomCount(acctsMap);
        }
    }*/

    public void createUser(List<Contact> cons){

        //set of contacts that need permission set
        Set<String> managingPartners = New Set<String>();

        List<User> usersToInsert = New List<User>();
        Id profId;

        if(Test.isRunningTest()){
             profId = [Select Id FROM Profile WHERE Name LIKE 'Community%'][0].Id;   //Updated profile from external identity 6/6
        }else{
             profId = [Select Id FROM Profile WHERE Name = 'Customer Community Plus Login - FTL' LIMIT 1].Id;   //Updated profile from external identity 6/6
        }
			
        //List<User> activeUserList =[Select Id,CommunityNickname from User where IsActive =true];
        for(Contact c : cons){
            //for(User existingUser :activeUserList ){
            User u = New User();
            u.firstName = c.FirstName;
            u.lastName = c.LastName;
            u.ContactId = c.Id;
            u.ProfileId = profId;
            u.Username = c.Email  +'.lennox';
            u.Email = c.Email;
            u.CommunityNickname = c.LastName + '_' + Math.random();
            String alias;
            if(c.FirstName.length()>0){
                alias = c.FirstName.subString(0,1);
            }
            if(c.LastName.length()>3){
                alias += c.LastName.substring(0,3);
            } else {
                alias += c.LastName;
            }
            u.Alias = alias;
            u.TimeZoneSidKey = 'America/Chicago'; // Required
            u.LocaleSidKey = 'en_US'; // Required
            u.EmailEncodingKey = 'ISO-8859-1'; // Required
            u.LanguageLocaleKey = 'en_US'; // Required
            u.IsActive = true;
            u.Customer__c = true;
            String nickName = c.firstName + '.'+ c.LastName;
            if(nickName.length()>40){
                u.CommunityNickname = nickName.substring(0,39);
            } //else if (existingUser.CommunityNickname == nickName){
            //u.CommunityNickname = c.LastName + '_' + Math.random();
            //}
                else {
                u.CommunityNickname = c.LastName + '_' + Math.random();
            }
            usersToInsert.add(u);

        //}
        }
        if(usersToInsert.size()>0 || Test.isRunningTest()){
            insert usersToInsert;
            List<Id> ids = new List<Id>();
            for(User u : usersToInsert) { ids.add(u.Id); }
            AssignPermissions(ids);
            //AssignContentWorkspaces(ids);
            AssignToPublicGroup(ids);
       }
    }

    @future
   public static void AssignContentWorkspaces(List<Id> users) {
        ContentWorkspacePermission permission = [SELECT Id FROM ContentWorkspacePermission WHERE Name='Viewer'];
        //Integer currentYear = System.today().year();
        if (permission == null) { return; }
        Set<String> libraries = new Set<String>();
       	libraries.add('Feel_The_Love');
        //libraries.add('FTL_Tools_'+currentYear);
        //libraries.add('FTL_Assets_'+currentYear);
        //libraries.add('FTL_Misc_'+currentYear);
        //libraries.add('FTL_Forms_'+currentYear);
        List<ContentWorkspace> workspaces = [SELECT Id FROM ContentWorkspace WHERE DeveloperName IN ('Feel_The_Love')];
        if (workspaces.isEmpty()) { return; }
        List<ContentWorkspaceMember> members = new List<ContentWorkspaceMember>();
        for (Id uId: users) {
            for (ContentWorkSpace cw: workspaces) {
                ContentWorkspaceMember m = new ContentWorkspaceMember();
                m.ContentWorkspaceId = cw.Id;
                m.ContentWorkspacePermissionId = permission.Id;
                m.MemberId = uId;
                members.add(m);
            }
        }
        insert members;
    }

    @future
    public static void AssignPermissions(List<Id> users) {
        try{
            List<PermissionSetAssignment> permsToInsert = new List<PermissionSetAssignment>();
            id permId = [SELECT Id FROM PermissionSet WHERE Name LIKE 'Feel_The_Love_Dealer' LIMIT 1].Id;
            for(Id i : users) {
                permsToInsert.add(new PermissionSetAssignment(AssigneeId = i, PermissionSetId = permId));
            }
            insert permsToInsert;
        }catch(Exception e){
            system.debug('Exception -- '+e);
        }

    }

    @future
    public static void AssignToPublicGroup(List<Id> users){
        try{
            Group grp = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = 'FTL_Group'];
            List<GroupMember> GMlist = new List<GroupMember>();
            for(Id U : users) {
                GroupMember GM = new GroupMember();
                GM.GroupId = grp.Id;
                GM.UserOrGroupId = U;
                GMList.add(GM);
            }
            if(!GMList.isEmpty()) {
                System.debug('Group Member List is ' + GMList);
                insert GMList;
            }
        }catch(Exception e){
            system.debug('Exception -- '+e);
        }
    }
}