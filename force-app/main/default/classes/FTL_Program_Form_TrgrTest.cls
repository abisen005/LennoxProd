@isTest
public class FTL_Program_Form_TrgrTest {
    
    @testSetup
    private static void dataSetup(){
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        Id pId = [select id from profile where name LIKE 'Community%' LIMIT 1][0].id;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE IsActive = true AND userRoleId = :sampleUserRole.Id LIMIT 1];
        
        System.runAs(admin) {
            List<account> accts = new List<account>();
            accts.add(new Account(name ='Grazitti',DS_Completion_Date__c=System.today(),Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US', FTL_Eligibility__c = 'Enrolled'));
            accts.add(new Account(name ='ParentGrazitti',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432', ShippingCountry='US'));
            insert accts; 
            //accts[0].FTL_Master_Agreement_Account__c = accts[1].Id;
            //update accts[0];
            
            List<contact> contacts = new List<contact>();
            
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[1].Id, 
                                     Phone='1234322111', 
                                     Email='test50293875owqjfq@lennox-testemail.com',
                                     FirstName='FName'));
            
            contacts.add(new Contact(LastName ='testCon',
                                     AccountId = accts[0].Id, 
                                     Phone='1234322131', 
                                     Email='test20958owiqjuhfnslakjagf@lennox-testemail.com',
                                     FirstName='FName',
                                     FTL_Program_Status__c = 'Enrolled',
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
            
            Id feeltheLovercdtype = Schema.SObjectType.Home_Owners__c.getRecordTypeInfosByDeveloperName().get('Feel_The_Love').getRecordTypeId();
            Home_Owners__c site = new Home_Owners__c(
                RecordTypeId = feeltheLovercdtype,
                Site_Type__c = 'Residential',
                Name = 'test',
                MailingAddress__c = 'test',
                MailingCity__c  = 'test',
                MailingState__c  = 'OH',
                MailingPostal__c = '347585',
                Country__c  = 'test',
                Phone__c = '1234565222');
            insert site;
            
            FTL_Program_Form__c ftlForm = new FTL_Program_Form__c();
            Id RecordTypeIdContact = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
            ftlForm.RecordTypeId = RecordTypeIdContact;
            ftlForm.Assigned_Dealer__c = accts[0].Id;
            //ftlForm.Name = 'Test Form';
            ftlForm.Nominee_Email__c = 'test@email.com';
            ftlForm.Nominee_Phone_Number__c = '1332431229';
            ftlForm.Nominee_City__c = 'City';
            ftlForm.Status__c = 'Assigned';
            ftlForm.Nominee_Street_Address__c = 'test';
            ftlForm.Nominee_City__c = 'test';
            ftlForm.Nominee_State__c = 'OH';
            ftlForm.Nominee_Zip_Code__c = '347585';
            ftlForm.Nominee_Country__c = 'test';
            ftlForm.Nominee_Phone_Number__c = '1231314565';
            ftlForm.Nominee_Email__c = 'test@test.com';
            insert ftlForm;
        }
        
    }
    
    @isTest
    static void testTrigger(){
        List<FTL_Program_Form__Share> shares;
        
        Test.startTest();
        Account accountRecord = [SELECT Id, (SELECT Id, FTL_Provisioned__c FROM Contacts WHERE FTL_Provisioned__c=true AND FTL_Program_Status__c = 'Enrolled') FROM Account WHERE name ='Grazitti' LIMIT 1];
        //accountrecord.Contacts[0].FTL_Program_Status__c = 'Enrolled';
        //accountrecord.Contacts[0].FTL_Provisioned__c = true;
        //update accountrecord.Contacts[0];
        
        FTL_Program_Form__c ftlForm = new FTL_Program_Form__c();
        Id RecordTypeIdContact = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
        ftlForm.RecordTypeId = RecordTypeIdContact;
        ftlForm.Assigned_Dealer__c = accountRecord.Id;
        //ftlForm.Name = 'Test Form';
        ftlForm.Nominee_Email__c = 'test@email.com';
        ftlForm.Nominee_Phone_Number__c = '1334545232';
        ftlForm.Nominee_City__c = 'City';
        ftlForm.Status__c = 'Assigned';
        ftlForm.Nominee_Street_Address__c = 'test';
        ftlForm.Nominee_City__c = 'test';
        ftlForm.Nominee_State__c = 'OH';
        ftlForm.Nominee_Zip_Code__c = '347585';
        ftlForm.Nominee_Country__c = 'test';
        ftlForm.Nominee_Phone_Number__c = '1234565565';
        ftlForm.Nominee_Email__c = 'test@test.com';
        insert ftlForm; 
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()>0);
        
        //ftlForm.Assigned_Dealer__c = null;
        ftlForm.Status__c = 'Declined';
        ftlForm.Reason_for_Declining__c = 'Home Not Suitable';
        update ftlForm;
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()==0);
        
        ftlForm.Assigned_Dealer__c = accountRecord.Id;
        ftlForm.Status__c = 'Assigned';
        update ftlForm;
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()>0);
        
        /*ftlForm.Assigned_Dealer__c = null;
        ftlForm.Status__c = 'Assigned';
        update ftlForm;
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()==0);*/
        
        /*ftlForm.Assigned_Dealer__c = accountRecord.Id;
        ftlForm.Status__c = 'Assigned';
        update ftlForm;
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()==2);

        ftlForm.Assigned_Dealer__c = accountRecord.Id;
        ftlForm.Status__c = 'Accepted';
        update ftlForm;
        
        shares = [SELECT Id FROM FTL_Program_Form__Share WHERE ParentId = :ftlForm.Id AND RowCause = 'Manual'];
        system.assert(shares.size()==2);*/

        Test.stopTest();
    }


@IsTest
static void NominationCountTest_Archived(){
    // Create a new FTL_Program_Form__c record
    FTL_Program_Form__c ftlForm = new FTL_Program_Form__c(
        Nominee_Zip_Code__c = '12345',
        Nominee_State__c = 'State',
        Nominee_Street_Address__c = '123 Street',
       
        Nominee_Phone_Number__c = '1234567890'
    );
    insert ftlForm;

    // Query the Account record
    Account account = [SELECT Id FROM Account WHERE Name = 'Grazitti' LIMIT 1];

    // Update the FTL_Program_Form__c record
    ftlForm.Archived__c = true;
    ftlForm.Status__c = 'New';
    ftlForm.Assigned_Dealer__c = account.Id;

    Test.startTest();
    update ftlForm;
    Test.stopTest();

    // Query the Account record again to ensure it was updated
    Account count = [SELECT Id FROM Account WHERE Id = :ftlForm.Assigned_Dealer__c LIMIT 1];
    System.Debug('!!! Account: ' + count);
}




