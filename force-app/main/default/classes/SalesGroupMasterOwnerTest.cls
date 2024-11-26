@istest(seeAllData=True)
public class SalesGroupMasterOwnerTest
{
    public static testMethod void testschedule()
    {
            Test.StartTest();
            System.schedule('job Scheduler1', '0 0 1-23 * * ?', new SalesGroupMasterOwner());
            Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Lennox - Res Sales TM - Lightning'];
            User u = new User();
            u.Email = 'email@email.com';
            u.Alias = 'Alias';
            u.TimeZoneSidKey = 'America/New_York';
            u.LocaleSidKey = 'ca';
            u.EmailEncodingKey = 'UTF-8';
            u.ProfileId = p.id;
            u.LanguageLocaleKey = 'en_US';
            u.FirstName = 'firstname';
            u.LastName = 'lastname';
            u.username= 'username@first.com';
            u.SAP_Sales_Group__c = '469';
            u.SAP_Sales_Office__c = 'U436';
            insert u;
         
            Sales_Group_Master__c sgm1 = new Sales_Group_Master__c();
            sgm1.Sales_Group__c='Tes1';
            sgm1.District_Number__c='12375';
            sgm1.OwnerId = u.id;
            insert sgm1;
            
            Sales_Group_Master__c sgm = new Sales_Group_Master__c();
              if(sgm.District_Number__c=='23428')
              {
               sgm.OwnerId = userInfo.getUserId();
              }
                 insert sgm;
    
     }
}