/*
* @purpose : This class will test SignatureSalesCompController
*/ 
@isTest
public class SignatureSalesCompControllerTest {
    /*
 	* @purpose : Setup test data
 	*/ 
    @testSetup 
    public static void setupTestData(){
        Map<String,Profile> profileMap = getProfiles();
        List<Profile> profileList = profileMap.values();
 		UserRole TestUserRole = new UserRole( DeveloperName = 'TestRole', Name = 'TestRole');
        insert TestUserRole;
        
        List<User> userList = new List<User>();
        User userRecord;
        for(Integer count = 0; count < profileList.size(); count++){
            userRecord = new User();
            userRecord = createTestUser('fName'+count, 
                                        'lName'+count, 
                                        'fnamelname'+count+'@gmail.com', 
                                        'fnamelname'+count+'@gmail.com', 
                                        'fname'+count, 
                                        profileList[count].Id, 
                                        TestUserRole.Id);
            userList.add(userRecord);
        }
        
        UserRole SalesDMUserRole = new UserRole( DeveloperName = 'ResSalesDMTestRole', Name = 'Lennox - Res Sales DM');
        insert SalesDMUserRole;
        userList.add(createTestUser('Lennox', 
                                    'User0', 
                                    SalesDMUserRole.DeveloperName+'@gmail.com', 
                                    SalesDMUserRole.DeveloperName+'@gmail.com', 
                                    'fname',
                                    profileMap.get('Lennox - Res Sales DM').Id,
                                    SalesDMUserRole.Id));
        
        UserRole ResInsideSalesUserRole = new UserRole( DeveloperName ='ResInsideSalesTestRole', Name ='Res Inside Sales' , ParentRoleId = SalesDMUserRole.Id);
       	insert ResInsideSalesUserRole;
        userList.add(createTestUser('ResInsideSales', 
                                    'User1', 
                                    ResInsideSalesUserRole.DeveloperName+'@gmail.com', 
                                    ResInsideSalesUserRole.DeveloperName+'@gmail.com', 
                                    'fname2',
                                    profileMap.get('Lennox - Res Sales DM').Id,
                                    ResInsideSalesUserRole.Id));
        
        UserRole ResTerritoryUserRole = new UserRole( DeveloperName ='ResTerritoryTestRole', Name ='Res Territory testRole' , ParentRoleId = ResInsideSalesUserRole.Id);
        insert ResTerritoryUserRole;
        userList.add(createTestUser('ResTerritory', 
                                    'User2', 
                                    ResTerritoryUserRole.DeveloperName+'@gmail.com', 
                                    ResTerritoryUserRole.DeveloperName+'@gmail.com', 
                                    'fname3',
                                    profileMap.get('Lennox - Res Sales TM').Id,
                                    ResTerritoryUserRole.Id));
        
        UserRole ResFTCUserRole = new UserRole( DeveloperName ='ResFTCTestRole', Name ='Res FTC' , ParentRoleId = ResTerritoryUserRole.Id);
       	insert ResFTCUserRole;
        userList.add(createTestUser('ResFTC', 
                                    'User3', 
                                    ResFTCUserRole.DeveloperName+'@gmail.com', 
                                    ResFTCUserRole.DeveloperName+'@gmail.com', 
                                    'fname4',
                                    profileMap.get('Lennox - Res Sales ASM').Id,
                                    ResFTCUserRole.Id));
        
        UserRole ResLPPSMUserRole = new UserRole( DeveloperName ='ResLPPSMTestRole', Name ='Res LPP SM' , ParentRoleId = ResFTCUserRole.Id);
       	insert ResLPPSMUserRole;
        userList.add(createTestUser('ResLPPSM', 
                                    'User4', 
                                    ResLPPSMUserRole.DeveloperName+'@gmail.com', 
                                    ResLPPSMUserRole.DeveloperName+'@gmail.com', 
                                    'fname5',
                                    profileMap.get('Lennox - Res Sales TM').Id,
                                    ResLPPSMUserRole.Id));
        insert userList;
    }
    
    /*
 	* @purpose : This method will test UserInformation
 	*/ 
    static testMethod void testCurrentUserInfo(){
        Test.startTest();
        List<User> userList = [SELECT Id, Name, UserRoleId , ProfileId , Profile.Name
                               FROM User
                               WHERE FirstName Like 'fName%'];
        Set<String> profileNames = profileSet();
        for( User user : userList ){
            System.runAs(user){
                User currentUser;
                currentUser = SignatureSalesCompController.getCurrentUserInfo();
                if(profileNames.contains(user.Profile.Name)){
                    System.assert(true);
                }else{
                    System.assert(false);
                }
            }
        } 
        Test.stopTest(); 
    } 
    
    /*
 	* @purpose : This method test ValidatedUserInfo.
 	*/
    static testMethod void testValidatedUserInfo(){
        Test.startTest();
        Set<String> profilesSet = profileSet();
        Map<Id,User> userRecords = new Map<Id,User>([SELECT Id, Name, UserRoleId , Profile.Name,ProfileId
                                                     FROM User 
                                                     WHERE (LastName LIKE  'User%' AND Profile.Name IN : profilesSet)] );
        System.runAs(userRecords.values().get(0)){
            List<User> UsersList;
            UsersList = SignatureSalesCompController.getValidatedUserInfo(UserInfo.getUserRoleId());
            if( UsersList != null ){
                for( User user : UsersList ){
                    System.assertEquals(true, userRecords.keySet().contains(user.Id) );
                }
            }
        }
        
        System.runAs(userRecords.values().get(2)){
            List<User> UsersList;
            UsersList = SignatureSalesCompController.getValidatedUserInfo(UserInfo.getUserRoleId());
            if( UsersList != null ){
                for( User user : UsersList ){
                    System.assertEquals(true, userRecords.keySet().contains(user.Id) );
                }
            }
        }
        Test.stopTest();
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
 	* @purpose : This method return Profile based on Profile Name.
	* @param   : Profile Name
	* @return  : Profile
 	*/
    private static Profile getProfile(String ProfileName){
        Profile profile = [SELECT Id, Name
                                     FROM Profile
                                     WHERE Name = : ProfileName];
        return profile;
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
                'Lennox - Res Sales DM',
                'Lennox - Res Sales DM Pilot',
                'Lennox - Res Sales ASM',
            	'Lennox - Res Sales TM',
                'Lennox - Res Sales TM Pilot',
                'Lennox - Res Sales AM',
                'Lennox - Res Sales AM Pilot',
                'Lennox - Res Sales RBM',
                'Lennox - Res Sales - Corporate User',
                'Lennox Business Administrator Super',
                'Lennox Business Administrator',
                'Lennox - Res Sales - EXE',
                'Lennox - Res Sales - BDM'
                };
  	}
}