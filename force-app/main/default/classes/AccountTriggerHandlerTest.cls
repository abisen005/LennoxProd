@isTest
public class AccountTriggerHandlerTest {
    @isTest
    static void testMasterAgreementSharing() {
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        Id pId = [select id from profile where name LIKE 'Community%' LIMIT 1][0].id;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE userRoleId = :sampleUserRole.Id and isActive = true LIMIT 1];
        
        System.runAs(admin) {
            List<account> accts = new List<account>();
            accts.add(new Account(name ='Grazitti',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US',FTL_Eligibility__c='Enrolled'));
            accts.add(new Account(name ='ParentGrazitti',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US'));
            insert accts;
            
            List<contact> contacts = new List<contact>();
            
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[0].Id,
                                     Phone='1234322',
                                     Email='test50293875owqjfq@lennox-testemail.com',
                                     FirstName='FName'));
            
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[1].Id,
                                     Phone='1234322',
                                     Email='test20958owiqjuhfnslakjagf@lennox-testemail.com',
                                     FirstName='FName',
                                     FTL_Program_Status__c='Enrolled',
                                     FTL_Provisioned__c=true));
            insert contacts;
            
            List<user> users = new List<user>();
            users.add(new User(alias = 'test1238', email = contacts[0].email, Customer__c = true,
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                               localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                               ContactId = contacts[0].Id,
                               timezonesidkey='America/Los_Angeles', username=contacts[0].email));
            users.add(new User(alias = 'test1234', email = contacts[1].email, Customer__c = true,
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                               localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                               ContactId = contacts[1].Id,
                               timezonesidkey='America/Los_Angeles', username=contacts[1].email));
            
            insert users;
            
            FTL_Program_Form__c ftlForm = new FTL_Program_Form__c();
            Id RecordTypeIdContact = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
            ftlForm.RecordTypeId = RecordTypeIdContact;
            ftlForm.Assigned_Dealer__c = accts[0].Id;
            ftlForm.Nominee_Email__c = 'test@email.com';
            ftlForm.Nominee_Phone_Number__c = '1332432';
            ftlForm.Nominee_City__c = 'City';
            ftlForm.Status__c = 'Assigned';
            insert ftlForm;
            
            List<AccountShare> acctShares;
            List<FTL_Program_Form__Share> formShares;
            
            test.startTest();
            acctShares = [SELECT Id FROM AccountShare WHERE AccountId = :accts[0].Id AND RowCause = 'Manual'];
            system.assert(acctShares.size()==0);
            formShares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
            //system.assert(formShares.size()==1);
            
            accts[0].FTL_Master_Agreement_Account__c = accts[1].Id;
            update accts[0];
            
            
            test.stopTest();
            
            acctShares = [SELECT Id FROM AccountShare WHERE AccountId = :accts[0].Id AND RowCause = 'Manual'];
            //system.assert(acctShares.size()==1);
            formShares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
            //system.assert(formShares.size()==2);
        }
        
    }
    
    @isTest
    static void testMasterAgreementSharingRemoval() {
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        Id pId = [select id from profile where name LIKE 'Community%' LIMIT 1][0].id;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE userRoleId = :sampleUserRole.Id and isActive = true LIMIT 1];
        
        System.runAs(admin) {
            List<account> accts = new List<account>();
            accts.add(new Account(name ='Grazitti',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US',FTL_Eligibility__c='Enrolled'));
            accts.add(new Account(name ='ParentGrazitti',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US'));
            system.debug('inserting accounts'); insert accts;
            
            accts[0].FTL_Master_Agreement_Account__c = accts[1].Id;
            system.debug('adding master agreement to: ' + accts[0]); update accts[0];
            
            List<contact> contacts = new List<contact>();
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[0].Id,
                                     Phone='1234322',
                                     Email='test50293875owqjfq@lennox-testemail.com',
                                     FirstName='FName'));
            
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[1].Id,
                                     Phone='1234322',
                                     Email='test20958owiqjuhfnslakjagf@lennox-testemail.com',
                                     FirstName='FName'));
            system.debug('inserting contacts'); insert contacts;
            
            List<user> users = new List<user>();
            users.add(new User(alias = 'test1238', email = contacts[0].email, Customer__c = true,
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                               localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                               ContactId = contacts[0].Id,
                               timezonesidkey='America/Los_Angeles', username=contacts[0].email));
            users.add(new User(alias = 'test1234', email = contacts[1].email, Customer__c = true,
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                               localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                               ContactId = contacts[1].Id,
                               timezonesidkey='America/Los_Angeles', username=contacts[1].email));
            
            system.debug('inserting users'); insert users;
            
            
            FTL_Program_Form__c ftlForm = new FTL_Program_Form__c();
            Id RecordTypeIdContact = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
            ftlForm.RecordTypeId = RecordTypeIdContact;
            ftlForm.Assigned_Dealer__c = accts[0].Id;
            ftlForm.Nominee_Email__c = 'test@email.com';
            ftlForm.Nominee_Phone_Number__c = '1332432';
            ftlForm.Nominee_City__c = 'City';
            ftlForm.Status__c = 'Assigned';
            system.debug('inserting form, share should be created...'); insert ftlForm;
            
            List<AccountShare> acctShares;
            List<FTL_Program_Form__Share> formShares;
            
            acctShares = [SELECT Id FROM AccountShare WHERE AccountId = :accts[0].Id AND RowCause = 'Manual'];
            system.assert(acctShares.size()==0);
            formShares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
            //system.assert(formShares.size()==2);
            
            test.startTest();
            accts[0].FTL_Master_Agreement_Account__c = null;
            update accts[0];
            test.stopTest();
            
            acctShares = [SELECT Id FROM AccountShare WHERE AccountId = :accts[0].Id AND RowCause = 'Manual'];
            system.assert(acctShares.size()==0);
            formShares = [SELECT Id, UserOrGroupId FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
            //system.assert(formShares.size()==1);
            //system.assert(users[0].Id == formShares[0].UserOrGroupId);
            
        }
        
    }  
    static testMethod void testInsertCustomerSalesArea() {
        
        final String SALES_ORG = 'LXUS';
        List<Vendavo__CustomerSalesArea__c> customerSalesAreas = new List<Vendavo__CustomerSalesArea__c>();
        
        Test.startTest();
        Account acc = new Account(Name = 'test', SAP_Sales_Org__c = SALES_ORG, ShippingStreet='123 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='54321',ShippingCountry='US',Phone='111-111-1111');
        
        Vendavo__SalesArea__c salesArea = new Vendavo__SalesArea__c();
        salesArea.Vendavo__SalesOrgID__c = SALES_ORG;
        salesArea.Vendavo__ChannelID__c = 'test';
        salesArea.Vendavo__Channel_Label__c = 'test';
        salesArea.Vendavo__VDivisionLabel__c = 'test';
        salesArea.Vendavo__DivisionID__c = 'test';
        salesArea.Vendavo__SalesAreaExternalID__c = SALES_ORG;
        salesArea.Vendavo__VSalesOrg_Label__c = SALES_ORG;
        
        insert salesArea;
        insert acc;
        update acc;
        
        customerSalesAreas = [SELECT Id FROM Vendavo__CustomerSalesArea__c WHERE Vendavo__Customer__c = :acc.Id];
        System.assertEquals(1, customerSalesAreas.size());
        
        Test.stopTest();
        
    }
    
    
    static testMethod void testProvisionFTLUser(){
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        Id pId = [select id from profile where name LIKE 'Community%' LIMIT 1][0].id;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE userRoleId = :sampleUserRole.Id and isActive = true LIMIT 1];
        
        System.runAs(admin) {
            List<Account> accountList =  new List<Account>();
            List<Contact> contactList =  new List<Contact>();
            List<Account> updatedAccountList = new List<Account>();
            Set<String> userNameList = new Set<String>();
            
            for(Integer count=1; count<=3; count++){
                if(count==2)
                    accountList.add(new Account(Name = 'Account'+count,
                                                ShippingStreet='123 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='54321',ShippingCountry='US',Phone='111-111-1111',
                                                DS_Completion_Date__c = System.today()-count));
                else
                    accountList.add(new Account(Name = 'Account'+count,
                                                ShippingStreet='123 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='54321',ShippingCountry='US',Phone='111-111-1111',
                                                DS_Completion_Date__c = System.today()-count));
            }
            
            insert accountList;
            
            Account childAcct = new Account(
                Name='Test Child Acct',
                ShippingStreet='123 Main St',
                ShippingCity='Austin',
                ShippingState='TX',
                ShippingPostalCode='54321',
                ShippingCountry='US',
                Phone='111-111-1111',
                FTL_Master_Agreement_Account__c=accountList[0].Id);
            insert childAcct;
            
            System.debug('accountList'+accountList);
            System.debug('childAcct' + childAcct);
            
            for(Account acc : accountList){
                String accountName = acc.Name.toLowerCase();
                Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
                
                for(Integer count=1; count<=3; count++){
                    if(count==2){
                        contactList.add(new Contact(FirstName = 'testcontactofAccount'+accountName, LastName = 'Testa',
                                                    recordTypeId = recordTypeId,
                                                    Email = accountName+'con'+count+'@gmail.com',
                                                    AccountId = acc.Id,
                                                    FTL_Program_Status__c = 'Request to Enroll',
                                                    FTL_Provisioned__c = false,
                                                    FTL_Dealer_Signup_Status__c = 'Approved'));
                    }else{
                        contactList.add(new Contact(FirstName = accountName+'test'+count, LastName = 'Testb',
                                                    Email = accountName+'con'+count+'@gmail.com',
                                                    AccountId = acc.Id,
                                                    recordTypeId = recordTypeId,
                                                    FTL_Program_Status__c = 'Request to Enroll',
                                                    FTL_Provisioned__c = false,
                                                    FTL_Dealer_Signup_Status__c = 'Approved'));
                    }
                }
            }
            
            for(Contact contact : contactList){
                userNameList.add(contact.Email+'.Lii');
            }
            insert contactList;
            
            for(Account updatedAccount: accountList){
                //updatedAccount.DS_Dealer_Agreement_Response__c = 'Accept';
                updatedAccount.DS_Completion_Date__c = System.today();
                updatedAccountList.add(updatedAccount);
            }
            
            Test.startTest();
            update updatedAccountList;
            List<User> newUser = [SELECT Id FROM User WHERE Username IN :userNameList];
            
            //System.assertEquals(9, newUser.size());
           //AccountTriggerHandler.AssignContentWorkspaces(admin.Id);
            
            Test.stopTest();
            
        }
        
    }
}