/*
* @ Purpose      : Handler for FTL_Program_Form_Trgr
* @ CreatedDate  : 03-04-2019
*/
public without sharing class FTL_Program_Form_TrgrHandler {
        public static Boolean isExecuting = false;

    public static void processTrigger() {
        processTriggerForCSVImportFields();
        processTriggerForSharing();
        processTriggerForEmails();
        processClosedArchived();
    }
    public static void processAfterUpdateTrigger() {
        processTriggerForGeolocation1();
    }
    public static void processAfterInsertTrigger() {
        processTriggerForGeolocation2();
    }
    
      public static void updateGeoLocation(List<FTL_Program_Form__c> newRecords) {
    List<FTL_Program_Form__c> newformRecordsToUpdate = new List<FTL_Program_Form__c>();

    for (FTL_Program_Form__c form : newRecords) {
        form.Refresh_GeoLocation__c = true;
    }
          system.debug('BOOM-Done Updating Refresh Lcoation');
}

   public static void processTriggerForGeolocation1() {
    // Ensure that the trigger is not already executing to prevent recursion
    if (!isExecuting) {
        isExecuting = true; // Set flag to indicate trigger execution
        try {
            List<Id> formRecordsToUpdate = new List<Id>(); // List to store record Ids that need geolocation update
             List<FTL_Program_Form__c> newformRecordsToUpdate = new List<FTL_Program_Form__c>();
                    List<FTL_Program_Form__c> programFormList = Trigger.new;

            for (FTL_Program_Form__c form : programFormList) {               
                 // Get the old record for comparison
FTL_Program_Form__c oldForm = (FTL_Program_Form__c)Trigger.oldMap.get(form.Id);

                // Check if the Refresh_GeoLocation__c field has changed from false or null to true
                if ((oldForm == null || !oldForm.Refresh_GeoLocation__c) && form.Refresh_GeoLocation__c)  {
                    formRecordsToUpdate.add(form.Id);
                } 
            } 
            // Enqueue job only if there are records to update
            if (!formRecordsToUpdate.isEmpty()) {
                // Serialize the list of record Ids into a JSON string
                String recordsJson = JSON.serialize(formRecordsToUpdate);
                //System.enqueueJob(new FTL_setGeoLocationQueueable(recordsJson));
                                FTL_Program_Form_TrgrHandler.setGeoLocation(recordsJson);

            }     
        }  
         finally {
            isExecuting = false; // Reset the flag after trigger execution
        }
    }
}

    
     public static void processTriggerForGeolocation2() {
    // Ensure that the trigger is not already executing to prevent recursion
    if (!isExecuting) {
        isExecuting = true; // Set flag to indicate trigger execution
        try {
            List<Id> formRecordsToUpdate = new List<Id>(); // List to store record Ids that need geolocation update
             List<FTL_Program_Form__c> newformRecordsToUpdate = new List<FTL_Program_Form__c>();
                    List<FTL_Program_Form__c> programFormList = Trigger.new;

            // Iterate over the new records in trigger context
            for (FTL_Program_Form__c form : programFormList) {
                // Check if the Refresh_GeoLocation__c field has changed from false or null to true
                if (form.Refresh_GeoLocation__c)  {
                    formRecordsToUpdate.add(form.Id);
                } 
            }          
            // Enqueue job only if there are records to update
            if (!formRecordsToUpdate.isEmpty()) {
                // Serialize the list of record Ids into a JSON string
                String recordsJson = JSON.serialize(formRecordsToUpdate);
                system.debug('BOOMTest'+recordsJson);
                //System.enqueueJob(new FTL_setGeoLocationQueueable(recordsJson));
                FTL_Program_Form_TrgrHandler.setGeoLocation(recordsJson);
            }
        }
         finally {
            isExecuting = false; // Reset the flag after trigger execution
        }
    }
}
    
    
    @future(callout=true)
    public static void setGeoLocation(String recordsJson){
        System.debug('BOOM1');
        List<String> idStrings = (List<String>) JSON.deserialize(recordsJson, List<String>.class);
        List<Id> recordIds = new List<Id>();
        for (String idString : idStrings) {
            recordIds.add((Id) idString);
        }
        // Now you can use the list of IDs as needed
        // Example:
        List<FTL_Program_Form__c> programFormList = [SELECT Id,Refresh_GeoLocation__c,
                                                     Nominee_Street_Address__c ,Nominee_Zip_Code__c, Nominee_City__c, Nominee_State__c,
                                                     Nominee_Country__c, Location__Latitude__s, Location__Longitude__s
                                                     FROM FTL_Program_Form__c WHERE Id IN :recordIds];
        List<FTL_Program_Form__c> updateFormList = new List<FTL_Program_Form__c>();
        String salesforceAddress;
        String salesforceWithnoStreetAddress;
        // Deserialize the JSON string back into a list of records
        // List<FTL_Program_Form__c> programFormList = (List<FTL_Program_Form__c>) JSON.deserialize(recordsJson, List<FTL_Program_Form__c>.class);
        for(FTL_Program_Form__c form:programFormList ){
            if ( form.Refresh_GeoLocation__c == true )  {
                System.debug('BOOM2');
                // if ( (programFormOldMap.get(form.id).Nominee_Street_Address__c) != form.Nominee_Street_Address__c )  {
                salesforceAddress =  FTL_findDealerController.setupOriginAddress(form);
                if(salesforceAddress == null){
                    // this.errorMsg = nodealermsg;
                }else{
                    Map<string,object> options = new Map<String,Object> {
                        'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                            'address' => salesforceAddress
                            };
                                Map<String, Object> response ;    
                        //System.debug(';;;'+options);
                          if(!Test.isRunningTest()) {
                        System.debug('---->>>'+maps.API.Geocode(options));
                        response = maps.API.Geocode(options); 
                          }
                                if(Test.isRunningTest()) {
                Map<String, Object> fakeResponse = (Map<String, Object>) JSON.deserializeUntyped('{"data":{"position":{"lat":1.23,"lng":4.56}}}');
               response = fakeResponse;
            }
                    
                    
                    String value1 = JSON.serialize(response.get('data'));
                    Map<String, Object> resultsMap1 = (Map<String, Object>) JSON.deserializeUntyped(value1);
                    system.debug('BINGO'+resultsMap1.toString());
                    String value2 = JSON.serialize(resultsMap1.get('position'));
                    system.debug('value2'+value2);
                    Map<String, Object> resultsMap2 = (Map<String, Object>) JSON.deserializeUntyped(value2);
                    if(!resultsMap2.isEmpty()){
                        system.debug('Check1BOOM');
                        Double lat = Double.valueOf(resultsMap2.get('lat'));
                        Double lon = Double.valueOf(resultsMap2.get('lng'));
                        form.Location__Latitude__s = lat;
                        form.Location__Longitude__s = lon;
                        form.Refresh_GeoLocation__c = false;
                        updateFormList.add(form);        
                    }
                }
            }
        }
        if(!updateFormList.isEmpty()){
            update updateFormList;
        }
    }
    
    public static void processClosedArchived(){
        List<FTL_Program_Form__c> formList = trigger.new;
        Map<Id, FTL_Program_Form__c> formOldMap = (Map<Id, FTL_Program_Form__c>)trigger.oldmap;
        if(trigger.isAfter && trigger.isUpdate){
            for(FTL_Program_Form__c form : formList){
                if(form.Assigned_Dealer__c != null &&
                   ((form.Archived__c != formOldMap.get(form.id).Archived__c) || 
                    (form.Status__c != formOldMap.get(form.id).Status__c) ||
                    (form.Assigned_Dealer__c != formOldMap.get(form.id).Assigned_Dealer__c))){
                        
                        Account acct = new Account(Id = form.Assigned_Dealer__c);
                        update acct;
                    } else if(form.Assigned_Dealer__c == null && formOldMap.get(form.id).Assigned_Dealer__c != null){
                        Account acct = new Account(Id = formOldMap.get(form.id).Assigned_Dealer__c);
                        update acct;
                    }
            }
        }
        else if(trigger.IsAfter && trigger.isDelete) {
            System.Debug('!!! formOldMap: ' + formOldMap);
            for(FTL_Program_Form__c form : formOldMap.values()){
                if(form.Assigned_Dealer__c != null) {
                    Account acct = new Account(Id = form.Assigned_Dealer__c);
                    update acct;
                }
            }
        }
    }
    
    public static void processTriggerForCSVImportFields() {
        if(trigger.isBefore) {
            if(trigger.isInsert) {
                //associateAccount(trigger.new); // We did not want to auto populate Assigned Dealer field Commented on 04-05-2020
                isValidAssignedDealer(trigger.new,null);
                ifStatusDeclined(trigger.new,null);
                //checkForDuplicateForms(trigger.new);
            }
            if(Trigger.isUpdate){
                isValidAssignedDealer((List<FTL_Program_Form__c>)trigger.new, (Map<Id, FTL_Program_Form__c>)trigger.oldmap);
                ifStatusDeclined((List<FTL_Program_Form__c>)trigger.new, (Map<Id, FTL_Program_Form__c>)trigger.oldmap);
                getUpdatedRecords((List<FTL_Program_Form__c>)trigger.new, (Map<Id, FTL_Program_Form__c>)trigger.oldmap);
            }
        }
    }
    
    /*public static List<FTL_Program_Form__c> findNominees(Set<Id> formSet, Set<String> namesSet, Set<String> citySet)
{
List<String> partialMatches = new List<String>();
for(String name : namesSet){
String field1 = name.replaceAll('[0-9]', ' ');
String field2 = field1.toLowerCase();
for (String fragment : field2.split(' '))
{
partialMatches.add('%' + fragment + '%');
}
}

System.debug('partialMatches ::'+partialMatches);
return [SELECT Id,Nominee_Name__c,Nominee_City__c, Nominee_Address__c,Assigned_Dealer__c,Assigned_Dealer__r.Name,Status__c,CreatedDate
FROM FTL_Program_Form__c
WHERE Nominee_Name__c LIKE : partialMatches AND Nominee_City__c IN : citySet AND Archived__c = false AND Id NOT IN : formSet];
}



public static void checkForDuplicateForms(List<FTL_Program_Form__c> programFormList){
Set<Id> formSet = new Set<Id>();
Map<String,List<FTL_Program_Form__c>> namecityToFormMap = new Map<String,List<FTL_Program_Form__c>>();
Set<String> namesSet = new Set<String>();
Set<String> citySet = new Set<String>();
for(FTL_Program_Form__c form : programFormList){
formSet.add(form.Id);
namesSet.add(form.Nominee_Name__c);
citySet.add(form.Nominee_City__c);
}
List<FTL_Program_Form__c> duplicateFormLst = findNominees(formSet, namesSet, citySet);/*[SELECT Id,Multiple_Submissions__c,Nominee_Name__c,Nominee_City__c
FROM FTL_Program_Form__c
WHERE Id NOT IN : formSet
AND Nominee_Name__c IN : namesSet
AND Nominee_City__c IN : citySet];*

if(!duplicateFormLst.isEmpty()){
for(FTL_Program_Form__c dupForm : duplicateFormLst){
String field1 = dupForm.Nominee_Name__c.replaceAll('[0-9]', ' ');
String field2 = field1.toLowerCase();
String nameCityKey = field2 + dupForm.Nominee_City__c;
if(!namecityToFormMap.containsKey(nameCityKey)){
namecityToFormMap.put(nameCityKey, new List<FTL_Program_Form__c>());
}

namecityToFormMap.get(nameCityKey).add(dupForm);
}
}
System.debug('namecityToFormMap ::'+JSON.serialize(namecityToFormMap));
for(FTL_Program_Form__c form : programFormList){
String field1 = form.Nominee_Name__c.replaceAll('[0-9]', ' ');
String field2 = field1.toLowerCase();
String nameCityKey = field2 + form.Nominee_City__c;
System.debug('nameCityKey ::'+nameCityKey);
if(namecityToFormMap.containsKey(nameCityKey) && !namecityToFormMap.get(nameCityKey).isEmpty()){
form.Multiple_Submissions__c = true;
}
}
}*/
    
    public static void isValidAssignedDealer(List<FTL_Program_Form__c> programFormList, Map<Id, FTL_Program_Form__c> programFormOldMap){
        Set<Id> dealerAccountIds = new Set<Id>();
        for(FTL_Program_Form__c form : programFormList){
            if(form.Assigned_Dealer__c != null){
                dealerAccountIds.add(form.Assigned_Dealer__c);
            }
        }
        if(!dealerAccountIds.isEmpty()){
            Integer currentYear = System.today().year();
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, FTL_Master_Agreement_Account__c,
                                                                (SELECT Id, Name
                                                                 FROM Contacts
                                                                 WHERE FTL_Program_Status__c = 'Enrolled'
                                                                 AND FTL_Provisioned__c=TRUE
                                                                )
                                                                FROM Account
                                                                WHERE Id IN :dealerAccountIds
                                                                AND CALENDAR_YEAR(DS_Completion_Date__c)=:currentYear
                                                                AND FTL_Eligibility__c = 'Enrolled']);
            for(FTL_Program_Form__c form : programFormList){
                if(programFormOldMap != null && !programFormOldMap.isEmpty() && form.Assigned_Dealer__c == programFormOldMap.get(form.Id).Assigned_Dealer__c){
                    continue;
                }
                if(accountMap.containsKey(form.Assigned_Dealer__c)){
                    Account acc = accountMap.get(form.Assigned_Dealer__c);
                    if(acc.Contacts.isEmpty()){
                        form.addError(Label.FTL_Dealer_Criteria);
                    }
                }
            }
        }
    }
    
    public static void ifStatusDeclined(List<FTL_Program_Form__c> programFormList, Map<Id, FTL_Program_Form__c> programFormOldMap){
        List<FTL_Program_Form__c> declined_ftlPrograms = new List<FTL_Program_Form__c> ();
        for(FTL_Program_Form__c form : programFormList){
            if(programFormOldMap != null && !programFormOldMap.isEmpty() && form.Status__c == programFormOldMap.get(form.Id).Status__c){
                continue;
            }
            if(form.Status__c == 'Declined'){
                form.Assigned_Dealer__c = null;
                declined_ftlPrograms.add(form);
            }
        }
        
        if(!declined_ftlPrograms.isEmpty()){
            deleteSharingRecords(declined_ftlPrograms);
        }
    }
    
    public static void processTriggerForSharing() {
        if(trigger.isAfter) {
            if(trigger.isInsert) {
                afterInsert();
            }
            else if(trigger.isUpdate) {
                afterUpdate();
            }
        }
    }
    
    public static void processTriggerForEmails() {
        if(trigger.isAfter) {
            if(trigger.isInsert) {
                vetNewForms(trigger.new);
            }
            else if(trigger.isUpdate) {
                vetUpdatedForms((List<FTL_Program_Form__c>)trigger.old, (Map<Id, FTL_Program_Form__c>)trigger.newMap);
            }
        }
    }
    
    /*Function to update the site location*/
    public static void getUpdatedRecords(List<FTL_Program_Form__c> programFormList, Map<Id, FTL_Program_Form__c> programFormOldMap){
        Set<Id> programFormIdSet = new Set<Id>();
        Id recordTypeId =
            Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName()
            .get('Nomination Form').getRecordTypeId();
        
        for(FTL_Program_Form__c form : programFormList){
            
            if(form.Assigned_Dealer__c != null &&
               programFormOldMap.get(form.Id).Assigned_Dealer__c == null &&
               programFormOldMap.get(form.Id).Assigned_Dealer__c != form.Assigned_Dealer__c  && form.recordTypeId == recordTypeId
              ){
                  programFormIdSet.add(form.Id);
              }
            
        }
        
        if (! programFormIdSet.isEmpty()) {
            updateSiteLocation(programFormIdSet);
        }
        
    }
    
    /* function to associate to an account when inserted via csv */
    /*public static void associateAccount(List<FTL_Program_Form__c> newForms){

Set<String> dNumber = New Set<String>();

for(FTL_Program_Form__c f : newForms){
if(f.Dealer_Number__c != '' && f.Dealer_Number__c != null){
dNumber.add(f.Dealer_Number__c);
}
}

if(dNumber.size() > 0){
List<Account> acnts = [Select Id, SAP_Customer_Number__c FROM Account WHERE SAP_Customer_Number__c IN :dNumber];

if(acnts.size()==0){
return;
}

//now that you have your accounts, iterate over and create a map associated them to SAP cust #
Map<String,Id> custNumAndId = New Map<String,Id>();
for(Account a : acnts){
custNumAndId.put(a.SAP_Customer_Number__c, a.Id);
}

//now iterate over original list and update account association
for(FTL_Program_Form__c f : newForms){
if(custNumAndId.containsKey(f.Dealer_Number__c)){
f.Assigned_Dealer__c = custNumAndId.get(f.Dealer_Number__c);
}
}
}
}*/
    
    /*
* @Purpose  : After inertion of new record If FTL_Program_Form__c is has
*             status = assigned, Account is present then share the record
*             with all users with associated contact.
*/
    public static void afterInsert() {
        List<FTL_Program_Form__c> ftlPrograms = new List<FTL_Program_Form__c>();
        for(FTL_Program_Form__c newFTLProgram : (List<FTL_Program_Form__c>) trigger.new) {
            if(newFTLProgram.Assigned_Dealer__c != null && (newFTLProgram.Status__c == 'Assigned' || newFTLProgram.Status__c == 'Accepted')) {
                ftlPrograms.add(newFTLProgram);
                system.debug(newFTLProgram);
            }
        }
        
        createNewSharingRecords(ftlPrograms);
    }
    
    /*
* @Purpose  : After Update of record If FTL_Program_Form__c is has
*             status = assigned, Account is present then share the record
*             with all users with associated contact. If account is changed
*             then remove previous sharings and add new.
*/
    public static void afterUpdate() {
        List<FTL_Program_Form__c> ftlPrograms = new List<FTL_Program_Form__c>();
        List<FTL_Program_Form__c> declined_ftlPrograms = new List<FTL_Program_Form__c> ();
        
        for(FTL_Program_Form__c newFTLProgram : (List<FTL_Program_Form__c>)trigger.new) {
            FTL_Program_Form__c oldFTLProgram = (FTL_Program_Form__c) trigger.oldMap.get(newFTLProgram.Id);
            
            //NOTE: We will not handle a change for Assigned_Dealer__r.FTL_Master_Agreement_Account__c here, that will be in the account after update trigger.
            
            if(newFTLProgram.Assigned_Dealer__c != null && (newFTLProgram.Status__c == 'Assigned' || newFTLProgram.Status__c == 'Accepted')) {
                if(oldFTLProgram.Status__c != newFTLProgram.Status__c) {
                    //Status changed to Assigned
                    
                    ftlPrograms.add(newFTLProgram);
                }
                
                if(oldFTLProgram.Assigned_Dealer__c != newFTLProgram.Assigned_Dealer__c) {
                    //Dealer changed
                    
                    ftlPrograms.add(newFTLProgram);
                    if (oldFTLProgram.Assigned_Dealer__c!=null) { declined_ftlPrograms.add(oldFTLProgram); }
                }
            }
            else {
                if (newFTLProgram.Assigned_Dealer__c!=null) { declined_ftlPrograms.add(newFTLProgram); }
                if (oldFTLProgram.Assigned_Dealer__c!=null) { declined_ftlPrograms.add(oldFTLProgram); }
            }
        }
        deleteSharingRecords(declined_ftlPrograms);
        createNewSharingRecords(ftlPrograms);
    }
    
    /*
* @Purpose  : Delete the form sharings related to the form Ids
* @Param    : List<FTL_Program_Form__c> declined_ftlPrograms
*/
    public static void deleteSharingRecords(List<FTL_Program_Form__c> declined_ftlPrograms) {
        system.debug('deleteSharingRecords');
        system.debug('declined_ftlPrograms ::'+declined_ftlPrograms);
        List<FTL_Program_Form__Share> shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId IN :declined_ftlPrograms AND RowCause = 'Manual'];
        delete shares;
    }
    
    /*
* @Purpose  : Insert sharing records.
* @Param    : List<FTL_Program_Form__c> ftlPrograms
*/
    public static void createNewSharingRecords(List<FTL_Program_Form__c> ftlPrograms) {
        system.debug('createNewSharingRecords');
        system.debug('ftlPrograms ::'+ftlPrograms);
        set<Id> dealerAccountIds = new set<Id>();
        for(FTL_Program_Form__c ftl: ftlPrograms) { dealerAccountIds.add(ftl.Assigned_Dealer__c); } //Make a set of Dealer Account Ids which we will query for Related Contacts
        Integer currentYear = System.today().year();
        List<Account> acctsWithMasterAcct = [SELECT Id, FTL_Master_Agreement_Account__c
                                             FROM Account
                                             WHERE Id IN :dealerAccountIds
                                             AND FTL_Master_Agreement_Account__c!=null
                                            ];
        for(Account a: acctsWithMasterAcct) { dealerAccountIds.add(a.FTL_Master_Agreement_Account__c); }
        Map<Id, Account> dealerAccounts = new Map<Id, Account> ([SELECT Id, FTL_Master_Agreement_Account__c,
                                                                 (SELECT Id, Name
                                                                  FROM Contacts
                                                                  WHERE FTL_Program_Status__c = 'Enrolled'
                                                                  AND FTL_Provisioned__c=TRUE)
                                                                 FROM Account
                                                                 WHERE Id IN :dealerAccountIds
                                                                 AND CALENDAR_YEAR(DS_Completion_Date__c)=:currentYear
                                                                 AND FTL_Eligibility__c = 'Enrolled']); //Populate dealer accounts with contacts into a map so we can lookup the accountId's contacts to generate shares
        
        System.debug('dealerAccounts ::'+dealerAccounts);
        List<Contact> allContacts = getContacts(dealerAccounts.values()); //Get a list of all Contacts so we can query a list of users
        Map<Id, User> contactIdToUser = createContactToUserMap(allContacts); //Query users and set the lookup key to the Contact Id to lookup users by Contact Id
        
        List<FTL_Program_Form__Share> allSharings = new List<FTL_Program_Form__Share>();
        for(FTL_Program_Form__c ftlProgram : ftlPrograms) {
            if(dealerAccounts.containsKey(ftlProgram.Assigned_Dealer__c)) {
                Account dealer = dealerAccounts.get(ftlProgram.Assigned_Dealer__c);
                List<Contact> acctContacts = dealer.Contacts;
                if (dealer.FTL_Master_Agreement_Account__c!=null) {
                    acctContacts.addAll(dealerAccounts.get(dealer.FTL_Master_Agreement_Account__c).Contacts);
                }
                if(acctContacts != NULL && !acctContacts.isEmpty()) {
                    allSharings.addAll(createNewSharingsRecs(ftlProgram, acctContacts, contactIdToUser));
                }
            }
        }
        system.debug(allSharings);
        insert allSharings;
    }
    
    /*
* @Purpose  : Create new sharing records.
* @Param    : FTL_Program_Form__c ftlProgram, List<Contact> contacts, Map<Id, User> contactIdToUser
* @Return   : List<FTL_Program_Form__Share>
*/
    public static List<FTL_Program_Form__Share> createNewSharingsRecs(FTL_Program_Form__c ftlProgram, List<Contact> contacts, Map<Id, User> contactIdToUser) {
        Map<Id, FTL_Program_Form__Share> shares = new Map<Id, FTL_Program_Form__Share>();
        
        for(Contact c : contacts) {
            if(shares.containsKey(c.Id)) {continue;}
            
            if(contactIdToUser.containsKey(c.Id)){
                User u = contactIdToUser.get(c.Id);
                
                shares.put(c.Id,
                           new FTL_Program_Form__Share(
                               ParentId = ftlProgram.Id,
                               UserOrGroupId = u.Id,
                               AccessLevel = 'edit',
                               RowCause = Schema.FTL_Program_Form__Share.RowCause.Manual
                           )
                          );
            }
        }
        
        system.debug('returning shares...');
        system.debug(shares.values());
        
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
    
    /*
* @Purpose  : Email associated provisioned users when dealer is assigned to program form
* @Param    : Trigger.newMap Trigger.old
* @Return   : void
*/
    
    public static void vetNewForms(List<Ftl_Program_Form__c> newForms){
        Map<Id,Ftl_Program_Form__c> vettedForms = New Map<Id,Ftl_Program_Form__c>();
        Map<Id,Id> fIdAndAcntId = New Map<Id,Id>();
        
        for(Ftl_Program_Form__c f : newForms){
            if(f.Assigned_Dealer__c != null){
                vettedForms.put(f.Id, f);
                fIdAndAcntId.put(f.Id, f.Assigned_Dealer__c);
            }
        }
        
        if(vettedForms.size()>0){
            emailContacts(vettedForms,fIdAndAcntId);
        }
    }
    
    private static List<string> formIdsAlreadyEmailed = new List<string>();
    
    public static void vetUpdatedForms(List<Ftl_Program_Form__c> oldForms, Map<Id,Ftl_Program_Form__c> newFormMap){
        Map<Id,Ftl_Program_Form__c> vettedForms = New Map<Id,Ftl_Program_Form__c>();
        Map<Id,Id> fIdAndAcntId = New Map<Id,Id>();
        
        for(Ftl_Program_Form__c f : oldForms){
            if (formIdsAlreadyEmailed.contains(f.Id)) {
                continue;
            }
            else {
                formIdsAlreadyEmailed.add(f.Id);
            }
            if((f.Assigned_Dealer__c != newFormMap.get(f.Id).Assigned_Dealer__c) && newFormMap.get(f.Id).Assigned_Dealer__c != null){
                vettedForms.put(f.Id,newFormMap.get(f.Id));
                fIdAndAcntId.put(f.Id, newFormMap.get(f.Id).Assigned_Dealer__c);
            }
        }
        
        if(vettedForms.size()>0){
            emailContacts(vettedForms,fIdAndAcntId);
        }
    }
    
    public static void emailContacts(Map<Id,FTL_Program_Form__c> vettedForms, Map<Id,Id> fiDAndAcntId){
        //email template
        String theTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'FTL_Dealer_Assigned_Nomination'].Id;
        //list of emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        //find Contacts associated to the designated accounts that are provisioned
        List<Contact> cons = New List<Contact>([Select Id, AccountId, Name FROM Contact WHERE FTL_Provisioned__c = true AND AccountId IN :fiDandAcntId.values()]);
        
        //set up map with account Id as key and a list of Contacts as values
        Map<Id, List<Id>> cs = New Map<Id, List<Id>>();
        for(Contact c : cons){
            if(cs.ContainsKey(c.AccountId)){
                List<Id> cIds = New List<Id>();
                cIds = cs.get(c.AccountId);
                cIds.add(c.Id);
                cs.remove(c.AccountId);
                cs.put(c.AccountId,cIds);
            } else {
                List<Id> cIds = New List<Id>();
                cIds.add(c.Id);
                cs.put(c.AccountId,cIds);
            }
        }
        //iterate and set up the emails
        for(FTL_Program_Form__c f : vettedForms.values()){
            
            if(cs.containsKey(f.Assigned_Dealer__c)){
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'feelthelove@lennoxind.com'];
                
                //iterate over contacts associated to the account
                for(Id c : cs.get(f.Assigned_Dealer__c)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(theTemplate);
                    mail.setWhatId(f.Id);
                    mail.setTargetObjectId(c);
                    emails.add(mail);
                }
            }
        }
        
        if(emails.size()>0){
            if(!Test.isRunningTest()){
                Messaging.sendEmail(emails);
            }
        }
    }
    
    
    private static void updateSiteLocation(Set<Id> programFormIdSet) {
        Database.executeBatch(new FTL_Program_Form_UpdateSiteLocationBatch(programFormIdSet));
    }
    
    //private static string keygenSite(Home_Owners__c site) {
    //    return site.MailingAddress__c+'|'+site.MailingCity__c+'|'+site.MailingState__c+'|'+site.MailingPostal__c+'|'+site.Country__c+'|'+site.Phone__c+'|'+site.Email__c+'|'+site.FTL_Contact__c;
    //}
    
    // private static string keygenForm(FTL_Program_Form__c f) {
    //     return f.Nominee_Street_Address__c+'|'+f.Nominee_City__c+'|'+f.Nominee_State__c+'|'+f.Nominee_Zip_Code__c+'|'+f.Nominee_Country__c+'|'+f.Nominee_Phone_Number__c+'|'+f.Nominee_Email__c+'|'+f.Nominee_Name__c;
    // }
}