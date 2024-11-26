/*
* @ Purpose      : This class is used to test the functionality of FTL_UnenrollControllerTest.                   
* @ CreatedDate  : 25-Apr-19
*/
@isTest
public class FTL_UnenrollControllerTest {

    /* 
    * @Purpose      : this function used to create test data.
    * @Parameter    : -
    * @Returntype   : -
    */
    @TestSetup
    public static void setup(){
        UserRole sampleUserRole = [SELECT ID,DeveloperName, Name FROM UserRole WHERE Name Like '%Admin' LIMIT 1 ];
        Id pId = [Select Id From Profile Where Name='Feel the Love Community'].id;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE IsActive = true AND userRoleId = :sampleUserRole.Id LIMIT 1];
        
        System.runAs(admin) {
            Account a = new Account(Name='Test Account Name',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='65432',ShippingCountry='US');
            insert a;
            
            Contact c = new Contact(LastName = 'ContactLastName',FirstName = 'FirstName', Email = 'test.user@example.com', AccountId = a.id);
            insert c;
            
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Feel the Love Community'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'first';
            user.LastName = 'last';
            user.Username = 'dreamtest@domain.com';   
            user.CommunityNickname = 'testUser123';
            user.Alias = 't1';
            user.Email = 'no@email.com';
            user.IsActive = true;
            user.ContactId = c.Id;
            
            insert user;
            
        }
        
    }
    
     /* 
    * @Purpose      : This function used to test functionality of unenroll user with reason.
    * @Parameter    : Reason to unenroll user
    * @Returntype   : We are sorry to see you go. If you decide you would like to join the program again, please go to https://www.feelthelove.com/ to sign up.
    */
    @isTest
    public static void unenrollWithReason(){

        User user = [SELECT ContactId, Id, isActive,
                     IsPortalEnabled, Username, LastName FROM User 
                     WHERE Username = 'dreamtest@domain.com'];
        System.runAs(user){
            String message = FTL_UnenrollController.unenroll('Not Interested');
            System.assertEquals('You have been unenrolled from Feel The Love. If you would like to come back next year, please register again or contact your Territory Manager.',
                                    message);
        }
    }
    /* 
    * @Purpose      : This function used to test functionality of unenroll user without reason.
    * @Parameter    : 
    * @Returntype   : Please enter a reason.
    */
    @isTest
    public static void unenrollWithoutReason(){

        User user = [SELECT ContactId, Id, isActive,
                     IsPortalEnabled, Username, LastName FROM User 
                     WHERE Username = 'dreamtest@domain.com'];
        System.runAs(user){
            String message = FTL_UnenrollController.unenroll('');
            System.assertEquals('Please enter a reason.', message);
        }
    }
    
    /* 
    * @Purpose      : This function used to test functionality of unenroll user with invalid contact.
    * @Parameter    : 
    * @Returntype   : Please enter a reason.
    */
    @isTest
    public static void unenrollTestForException(){
        
        User user = [SELECT ContactId, Id, isActive,
                     IsPortalEnabled, Username, LastName FROM User 
                     WHERE Username = 'dreamtest@domain.com'];
        String reason =  'The fact is you can’t get around using text fields.'+
                        ' Another option is Notes & Attachments or even creating Task based on what the business driver is.'+
                        ' Experience tells me Notes & Attachments is the least favorite of the user and Task should remain just that–a reportable action and not notes on a page.'+
                        ' Both of these actions will drive the user down page off of the details section away from the action. Users want to keep looking at the details not down.';
        System.runAs(user){
            String message = FTL_UnenrollController.unenroll(reason);
            System.assert(message.contains('Update failed.'));
        }
    }
    
}