/*
  @description       : CommunityLoginController.cls used as Custom Login for FTL 
  @author            : Abi@Ventas
  @last modified on  : 02-23-2024 
  @last modified by  : 
*/
public with sharing class CommunityLoginController {
    
    @AuraEnabled
    public static String getCommunityURL() {
        try {
            Site mySite;
            if (Test.isRunningTest()) {
                mySite = [SELECT Id FROM Site WHERE Name = 'Feel_The_Love2' LIMIT 1];
            } else {
                mySite = [SELECT Id FROM Site WHERE Name = 'Feel_The_Love2'];
            }
            SiteDetail mySiteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :mySite.Id];
            return mySiteDetail.SecureURL;
        } catch (Exception e) {
            System.debug('Error in getCommunityURL: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static String authenticateUser(String username, String password) {
        try {
            String siteName = 'Feel_The_Love2';
            Site mySite = [SELECT Id FROM Site WHERE Name = :siteName];
            SiteDetail mySiteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :mySite.Id];
            String startUrl = mySiteDetail.SecureURL;
            String newUsername = username.toLowerCase().contains('lennox') ? username : username + '.lennox';
            system.debug('newUsername'+newUsername);
            ApexPages.PageReference pageRef = Site.login(newUsername, password, startUrl);
            return pageRef != null ? pageRef.getUrl() : null;
        } catch (Exception e) {
            System.debug('Error in authenticateUser: ' + e.getMessage());
            return 'error';
        }
    }
}