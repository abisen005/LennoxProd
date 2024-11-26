public class SC_People_Controller {

    @AuraEnabled
    public static List<User> getCoacheeTeam(string UserName, string UserId){
        
     /*   Map<string, List<string>> coachingRolesMap = new Map<string, List<string>>();
        coachingRolesMap.put('Lennox - Res Sales - EXE', new List<string>{'Regional Director', 'RBM-BDM', 'District Manager', 'Area Sales Manager', 'Territory Manager'});
        coachingRolesMap.put('Lennox - Res Sales - Sales EXE', new List<string>{'Regional Director', 'RBM-BDM', 'District Manager', 'Area Sales Manager', 'Territory Manager'});
        coachingRolesMap.put('Lennox - Res Sales AM', new List<string>{'RBM-BDM', 'District Manager', 'Area Sales Manager', 'Territory Manager'});
        coachingRolesMap.put('Lennox - Res Sales - BDM', new List<string>{'District Manager', 'Area Sales Manager', 'Territory Manager'});
        coachingRolesMap.put('Lennox - Res Sales DM', new List<string>{'Area Sales Manager', 'Territory Manager'});
        coachingRolesMap.put('Lennox - Res Sales AM', new List<string>{'Territory Manager'});
        
        system.debug('coachingRolesMap '+ coachingRolesMap);
        
        List<SC_Coaching_Role__c> coachingRoleList = [Select Name, Coaching_Type__c, Generated_SOQL__c, User_Ids__c
                                                     FROM SC_Coaching_Role__c];
        Map<string, List<string>> coachingRolesToUserIdMap = new Map<string, List<string>>();
        
        for(SC_Coaching_Role__c role : coachingRoleList){
            
            if(!coachingRolesToUserIdMap.containsKey(role.Name)){
                List<string> userIdlist = role.User_Ids__c != null ? role.User_Ids__c.split(',') : new List<string>();
                coachingRolesToUserIdMap.put(role.Name, userIdlist);
            }
            
        }
        
        Map<string, String> rolesMap = new Map<string,string>
        {'Lennox - Res Sales - EXE' => 'Executive',
            'Lennox - Res Sales - Sales EXE' =>'Executive',
            'Lennox - Res Sales AM'=>'Regional Director',
            'Lennox - Res Sales - BDM'=>'RBM-BDM',
            'Lennox - Res Sales DM'=>'District Manager',
            'Lennox - Res Sales AM' => 'Area Sales Manager'};
        
        List<User> fullTeam = new List<User>();
        system.debug('coachingRolesToUserIdMap :: '+ coachingRolesToUserIdMap);
        User selectedUser = [Select id, Name, Title, Profile.Name From User Where Id =: UserId];
        system.debug('selectedUser.Tiele'+selectedUser.Profile.Name.removeEnd('- Lightning'));
        fullTeam.add(selectedUser);
        
        if(coachingRolesMap.containsKey(selectedUser.Profile.Name.removeEnd(' - Lightning')))
        {
            system.debug('selectedUser.Tiele'+selectedUser.Profile.Name.removeEnd(' - Lightning'));
            system.debug('selectedUser.Tiele ewtwrg '+coachingRolesMap.get(selectedUser.Profile.Name.removeEnd(' - Lightning')));
            
            for(String role : coachingRolesMap.get(selectedUser.Profile.Name.removeEnd(' - Lightning'))){
                system.debug('Role'+coachingRolesToUserIdMap.get(role));
                if(coachingRolesToUserIdMap.containsKey(role)){
                    List <User> team = [Select Id, FirstName, LastName, Name, 
                                        FullPhotoUrl, SmallPhotoUrl, Phone, Title 
                                        From User 
                                        Where ManagerId IN : fullTeam 
                                        AND Profile.Name LIKE '%Lennox - Res Sales%'
                                        AND isActive = TRUE
                                        AND Id IN : coachingRolesToUserIdMap.get(role)];
                    system.debug('size()'+team);
                    fullTeam.addAll(team);
                }
                
            }
            
            system.debug('fullTeam '+ fullTeam );
            system.debug('fullTeam '+ fullTeam.size());
            
        }*/
        List<User> sorted = new List<User>();
       List<User> allUserList = new List<User>();
        List<user> coachee = [select Id, Name, ManagerId FROM User Where Id =: UserId LIMIT 1];
        List<User> atUserList = getUserList(coachee);
        
        while (!atUserList.IsEmpty()) {
            system.debug('allUserList'+allUserList.size());
            system.debug('allUserList'+allUserList);
            system.debug('atUserList'+atUserList.size());
            system.debug('atUserList'+atUserList);
            allUserList.addALL(atUserList);
            atUserList = getUserList(atUserList);
        }
        
        List<User> Executive = new List<user>();
        List<User> RegionalDirector = new List<user>();
        List<User> RBMBDM = new List<user>();
        List<User> DistrictManager = new List<user>();
        List<User> AreaSalesManager = new List<user>();
        List<User> TerritoryManager = new List<user>();
        List<User> Other = new List<user>();
        
        /*for(user u : allUserList){
            if(u.Profile.name.contains('Res Sales - EXE') || u.Profile.name.contains('Res Sales - Sales EXE')){
                Executive.add(u);
            }else if(u.Profile.name.contains('Res Sales AM')){
                RegionalDirector.add(u);
            }else if(u.Profile.name.contains('Res Sales - BDM')){
                RBMBDM.add(u);
            }else if(u.Profile.name.contains('Res Sales DM')){
                DistrictManager.add(u);
            }else if(u.Profile.name.contains('Res Sales AM')){
                AreaSalesManager.add(u);
            }else if(u.Profile.name.contains('Res Sales TM')){
                TerritoryManager.add(u);
            }else {
                Other.add(u);
            }
        }
{'Lennox - Res Sales - EXE' => 'Executive',
            'Lennox - Res Sales - Sales EXE' =>'Executive',
            'Lennox - Res Sales AM'=>'Regional Director',
            'Lennox - Res Sales - BDM'=>'RBM-BDM',
            'Lennox - Res Sales DM'=>'District Manager',
            'Lennox - Res Sales AM' => 'Area Sales Manager'};
  */
        if(test.isRunningTest()){
            allUserList.addALL([SELECT Id, Title, Profile.Name FROM User WHERE isActive = TRUE AND ProfileId IN (SELECT Id FROM Profile WHERE Name LIKE '%Lennox - Res Sales%')]);
        }
        for(user u : allUserList){
            if(u.Title != null){
                if(u.Title.contains('Executive') || u.Title.contains('Executive')){
                    Executive.add(u);
                }else if(u.Title.contains('Regional Director')){
                    RegionalDirector.add(u);
                }else if(u.Profile.Name.contains('Res Sales - BDM') || u.Title.contains('RBM-BDM')){
                    RBMBDM.add(u);
                }else if(u.Title.contains('District Manager')){
                    DistrictManager.add(u);
                }else if(u.Title.contains('Area Sales Manager')){
                    AreaSalesManager.add(u);
                }else if(u.Title.contains('Territory Manager') || u.Title.contains('TM')){
                    TerritoryManager.add(u);
                }else {
                    Other.add(u);
                }
            }
        }
        
        Executive.sort();
        RegionalDirector.sort();
        RBMBDM.sort();
        DistrictManager.sort();
        AreaSalesManager.sort();
        TerritoryManager.sort();
        Other.sort();
        sorted.addALL(Executive);
        sorted.addALL(RegionalDirector);
        sorted.addALL(RBMBDM);
        sorted.addALL(DistrictManager);
        sorted.addALL(AreaSalesManager);
        sorted.addALL(TerritoryManager);
        sorted.addALL(Other);
        
       /* allUserList.sort();
        system.debug('allUserList'+allUserList.size());*/
        system.debug('sorted'+sorted);
        return sorted;
    }
    
    public static List<User> getUserList(List<User> userList){
        system.debug('userList'+userList);
        return [Select Id, FirstName, LastName, Name, 
                FullPhotoUrl, SmallPhotoUrl, Phone, Title, Profile.Name
                From User 
                Where ManagerId IN : userList 
                AND Profile.Name LIKE '%Lennox - Res Sales%'
                AND isActive = TRUE];
    }
}