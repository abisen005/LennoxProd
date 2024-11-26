@isTest
public class QuickLinksLightningHomeControllerTest {
    
    public static testmethod void QuickLinksLightningHomeControllerTest(){
        Profile p=[select id from profile where name = 'Standard User'];
        
        User u = new user(alias='Tom', email = 'dlkafjl@dkljafd.com', firstname = 'Tom', lastname = 'Smykawski', profileid = p.Id, username = 'dlkafjl@dkljafd.com.lennox', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        Insert u;
        
        Quick_Links_Cmp_Setting__c s = new Quick_Links_Cmp_Setting__c(Name='Settings Name', Profile_Name__c='Standard User', CDQ__c=True);
        Insert s;
        QuickLinksLightningHomePageController.Response res;
        System.runAs(u){
            res = new QuickLinksLightningHomePageController.Response(false, null, '');
            res = QuickLinksLightningHomePageController.fetchUser();
        }
        system.assertEquals(true, res.isSuccess);
        system.assertNotEquals(null, res.data);
    }
}