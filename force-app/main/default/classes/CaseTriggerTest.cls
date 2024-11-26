/** ===========================================================================
@Purpose	: This apex class used to test the functionality of CaseTrigger.
@Author		: Dreamwares
@Date		: 6 Mar 2019
===========================================================================
ChangeLog : 
=========================================================================== 
 */
@IsTest
public class CaseTriggerTest {
    @testSetUp
    private static void testData(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Lennox - CS Agent' LIMIT 1];
        
        user u = createUser(p.Id);
        Insert u;
        
        Id caseCSRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Customer Support').getRecordTypeId();
        case c = createCase(u.Id, caseCSRecTypeId);
        Insert c;
    }
    
    @IsTest
    private static void unitTest(){
        case c = [Select Id, subject 
                  FROM Case 
                  LIMIT 1];
        User u = [Select Id, Profile.Name, Technical_Support__c FROM User Limit 1];
            
        test.startTest();
        System.runAs(u){
            c.subject = 'test';
            update c;
        }
        test.stopTest();
    }
    
    private static case createCase(String OwnerId, string recordTypeId){
        case c = new case();
        c.Description = 'TestDescription';
        c.Status = 'New';
        c.Subject = 'TestSubject';
        c.OwnerId = OwnerId;
        c.RecordTypeId = recordTypeId;
        return c;
    }
    
    private static user createUser(String profileId){
        String orgId = UserInfo.getOrganizationId();
        String dateString = 
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User u = new User();
        u.Alias = 'test';
        u.Email= 'test@test.com'; 
        u.EmailEncodingKey = 'UTF-8'; 
        u.LastName = 'Intgrtcrdusr'; 
        u.LanguageLocaleKey = 'en_US'; 
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId; 
        u.TimeZoneSidKey = 'America/New_York'; 
        u.UserName =  uniqueName + '@test' + orgId + '.org';
        
        return u;
    }
}