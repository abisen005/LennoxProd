@isTest
public class FTLDealerSignupFormTrigger_Test {
    
    public static testMethod void testUpdateDelalerSignupForm(){
        
        Account testAccount = new Account(Name = 'TestAccount',Phone='111-111-1111',ShippingStreet='124 Main St',ShippingCity='Austin',ShippingState='TX',ShippingPostalCode='43212',ShippingCountry='US');
            insert testAccount;
        System.debug('Account is created '+testAccount.Name);
        
        List<Contact> contactList = new List<Contact>();
        for(Integer count=1; count<=5; count++){
            contactList.add(new Contact(FirstName = 'Test', LastName = 'LastName', Contact_Type__c = 'RNC',
                                        Email = 'contact'+count+'@gmail.com',
                                               Account = testAccount, Role__c = 'Sponsor'));
        }
        for(Contact c:contactList){
            System.debug('Contact created '+c.LastName);
        }
        
            insert contactList;
        
        List<FTL_Dealer_Signup_Form__c> dealerFormList = new List<FTL_Dealer_Signup_Form__c>();
        for(Integer count=1; count<=5; count++){
            System.debug('contactList contact  '+contactList.get(count-1).Id);
            	if(count!=2)
            		dealerFormList.add( new FTL_Dealer_Signup_Form__c(Contact__c = contactList.get(count-1).Id));
            	else
                    dealerFormList.add( new FTL_Dealer_Signup_Form__c());
        }
        
            insert dealerFormList;
        
        //updte status field on FTL_Dealer_Signup_Form__c
        List<FTL_Dealer_Signup_Form__c> updatedDealerFormList = new List<FTL_Dealer_Signup_Form__c>();
        List<Id> contactIdList = new List<Id>();
       
        for(FTL_Dealer_Signup_Form__c form : dealerFormList){
                form.Status__c = 'Approved';            
            	contactIdList.add(form.Contact__c);
            	updatedDealerFormList.add(form); 
        }
        update updatedDealerFormList;
        
        List<Contact> UpdatedContactList = [SELECT Id, FTL_Dealer_Signup_Status__c FROM Contact WHERE Id IN : contactIdList];
        Integer count=0;
        for(Contact contact:UpdatedContactList){
            System.assertEquals(contact.FTL_Dealer_Signup_Status__c,updatedDealerFormList.get(count).Status__c);
        }
    } 
}