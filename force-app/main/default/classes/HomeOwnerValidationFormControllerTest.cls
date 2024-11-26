/*
* @ Purpose      : This class is used to test the functionality of HomeOwnerValidationFormController.                   
* @ CreatedDate  : 4/4/2019
*/
@IsTest
public class HomeOwnerValidationFormControllerTest {
    
    /* 
    * @Purpose      : this function used to create test data.
    * @Parameter    : -
    * @Returntype   : -
    */
    @testSetup
    private static void testData(){
        
        Id devRecordTypeId = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Homeowner Finalist Validation Form').getRecordTypeId();
        
        FTL_Program_Form__c pf = createProgramForm(devRecordTypeId);
        Insert pf;
    }
    
    /* 
    * @Purpose      : this function used to test functionality of HomeOwnerValidationFormController.
    * @Parameter    : -
    * @Returntype   : -
    */
    @IsTest
    private static void testHomeOwnerValidationFormController(){
        FTL_Program_Form__c pf = [SELECT Id, Nominee_Phone_Number__c FROM FTL_Program_Form__c LIMIT 1];
        
        HomeOwnerValidationFormController.Response res = HomeOwnerValidationFormController.getOnloadPageData(pf.Id);
        System.assertEquals(res.isSuccess, true);
        pf.Nominee_Phone_Number__c = '1234567890';
        HomeOwnerValidationFormController.Response Updatedres = HomeOwnerValidationFormController.updateProgramStatusRecord(pf);
        System.assertEquals(res.isSuccess, true);
    }
    
    /* 
    * @Purpose      : this function used to test negative user cases.
    * @Parameter    : -Invalid Id , Null
    * @Returntype   : -
    */
    @IsTest
    private static void negativeTest(){
        HomeOwnerValidationFormController.Response res = HomeOwnerValidationFormController.getOnloadPageData('Invalid Id');
        System.assertEquals(res.data, NULL);
        System.assertEquals(res.msg, 'Record Not Found.');
        System.assertEquals(res.isSuccess, false);
        HomeOwnerValidationFormController.Response Updatedres = HomeOwnerValidationFormController.updateProgramStatusRecord(null);
        System.assertEquals(Updatedres.data, NULL);
        System.assertEquals(Updatedres.msg, 'Program Status Record not found.');
        System.assertEquals(Updatedres.isSuccess, false);
    }
    /* 
    * @Purpose      : this function used to test getOnloadPageData negative user cases.
    * @Parameter    : Empty String
    * @Returntype   : -
    */
    @IsTest
    private static void negativeTestWithNoInput(){
        HomeOwnerValidationFormController.Response res = HomeOwnerValidationFormController.getOnloadPageData('');
        System.assertEquals(res.data, NULL);
        System.assertEquals(res.msg, 'Record Id Not Found.');
        System.assertEquals(res.isSuccess, false);
        
        FTL_Program_Form__c FTL_form = [SELECT Id, Nominee_Phone_Number__c FROM FTL_Program_Form__c LIMIT 1];
        delete FTL_form;
        HomeOwnerValidationFormController.Response Updatedres = HomeOwnerValidationFormController.updateProgramStatusRecord(FTL_form);
        System.assertEquals(Updatedres.data, NULL);
        System.assertEquals(Updatedres.isSuccess, false);
        System.assert(Updatedres.msg.contains('Update failed.'));
    }
    
    /* 
    * @Purpose      : this function used to create FTL_Program_Form__c.
    * @Parameter    : String recordTypeId
    * @Returntype   : FTL_Program_Form__c
    */
    private static FTL_Program_Form__c createProgramForm(String recordTypeId){
        FTL_Program_Form__c  pf = new FTL_Program_Form__c();
        pf.Nominee_Name__c = 'Test';
        pf.Nominee_City__c = 'Austin';
        pf.Nominee_State__c = 'TX';
        pf.Nominee_Street_Address__c = '123 main st';
        pf.Nominee_Zip_Code__c = '12345';
        pf.Nominee_Phone_Number__c = '9999999999';
        pf.RecordTypeId = recordTypeId;
            
        return pf;
    }   
}