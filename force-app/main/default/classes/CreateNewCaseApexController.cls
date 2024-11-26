public class CreateNewCaseApexController {

    @AuraEnabled
    public static Response getContacts(String accountId){
         try{
             List<Contact> contactList = [SELECT Id,Full_name_obsolete__c,Name,FirstName,LastName FROM Contact WHERE AccountId =:accountId ORDER BY Full_name_obsolete__c];
              return new Response(true, '', contactList);   
         } catch(Exception ex){
            return new Response(false, ex.getMessage(), null);
        }  
    }
    
    @AuraEnabled
    public static Response getCaseRecordTypeId(){
        Id recordTypeId;
        try{
            User user = [SELECT Id, Technical_Support__c 
                         FROM User 
                         WHERE Id =: userinfo.getUserId()];
            
            if(user != null  ){
                System.debug('Technical Support ::' + user.Technical_Support__c);
                if(user.Technical_Support__c == 'CS Agent P&S'){
                    recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Programs & Services').getRecordTypeId();    
                }
                else if(user.Technical_Support__c == 'CS Resource'){
                    recordTypeId = '0123c000000QmoTAAS';    
                }else {
                    recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Customer Support').getRecordTypeId();
                }
                System.debug('recordTypeId ::' + recordTypeId);
            }
            
           return new Response(true, '', recordTypeId);            
        }
        catch(Exception ex){
            return new Response(false, ex.getMessage(), null);
        }        
    }
    
    @AuraEnabled
    public static Response getAccountRecordId(String contactId){
        try{
            if(String.isNotBlank(contactId)){
                Contact con = [SELECT Id, AccountId 
                               FROM Contact 
                               WHERE Id =: contactId];
                return new Response(true, '', con.AccountId);
            }
            return new Response(false, 'Contact Id not Found', null);
        }
        catch(Exception ex){
            return new Response(false, '', null);
        }
    }
    
    public class Response{
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public object data;
        
        public Response(boolean isSuccess, String msg, object data){
           this.msg =msg;
           this.isSuccess = isSuccess;
           this.data = data; 
        }
    }

}