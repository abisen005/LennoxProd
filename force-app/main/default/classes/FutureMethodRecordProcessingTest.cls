@IsTest
public class FutureMethodRecordProcessingTest {
    @IsTest
    public static void testInsertPermSet() {
        //Creating Permission Set and users
        Integer i;
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        PermissionSet permissionSet;
        List<PermissionSet> permissionSets = new List<PermissionSet>();
        User user;
        String orgId = userInfo.getOrganizationId();
        List<User> users = new List<User>();
        for(i=0;i<10;i++) {
            permissionSet = new PermissionSet(Label = 'Test '+i+' Permission Set', Name = 'Test_'+i+'_Permission_Set');                                        
            user = new User(firstname = 'fName'+i,
                            lastName = 'lName'+i,
                            email = 'fnamelname'+i+ '@test' + orgId + '.org',
                            Username = 'fnamelname'+i+ '@test' + orgId + '.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias = 'aName'+i,
                            TimeZoneSidKey = 'America/Chicago',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            ProfileId = profile.Id);            
            permissionSets.add(permissionSet);
            users.add(user);
        }
        insert permissionSets;
        insert users;
        
        Map<Id,Id> userAndPerm = new Map<Id,Id>();
        for(i=0;i<10;i++) {
            userAndPerm.put(users[i].Id,permissionSets[i].Id);
         }
        
        System.debug('permissionSets:'+permissionSets);
        System.debug('users:'+users);
        
        System.assertEquals(0, [SELECT ID from PermissionSetAssignment where PermissionSetId In : permissionSets].size());
        System.assertEquals(10, [SELECT ID from PermissionSetAssignment where AssigneeId In : users].size());  
        
        System.debug('permissionSets in PermissionSetAssignment:'+[SELECT PermissionSetId from PermissionSetAssignment where PermissionSetId In : permissionSets]);
        System.debug('users in PermissionSetAssignment:'+[SELECT AssigneeId from PermissionSetAssignment where AssigneeId In : users]);
        
        List<PermissionSetAssignment> permSetAssigns = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment where AssigneeId In : users];
        for(PermissionSetAssignment permSetAssign:permSetAssigns) {
            System.debug('PermissionSetAssignments:'+permSetAssign+' Name:'+permSetAssign.PermissionSet.Name);
        }
        
        Test.startTest();
        FutureMethodRecordProcessing.insertPermSet(userAndPerm);
        Test.stopTest();
        
        System.assertEquals(10, [SELECT ID from PermissionSetAssignment where PermissionSetId In : permissionSets].size());
        System.assertEquals(20, [SELECT ID from PermissionSetAssignment where AssigneeId In : users].size());        
        System.assertEquals(permissionSets[0].Id,[SELECT PermissionSetId 
                                                  FROM PermissionSetAssignment 
                                                  WHERE AssigneeId = : users[0].Id and PermissionSetId In :permissionSets].PermissionSetId);
        
        permSetAssigns = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment where AssigneeId In : users];
        for(PermissionSetAssignment permSetAssign:permSetAssigns) {
            System.debug('PermissionSetAssignments after test:'+permSetAssign+' Name:'+permSetAssign.PermissionSet.Name);
        }
    }
}