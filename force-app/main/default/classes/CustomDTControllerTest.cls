@isTest
public class CustomDTControllerTest {
     @isTest
    public static void method1(){
        String str1 =    '[{ "USER_STATUS": "2022-11-03T00:00:00","TRANSCRIPT_STATUS": "Completed", "TRAINING_HOURS": 0.029999999329447746,"USER_POSITION_DESCR": "Comfort Advisor (Sales)","TRAINING_OBJECT_ID": "127674da-470b-4b6e-9ca3-9b9e6a78db6b","NATE_COURSE_ID": null,"NATE_ID": null,"USER_FULL_NAME": "Jeremy Stevens","DEALER_NUMBER": "E88770", "TRAINING_TYPE": "VID", "TRAINING_TITLE": "Internet is the homeowners most important source for researching in HVAC", "PROVIDER_NAME": "Lennox Learning","REGISTRATION_DT": "2022-11-03T00:00:00"}]';
        String str2 =    '[{"AccountName":"Mtn Valley Home Comfort Inc","CustomerNumber":"A85500"}]';
        CustomDTController.storeJSONIntoTempCache(str1 ,str2);
        String tableName ='OrderSearchFlow';
        CustomDTController.returnDefaultColumns(tableName);
    }
}