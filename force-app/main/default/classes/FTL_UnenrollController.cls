public without sharing class FTL_UnenrollController {
    
    /* @future
    public static void deactivatePortalUser(Id userId){
        User currentUser = [ SELECT Id, 
                                contactId,
                                isActive,
                                IsPortalEnabled
                                FROM User 
                                WHERE Id = : userId ];
        currentUser.isActive = false;
        //currentUser.IsPortalEnabled = false;
        update currentUser;
    }*/
    
    @AuraEnabled
    public static String unenroll( String reason ) {    
        if( String.isNotBlank( reason ) ){
            String message = '';
            
            Id userId = UserInfo.getUserId();
            
            User currentUser = [ SELECT Id, 
                                contactId,
                                isActive,
                                IsPortalEnabled
                                FROM User 
                                WHERE Id = : userId ];
            
            Contact userContact = [ SELECT Id, 
                                   FirstName,
                                   LastName,
                                   AccountId,
                                   Reason_for_FTL_Unenrollment__c, 
                                   FTL_Program_Status__c
                                   FROM Contact
                                   WHERE Id =: currentUser.contactId ];
            
            /*Account userAccount	= [ SELECT Id, 
                                   Name,
                                   FTL_Number_of_Nominations_Assigned__c
                                   FROM Account
                                   WHERE Id = : userContact.AccountId ];*/
            
           /* UserLogin uLogin = [ SELECT Id, 
                                UserId, 
                                IsFrozen 
                                FROM UserLogin
                                WHERE UserId =: userId ];	*/	
            
/*            if( userAccount.FTL_Number_of_Nominations_Assigned__c == 0 || 
               String.valueOf( userAccount.FTL_Number_of_Nominations_Assigned__c ) == '' ||
               userAccount.FTL_Number_of_Nominations_Assigned__c == NULL ){
                   
                   userContact.Reason_for_FTL_Unenrollment__c = reason;
                   userContact.FTL_Program_Status__c = 'Request to Unenroll';
                   FTL_UnenrollController.deactivatePortalUser(currentUser.Id);
                   message = 'We are sorry to see you go. If you decide you would like to join the program again, please go to https://www.feelthelove.com/ to sign up.';
               }else if( userAccount.FTL_Number_of_Nominations_Assigned__c > 0 ){
                   userContact.Reason_for_FTL_Unenrollment__c = reason;
                   userContact.FTL_Program_Status__c = 'Request to Unenroll';
                   message = 'We have received your request to unenroll from the program. A member of the Feel the Love Program team will review the unenrollment request and unenroll your program membership.';
               }*/
            
            userContact.Reason_for_FTL_Unenrollment__c = reason;
            userContact.FTL_Program_Status__c = 'Request to Unenroll';
            
            message = 'You have been unenrolled from Feel The Love. If you would like to come back next year, please register again or contact your Territory Manager.';
            
            // update contact record
            try{
                System.debug('userContact..'+userContact);
                update userContact;
                System.debug('userContact..'+userContact);
                
                /*update currentUser;
                System.debug('currentUser..'+currentUser);*/
            }catch( Exception e ){
                message = e.getMessage();
                System.debug( 'Exception occured while updating contact -' + e );
            }
            return message;
        }else{
            return 'Please enter a reason.';
        }
    }       
    /*
    @AuraEnabled
    public static void deactivateUser() { 
        Id userId = UserInfo.getUserId();
            System.debug('Here');
            User currentUser = [ SELECT Id, 
                                contactId,
                                isActive
                                FROM User 
                                WHERE Id = : userId ];
            
            Contact userContact = [ SELECT Id, 
                                   FirstName,
                                   LastName,
                                   AccountId,
                                   Reason_for_FTL_Unenrollment__c, 
                                   FTL_Program_Status__c
                                   FROM Contact
                                   WHERE Id =: currentUser.contactId ];
            
            Account userAccount	= [ SELECT Id, 
                                   Name,
                                   FTL_Number_of_Nominations_Assigned__c
                                   FROM Account
                                   WHERE Id = : userContact.AccountId ];
            
          
            
            if( userAccount.FTL_Number_of_Nominations_Assigned__c == 0 || 
               String.valueOf( userAccount.FTL_Number_of_Nominations_Assigned__c ) == '' ||
               userAccount.FTL_Number_of_Nominations_Assigned__c == NULL ){
                   
                  
                   currentUser.isActive = false;
               
               }
            
            // update contact record
            try{
                
                update currentUser;
                System.debug('currentUser..'+currentUser);
            }catch( Exception e ){
                System.debug( 'Exception occured while updating contact -' + e );
            }
    }*/
}