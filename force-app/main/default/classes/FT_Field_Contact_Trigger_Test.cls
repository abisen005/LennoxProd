/* ===========================================================================
@Class Name  : Field_Trial_Contact_Trigger_Test
@Purpose     : Test class for Field_Trial_Contact_Trigger
@CreatedDate: 28 November 2019
===========================================================================*/

@isTest
public class FT_Field_Contact_Trigger_Test {
    //Create test data
    @testSetup
    public static void testData(){
        //Create Account record
        Account account = createAccount();
        insert account;
        
        //Create Contact record
        List<Contact> contactList = createContact(account.Id);
        insert contactList;
        System.assertEquals(2,contactList.size());
        
        //Create Users
        List<User> userList = createUsers(contactList[0].Id);
        insert userList;
        System.assertEquals(1, userList.size());
        
        //Create field trail records
        List<FT_Field_Trial__c> fieldTrialList = createFieldTrials(userList[0].Id);
        insert fieldTrialList;
        System.assertEquals(4,fieldTrialList.size());
        
        //Create field trial contact records
        List<Field_Trial_Contacts__c> fieldtrailContactList = createFieldTrialContacts(fieldTrialList[0].Id,contactList[0].Id,
                                                                                       contactList[1].Id);
        insert fieldtrailContactList;
        System.assertEquals(4, fieldtrailContactList.size());
        
        //Create site location
        List<Home_Owners__c> siteLocations = createSiteLocation(fieldtrailContactList[0].Id);
        insert siteLocations;
        System.assertEquals(1, siteLocations.size());
        
        //Create Equipment Data
        List<Equipment_Data__c> equipmentData = createEquipmentaData(siteLocations[0].Id,fieldTrialList[0].Id);
        insert equipmentData;
        System.assertEquals(1, equipmentData.size());
        
        // Create Service Event
        List<ServiceRecord__c> serviceEvents= createServiceEvent(fieldtrailContactList[0].Id, siteLocations[0].Id, equipmentData[0].Id);
        insert serviceEvents;
        System.assertEquals(1, serviceEvents.size());
        
        //Create Field Trial Form Records
        List<FieldTrialForms__c> fieldTrialFormList = createFieldTrialForms(fieldtrailContactList[0].Id);
        insert fieldTrialFormList;
        System.assertEquals(1, fieldTrialFormList.size());
        
        //Create Field Trial Form Invoice Records
        List<FT_Field_Trial_Invoices__c> fieldTrialInvoiceList = 
            createFieldTrialInvoices(fieldtrailContactList[0].Id,account.Id,equipmentData[0].Id, userList[0].Id, serviceEvents[0].Id, siteLocations[0].Id);
        insert fieldTrialInvoiceList;
        System.assertEquals(1, fieldTrialInvoiceList.size());
        
        //Create Field Trial Participant Application c
        List<FT_Field_Trial_Participant_Application__c> fieldTrialParticipantAppList = createFieldTrialParticipantApplications(fieldtrailContactList[0].Id);
        insert fieldTrialParticipantAppList;
        System.assertEquals(1, fieldTrialParticipantAppList.size());
    }
    
    //Testing for Field_Trial_Contacts__c where RecordTypeId is Dealer and contactId having user
    @isTest static void testAfterUpdate(){
        Test.startTest();
        Field_Trial_Contacts__c fieldTrialContact = [SELECT Id,RecordTypeId,FT_Field_Trial__c,FT_Contact_Record__c,FT_Status__c
                                                     FROM Field_Trial_Contacts__c
                                                     LIMIT 1];
        
        fieldTrialContact.FT_Status__c = 'Approved';
        update fieldTrialContact; 
        Test.stopTest();
    }
    
    //Testing for Field_Trial_Contacts__c where RecordTypeId is Dealer and contactId is does not have any user
    @isTest static void testAfterUpdate1(){
        Test.startTest();
        Field_Trial_Contacts__c fieldTrialContact = [SELECT Id,RecordTypeId,FT_Field_Trial__c,FT_Contact_Record__c,FT_Status__c
                                                     FROM Field_Trial_Contacts__c
                                                     WHERE FT_Status__c =:'Removed - Not in Compliance'];
        
        fieldTrialContact.FT_Status__c = 'Approved';
        update fieldTrialContact; 
        Test.stopTest();
    }
    
