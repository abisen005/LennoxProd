public with sharing class SignatureSalesAppController {
    
    @AuraEnabled
    public static String getUserMode() {
        
        Set<String> territoryProfiles = new Set<String>{'Lennox - Res Sales TM', 'Lennox - Res Sales TM - Lightning'};
        Set<String> districtProfiles = new Set<String>{'Lennox - Res Sales DM', 'Lennox - Res Sales DM - Lightning'};
        Set<String> regionProfiles = new Set<String>{'Lennox - Res Sales RBM - Lighting', 'Lennox - Res Sales RBM'};
        Set<String> executiveProfiles = new Set<String>{'Lennox - Res Sales - BDM - Lighting', 'Lennox - Res Sales - BDM', 'Lennox IT Administrator'};
        Id userId = UserInfo.getUserId();
        Id profileId = [SELECT profileId FROM USER WHERE Id = :userId LIMIT 1].profileId;
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;
        
        if(territoryProfiles.contains(profileName)) return 'Territory';
        if(districtProfiles.contains(profileName)) return 'District';
        if(regionProfiles.contains(profileName)) return 'Region';
        if(executiveProfiles.contains(profileName)) return 'Executive';
        
        return 'No Match';
        
    }
    
    @AuraEnabled
    public static Dashboard[] getDashboards(String folderName) {
        return [SELECT Id, Title, Description FROM Dashboard WHERE FolderName = :folderName];
    }
    
    @AuraEnabled
    public static Report[] getReports(String folderName) {
        System.debug(folderName);
        return [SELECT Id, Name, Description FROM Report WHERE FolderName = :folderName];
    }
    
    @AuraEnabled
    public static Signature_Sales_Console_Settings__c getConsoleSetting(String userMode) {

        Map<String, Signature_Sales_Console_Settings__c> consoleSettings = Signature_Sales_Console_Settings__c.getAll();
        System.debug(userMode);
        if(consoleSettings.get(userMode) == null) {
            return consoleSettings.get('No Match');
        } else {
            return consoleSettings.get(userMode);
        }
        
    }
    
    @AuraEnabled
    public static List<Account> searchDealers(String query) {
        final Integer LIMIT_TO = 30;
        List<List<SObject>> searchList = [FIND :query IN ALL FIELDS RETURNING Account(Id, Name, SAP_Customer_Number__c) LIMIT :LIMIT_TO];
        return ((List<Account>)searchList[0]);
    }
    

}