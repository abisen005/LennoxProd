/**
 * @Purpose           : Test class of TerritoryManagerScoreCardsController
 * @Created Date      : 29/06/2018
 */ 
@isTest
public class TerritoryManagerScoreCardsControllerTest {
    /** 
     * @Purpose : Method to create test data
     */
    @TestSetup
    public static void createTestData(){
        
          Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Lennox - Res Sales TM - Lightning' LIMIT 1];
        
       User usrTM = new User(LastName = 'TLIVESTON',
                           FirstName='TJASON',
                           Alias = 'jli2',
                           Email = 'test1liveston@asdf.com',
                           Username = 'test1Sliveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           SAP_Sales_Group__c='T123'
                           );
        insert usrTM;
                
        User usrTM1 = new User(LastName = 'TLIVESTON',
                           FirstName='TJASON',
                           Alias = 'jli2',
                           Email = 'testTM1liveston@asdf.com',
                           Username = 'testTM11Sliveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           SAP_Sales_Group__c='T425'
                           );
        insert usrTM1;
                
        Profile dMProfileId = [SELECT Id FROM Profile WHERE Name = 'Lennox - Res Sales DM - Lightning' LIMIT 1];
        
        User usrDM = new User(LastName = 'TLIVESTON',
                           FirstName='TJASON',
                           Alias = 'jli2',
                           Email = 'test2liveston@asdf.com',
                           Username = 'test2Sliveston@asdf.com',
                           ProfileId = dMProfileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           SAP_Sales_Group__c='T123',
                           SAP_Sales_Office__c='TN12'
                           );
        insert usrDM;
        
        Profile aMProfileId = [SELECT Id FROM Profile WHERE Name = 'Lennox - Res Sales AM - Lightning' LIMIT 1];
        
        User usrAM = new User(LastName = 'TLIVESTON',
                           FirstName='TJASON',
                           Alias = 'jli2',
                           Email = 'test3liveston@asdf.com',
                           Username = 'test3Sliveston@asdf.com',
                           ProfileId = aMProfileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           SAP_Sales_Group__c='T123',
                           SAP_Sales_District1__c='West Region'   
                           );
        insert usrAM;
         List<Profile> profileList = [Select Id From Profile Where Name like '%Res Sales TM%'];
        List<UserRole> uRoleList = [Select Id From UserRole Where Name like '%Lennox System Admin%'];
        User testUser = new User();
        testUser.UserName = 'Lennox_testuser1@testuser.com';
        testUser.LastName = 'Test';
        testUser.email = 'test1@testuser.com';
        testUser.alias = 'testusr1';
        testUser.communitynickname = 'tstusr';
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.ProfileId = profileList[0].Id;
        testUser.LanguageLocaleKey = 'en_US';   
        testUser.UserRoleId = uRoleList[0].Id;
        testUser.SAP_Sales_Group__c = '700';
        testUser.SAP_Sales_Office__c = 'C489';
        insert testUser;
        
        //System.runAs(sfUser) 
        
        System.runAS(testUser){
        Oasis_Sales__c oSales = new Oasis_Sales__c(Name='Test', MTD_Plan_Sales__c=5860, MTD_Actual_Sales__c=7890, YTD_Plan_Sales__c=9866, 
                                                  YTD_Actual_Sales__c=4896, MTD_Plan_GP__c=8795, MTD_Actual_GP__c=2035, YTD_Plan_GP__c=8516, YTD_Actual_GP__c=8650,
                                                  Sales_Group__c='T123', Daily_Actual_Sales__c=7653, Daily_Actual_GP__c=4508);
        insert oSales;
        
        Oasis_Sales__c oSales1 = new Oasis_Sales__c(Name='Test', MTD_Plan_Sales__c=15860, MTD_Actual_Sales__c=5890, YTD_Plan_Sales__c=3866, 
                                                  YTD_Actual_Sales__c=6896, MTD_Plan_GP__c=10795, MTD_Actual_GP__c=4035, YTD_Plan_GP__c=5516, YTD_Actual_GP__c=2650,
                                                  Sales_Group__c='Tett', Daily_Actual_Sales__c=9653, Daily_Actual_GP__c=2508);
        insert oSales1;
            
        Metric_Parameter__c metricParam = new Metric_Parameter__c(Name='Oasis Sales MTD to Quota', Is_Active__c=true, Role__c='All Roles',
                                                                 Green_Start_Range__c= 48, Green_End_Range__c=110, 
                                                                 Red_Start_Range__c=60, Red_End_Range__c=100,
                                                                 Yellow_Start_Range__c=55, Yellow_End_Range__c=120, Metric_Unit__c='Number');
        insert metricParam;
        
        Metric_Parameter__c metParam1 = new Metric_Parameter__c(Name='Oasis Sales MTD to Quota', Is_Active__c=true, Role__c='All Roles',
                                                                 Green_Start_Range__c= 88, Green_End_Range__c=111, 
                                                                 Red_Start_Range__c=50, Red_End_Range__c=65,
                                                                 Yellow_Start_Range__c=75, Yellow_End_Range__c=95, Metric_Unit__c='Percentage');
        insert metParam1;
        
        Metric_Parameter__c metricParam1 = new Metric_Parameter__c(Name='Oasis Sales YTD to Quota', Is_Active__c=true, Role__c='All Roles',
                                                                 Green_Start_Range__c= 30, Green_End_Range__c=42, 
                                                                 Red_Start_Range__c=40, Red_End_Range__c=45,
                                                                 Yellow_Start_Range__c=12, Yellow_End_Range__c=25, Metric_Unit__c='Percentage');
        insert metricParam1;
        
        Metric_Parameter__c metricParam2 = new Metric_Parameter__c(Name='Oasis GP MTD to Quota', Is_Active__c=true, Role__c='All Roles',
                                                                 Green_Start_Range__c= 9, Green_End_Range__c=18, 
                                                                 Red_Start_Range__c=10, Red_End_Range__c=20,
                                                                 Yellow_Start_Range__c=20, Yellow_End_Range__c=22, Metric_Unit__c='Percentage');
        insert metricParam2;
        
         Metric_Parameter__c metricParam3 = new Metric_Parameter__c(Name='Oasis GP YTD to Quota', Is_Active__c=true, Role__c='All Roles',
                                                                 Green_Start_Range__c= 67, Green_End_Range__c=97, 
                                                                 Red_Start_Range__c=50, Red_End_Range__c=69,
                                                                 Yellow_Start_Range__c=75, Yellow_End_Range__c=88, Metric_Unit__c='Percentage');
        insert metricParam3;
        
        
        Metric_Parameter__c metParam = new Metric_Parameter__c(Name='Test', Is_Active__c=true, Role__c='District Manager',
                                                                 Green_Start_Range__c= 1, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=5, Red_End_Range__c=8,
                                                                 Yellow_Start_Range__c=2, Yellow_End_Range__c=6, Metric_Unit__c='Percentage');
        insert metParam;
        
        Metric_Parameter__c metParamD1 = new Metric_Parameter__c(Name='Test', Is_Active__c=true, Role__c='District Manager',
                                                                 Green_Start_Range__c= 1, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=5, Red_End_Range__c=8,
                                                                 Yellow_Start_Range__c=2, Yellow_End_Range__c=6, Metric_Unit__c='Number');
        insert metParamD1;
        
        List<Metric_Parameter__c> metricTMPList = new List<Metric_Parameter__c>();
        
        Metric_Parameter__c metriParam2 = new Metric_Parameter__c(Name='Oasis Sales MTD to Quota', Is_Active__c=true, Role__c='Territory Manager',
                                                                 Green_Start_Range__c= 1, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=3, Red_End_Range__c=6,
                                                                 Yellow_Start_Range__c=1, Yellow_End_Range__c=4, Metric_Unit__c='Percentage');
        metricTMPList.add(metriParam2);
        
        Metric_Parameter__c metriParam12 = new Metric_Parameter__c(Name='Oasis Sales MTD to Quota1', Is_Active__c=true, Role__c='Territory Manager',
                                                                 Green_Start_Range__c= 2, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=5, Red_End_Range__c=7,
                                                                 Yellow_Start_Range__c=1, Yellow_End_Range__c=4, Metric_Unit__c='Number');
        metricTMPList.add(metriParam12);
        
        Metric_Parameter__c metriParam13 = new Metric_Parameter__c(Name='Oasis Sales MTD to Quota2', Is_Active__c=true, Role__c='Territory Manager',
                                                                 Green_Start_Range__c= 4, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=4, Red_End_Range__c=6,
                                                                 Yellow_Start_Range__c=2, Yellow_End_Range__c=4, Metric_Unit__c='Dollars');
        metricTMPList.add(metriParam13);
        
        insert metricTMPList;
        
        Metric_Parameter__c metricPara1 = new Metric_Parameter__c(Name='Oasis', Is_Active__c=true, Role__c='District Manager',
                                                                 Green_Start_Range__c= 3, Green_End_Range__c=5, 
                                                                 Red_Start_Range__c=2, Red_End_Range__c=6,
                                                                 Yellow_Start_Range__c=3, Yellow_End_Range__c=7, Metric_Unit__c='Percentage');
        insert metricPara1;
        
                
      
             
        Performance_Metric__c perMetric = new Performance_Metric__c(Goal_Type__c=metricParam.Id, TM_DM_Name__c=usrTM.Id, Performance_Number__c=123);
        insert perMetric;
        
        Performance_Metric__c perMetric1 = new Performance_Metric__c(Goal_Type__c=metricParam1.Id, TM_DM_Name__c=usrDM.Id);
        insert perMetric1;
        
        Performance_Metric__c perMetric2 = new Performance_Metric__c(Goal_Type__c=metParam.Id, TM_DM_Name__c=usrDM.Id);
        insert perMetric2; 
            
        Performance_Metric__c perMetric12 = new Performance_Metric__c(Goal_Type__c=metParamD1.Id, TM_DM_Name__c=usrDM.Id, Performance_Number__c=235);
        insert perMetric12;    
        
        Performance_Metric__c perMetric3 = new Performance_Metric__c(Goal_Type__c=metriParam2.Id, TM_DM_Name__c=usrTM.Id);
        insert perMetric3;
        
        List<Performance_Metric__c> performMetricList = new List<Performance_Metric__c>();
        
        for (Metric_Parameter__c metParamRec : metricTMPList){
            Performance_Metric__c perMetricRec = new Performance_Metric__c(Goal_Type__c=metParamRec.Id, TM_DM_Name__c=usrTM1.Id, Performance_Number__c=123);
            performMetricList.add(perMetricRec);
        }
        insert performMetricList;
        
        Sales_Group_Master__c saleMaster = new Sales_Group_Master__c(Region__c='Central Region', District__c='TestN', District_Number__c='T347',
                                                                    Sales_Group__c='T123');
        insert saleMaster; 
            
        Sales_Group_Master__c saleMasterD = new Sales_Group_Master__c(Region__c='Central Region', District__c='TestN', District_Number__c='TN12',
                                                                    Sales_Group__c='T123');
        insert saleMasterD;    
        
        Sales_Group_Master__c saleMasterR = new Sales_Group_Master__c(Region__c='West Region', District__c='TestN', District_Number__c='TN12',
                                                                    Sales_Group__c='T123');
        insert saleMasterR;    
        
        }
    }
    
