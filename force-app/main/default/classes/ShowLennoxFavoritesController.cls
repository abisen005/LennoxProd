/*
 * @purpose     : 1) This class is a controller of the ShowLennoxFavorites Lightning component.
 *                 
 * @createdDate : 20 Apr 2018   
 */ 
public with sharing class ShowLennoxFavoritesController {
    /*
     * @purpose : 1) Wrapper
     */ 
    public class FavoriteRecordWrapper{
        @AuraEnabled Public String name; 
        @AuraEnabled Public String favoriteURL; 
        @AuraEnabled Public String documentId;
        @AuraEnabled Public String docDescription;
        @AuraEnabled Public String docTitle;
        @AuraEnabled Public Double sequence;
        @AuraEnabled Public Boolean externalLink;
    }
    
   /*
    * @purpose     : 1) This method will return map of category to list of link
    * @return      : 1) Map<String, List<FavoriteRecordWrapper>> 
    *                   String                      : Category__c name
    *                   List<FavoriteRecordWrapper> : list of record
    */
    @AuraEnabled
    public static Map<String, List<FavoriteRecordWrapper>> getFavoritesLink(){
        
        Map<String, List<FavoriteRecordWrapper>> urlsByCategory = new Map<String, List<FavoriteRecordWrapper>>();
        FavoriteRecordWrapper favoriteWrapperObj;
        try{

            Set<Id> userAndGroupIdSet = getUserOrGroupIdsForCurrentUserAndSpecificRole();

            Set<Id> favoritesIdSet = new Set<Id>();
            for (Favorites__Share favoritesShare : [
                SELECT Id, ParentId
                FROM Favorites__Share 
                WHERE UserOrGroupId IN :userAndGroupIdSet
            ]) {
                favoritesIdSet.add(favoritesShare.ParentId);
            }

            //fetch Favorites__c object record by adding filter where Category__c != NULL AND Favorites_URL__c != NULL
            for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c, External_Link__c
                FROM Favorites__c
                WHERE (Category__c != NULL 
                    AND Favorites_URL__c != NULL 
                    AND Show_On_Home_Page__c = true 
                    AND Id IN :favoritesIdSet)
                ORDER BY Category__c ASC]){ 
                //get FavoriteRecordWrapper object
                //check whether key is contains or not
                if(!urlsByCategory.containsKey(favoriteRecord.Category__c)){ 
                    urlsByCategory.put(favoriteRecord.Category__c, new List<FavoriteRecordWrapper>());
                }
                                                   
                String favoriteUrl = favoriteRecord.Favorites_URL__c;
                
                if(String.isNotBlank(favoriteUrl) && favoriteRecord.Category__c.equals('Content')){
                    String contentDocId = getDocumentId(favoriteUrl, favoriteRecord.Name);
                    if(String.isNotBlank(contentDocId)){
                        favoriteWrapperObj = getFavoriteRecordWrapper(contentDocId, favoriteRecord);
                        urlsByCategory.get(favoriteRecord.Category__c).add(favoriteWrapperObj);
                    }
                }else{
                    favoriteWrapperObj = getFavoriteRecordWrapper(null, favoriteRecord);
                    urlsByCategory.get(favoriteRecord.Category__c).add(favoriteWrapperObj);
                }
                                                   
                
                //get key and add favoriteWrapperObj
                
            }
        }catch(Exception e){
            //throw auraHandled Exception
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
        //check whether map contains key  
        If(urlsByCategory.containskey('Content')){
            getContentDocDesc(urlsByCategory.get('Content'));
        }
        return urlsByCategory;
    }
    
   /*
    * @purpose     : 1) This method will get content's description related content
    * @param       : 1) List<FavoriteRecordWrapper> : This contains 'content's' wrapper list
    */
    private static void getContentDocDesc(List<FavoriteRecordWrapper> favoriteRecordWrapperList){
        if(!favoriteRecordWrapperList.isEmpty()){
            Set<String> contentDocumentIds = new Set<String>();
            //get document id in list
            for(FavoriteRecordWrapper favoriteWrapperObj : favoriteRecordWrapperList){
                if(String.isNotBlank(favoriteWrapperObj.documentId)){
                    contentDocumentIds.add(favoriteWrapperObj.documentId);
                }
            }
            //get map of content document
            Map<Id, ContentDocument> idtoContentDocMap = new Map<Id, ContentDocument>([SELECT Id, Description, Title 
                                                                                       FROM ContentDocument 
                                                                                       WHERE Id IN :contentDocumentIds
                                                                                       ]);
            //iterate over to get the id of content 
            for(FavoriteRecordWrapper favoriteWapper : favoriteRecordWrapperList){
                
                
                
                if(	idtoContentDocMap.containskey(favoriteWapper.documentId)){
                    //assign doc description
                    String docDesc = idtoContentDocMap.get(favoriteWapper.documentId).Description;
                    //assign doc title
                    String docTitle = idtoContentDocMap.get(favoriteWapper.documentId).Title;
                    favoriteWapper.docDescription = String.isNotBlank(docDesc) ? docDesc : null;
                    favoriteWapper.docTitle = String.isNotBlank(docTitle) ? docTitle : null;
                }
                
            }
        }
    }
    
    /*
     * @purpose : 1) This method extract the content id from favoriteURL field of wrapper
     * @param   : 1) String favoriteURL : favorite url string
     *            2) FavoriteRecordWrapper favoriteWrapperObj : favorite record wrapper 
     */ 
    private static String getDocumentId(String favoriteURL, String favoriteRecordName){
        Id contentDocId = null;
        if(String.isNotBlank(favoriteURL)){
            List<String> listString = favoriteURL.split('/');
            for(String urlString : listString){
                //check the length of id 
                if(urlString.length() == 18 || urlString.length() == 15){
                    if (Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( urlString ).matches() ){
                        //urlString to documentId
                        try{
                            contentDocId = Id.valueOf(urlString); //NOTE: It appears the last one to match (15|18 chars or digits) is what is accepted as the ID
                        }catch(Exception exc){
                        	System.debug(exc.getMessage());
                        }                  
                        
                    }
                }
            }
        }
        return contentDocId;
    } 
    
    /*
     * @purpose : 1) This method will create the wrapper object
     * @param   : 1) Favorites__c favoriteRecord : favorite Record Obj 
     */ 
    private static FavoriteRecordWrapper getFavoriteRecordWrapper(String contentDocId ,Favorites__c favoriteRecord){
        FavoriteRecordWrapper favoriteWrapperObj = new FavoriteRecordWrapper();
        if(String.isNotBlank(contentDocId)){
            favoriteWrapperObj.documentId = contentDocId;
        }
        favoriteWrapperObj.name = favoriteRecord.Name;
        favoriteWrapperObj.favoriteURL = favoriteRecord.Favorites_URL__c;
        favoriteWrapperObj.sequence = favoriteRecord.Sequence__c;
        favoriteWrapperObj.externalLink = favoriteRecord.External_Link__c;
        return favoriteWrapperObj;
    }
   
    private static Set<Id> getUserOrGroupIdsForCurrentUserAndSpecificRole() {
        set<Id> ids = new set<Id>();

        User u = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        ids.add(u.Id);

        for (List<Group> groups : [SELECT Id FROM Group WHERE RelatedId = :u.UserRoleId]) {
            for (Group g : groups) {
                ids.add(g.Id);
            }
        }

        for (List<GroupMember> members : [SELECT Id, GroupId FROM GroupMember WHERE UserOrGroupId = :ids AND (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')]) {
            for (GroupMember gm : members) {
                ids.add(gm.GroupId);
            }
        }

        return ids;



/*
    AND (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')
    
*/

//NOTE: does not handle nested groups at this time...

    }

}