    //Testing for Field_Trial_Contacts__c where RecordTypeId is Participant but contactId having user
    @isTest static void testAfterUpdate2(){
        Test.startTest();
        Field_Trial_Contacts__c fieldTrialContact = [SELECT Id,RecordTypeId,FT_Field_Trial__c,FT_Contact_Record__c,FT_Status__c
                                                     FROM Field_Trial_Contacts__c
                                                     WHERE FT_Status__c =:'Chosen'
                                                     LIMIT 1];
        
        fieldTrialContact.FT_Status__c = 'Approved';
        update fieldTrialContact; 
        Test.stopTest();
    }
    
    //Testing for Field_Trial_Contacts__c where RecordTypeId is Dealer but contactId does not have any user
    @isTest static void testAfterUpdate3(){
        Test.startTest();
        Field_Trial_Contacts__c fieldTrialContact = [SELECT Id,RecordTypeId,FT_Field_Trial__c,FT_Contact_Record__c,FT_Status__c
                                                     FROM Field_Trial_Contacts__c
                                                     WHERE FT_Status__c =:'Eligible - Not Chosen'
                                                     LIMIT 1];
        
        fieldTrialContact.FT_Status__c = 'Approved';
        update fieldTrialContact; 
        Test.stopTest();
    }
    //Method to create Account
    private static Account createAccount(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
        Account accountRec = new Account(RecordTypeId = recordTypeId, Name = 'Test Account',AccountNumber = '12345',Phone ='123',
                                         ShippingCity ='Nashik',ShippingStreet = 'Nashik Road',ShippingCountry = 'India',
                                         ShippingPostalCode = '12345',ShippingState = 'Maharashtra');
        return accountRec;
    }
    
    //Method to create contact records
    private static List<Contact> createContact(String accountId){
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Contact').getRecordTypeId();
        List<Contact> contactList = new List<Contact>();
        Contact contactRec = new Contact(RecordTypeId = recordTypeId, Contact_Type__c = 'Partner', FirstName = 'Test',
                                         LastName = 'Contact', AccountId = accountId, Email = 'test@gmail.com');
        contactList.add(contactRec);
        
        Contact contactRec1 = new Contact(RecordTypeId = recordTypeId, Contact_Type__c = 'Partner', FirstName = 'Test1',
                                          LastName = 'Contact1', AccountId = accountId, Email = 'test1@gmail.com');
        contactList.add(contactRec1);
        return contactList;
    }
    
    //Method to create field trial records
    private static List<FT_Field_Trial__c> createFieldTrials(String userId){
        List<FT_Field_Trial__c> fieldTrialList = new List<FT_Field_Trial__c>();
        
        FT_Field_Trial__c fieldTrialRec = new FT_Field_Trial__c(Name = 'Field Trial',FT_Stage__c = 'Planned', FT_ProductServiceCoordinator__c = userId);
        fieldTrialList.add(fieldTrialRec);
        
        FT_Field_Trial__c fieldTrialRec1 = new FT_Field_Trial__c(Name = 'Field Trial1',FT_Stage__c = 'Active' , FT_ProductServiceCoordinator__c = userId);
        fieldTrialList.add(fieldTrialRec1);
        
        FT_Field_Trial__c fieldTrialRec2 = new FT_Field_Trial__c(Name = 'Field Trial2',FT_Stage__c = 'In Process', FT_ProductServiceCoordinator__c = userId);
        fieldTrialList.add(fieldTrialRec2);
        
        FT_Field_Trial__c fieldTrialRec3 = new FT_Field_Trial__c(Name = 'Field Trial3',FT_Stage__c = 'Completed', FT_ProductServiceCoordinator__c = userId);
        fieldTrialList.add(fieldTrialRec3);
        
        return fieldTrialList;
    } 
    
