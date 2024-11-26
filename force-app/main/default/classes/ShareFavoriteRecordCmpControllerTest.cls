/*
 * @purpose : This class will test ShareFavoriteRecordCmpControllerTest
 */ 
@isTest
public class ShareFavoriteRecordCmpControllerTest {
    
	/*
 	* @purpose : Setup test data
 	*/ 
    @testSetup 
    public static void setupTestData(){
        //get Profiles map
        Map<String,Profile> profileMap = getProfiles();		
        List<Profile> profileList = profileMap.values();
 		//UserRole sampleUserRole = new UserRole( DeveloperName = 'TestSampleRole', Name = 'Sample');
        //insert sampleUserRole;
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        //List to create new user records
        List<User> userList = new List<User>();	
        User userRecord;
        for(Integer count = 0; count < profileList.size(); count++){
            userRecord = new User();
            userRecord = createTestUser('fName'+count, 
                                        'lName'+count, 
                                        'fnamelname'+count+'@lennoxind.com', 
                                        'fnamelname'+count+'@lennoxind.com', 
                                        'fname'+count, 
                                        profileList[count].Id, 
                                        sampleUserRole.Id);
            userList.add(userRecord);
        }
    /*    userList.add(createTestUser('test', 
                                    'UserTest', 
                                    'errortestuser@gmail.com', 
                                    'errortestuser@gmail.com', 
                                    'tester', 
                                    profileMap.get('Read Only').Id, 
                                    null));*/
        //creating userRoles and user for the role
        //Parent userrole
        //UserRole SalesDMUserRole = new UserRole( DeveloperName = 'ResSalesDMTestRole', Name = 'Lennox - Res Sales DM');
        //insert SalesDMUserRole;
        UserRole SalesDMUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Res District Manager %' LIMIT 1];
        User SalesDMUser= createTestUser('Lennox', 
                                         'User0', 
                                         SalesDMUserRole.DeveloperName+'@lennoxind.com', 
                                         SalesDMUserRole.DeveloperName+'@lennoxind.com', 
                                         'fname',
                                         profileMap.get('Lennox - Res Sales DM - Lightning').Id,
                                         SalesDMUserRole.Id);
        userList.add(SalesDMUser);
        //chiled userrole
        /*UserRole ResInsideSalesUserRole = new UserRole( DeveloperName ='ResInsideSalesTestRole', Name ='Res Inside Sales' , ParentRoleId = SalesDMUserRole.Id);
       	insert ResInsideSalesUserRole;*/
        
		UserRole ResInsideSalesUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE ParentRoleId =:SalesDMUserRole.Id LIMIT 1];        
        System.debug('profileMap--' + JSON.serializePretty(profileMap));
        User ResInsideSalesUser = createTestUser('ResInsideSales', 
                                                 'User1', 
                                                 ResInsideSalesUserRole.DeveloperName+'@lennoxind.com', 
                                                 ResInsideSalesUserRole.DeveloperName+'@lennoxind.com', 
                                                 'fname2',
                                                 profileMap.get('Lennox - Res Sales DM - Lightning').Id,
                                                 ResInsideSalesUserRole.Id);
        userList.add(ResInsideSalesUser);
        
        /*UserRole ResFTCUserRole = new UserRole( DeveloperName ='ResFTCTestRole', Name ='Res FTC' );
       	insert ResFTCUserRole;*/
        
        UserRole ResFTCUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Res FTC%' LIMIT 1];
       /* User ResFTCUser = createTestUser('ResFTC', 
                                         'User2', 
                                         ResFTCUserRole.DeveloperName+'@gmail.com', 
                                         ResFTCUserRole.DeveloperName+'@gmail.com', 
                                         'fname3',
                                         profileMap.get('Lennox - Res Sales ASM - Lightning').Id,
                                         ResFTCUserRole.Id);
        userList.add(ResFTCUser);*/
        
        /*UserRole ResTerritoryUserRole = new UserRole( DeveloperName ='ResTerritoryTestRole', Name ='Res Territory' );
        insert ResTerritoryUserRole;*/
        
