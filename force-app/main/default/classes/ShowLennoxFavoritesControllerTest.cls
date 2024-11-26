/*
 * @purpose : This class will test ShowLennoxFavoritesControllerTest
 */ 
@isTest
public class ShowLennoxFavoritesControllerTest {
    /*
 	* @purpose : Setup test data
 	*/
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
    
    /*
 	* @purpose : This method will test FavoriteLinks
 	*/
    static testMethod void testFavoriteLinks(){
        Test.startTest();
        Set<Id> DocumentIdList = new Set<Id>();
        for(ContentDocument document : [SELECT Id,Description,Title,LatestPublishedVersionId FROM ContentDocument]){
            DocumentIdList.add(document.Id);
        }
        Map<String , List<ShowLennoxFavoritesController.FavoriteRecordWrapper>> urlsByCategory = new Map<String , List<ShowLennoxFavoritesController.FavoriteRecordWrapper>>();
        
        urlsByCategory = ShowLennoxFavoritesController.getFavoritesLink();
        
        for( String  key : urlsByCategory.keySet() ){
            for( ShowLennoxFavoritesController.FavoriteRecordWrapper FavoriteRecord : urlsByCategory.get(key) ){
                System.assertEquals( true , FavoriteRecord.favoriteURL != null );
                if( key == 'Content' ){
                    System.assertEquals(true, DocumentIdList.contains((Id)FavoriteRecord.documentId) );
                }
            }
        }
        Test.stopTest();
    }
}