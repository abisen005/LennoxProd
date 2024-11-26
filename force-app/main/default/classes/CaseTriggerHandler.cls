/** ===========================================================================
@Purpose	: This apex class used to change the owner of case.
@Author		: Dreamwares
@Date		: 6 Mar 2019
===========================================================================
ChangeLog : 
=========================================================================== 
 */

public class CaseTriggerHandler {
    
    /**
    @Purpose		: this method used to change owner of case record where owner name like 'Intgrtcrdusr'
    @Param	        : Map<Id, Case> caseIdToRecordMap
    @return		    :-
    **/ 
    public static void changeCaseOwner(Map<Id, Case> caseIdToRecordMap){
        map<Id, String> userIdTouserNameMap;
        set<Id> userIds = getCaseOwnerIdS(caseIdToRecordMap.values());
        
        if(userIds != null && !userIds.isEmpty()){
            
            userIdTouserNameMap = getuserIdTouserNameMap(userIds);
        }
        
        User u = getCurrentUserInfo();
        Id caseCSProgramRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Programs & Services').getRecordTypeId();
        Id caseCSRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Customer Support').getRecordTypeId();
        
        if(userIdTouserNameMap != null && !userIdTouserNameMap.isEmpty()){
            
            for(case c : caseIdToRecordMap.values()){
                
                if(userIdTouserNameMap.containskey(c.ownerId) && userIdTouserNameMap.get(c.ownerId).contains('Intgrtcrdusr')
                   && u.Profile.Name.contains('CS') && c.RecordTypeId.equals(caseCSRecTypeId)){
                       
                       c.ownerId = u.Id;
                       
                       if(u != null && String.isNotEmpty(u.Technical_Support__c) && u.Technical_Support__c == 'CS Agent P&S'){
                           
                           c.RecordTypeId = caseCSProgramRecTypeId;
                       }
                       else{
                           c.RecordTypeId = caseCSRecTypeId;
                       }
                   }
                
            }
        }
        
        
    }
    
    /**
    @Purpose		: this method used to get case owner Id set
    @Param	        : list<Case> caseRecords
    @return		    : Set<Id>
    **/ 
    private Static Set<Id> getCaseOwnerIdS(list<Case> caseRecords){
        Set<Id> userIds = new Set<Id>();
        
        for(Case c : caseRecords){
            userIds.add(c.OwnerId);
        }
        return userIds;
    }
    
    /**
    @Purpose		: this method used to get map of userId to user name.
    @Param	        : set<Id> userIds
    @return		    : map<Id, String>
    **/ 
    private Static map<Id, String> getuserIdTouserNameMap(set<Id> userIds){
        map<Id, String> userIdTouserNameMap = new map<Id, String>();
        
        List<user> userList = [SELECT Id, Name
                               FROM user 
                               WHERE Id IN : userIds];
        
        for(user u : userList){
            userIdTouserNameMap.put(u.Id, u.Name);
        }
        return userIdTouserNameMap;
   }
    
    /**
    @Purpose		: this method used to get Current log in user info.
    @Param	        : -
    @return		    : User
    **/ 
    private static User getCurrentUserInfo(){
        User u = [SELECT Id, Profile.Name, Technical_Support__c 
                  FROM User 
                  WHERE Id =: userinfo.getUserId()];
        
        return u;
    } 
    
}