   /*
    @IsTest
    static void NominationCountTest_Archived(){
    
    
    
 
        //Count archive form
        FTL_Program_Form__c ftlForm = [SELECT Id, Nominee_Zip_Code__c, Nominee_State__c, 
                                        Nominee_Street_Address__c, Assigned_Dealer__c,
                                        Status__c, Archived__c
                                        FROM FTL_Program_Form__c];
        Account account = [SELECT Id FROM Account Where Name = 'Grazitti'];
        ftlForm.Archived__c = true;
        ftlForm.Status__c = 'New';
        ftlForm.Assigned_Dealer__c = account.id;
        Test.startTest();
        update ftlForm;
        //delete ftlForm;
        Test.stopTest();
        Account count = [SELECT Id FROM Account WHERE Id = : ftlForm.Assigned_Dealer__c];
        System.Debug('!!! Account: ' + count);
        
    }
*/



@IsTest
static void NominationCountTest_Deleted(){
    
    FTL_Program_Form__c ftlForm = new FTL_Program_Form__c(
        Nominee_Zip_Code__c = '12345',
        Nominee_State__c = 'State',
        Nominee_Street_Address__c = '123 Street',
       
        Nominee_Phone_Number__c = '1234567890'
    );
    insert ftlForm;

    Test.startTest();
    delete ftlForm;
    Test.stopTest();

    // Query the Account record to ensure it was deleted
    Integer accountCount = [SELECT COUNT() FROM Account WHERE Id = :ftlForm.Assigned_Dealer__c];
    System.Debug('!!! Account Count: ' + accountCount);
}


/*

    @IsTest
    static void NominationCountTest_Deleted(){
        //Count delete form
        FTL_Program_Form__c ftlForm = [SELECT Id, Nominee_Zip_Code__c, Nominee_State__c, 
                                        Nominee_Street_Address__c, Assigned_Dealer__c,
                                        Status__c, Archived__c
                                        FROM FTL_Program_Form__c];
        Test.startTest();
        delete ftlForm;
        Test.stopTest();
        Account count = [SELECT Id FROM Account WHERE Id = : ftlForm.Assigned_Dealer__c];
        System.Debug('!!! Account: ' + count);
        
    }
    
 */
 
}