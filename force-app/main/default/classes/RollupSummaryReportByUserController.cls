public with sharing class RollupSummaryReportByUserController {

    @AuraEnabled
    public static string getVFPageName() {

        String reportType, VFPageName;
        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;
        List<Quick_Links_Cmp_Setting__c> userSetting = [
            SELECT  Id, 
                    Profile_Name__c, 
                    RollupSummary__c, 
                    RegionRollupSummary__c, 
                    DistrictRollupSummary__c, 
                    TerritoryRollupSummary__c
            FROM    Quick_Links_Cmp_Setting__c
            WHERE   Profile_Name__c = :profileName];
        
            if (!userSetting.isEmpty()){
            if(userSetting[0].RollupSummary__c) {
                reportType = 'Executive';
            } else if (userSetting[0].RegionRollupSummary__c){
                reportType = 'Region';
            } else if (userSetting[0].DistrictRollupSummary__c) {
                reportType = 'District';
            } else if (userSetting[0].TerritoryRollupSummary__c) {
                reportType = 'Territory';
            } else {
                reportType = 'No Match';
            }
        }
        List<Signature_Sales_Console_Settings__c> reportSetting = [
            SELECT  Roll_Up_Report_Page_Name__c 
            FROM    Signature_Sales_Console_Settings__c
            WHERE   Name = :reportType];
        if(!reportSetting.isEmpty()){
            VFPageName = reportSetting[0].Roll_Up_Report_Page_Name__c;
        } else {
           throw new AuraHandledException('VF Page Not Found.');
        }
        return VFPageName;
    }
}