        UserRole ResTerritoryUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Res Territory%' LIMIT 1];
        User ResTerritoryUser = createTestUser('ResTerritory', 
                                               'User3', 
                                               ResTerritoryUserRole.DeveloperName+'@lennoxind.com', 
                                               ResTerritoryUserRole.DeveloperName+'@lennoxind.com', 
                                               'fname4',
                                               profileMap.get('Lennox - Res Sales TM - Lightning').Id,
                                               ResTerritoryUserRole.Id);
        userList.add(ResTerritoryUser);
        
       /* UserRole ResLPPSMUserRole = new UserRole( DeveloperName ='ResLPPSMTestRole', Name ='Res LPP SM' );
       	insert ResLPPSMUserRole;*/
        
        UserRole ResLPPSMUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Res LPP SM%' LIMIT 1];
        userList.add(createTestUser('ResLPPSM', 
                                    'User4', 
                                    ResLPPSMUserRole.DeveloperName+'@lennoxind.com', 
                                    ResLPPSMUserRole.DeveloperName+'@lennoxind.com', 
                                    'fname5',
                                    profileMap.get('System Administrator').Id,
                                    ResLPPSMUserRole.Id));
        //insert users List
        insert userList;
        //create groups 
        Group regularGroup = new Group(); 
        regularGroup.Name = 'Test Group1';
        insert regularGroup;
        //add users to Group
        List<GroupMember> MembersList = new List<GroupMember>();
        for(Integer count = 0; count < 3; count++){
            MembersList.add(new GroupMember( UserOrGroupId = userList[count].Id , GroupId = regularGroup.Id ));
        }
        
        Group RoleAndSubordinatesGroup = new Group(); 
        RoleAndSubordinatesGroup.Name = 'Test Group2';
        insert RoleAndSubordinatesGroup;
        //create sub group 
        Group subGroup = new Group(); 
        subGroup.Name = 'Test subGroup';
        insert subGroup;
        MembersList.add(new GroupMember( UserOrGroupId = subGroup.Id , GroupId = RoleAndSubordinatesGroup.Id ));
        
       	Group RoleAndSubordinatesInternalGroup = new Group();
        RoleAndSubordinatesInternalGroup.Name = 'Test Group3';
        insert RoleAndSubordinatesInternalGroup;
        
        Group subInternalGroup = new Group(); 
        subInternalGroup.Name = 'Test subGroup2';
        insert subInternalGroup;
        MembersList.add(new GroupMember( UserOrGroupId = subInternalGroup.Id , GroupId = RoleAndSubordinatesInternalGroup.Id ));
        
