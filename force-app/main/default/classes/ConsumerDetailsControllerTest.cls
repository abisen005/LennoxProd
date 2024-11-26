/*
*  @Description: This class is used to Check the functionality of "ConsumerDetailsController" class.
*/
@isTest
public class ConsumerDetailsControllerTest {

    public static final Integer TOTALRECORDS = 5;
    
  /*
   *	@Purpose - Create test records that are used while testing 'ConsumerDetailsController' class.
   */
    @testSetup
    public static void createTestData() {
		//Get record type id for Contact
		Id recordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
		
		//Create Contact record
		Contact contact = new Contact(RecordTypeId = recordTypeIdContact, firstName = 'test', LastName = 'Test', email = 'test@example.com');
		Insert contact;
		
		
		//Get record type id for Case
		Id recordTypeIdCase =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Salesforce Support').getRecordTypeId();
		
        
        
        /*
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile limit 1 ].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        
        INSERT u;*/
        
        //Create Site location record
		Home_Owners__c homeOwner = new Home_Owners__c(Name = 'Test', FirstName__c='Test');
		INSERT homeOwner;
        
        //Insert Case records
        Case caseRecord = new Case(RecordTypeId = recordTypeIdCase, Status = 'New', ContactId = contact.Id , Home_Owner__c = homeOwner.Id );//, OwnerId = u.Id);
		Insert caseRecord; 
        
        
		
        System.debug('caseRecord--' + caseRecord);
		
		//Create Lennox_Form__c records
		Lennox_Form__c lennoxForm = new Lennox_Form__c(First_Name__c = 'Danial', Case__c = caseRecord.Id, Last_Name__c = 'Smith', Consumer_Postal_Code__c = '45601',
                                                       Consumer_Street_Address__c = '215 North Gates Rd', Consumer_City__c = 'Chillicothe', Consumer_State__c = 'OH', Home_Phone__c = '7685946348',
                                                      Business_Phone__c = '9583657848');
		INSERT lennoxForm;  
        
		//Create Form_Instruction__c records
		Form_Instruction__c formInstruction = new Form_Instruction__c(/*Form_Type__c = 'Salesforce Support', Status__c = 'Active', */Order__c = 1, Header__c = 'test', Instruction__c = 'test' );
		
		INSERT formInstruction;
		
		//Create Installation__c records
		Installation__c installation = new Installation__c(Serial_Number__c = '123', Number_of_Products_Installed__c = '1',Date_Installed__c = System.today(), Installation_Type__c = 'Indoor Unit', Lennox_Form__c = lennoxForm.Id, Model_Number__c = '123' );
		
		INSERT installation;
        
        Installation__c installation1 = new Installation__c(Serial_Number__c = '1234', Number_of_Products_Installed__c = '2',Date_Installed__c = System.today(), Installation_Type__c = 'Outdoor Unit', Lennox_Form__c = lennoxForm.Id, Model_Number__c = '123' );
        
        INSERT installation1;
        
        //Get record type Id
        Id recordTypeIdEquipmentData = Schema.SObjectType.Equipment_Data__c.getRecordTypeInfosByName().get('Active Equip Record').getRecordTypeId();
        //Insert Equipment_Data__c record
        Equipment_Data__c equipmentData = new Equipment_Data__c(RecordTypeId = recordTypeIdEquipmentData, Name = 'test',Serial_Number__c = '123');
        INSERT equipmentData;
        
        // Insert Case_Equip_Junction__c records
        Case_Equip_Junction__c equipment = new Case_Equip_Junction__c(Equipment_Data__c = equipmentData.Id, Case__c = caseRecord.Id);
        INSERT equipment;
    }
	
    /**
    * @Purpose - Call ConsumerDetailsController class methods and test the functionality of that class .
    */
    public static testmethod void testConsumerDetailsController(){
        
		List<Lennox_Form__c> lenoxFormList = [SELECT Id, First_Name__c, Case__c FROM Lennox_Form__c];
        List<Installation__c> installationList = [SELECT Id, Serial_Number__c, Number_of_Products_Installed__c ,Date_Installed__c, Installation_Type__c, 
                                                  Lennox_Form__c, Model_Number__c 
                                                  FROM Installation__c];
        
        Case caseRecord = [SELECT Id, Owner.Email, Owner.Name, Summary_of_Concerns__c FROM Case];
        System.debug('caseRecord--' + caseRecord);
        
        Attachment attach = new Attachment();   	
    	attach.Name = 'Test';
    	Blob bodyBlob = Blob.valueOf('Testing Body of Attachment');
    	attach.body = bodyBlob;
        attach.parentId = caseRecord.id;
        insert attach;
        
        Test.startTest();
        
        ConsumerDetailsController.updateSiteLocationRecord(System.JSON.serialize(lenoxFormList), 'Test');
        ConsumerDetailsController.getInstructions('Consumer Support');
        ConsumerDetailsController.insertInstallationRecords(System.JSON.serialize(installationList), String.valueOf(caseRecord.Id), 'strSummeryOfConcern');
        ConsumerDetailsController.sendMail('test@example.com', 'test');
        ConsumerDetailsController.saveChunk(caseRecord.Id, 'fileName', EncodingUtil.base64Encode(Blob.valueOf('fileData')), 'text/csv;base64,', '');
        ConsumerDetailsController.saveChunk(caseRecord.Id, 'fileName', EncodingUtil.base64Encode(Blob.valueOf('fileData')), 'text/csv;base64,', attach.Id);
        //ConsumerDetailsController.Response test = new ConsumerDetailsController.Response( true, 'test', 'test');
        ConsumerDetailsController.getSiteLocationDetails(caseRecord.Id);
        ConsumerDetailsController.getObjectName(caseRecord.Id);
        ConsumerDetailsController.getObjectName('test');
        ConsumerDetailsController.getRecordTypeId();
        
        caseRecord.Home_Owner__c = null; 
        
        update caseRecord;
        ConsumerDetailsController.getSiteLocationDetails(caseRecord.Id);
        Test.stopTest();   
    }      
}