/*
* @ Purpose      : Handler for FTLDealerSignupFormTrigger            
* @ CreatedDate  : 12-04-2019
*/
public class FTLDealerSignupFormHandler {
    
    //update contact FTL_Dealer_Signup_Status__c field if FTL_Dealer_Signup_Form__c object's Status__c field is changed
    public static void afterUpdate(List<FTL_Dealer_Signup_Form__c > dealerSignupFormList,Map<Id,FTL_Dealer_Signup_Form__c> dealerSignupFormMap){

        Map<Id,String> contactToUpdateMap = new Map<Id,String>();
        Map<Id,String> accountToUpdateMap = new Map<Id,String>();
        for(FTL_Dealer_Signup_Form__c form : dealerSignupFormList){
            
            if(form.Status__c != dealerSignupFormMap.get(form.id).Status__c){
                if(form.Contact__c!=null){
                    contactToUpdateMap.put(form.Contact__c,form.Status__c);
                    System.debug('form.Contact__c '+form.Contact__c+'  form.Status__c'+form.Status__c);
                }
            }
            
            if(form.Status__c == 'Approved'){
                accountToUpdateMap.put(form.Company_Name__c, 'Enrolled');
            }
        }
        updateRelatedAccountEligibility(accountToUpdateMap);
        updateRelatedContactStatus(contactToUpdateMap);        
    }
    
    //update contact FTL_Dealer_Signup_Status__c field at time of Dealer_Signup_Form creation
    public static void afterInsert(List<FTL_Dealer_Signup_Form__c > dealerSignupFormList){
        
        Map<Id,String> contactToUpdateMap = new Map<Id,String>();
		Map<Id,String> accountToUpdateMap = new Map<Id,String>();        
        for(FTL_Dealer_Signup_Form__c form : dealerSignupFormList){
            if(form.Contact__c!=null){
                contactToUpdateMap.put(form.Contact__c,form.Status__c);
            }
            
            if(form.Status__c == 'Approved'){
                accountToUpdateMap.put(form.Company_Name__c, 'Enrolled');
            }
        }
        updateRelatedAccountEligibility(accountToUpdateMap);
        updateRelatedContactStatus(contactToUpdateMap);    
    }
    
    //method to update related contact status to FTL_Dealer_Signup_Form status 
    public static void/*List<Id>*/ updateRelatedContactStatus(Map<Id,String> contactToUpdateMap){
        
        List<Contact> updatedContactList = new List<Contact>();
        List<Id> unUpdatedContactList = new List<Id>();
        
        for(Contact contact : [SELECT Id,FTL_Dealer_Signup_Status__c FROM Contact WHERE Id IN : contactToUpdateMap.keySet()]){
            contact.FTL_Dealer_Signup_Status__c = contactToUpdateMap.get(contact.Id);
            updatedContactList.add(contact);
             System.debug('Contact updated status '+contact.FTL_Dealer_Signup_Status__c);
        }
       	update updatedContactList;    
    }
    
    //method to update related contact status to FTL_Dealer_Signup_Form status 
    public static void updateRelatedAccountEligibility(Map<Id,String> accountToUpdateMap){
        Integer currentYear = System.today().year();
        List<Account> updatedAccountList = new List<Account>();
        List<Id> unUpdatedAccountList = new List<Id>();
        
        for(Account account : [SELECT Id,FTL_Eligibility__c,DS_Completion_Date__c FROM Account WHERE Id IN : accountToUpdateMap.keySet() AND CALENDAR_YEAR(DS_Completion_Date__c)=:currentYear]){
            account.FTL_Eligibility__c = accountToUpdateMap.get(account.Id);
            updatedAccountList.add(account);
        }
       	update updatedAccountList;    
    }
}