        MembersList.add(new GroupMember( UserOrGroupId = SalesDMUser.Id , GroupId = subGroup.Id ));
        MembersList.add(new GroupMember( UserOrGroupId = ResInsideSalesUser.Id , GroupId = subInternalGroup.Id ));
        //MembersList.add(new GroupMember( UserOrGroupId = ResFTCUser.Id , GroupId = subGroup.Id ));
        insert MembersList;
        
    }
    
    /*
 	* @purpose : This method will test UserInformation
 	*/ 
    static testMethod void testGetUserRecords(){
        
//        UserRole userRole = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'TestSampleRole' ];

        UserRole userRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1];
        
        Map<Id,User> userRecords = new Map<Id,User>([SELECT Id, Name, UserRoleId , UserRole.Name,ProfileId
                                                     FROM User 
                                                     WHERE LastName LIKE 'lName%' ]);//OR UserRoleId = : userRole.Id ]);
        //create Favorites object record by using runAs()
        if(userRecords != null){
            createFavoriteRecords(userRecords.values());
        }
        Test.startTest();
        Favorites__c FavoriteRecord = [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c ,OwnerId
                                            FROM Favorites__c 
                                            WHERE Name Like 'Test Like%' LIMIT 1 ];
        if(FavoriteRecord != null){
            Response response = ShareFavoriteRecordCmpController.getUserRecords(FavoriteRecord.Id);
            System.assert(response.isSuccess);
        }
        Test.stopTest();
    }
    
    /*
 	* @purpose : This method will test UserInformationError
 	*/ 
    static testMethod void testGetUserRecordsError(){
        List<User> userRecords = [SELECT Id, Name, UserRoleId , Profile.Name,ProfileId 
                                  FROM User 
                                  WHERE isActive = true LIMIT 1];
        if(userRecords != null){
            createFavoriteRecords(userRecords);
        }
      
        Favorites__c FavoriteRecord = [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c 
                                            FROM Favorites__c 
                                             LIMIT 1 ];
        if(FavoriteRecord != null){
            Response response = ShareFavoriteRecordCmpController.getUserRecords(FavoriteRecord.Id);
            System.assert(response.isSuccess);
        }
        
        Id testFavoriteId = null;
        Response response = ShareFavoriteRecordCmpController.getUserRecords(testFavoriteId);
        System.assertEquals(false, response.isSuccess);
        
   
    }
    
    /*
 	* @purpose : This method will test GetAlreadySharedRecords
 	*/ 
    static testMethod void testGetAlreadySharedRecords(){
        Test.startTest();
        Map<Id,User> userRecords = new Map<Id,User>([SELECT Id, Name, UserRoleId , Profile.Name,ProfileId
                                                     FROM User 
                                                     WHERE (Username = 'errortestuser@lennoxind.com' OR LastName= 'lname5') 
                                                     OR (LastName LIKE  'User%' AND Alias Like 'fname%')]);
        if(userRecords != null){
            createFavoriteRecords(userRecords.values());
        }
        List<Favorites__c> FavoritesList = [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c,Owner.Name
                                            FROM Favorites__c 
                                            WHERE Name Like 'Test Like%' ];
        if(FavoritesList != null){
            for(Favorites__c favorite : FavoritesList ){
                Response response = ShareFavoriteRecordCmpController.getAlreadySharedRecords(favorite.Id);
                System.assert(response.isSuccess);
            }
        }
        
        Test.stopTest();
    }
    
    /*
 	* @purpose : This method will test SaveShareRecord
 	*/
    static testMethod void testSaveShareRecord(){
        Test.startTest();
        List<User> usersList = [ SELECT Id, Name , UserRoleId ,UserRole.Name
                                FROM User 
                                WHERE LastName LIKE 'lName%' ];
        if(usersList != null){
            createFavoriteRecords(usersList);
        }
        List<Favorites__c> FavoritesList = [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c,Owner.Name
                                            FROM Favorites__c 
                                            WHERE Name Like 'Test Like%' ];
       	usersList = [SELECT Id, Name , UserRoleId ,UserRole.Name
                     FROM User 
                     WHERE LastName LIKE 'User%' AND Alias Like 'fname%' ];
        //test method for user record
        Response response = ShareFavoriteRecordCmpController.saveShareRecord(shareRecorde(FavoritesList.get(0).Id,
                                                                                          'Read',
                                                                                          usersList.get(0).Id,
                                                                                          usersList.get(0).Name,
                                                                                          false));
        System.assert(response.isSuccess);
        List<Favorites__share> favoritesShareRecords = [SELECT ParentId, UserOrGroupId, AccessLevel, RowCause 
                                                        FROM Favorites__share 
                                                        WHERE ParentId = : FavoritesList.get(0).Id ]; 
        Set<Id> IdSet = new Set<Id>();
        for( Favorites__share favorite : favoritesShareRecords ){
            IdSet.add(favorite.UserOrGroupId);
        }
        //test method for userRole record
        response = ShareFavoriteRecordCmpController.saveShareRecord(shareRecorde(FavoritesList.get(0).Id,
                                                                                 'Read',
                                                                                 usersList.get(1).UserRoleId,
                                                                                 usersList.get(1).UserRole.Name,
                                                                                 true));
        System.assert(response.isSuccess);
        favoritesShareRecords = [SELECT ParentId, UserOrGroupId, AccessLevel, RowCause 
                                                        FROM Favorites__share 
                                                        WHERE ParentId = : FavoritesList.get(0).Id ]; 
        IdSet = new Set<Id>();
        for( Favorites__share favorite : favoritesShareRecords ){
            IdSet.add(favorite.UserOrGroupId);
        }
        System.assertEquals(true, IdSet.contains(usersList.get(1).Id));
        
        response = ShareFavoriteRecordCmpController.getAlreadySharedRecords(FavoritesList.get(0).Id);
        System.assert(response.isSuccess);
        Test.stopTest();
    }
    
    /*
 	* @purpose : This method will test SaveShareRecordError
 	*/
    static testMethod void testSaveShareRecordError(){
        Test.startTest();
        Response response = ShareFavoriteRecordCmpController.saveShareRecord(JSON.serialize(null));
        System.assert(!response.isSuccess);
    }
    
    /*
 	* @purpose : This method will test DeleteShareRecordFrmServer
 	*/
    static testMethod void testDeleteShareRecordFrmServer(){
        Test.startTest();
        List<User> usersList = [ SELECT Id, Name , UserRoleId ,UserRole.Name
                                FROM User 
                                WHERE LastName LIKE 'lName%' ];
        if(usersList != null){
            createFavoriteRecords(usersList);
        }
        List<Favorites__c> FavoritesList = [SELECT Id, Name, Category__c, Favorites_URL__c, Sequence__c,Owner.Id
                                            FROM Favorites__c 
                                            WHERE Name Like 'Test Like%' ];
       	usersList = [SELECT Id, Name , UserRoleId ,UserRole.Name
                     FROM User 
                     WHERE LastName LIKE 'User%' AND Alias Like 'fname%' ];
        //test for share record with user
        Response response = ShareFavoriteRecordCmpController.saveShareRecord(shareRecorde(FavoritesList.get(0).Id,
                                                                                          'Read',
                                                                                          usersList.get(0).Id,
                                                                                          usersList.get(0).Name ,
                                                                                          false));
       	System.assert(response.isSuccess);
        
        List<ShareFavoriteRecordCmpController.ShareRecordWrapper> shareRecordsList =  new List<ShareFavoriteRecordCmpController.ShareRecordWrapper>();
        ShareFavoriteRecordCmpController.ShareRecordWrapper shareRecord = new ShareFavoriteRecordCmpController.ShareRecordWrapper();
        shareRecord.id = usersList.get(0).Id ;
        shareRecord.accessLevel = 'Read Only' ;
        shareRecord.name = usersList.get(0).Name ;
        shareRecord.parentId = FavoritesList.get(0).Id;
        shareRecord.reason = 'Manual Sharing';
        shareRecordsList.add(shareRecord);
        
        //delete record share is removed
        response = ShareFavoriteRecordCmpController.deleteShareRecordFrmServer(JSON.serialize(shareRecordsList));
        ShareFavoriteRecordCmpController.SharedOrUsersWrapper sharedUsers = new ShareFavoriteRecordCmpController.SharedOrUsersWrapper();
        sharedUsers =(ShareFavoriteRecordCmpController.SharedOrUsersWrapper) response.data;
        Set<Id> UserIdSet = new Set<Id>();
        for(ShareFavoriteRecordCmpController.PicklistWrapper record : sharedUsers.strToPicklistWrappers.get('User') ){
            UserIdSet.add(record.Id);
        }
        System.assertEquals( false , UserIdSet.contains(usersList.get(0).Id));
        
        Group testgroup = [SELECT Name ,Id FROM Group WHERE Name = 'Test subGroup' LIMIT 1 ];
        
        shareRecordsList =  new List<ShareFavoriteRecordCmpController.ShareRecordWrapper>();
        shareRecord = new ShareFavoriteRecordCmpController.ShareRecordWrapper();
        shareRecord.id = testgroup.Id ;
        shareRecord.accessLevel = 'Read Only' ;
        shareRecord.name = testgroup.Name ;
        shareRecord.parentId = FavoritesList[1].Id;
        shareRecord.reason = 'Manual Sharing';
        shareRecord.isRole= false;
        shareRecordsList.add(shareRecord);
        //delete record share with group
        response = ShareFavoriteRecordCmpController.deleteShareRecordFrmServer(JSON.serialize(shareRecordsList));
        sharedUsers = new ShareFavoriteRecordCmpController.SharedOrUsersWrapper();
        sharedUsers =(ShareFavoriteRecordCmpController.SharedOrUsersWrapper) response.data;
        UserIdSet = new Set<Id>();
        for(ShareFavoriteRecordCmpController.PicklistWrapper record : sharedUsers.strToPicklistWrappers.get('UserRole') ){
            UserIdSet.add(record.Id);
        }
        System.assertEquals( false , UserIdSet.contains(FavoritesList.get(1).OwnerId));
        
       	Test.stopTest();
    }
    
    /*
 	* @purpose : This method shareRecorde with User or group.
	* @param   : objectRecordId sfId , String accessLevel , UserOrRoleId value , String label , boolean isRole
	* @return  : String JSON serialize 
 	*/
    private static String shareRecorde( Id sfId , String accessLevel , Id value , String label , boolean isRole ){
        ShareFavoriteRecordCmpController.ClientResponseWrapper ClientRequest = new ShareFavoriteRecordCmpController.ClientResponseWrapper();
        ClientRequest.sfid = sfId ;
        ClientRequest.accessLevel = accessLevel;
        
        List<ShareFavoriteRecordCmpController.cls_records> shareRecords = new List<ShareFavoriteRecordCmpController.cls_records>();
        ShareFavoriteRecordCmpController.cls_records record = new ShareFavoriteRecordCmpController.cls_records() ;
        
        record.value = value ;
        record.label = label ;
        record.isRole = isRole ;
        shareRecords.add(record);
        ClientRequest.records = shareRecords;
        return JSON.serialize(ClientRequest) ;
    }
    
    /*
 	* @purpose : This method create Favorites__c record for List<User>.
	* @param   : List<User>
 	*/
    private static void createFavoriteRecords(List<User> usersList){
        for(User user : usersList){
            System.runAs(user){
                insert new Favorites__c(Name = 'Test Like1'+ user.Name, 
                                        Category__c = 'Key Links', 
                                        Show_On_Home_Page__c = true,
                                        Favorites_URL__c = 'https://lennox--dev2.lightning.force.com/one/one.app?source=aloha#/sObject/0018000000OQeNBAA1/view'
                                        );
            }
        }
    }
    
    /*
 	* @purpose : This method return new user.
	* @param   : String firstName, String lastName, String email, String userName, String alias, Id ProfileId, Id userRoleId
	* @return  : User
 	*/
    private static User createTestUser(String firstName, String lastName, String email, String userName, String alias, Id ProfileId, Id userRoleId){
        
        User userRec = new User(firstname = firstName,
                                lastName = lastName,
                                email = email,
                                Username = userName,
                                Alias = alias,
                                EmailEncodingKey = 'ISO-8859-1',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = ProfileId,
                                UserRoleId  = userRoleId);
        return userRec;
    }
    /*
 	* @purpose : This method return map of Profiles based on set of Profile Name.
	* @return  : Map<String,Profile> :String of the Profile name and Profile
 	*/ 
    private static Map<String,Profile> getProfiles(){
        Set<String> profileNames = profileSet();
        Map<String,Profile> ProfileMap = new Map<String,Profile>();
        for(Profile profile : [SELECT Id, Name
                              FROM Profile
                              WHERE Name IN : profileNames]){
        	ProfileMap.put(profile.Name, profile);
        }
        return ProfileMap;
    }
    
    /*
 	* @purpose : This method return set of Profile Name.
	* @return  : Set<String>
 	*/ 
    private static Set<String> profileSet(){
        return new Set<String>{
                'Lennox - Res Sales DM - Lightning',
                'Lennox - Res Sales DM Pilot',
                'Lennox - Res Sales ASM - Lightning',
            	'Lennox - Res Sales TM - Lightning',
                'Lennox - Res Sales TM Pilot',
                'Lennox - Res Sales AM - Lightning',
                'Lennox - Res Sales AM Pilot',
                'Lennox - Res Sales RBM - Lightning' ,
                'Lennox - Res Sales - Corporate User',
                'Lennox Business Administrator Super',
                'Lennox Business Administrator',
                'Lennox - Res Sales - EXE - Lightning',
                'Lennox - Res Sales - BDM - Lightning',
                'Read Only',
                'Marketing User',
                'System Administrator'
                };
  	}
}