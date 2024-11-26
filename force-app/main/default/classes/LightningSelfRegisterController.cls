global without sharing class LightningSelfRegisterController {

    public LightningSelfRegisterController() {

    }
    
    @AuraEnabled
    public static Account checkIdValidity(String customerId){
        Account a = New Account();
        
        List<Account> acnts = New List<Account>();
        acnts = [Select Id, Name, SAP_Customer_Number__c, FTL_Eligibility__c,ShippingStreet, ShippingPostalCode, ShippingCity, ShippingState FROM Account WHERE SAP_Customer_Number__c = :customerId];
        
        if(acnts.size()>0){
            
            //check if the account is eligible
            if(acnts[0].FTL_Eligibility__c == null){
                a.FTL_Eligibility__c = 'Ineligible';
            }else if(acnts[0].FTL_Eligibility__c.startsWith('Eligible') || acnts[0].FTL_Eligibility__c.equals('Enrolled')){
                a = acnts[0];
            } else {
                a.FTL_Eligibility__c = 'Ineligible';
            }
            
            
        } 
        
        return a;
    }
    
    @AuraEnabled
    global static Id insertForm(String acntId, FTL_Dealer_Signup_Form__c form){
        //take the account and associate it to the form
        FTL_Dealer_Signup_Form__c d = New FTL_Dealer_Signup_Form__c();
		d = form;
        d.Company_Name__c = acntId;
        d.Customer_ID__c = form.Customer_ID__c;
        d.Status__c = 'Submitted';
        d.Customer_ID__c = [Select SAP_Customer_Number__c FROM Account WHERE Id = :acntId LIMIT 1].SAP_Customer_Number__c;
        //insert the contact
        d.contact__c = addContact(form.Point_of_Contact_Email__c, acntId, form);
        //d.Receive_Emails__c = form.Receive_Emails__c;
        
        //d.Contact__c = [Select Id FROM Contact WHERE AccountId = :acntId AND Email = :form.Point_of_Contact_Email__c LIMIT 1].Id;
        //also assign to queue
        d.OwnerId = [Select Id FROM Group WHERE Type = 'Queue' And NAME = 'Feel the Love' LIMIT 1].Id;
        insert d;
        //deleteDealerSignupForm(d.Id);
        
        return d.Id;
    }
    
    /*global static void deleteDealerSignupForm(String dealerSignupFormId){
        List<FTL_Dealer_Signup_Form__c> dealerSignupFormList = [SELECT Id,
                                                               Company_Name__c,
                                                               Status__c, Customer_ID__c,
                                                               contact__c,
                                                               Receive_Emails__c,
                                                               Point_of_Contact_Email__c
                                                               FROM FTL_Dealer_Signup_Form__c
                                                               WHERE Id = :dealerSignupFormId];
        for(FTL_Dealer_Signup_Form__c dealerSignupForm : dealerSignupFormList){
            if(dealerSignupForm.Company_Name__c == dealerSignupForm.Point_of_Contact_Email__c){
                DELETE dealerSignupForm;
            }
        }
        
    }*/
    
    @AuraEnabled
    global static String addContact(String email, String acntId, FTL_Dealer_Signup_Form__c form){
        String conId = '';
        Id ownerId; 
        if(Test.isRunningTest()){
           ownerId = [Select Id FROM User WHERE Email != null LIMIT 1][0].Id;
        }else{
           ownerId = [Select id,name from user where lastname='Intgrtduser'].Id;//[Select Id FROM User WHERE Email = 'lisa@ventasconsulting.com' LIMIT 1].Id;  //changed the email address so this could be tested
        }
        
        List<Contact> cons = New List<Contact>([Select Id, AccountId, Email FROM Contact WHERE AccountId = :acntId AND Email = :email]);
        if(cons.size()>0){
            String uName;
            uName  = email+'.ftl';
            //check if an active user is already provisioned for this email
            List<User> us = New List<User>([Select Email FROM User WHERE IsActive= true AND Email = :email AND UserName = :uName]);
            if(us.size()>0){
                conId = 'existing';
            } else {
                conId = cons[0].Id;
                //and update the role
                cons[0].FTL_Program_Status__c = 'Request to Enroll';
                cons[0].Contact_Type__c = 'Dealer';
                update cons[0];
            }
            
        } else {
            //insert a contact
            Contact c = New Contact();
            c.RecordTypeId = [Select Id FROM RecordType WHERE Name = 'Residential Contact' LIMIT 1].Id;
            c.AccountId = acntId;
            c.FirstName = form.Point_of_Contact_First_Name__c;
            c.LastName = form.Point_of_Contact_Last_Name__c;
            c.Email = email;
            c.OwnerId = ownerId;
            c.FTL_Program_Status__c = 'Request to Enroll';
            c.Contact_Type__c = 'Dealer';
            c.Phone = form.Point_of_Contact_Phone_Number__c;
            insert c;
            conId = c.Id;
        }
        
        
        return conId;
    }
    
    @AuraEnabled
    global static String searchContact(String email, String acntId, FTL_Dealer_Signup_Form__c form){
        String returnId = '';
        
       // List<Contact> cons = New List<Contact>([Select Id, AccountId, Email FROM Contact WHERE Email = :email AND AccountId =:acntId]);
        //if(cons.size()>0){
           //String uName;
            //uName  = email+'.ftl';
            //check if an active user is already provisioned for this email
            List<User> us = New List<User>([Select Email FROM User WHERE IsActive= true AND Email = :email]);
            if(us.size()>0){
                returnId = 'existing';
            } else {
                returnId = insertForm(acntId,form);
            }
        //call function to add company anme and insert
        
       // } 
        return returnId;
    }
    
    
    @AuraEnabled
    global static void searchDuplicateForm (String email, String acntId, FTL_Dealer_Signup_Form__c form){
    List <FTL_Dealer_Signup_Form__c> dealerListToBeDeleted = new List <FTL_Dealer_Signup_Form__c> ();
    List<FTL_Dealer_Signup_Form__c> dealerList = new List<FTL_Dealer_Signup_Form__c>([Select Id, Company_Name__c, Point_of_Contact_Email__c FROM FTL_Dealer_Signup_Form__c WHERE Company_Name__c =: acntId AND Point_of_Contact_Email__c =:email ]);
    if(dealerList.size()>1){
    dealerListToBeDeleted =[Select Id, Company_Name__c, Point_of_Contact_Email__c FROM FTL_Dealer_Signup_Form__c WHERE Company_Name__c =: acntId AND Point_of_Contact_Email__c =:email order by CreatedDate desc limit 1];
     delete dealerListToBeDeleted;
    }
       
    }
    
    
    //commented out boiler plate code from SF below
/*
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
        Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
    
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword) {
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();
            
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            
            User u = new User();
            u.Username = email;
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            
            String networkId = Network.getNetworkId();

            // If using site to host the community the user should not hit s1 after logging in from mobile.
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
            
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
                     
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            }
                        
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return Label.site.passwords_dont_match;
                }
             validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
            
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            String userId = Site.createPortalUser(u, accountId, password);
            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {
                     aura.redirect(lgn);
                    }
                }
                else {
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    if(!Test.isRunningTest()) {
                    aura.redirect(confirmRef);
                   }

                }
            }
            return null;
        }
        catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage();            
        }
    }

    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
            }}}
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    }
    
*/   
}