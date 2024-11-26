public class FTL_DisablePartnerUserController {
    public Contact oContact{get;set;}
    private Id rt;
    public FTL_DisablePartnerUserController(ApexPages.StandardController stdCon){
        oContact = (Contact)stdCon.getRecord();
        for(RecordType r : [Select Id From RecordType Where Name = 'Residential Contact' AND SObjectType = 'Contact' ]){
            rt = r.id;
        }
        if(rt != null){
            oContact = [Select Id,Name,Email From Contact Where Id =: oContact.Id AND RecordTypeId =: rt];
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,'Only Provider User can be deactivated'));
        }                
    }
    
    public PageReference disableCustomerUser(){
        set<Id> setUserId = new set<Id>();
        PageReference oPage = null;
        if(rt != null){
            for(User oUser : [Select Id,UserName,Email,ContactId From User Where ContactId =:oContact.Id AND IsActive = true ]){
                setUserId.add(oUser.Id);
            }
            if(setUserId.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,'No active community user are associated to this contact.'));
                return null;
            }else{
                Savepoint sp = Database.setSavepoint();
                try{
                    updateUser(setUserId);
                    updateContact();
                    return new PageReference('/'+oContact.Id);
                }
                catch(Exception ex){
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,ex.getMessage()));
                    return null;
                }
            }
        }
        return oPage;
    }
    @future
    public static void updateUser(set<Id> setUserId){
        list<User> lstUser = new list<User>();
        for(User oUser : [Select Id,Name,UserName,Email,IsActive From User Where Id IN:setUserId]){
            oUser.UserName = oUser.Username.replace('@','=')+'@example.com';
            oUser.Email = oUser.Email.replace('@','=')+'@example.com';
            oUser.IsActive = false;
            lstUser.add(oUser);
        }
        if(lstUser.size()>0){
            update lstUser;
        }
    }
    
    public void updateContact(){
        for(User oUser : [Select Id,Name,UserName,ContactId From User Where ContactId =:oContact.id limit 1]){
            oContact.Salesforce_Username__c =  oUser.UserName.replace('@','=')+'@example.com';
        }
        oContact.FTL_Program_Status__c = 'Unenrolled';
        update oContact;
    }
}