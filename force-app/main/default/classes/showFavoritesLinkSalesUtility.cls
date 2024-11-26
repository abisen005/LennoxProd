public class showFavoritesLinkSalesUtility {
    /*
* @purpose : 1) Wrapper
*/ 
    public class FavoriteRecordWrapper{
        Public String name{get; set;} 
        Public   String favoriteURL{get; set;}
        Public Boolean externalLink;
    }
    public  List<showFavoritesLinkSalesUtility.FavoriteRecordWrapper> getFavoritesLink(Id currentLoginUser){
        
        List<FavoriteRecordWrapper> urlsByCategory = new List<FavoriteRecordWrapper>();
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
            
            //fetch Favorites__c object record by adding filter where Category__c = 'Reports/Dashboards' AND Favorites_URL__c != NULL
            for(Favorites__c favoriteRecord : [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c, External_Link__c
                                               FROM Favorites__c
                                               WHERE (Category__c != NULL 
                                                      AND Favorites_URL__c != NULL 
                                                      AND Show_On_Home_Page__c = true 
                                                      AND Id IN :favoritesIdSet 
                                                      AND Category__c = 'Reports/Dashboards')
                                               ORDER BY Category__c ASC]){ 
                                                   
                                                   FavoriteRecordWrapper favURL = new FavoriteRecordWrapper();
                                                   favURL.favoriteURL = favoriteRecord.Favorites_URL__c;
                                                   favURL.name =favoriteRecord.Name;
                                                   urlsByCategory.add( favURL);
                                                   
                                                   
                                               }
        }catch(Exception e){
            //throw auraHandled Exception
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
        
        return urlsByCategory;
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
        
    }
    
}