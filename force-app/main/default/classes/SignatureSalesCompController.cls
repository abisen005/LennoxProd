/*
 * @purpose : This class will return current user profiles for logged in user
 * @CreatedDate : 12 Apr 2018
 */ 
public with sharing class SignatureSalesCompController {
	
    
   /*
    * @purpose : This method will return current logged in user
    * @return  : User
    */ 
    @AuraEnabled
    public static User getCurrentUserInfo(){
        User user;
        try{
            //get current user to by getting userinfo id
            user = [SELECT Id, Name, Profile.Name, UserRoleId
                    FROM User
                    WHERE Id =: UserInfo.getUserId()];
        }catch(Exception e){
            //throw an exception where user can see what's wrong.
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
        return User;
    }
    
   /*
    * @purpose : This method will return list of user for specific profiles and they are following
    * 			 1) Lennox - Res Sales DM
    *            2) Lennox - Res Sales DM Pilot
    * 			 3) Lennox - Res Sales ASM
    * @param   : User's Role Id
    * @return  : List<User>
    */ 
    @AuraEnabled
    public static List<User> getValidatedUserInfo(Id userRoleId){
        if(String.isNotBlank(userRoleId)){
            try{
                //get user by filtering Userrole Id
                User usrRecord =  [SELECT UserRoleId 
                                   FROM User 
                                   WHERE (UserRole.ParentRoleId = :userRoleId And isActive = true)
                                   LIMIT 1];
                //get users 
                List<User> userList = new List<User>([SELECT Id, FirstName, LastName, UserRoleId 
                                                      FROM User Where UserRole.ParentRoleId =: usrRecord.UserRoleId
                                                      AND isActive = true
                                                      LIMIT :LIMITS.getLimitQueryRows()
                									]);
                //check list is empty or not
                if(!userList.isEmpty()){
                    UserRole userRole = [SELECT Id, Name 
                                         FROM UserRole WHERE Id =: userList[0].UserRoleId LIMIT 1];
                    //check user role name index of is --1
                    if(userRole.Name.indexOf('Res Territory') == -1){
                        return userList;
                    }else{
                        List<User> newUserList = new List<User>([SELECT Id, FirstName, LastName  
                                                                 FROM User 
                                                                 Where UserRole.ParentRoleId =: userRole.Id 
                                                                 AND isActive = true]);
                        return newUserList;
                    }
                }else{
                    throw new AuraHandledException('We counld not found user list. Please contact your system admin.');
                }
            }catch(Exception e){
                throw new AuraHandledException('Error occurred : '+e.getMessage()+' Please contact your system admin.');
            }
        }else{
            throw new AuraHandledException('User Role id not found for the the current user.  Please contact your system admin');
        }
    }
}