@isTest
public class QuickLinksLightningHomePageTest {
    
    public static testmethod void test(){
        
        Profile profile = [SELECT Id, Name FROM Profile WHERE Name = 'FDC - Lennox - LPP ZM/AZM/RZD' LIMIT 1];
        
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'test5643567@test.com',
                           ProfileId = profile.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        
        // insert Custom Setting record
        Quick_Links_Cmp_Setting__c quickLinksConfig = new Quick_Links_Cmp_Setting__c(Name = profile.Name, profile_name__c = profile.Name,
                                                                                     CDQ__c = true, 
                                                                                     Approvalrequests__c = true);
        insert quickLinksConfig;
        
        System.runAs(usr) {
            
            QuickLinksLightningHomePageController.Response res = QuickLinksLightningHomePageController.fetchUser(); 
            
            system.assertEquals(res.isSuccess, true);
            system.assertNotEquals(res.data, null);
            
        }

        
    }

}