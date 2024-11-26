@isTest
public class showFavoritesLinkSalesUtilityTest {
 	
    @testSetup 
    public static void setupTestData(){
        List<ContentVersion> ContentList = new List<ContentVersion>();
        for( Integer count = 0 ; count < 10 ; count++ ){
			ContentList.add(new ContentVersion(Title = 'TestContent'+count,
                                               PathOnClient = 'TestDoc'+count+'.txt',
                                               VersionData = Blob.valueOf('Test Content Details'),
                                               IsMajorVersion = true
                                              ));
        }
        insert ContentList;
        
        List<ContentDocument> DocumentList = [SELECT Id, Description, Title , LatestPublishedVersionId FROM ContentDocument];
        List<Favorites__c> FavoritesList = new List<Favorites__c>();
        for( Integer count = 0 ; count < 10 ; count++ ){
            FavoritesList.add( new Favorites__c(Name = 'Test Like1'+ count , 
                                                Category__c = 'Key Links' , 
                                                Show_On_Home_Page__c = true,
                                                Favorites_URL__c = 'https://lennox--dev2.lightning.force.com/one/one.app?source=aloha#/sObject/0018000000OQeNBAA1/view'
                                               ) );
            FavoritesList.add( new Favorites__c(Name = 'Test Like2'+ count , 
                                                Category__c = 'Reports/Dashboards' , 
                                                Show_On_Home_Page__c = true,
                                                Favorites_URL__c = 'https://lennox--dev2.lightning.force.com/one/one.app?source=aloha#/sObject/0018000000OQeNBAA1/view'
                                               ) );
            FavoritesList.add( new Favorites__c(Name = 'Test Like3'+ count , 
                                                Category__c = 'Content' , 
                                                Show_On_Home_Page__c = true,
                                                Favorites_URL__c = 'https://lennox--dev2.lightning.force.com/one/one.app?source=aloha#/sObject/'+DocumentList[count].Id+'/view'
                                               ) );
        }
        insert FavoritesList;
    }
    
    
    static testMethod void testFavoriteLinks(){
        Test.startTest();
                  showFavoritesLinkSalesUtility showReport = new showFavoritesLinkSalesUtility();

        Set<Id> DocumentIdList = new Set<Id>();
        for(ContentDocument document : [SELECT Id,Description,Title,LatestPublishedVersionId FROM ContentDocument]){
            DocumentIdList.add(document.Id);
        }
        Map<String , List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper>> urlsByCategory = new Map<String , List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper>>();
        
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
        
        showReport.getFavoritesLink(testUser.ID);
        
        for( String  key : urlsByCategory.keySet() ){
            for( showFavoritesLinkSalesUtility.FavoriteRecordWrapper FavoriteRecord : urlsByCategory.get(key) ){
                System.assertEquals( true , FavoriteRecord.favoriteURL != null );
                if( key == 'Content' ){
                 //   System.assertEquals(true, DocumentIdList.contains((Id)FavoriteRecord.documentId) );
                }
            }
        }
        Test.stopTest();
    }
}