    //Method to create field trial contact records
    private static List<Field_Trial_Contacts__c> createFieldTrialContacts(String fieldTrialId, String contactId, String contactId1){
        Id recordTypeId = Schema.SObjectType.Field_Trial_Contacts__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id recordTypeId1 = Schema.SObjectType.Field_Trial_Contacts__c.getRecordTypeInfosByName().get('Participant').getRecordTypeId();
        List<Field_Trial_Contacts__c> fieldTrialContactList = new List<Field_Trial_Contacts__c>();
        Field_Trial_Contacts__c fieldTrialContactRec = new Field_Trial_Contacts__c(RecordTypeId = recordTypeId, FT_Field_Trial__c=
                                                                                   fieldTrialId,FT_Contact_Record__c = contactId,
                                                                                   FT_Status__c = 'Eligible');
        fieldTrialContactList.add(fieldTrialContactRec);
        
        Field_Trial_Contacts__c fieldTrialContactRec1 = new Field_Trial_Contacts__c(RecordTypeId = recordTypeId, FT_Field_Trial__c=
                                                                                    fieldTrialId,FT_Contact_Record__c = contactId1,
                                                                                    FT_Status__c = 'Removed - Not in Compliance');
        fieldTrialContactList.add(fieldTrialContactRec1);
        
        Field_Trial_Contacts__c fieldTrialContactRec2 = new Field_Trial_Contacts__c(RecordTypeId = recordTypeId1, FT_Field_Trial__c=
                                                                                    fieldTrialId,FT_Contact_Record__c = contactId,
                                                                                    FT_Status__c = 'Chosen');
        fieldTrialContactList.add(fieldTrialContactRec2);
        
        Field_Trial_Contacts__c fieldTrialContactRec3 = new Field_Trial_Contacts__c(RecordTypeId = recordTypeId1, FT_Field_Trial__c=
                                                                                    fieldTrialId,FT_Contact_Record__c = contactId1,
                                                                                    FT_Status__c ='Eligible - Not Chosen');
        fieldTrialContactList.add(fieldTrialContactRec3);
        return fieldTrialContactList;
    }
    
