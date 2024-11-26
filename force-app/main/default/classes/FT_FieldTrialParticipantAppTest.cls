@isTest
public class FT_FieldTrialParticipantAppTest {
    @TestSetup
    static void makeData(){
        /*Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(
            Alias = 'fjk',
            Email='sdkfasdhk@ksafdasdfh.com', 
            EmailEncodingKey='UTF-8',
            FirstName='Lennox',
            LastName='Salesforce User',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='sdkfasdhk@ksafdasdfh.com'
        );
        insert u;*/
        
        FT_Field_Trial_Participant_Application__c rec1 = createRecord('');
        FT_Field_Trial_Participant_Application__c rec2 = createRecord('1234');
        
        FT_Field_Trial_Participant_Applctn_Systm__c system1 = new FT_Field_Trial_Participant_Applctn_Systm__c( FT_Field_Trial_Participant_Application__c = rec1.Id );
        insert system1;
        
        FT_Field_Trial_Participant_Applctn_Systm__c system2 = new FT_Field_Trial_Participant_Applctn_Systm__c( FT_Field_Trial_Participant_Application__c = rec2.Id );
        insert system2;
    }

    static FT_Field_Trial_Participant_Application__c createRecord(string employeeId){
        FT_Field_Trial_Participant_Application__c record = new FT_Field_Trial_Participant_Application__c(
            FT_First_Name__c='Test1',FT_Last_Name__c='Test2',FT_Employee_ID__c=employeeId,FT_Email__c='test@test.com'
        );
        insert record;
        return record;
    }

    @IsTest
    static void positiveNegative(){
        Test.startTest();
        
        FT_Field_Trial_Participant_Application__c rec2 = [SELECT Id,FT_First_Name__c,FT_Last_Name__c,FT_Employee_ID__c,FT_Email__c
                                                          FROM FT_Field_Trial_Participant_Application__c 
                                                          WHERE FT_Employee_ID__c != null];           

        ApexPages.StandardController sc2 = new ApexPages.StandardController(rec2);
        FT_FieldTrialParticipantAppController controllerObj2 = new FT_FieldTrialParticipantAppController(sc2); 
        //PageReference pg2 =  controllerObj2.save();
        controllerObj2.saveCustom();
        
        controllerObj2.isSuccess = true;
        controllerObj2.message = '';
        controllerObj2.res = new FT_FieldTrialParticipantAppController.Response( true, '', '' );
        
        FT_FieldTrialParticipantAppController.removeElements( new List<FT_Field_Trial_Participant_Applctn_Systm__c>{ new FT_Field_Trial_Participant_Applctn_Systm__c() }, 1 );
        
        controllerObj2.fieldParticipant.FT_Number_of_Systems_in_the_home__c = '3';
        
        controllerObj2.getParticipantAppSystems();
        
        Test.stopTest();
    }
    
    @IsTest
    static void testSaveData(){
        Test.startTest();

        FT_Field_Trial_Participant_Application__c rec1 = [SELECT Id,FT_First_Name__c,FT_Last_Name__c,FT_Employee_ID__c,FT_Email__c
                                                          FROM FT_Field_Trial_Participant_Application__c 
                                                          WHERE FT_Employee_ID__c = null];
                
        ApexPages.StandardController sc = new ApexPages.StandardController(rec1);
        FT_FieldTrialParticipantAppController controllerObj = new FT_FieldTrialParticipantAppController(sc);
        //PageReference pg =  controllerObj.save();
        controllerObj.saveCustom();
        
        Test.stopTest();
    }
    
    @IsTest
    static void testSaveData2(){
        Test.startTest();
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(new FT_Field_Trial_Participant_Application__c());
        FT_FieldTrialParticipantAppController controllerObj1 = new FT_FieldTrialParticipantAppController(sc1);
        //PageReference pg1 =  controllerObj1.save();
		controllerObj1.saveCustom();
        
        controllerObj1.fieldParticipant.FT_Number_of_Systems_in_the_home__c = '3';
        controllerObj1.getParticipantAppSystems();
                
        Test.stopTest();
    }
    
    @IsTest
    static void testSaveData3(){
        Test.startTest();

        FT_Field_Trial_Participant_Application__c testrec = new FT_Field_Trial_Participant_Application__c();
        testrec.FT_Email__c = 'abc@pqr.com';
        testrec.FT_Employee_ID__c = '1234';
        ApexPages.StandardController sc3 = new ApexPages.StandardController(testrec);
        FT_FieldTrialParticipantAppController controllerObj3 = new FT_FieldTrialParticipantAppController(sc3);
        //PageReference pg3 =  controllerObj3.save();
        
        controllerObj3.fieldParticipant = testrec;
		controllerObj3.saveCustom();
        
        controllerObj3.resetForm();
        
        Test.stopTest();
    }
}