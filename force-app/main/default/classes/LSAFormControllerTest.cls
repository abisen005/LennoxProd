/*
 *  @Description: This class is used to Check the functionality of "LSAFormController" class.
 */
@isTest
public class LSAFormControllerTest {
  @testSetup
  public static void createTestData() {
    Lennox_LSA_Program__c LSAprogram = new Lennox_LSA_Program__c();
    LSAprogram.Name = 'test';
    LSAprogram.Special_Allowance_Form__c = 'test';
    LSAprogram.Units_Affected__c = 'test';
    LSAprogram.Program_Expiration_Date__c = System.today();
    LSAprogram.Material_Number__c = '1';
    LSAprogram.Description__c = 'test';
    LSAprogram.Amount__c = 1;
    Insert LSAprogram;

    Home_Owners__c hm = new Home_Owners__c();
    hm.Name = 'test428';
    hm.Address__c = '121AB street';
    hm.City__c = 'texas';
    hm.StateProvince__c = 'AK';
    hm.Postal_Code__c = 'ADRT56';
    hm.FirstName__c = 'test127';
    insert hm;

    Consumer_Form__c consumer = new Consumer_Form__c();
    consumer.Back_Up_Heat_Model__c = 'Test';
    consumer.Serial_Number__c = '1523F03249';
    consumer.Unit_Serial_Number__c = '1523F03249';
    consumer.Unit_Model_Number__c = '123';
    Insert consumer;
  }

  @isTest
  public static void TestLSAForm() {
    //test method
    Lennox_LSA_Program__c LSAProgram =
        [ SELECT Id, Name, Reason_for_Reimbursement__c, Order_Reason__c, Amount__c FROM Lennox_LSA_Program__c LIMIT 1 ];

    Lennox_Form__c lennoxForm = new Lennox_Form__c(JobFirstName__c = 'test127', Last_Name__c = 'test428', Consumer_Postal_Code__c = '12345',
        IndoorUnitSerialNumber__c = '12345', JobStreetAddress__c = '121AB street', JobCity__c = 'texas', JobState__c = 'AK',
        Home_Phone__c = '2988888874', JobPostalCode__c = 'ADRT56', Business_Phone__c = '0967444441');

    Home_Owners__c siteLocation = [ SELECT ID FROM Home_Owners__c ];
    Consumer_Form__c consumerForm = [ SELECT ID, Unit_Serial_Number__c, Serial_Number__c, Unit_Model_Number__c FROM Consumer_Form__c ];

    LSAFormController.Response LSAProgramres = LSAFormController.getLSAProgramRecord(LSAProgram.Name);

    LSAFormController.Response lennoxFormres = LSAFormController.createLennoxFormRecord(lennoxForm, LSAProgram);
    LSAFormController.createSiteLocation(lennoxForm, LSAProgram);

    LSAFormController.Response lennoxFormresforExistingSiteLocation = LSAFormController.createLennoxFormRecord(lennoxForm, LSAProgram);

    LSAFormController.Response LSAProgramresInvalidName = LSAFormController.getLSAProgramRecord('Invalid');

    LSAFormController.Response LSAProgramresNullArgument = LSAFormController.getLSAProgramRecord(null);
    LSAFormController.getRecordTypeId();
    LSAFormController.getAccountDetailsApex('ABCS');

    LSAFormController.LSAserialNumberCheck('1523F03249');
    LSAFormController.UpdateLennoxConsumerFormRecord(consumerForm, 'test@gmail.com', siteLocation.Id);

    List<account> accts = new List<account>();
    accts.add(new Account(name = 'Grazitti', Phone = '111-111-1111', ShippingStreet = '124 Main St', ShippingCity = 'Austin', ShippingState = 'TX',
        ShippingPostalCode = '65432', ShippingCountry = 'US', FTL_Eligibility__c = 'Enrolled', SAP_Customer_Number__c = '501037'));
    insert accts;
    Lennox_LSA__c LennoxLSA = new Lennox_LSA__c();
    // LennoxLSA.Site_Location__c =hm.Id;
    LennoxLSA.Approval_Status__c = 'Approval Pending';
    LennoxLSA.Account__c = accts[0].Id;
    LennoxLSA.Serial_Number__c = '1523F03249';
    LennoxLSA.Model_Number__c = '11112222';
    LennoxLSA.Reason_for_Reimbursement__c = 'Programs (Res)';
    LennoxLSA.Is_LSA_Request_to_Reimburse_a_Homeowner__c = 'Yes';
    LennoxLSA.Corp_Program__c = true;
    LennoxLSA.Requestor_Comments__c = 'test';
    LennoxLSA.Type_of_Backup_Heat__c = 'Electric';
    LennoxLSA.Order_Reason__c = 'Application Error';
    LennoxLSA.Request_outside_of_LSA_process__c ='No';
    insert LennoxLSA;

    LSAFormController.findOrCreateConsumerEquipmentData(consumerForm, siteLocation.Id, null, LennoxLSA);
    LSAFormController.checkSerialNumberApex(LennoxLSA.Model_Number__c, LSAProgram.Id);
    LSAFormController.searchSerialNumberApex(LennoxLSA.Model_Number__c, LSAProgram.Id);
  }
}