    //Method to create Users
    private static List<User> createUsers(String contactId){
        Profile p = [SELECT Id FROM Profile WHERE Name=:'Customer Community Plus Login - FTL'];
        List<User> userList = new List<User>();
        User user = new User(Username ='testingsss@gmail.com',LastName = 'user', Email = 'Test@gmail.com',
                             IsActive = true,ContactId =contactId,TimeZoneSidKey ='America/Los_Angeles',Alias ='user@',
                             LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',LanguageLocaleKey ='en_US',ProfileId = p.Id);
        userList.add(user);
        return userList;
    }
    
    //Method to create field Trial form record
    private static List<FieldTrialForms__c> createFieldTrialForms(String fieldTrialContactId){
        Id recordTypeId = Schema.SObjectType.FieldTrialForms__c.getRecordTypeInfosByName().get('Dealer Install Survey').getRecordTypeId();
        List<FieldTrialForms__c> fieldTrialFormList = new List<FieldTrialForms__c>();
        FieldTrialForms__c fieldTrialFormRec = new FieldTrialForms__c(RecordTypeId = recordTypeId, Name = 'Field Trial Form',
                                                                      FT_Field_Trial_Contacts__c = fieldTrialContactId);
        fieldTrialFormList.add(fieldTrialFormRec);
        return fieldTrialFormList;
    }
    
    //Method to create site location
    private static List<Home_Owners__c> createSiteLocation(String fieldTrialContactId){
        List<Home_Owners__c> siteLocationList = new List<Home_Owners__c>();
        Id recordTypeId = Schema.SObjectType.Home_Owners__c.getRecordTypeInfosByName().get('Field Trial').getRecordTypeId();
        Home_Owners__c homeOwnerRec = new Home_Owners__c(RecordTypeId = recordTypeId,FT_Field_Trial_Contact__c = fieldTrialContactId,
                                                         Phone__c = '12345', Email__c = 'Test@gmail.com');
        siteLocationList.add(homeOwnerRec);
        return siteLocationList;
        
    }
    
    //Method to create equipment data
    private static List<Equipment_Data__c> createEquipmentaData(String siteLocationId,String fieldTrialId){
        Id recordTypeId = Schema.SObjectType.Equipment_Data__c.getRecordTypeInfosByName().get('Field Trial').getRecordTypeId();
        List<Equipment_Data__c> equipmentDataList = new List<Equipment_Data__c>();
        Equipment_Data__c equipmentData = new Equipment_Data__c(recordTypeId = recordTypeId,
                                                                Name = 'Equipment data',
                                                                Home_Owner__c = siteLocationId,
                                                                Serial_Number__c = '12345',
                                                                Model_Number__c ='12345',
                                                                FT_Field_Trial__c = fieldTrialId,
                                                                FT_Field_Trial_Type__c='Field Trial',
                                                                Category__c = 'Category', Address__c ='Test Address');
        
        equipmentDataList.add(equipmentData);
        return equipmentDataList;
    }
    
    //Method to create Field Trial Invoice records
    private static List<FT_Field_Trial_Invoices__c> createFieldTrialInvoices(String fieldTrialContactId,String accountId,String equipmentData, String userId, String serviceEventId, String siteLocationId){
        List<FT_Field_Trial_Invoices__c> fieldTrialInvoiceList = new List<FT_Field_Trial_Invoices__c>();
        FT_Field_Trial_Invoices__c fieldTrialInvoiceRec = new FT_Field_Trial_Invoices__c(FT_Dealer__c = fieldTrialContactId,
                                                                                         FT_Dealer_Account__c = accountId,FT_Equipment_Data__c=equipmentData,
                                                                                         FT_Field_Trial_Lead__c = userId, FT_Participant__c = fieldTrialContactId, FT_Service_Event__c = serviceEventId, FT_Site_Location__c = siteLocationId
                                                                                        );
        fieldTrialInvoiceList.add(fieldTrialInvoiceRec);                                                                              
        return fieldTrialInvoiceList;
    }
    
    //Method to create Field Trial Participant Applications Records
    private static List<FT_Field_Trial_Participant_Application__c> createFieldTrialParticipantApplications(String fieldTrialContactId){
        List<FT_Field_Trial_Participant_Application__c> fieldTrialParticipantApplicationList = new  List<FT_Field_Trial_Participant_Application__c>();
        FT_Field_Trial_Participant_Application__c fieldTrialParticipantAppRec = new FT_Field_Trial_Participant_Application__c(
            FT_Field_Trial_Contacts__c = fieldTrialContactId);
        fieldTrialParticipantApplicationList.add(fieldTrialParticipantAppRec);
        return fieldTrialParticipantApplicationList;
    }
    
    private static List<ServiceRecord__c> createServiceEvent(String fieldTrialContId, String siteLocationId, String eqpDataId){
        Id recordTypeId = Schema.SObjectType.ServiceRecord__c.getRecordTypeInfosByName().get('Service Record Layout for Equip').getRecordTypeId();
        List<ServiceRecord__c> serviceEvenets = new List<ServiceRecord__c>();
        ServiceRecord__c serviceRec = new ServiceRecord__c();
        serviceRec.FT_Field_Trial__c = 'Yes';
        serviceRec.Name = 'Yes';
        serviceRec.ServiceRecordSubject__c = 'Subject';
        serviceRec.EquipmentData__c = eqpDataId;
        serviceRec.FT_Participant__c = fieldTrialContId;
        serviceRec.FT_Dealer__c = fieldTrialContId;
        serviceRec.FT_Site_Location__c = siteLocationId;
        serviceRec.FT_Service_Event_Status__c = 'Reported';
        serviceRec.FT_Incident_Description__c = 'Description';
        serviceRec.RecordTypeId = recordTypeId;
        serviceEvenets.add(serviceRec);
        return serviceEvenets;
    }
}