    /**
     * @Purpose: Test for TM user
     */
   static testMethod void testTMUser() {
       User user = [SELECT Id, Name FROM User WHERE isActive = true AND profile.Name like '%Res Sales TM%' LIMIT 1];              
       Test.startTest();
       System.runAs(user)
        {  
          TerritoryManagerScoreCardsController controller = new TerritoryManagerScoreCardsController();    
        }
             
       Test.stopTest();
   }
    
    /**
     * @Purpose: Test 
     */
   static testMethod void testDmUser() {
       User user = [SELECT Id, Name FROM User WHERE isActive = true AND profile.Name like '%Res Sales DM%' LIMIT 1];      
       Test.startTest();
       System.runAs(user)
        {
          TerritoryManagerScoreCardsController controller = new TerritoryManagerScoreCardsController();    
        }
           
       
       Test.stopTest();
   }
    
    /**
     * @Purpose: Test
     */
   static testMethod void testAmUser() {
       User user = [SELECT Id, Name FROM User WHERE isActive = true AND profile.Name like '%Res Sales AM%' LIMIT 1];       Test.startTest();
       System.runAs(user){
           TerritoryManagerScoreCardsController controller = new TerritoryManagerScoreCardsController();    
       }
           
       Test.stopTest();
   }
    
    /**
     * @Purpose: Test 
     */
   static testMethod void testTManager() {
       Test.startTest();
       TerritoryManagerScoreCardsController controller = new TerritoryManagerScoreCardsController();    
        
       Test.stopTest();
   }
    
    /**
     * @Purpose: Test 
     */
   static testMethod void testTMmUserNeg() {
       User user = [SELECT Id, Name FROM User WHERE isActive = true LIMIT 1];
       Test.startTest();
       System.runAs(user)
        {
         TerritoryManagerScoreCardsController controller = new TerritoryManagerScoreCardsController();    
        } 
       Test.stopTest();
   }

}