@isTest
private class RollupSummaryReportByUserControllerTest {

    @isTest 
    private static void test1 () {

        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;

        Quick_Links_Cmp_Setting__c qSetting = new Quick_Links_Cmp_Setting__c();
        qSetting.Name = 'testName';
        qSetting.Profile_Name__c = profileName;
        qSetting.RollupSummary__c = true;
        qSetting.RegionRollupSummary__c = false;
        qSetting.DistrictRollupSummary__c = false;
        qSetting.TerritoryRollupSummary__c = false;
        insert qSetting;

        Signature_Sales_Console_Settings__c sSetting = new Signature_Sales_Console_Settings__c();
        sSetting.Name = 'Executive';
        sSetting.Roll_Up_Report_Page_Name__c = 'DummpyVFPage';
        sSetting.Dashboard_Folder_Name__c = 'DashboardFolderName';
        sSetting.Report_Folder_Name__c = 'ReportFolderName';
        sSetting.User_Mode__c = 'UserMode';
        insert sSetting;
        
        String VFPageName = RollupSummaryReportByUserController.getVFPageName();
        system.assertEquals('DummpyVFPage', VFPageName);
    }

    @isTest 
    private static void test2 () {

        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;

        Quick_Links_Cmp_Setting__c qSetting = new Quick_Links_Cmp_Setting__c();
        qSetting.Name = 'testName';
        qSetting.Profile_Name__c = profileName;
        qSetting.RollupSummary__c = false;
        qSetting.RegionRollupSummary__c = true;
        qSetting.DistrictRollupSummary__c = false;
        qSetting.TerritoryRollupSummary__c = false;
        insert qSetting;

        Signature_Sales_Console_Settings__c sSetting = new Signature_Sales_Console_Settings__c();
        sSetting.Name = 'Region';
        sSetting.Roll_Up_Report_Page_Name__c = 'DummpyVFPage';
        sSetting.Dashboard_Folder_Name__c = 'DashboardFolderName';
        sSetting.Report_Folder_Name__c = 'ReportFolderName';
        sSetting.User_Mode__c = 'UserMode';
        insert sSetting;
        
        String VFPageName = RollupSummaryReportByUserController.getVFPageName();
        system.assertEquals('DummpyVFPage', VFPageName);
    }
    
    @isTest 
    private static void test3 () {

        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;

        Quick_Links_Cmp_Setting__c qSetting = new Quick_Links_Cmp_Setting__c();
        qSetting.Name = 'testName';
        qSetting.Profile_Name__c = profileName;
        qSetting.RollupSummary__c = false;
        qSetting.RegionRollupSummary__c = false;
        qSetting.DistrictRollupSummary__c = true;
        qSetting.TerritoryRollupSummary__c = false;
        insert qSetting;

        Signature_Sales_Console_Settings__c sSetting = new Signature_Sales_Console_Settings__c();
        sSetting.Name = 'District';
        sSetting.Roll_Up_Report_Page_Name__c = 'DummpyVFPage';
        sSetting.Dashboard_Folder_Name__c = 'DashboardFolderName';
        sSetting.Report_Folder_Name__c = 'ReportFolderName';
        sSetting.User_Mode__c = 'UserMode';
        insert sSetting;
        
        String VFPageName = RollupSummaryReportByUserController.getVFPageName();
        system.assertEquals('DummpyVFPage', VFPageName);
    }
    
    @isTest 
    private static void test4 () {

        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;

        Quick_Links_Cmp_Setting__c qSetting = new Quick_Links_Cmp_Setting__c();
        qSetting.Name = 'testName';
        qSetting.Profile_Name__c = profileName;
        qSetting.RollupSummary__c = false;
        qSetting.RegionRollupSummary__c = false;
        qSetting.DistrictRollupSummary__c = false;
        qSetting.TerritoryRollupSummary__c = true;
        insert qSetting;

        Signature_Sales_Console_Settings__c sSetting = new Signature_Sales_Console_Settings__c();
        sSetting.Name = 'Territory';
        sSetting.Roll_Up_Report_Page_Name__c = 'DummpyVFPage';
        sSetting.Dashboard_Folder_Name__c = 'DashboardFolderName';
        sSetting.Report_Folder_Name__c = 'ReportFolderName';
        sSetting.User_Mode__c = 'UserMode';
        insert sSetting;
        
        String VFPageName = RollupSummaryReportByUserController.getVFPageName();
        system.assertEquals('DummpyVFPage', VFPageName);
    }    
}