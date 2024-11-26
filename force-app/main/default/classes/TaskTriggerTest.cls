@isTest
public class TaskTriggerTest {
    
    @TestSetup  
    private static void setup() {
        
        List<Account> testAccountList = new List<Account>();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SAP Accounts').getRecordTypeId();
        for(Integer count=1;count<=3;count++){
            testAccountList.add(new Account(Name ='testAccount '+count,
                                           RecordTypeId = recTypeId,ShippingStreet='123 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='54321',ShippingCountry='US',Phone='111-111-1111'));
        }   
            insert testAccountList;
		

        Contact contact = new Contact(LastName = 'LastName',FirstName = 'Test', Email ='lastname@gmail.com',
                                     AccountId = testAccountList.get(0).Id);
        insert contact;
        
        
        Profile profile = [SELECT Id,UserLicenseId FROM Profile 
                           WHERE UserLicenseId  in 
                           (SELECT Id FROM UserLicense WHERE name ='Partner Community') LIMIT 1];
		
         User user = new User();
 		 user.ProfileID = profile.Id;
  		 user.EmailEncodingKey = 'ISO-8859-1';
 		 user.LanguageLocaleKey = 'en_US';
  		 user.TimeZoneSidKey = 'America/New_York';
		 user.LocaleSidKey = 'en_US';
  		 user.FirstName = 'first';
  		 user.LastName = 'last';
  		 user.Username = contact.Email+'.ftl';   
  		 user.CommunityNickname = 'testUser123';
  		 user.Alias = 't1';
  		 user.Email = 'no@email.com';
  		 user.IsActive = true;
  		 user.ContactId = contact.Id;
         
        insert user;

            	
    }
    @isTest
    public static void testUpdateTaskMethod(){
        
        List<Contact> contactList = [SELECT Id,Email FROM Contact LIMIT 1];
        
		User user = (User)[SELECT Id, Profile.UserLicense.Name, Username FROM User WHERE Username = :contactList.get(0).Email+'.ftl' LIMIT 1];
      
		system.runAs(user){
            
            List<Account> testAccountList = [SELECT Id, Name FROM Account Limit 3];
           	System.debug('Accounts created '+testAccountList.size());
        	List<Task> newTaskList = new List<Task>();
            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('FTL Task').getRecordTypeId();
        	for(Account testAccount : testAccountList){
            	for(Integer count=1;count<=7;count++){
                	newTaskList.add(new Task(subject = 'Step '+count+' - task',
                                         WhatId = testAccount.Id,
                                         Status = 'Not Started',
                                         Priority = 'Normal',
                                         RecordTypeID = devRecordTypeId
                                         ));
            	}
        	}
            	insert newTaskList;

        	List<Task> updatingTaskList = new List<Task>();
        	for(Task newTask : newTaskList){
               
                    newTask.Priority = 'High';
            		updatingTaskList.add(newTask);
                
        	}
        	try{
            	update updatingTaskList; 
        	}catch(Exception excep){
            	Boolean expectedExceptionThrown =  excep.getMessage().contains('Previous Task must be marked complete') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
        	}   
        }      
    }
    @isTest
    public static void testUpdateTaskWithMissingStepTest(){
       
        List<Contact> contactList = [SELECT Id,Email FROM Contact LIMIT 1];
		User user = (User)[SELECT Id, Profile.UserLicense.Name, Username FROM User WHERE Username = :contactList.get(0).Email+'.ftl' LIMIT 1];
		
        system.runAs(user){
            Account account =  new Account(Name='TestAccount');
           	
        	List<Task> newTaskList = new List<Task>();
            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('FTL Task').getRecordTypeId();
        	
            	for(Integer count=1;count<=4;count++){
                    if(count!=3){
                        newTaskList.add(new Task(subject = 'Step '+count+' - task',
                                         WhatId = account.Id,
                                         Status = 'Not Started',
                                         Priority = 'Normal',
                                         RecordTypeID = devRecordTypeId
                                         ));
                    }
                	
            	}

           insert newTaskList;

        	List<Task> updatingTaskList = new List<Task>();
        	for(Task newTask : newTaskList){
               		newTask.Status = 'Completed';
                    newTask.Priority = 'High';
            		
                try{
            		update newTask; 
        		}catch(Exception excep){
            		Boolean expectedExceptionThrown =  excep.getMessage().contains('Previous Step, Step 3 is not available') ? true : false;
					System.AssertEquals(expectedExceptionThrown, true);
        		}
                
        	}   
        } 
    }
    
}