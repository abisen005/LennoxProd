public Without Sharing class NominationFormController {
    
    private static Account getAccount(String dealerNo, String dealerName ) {
        
        try {        
            System.debug('dealerNo ' + dealerNo);
            if(String.isNotBlank(dealerNo)){
                return [
                    SELECT Id, Name, SAP_Customer_Number__c
                    FROM Account
                    WHERE SAP_Customer_Number__c =:dealerNo
                ][0];
            }else if(String.isNotBlank(dealerName)){
                return [
                    SELECT Id, Name, SAP_Customer_Number__c
                    FROM Account
                    WHERE Name =:dealerName
                ][0];
            }
            
        } catch(Exception exp) {
            System.debug(exp.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static string getNominationFormRecordType(){
        
        initResponse res = new initResponse();
        
         string recordTypeId =
            Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName()
            .get('Nomination Form').getRecordTypeId();
        res.recordTypeId = recordTypeId;
        
        string queueId = [select Id from Group where Type = 'Queue' AND Name = 'Feel The Love'][0].Id;
        res.queueId = queueId;
        
        return JSON.serialize(res);
    }  
    
    public class initResponse {
     @AuraEnabled
     public String recordTypeId;
        
     @AuraEnabled
     public String queueId;
        
     public initResponse() {}
     public initResponse(String recordTypeId, String queueId ) {}
    }
    
    @AuraEnabled
    public static Response getAccountDetailsApex(String dealerNumber, String dealerName) {
        
        try {
            
            Account account = getAccount(dealerNumber, dealerName);
            
            if (account != null) {
                
                return new Response(true, account, null);
            } else {
                
                return new Response(false, null, 'Unable to find account. Please enter a valid Account Number.');
            }
        } catch (Exception e) {
            
            return new Response(false, null, getExceptionString(e));
        }
    }
    
    
    @AuraEnabled
    public static FTL_Program_Form__c updateNominationStory(Id nominationRecordId, String nominationStory) {
    
         FTL_Program_Form__c newStory = [SELECT Id, Nominee_Story__c FROM FTL_Program_Form__c WHERE Id=:nominationRecordId];
        newStory.Nominee_Story__c = nominationStory;
        update newStory;
        return newStory;
    }
    
    
   @TestVisible
    private static String getExceptionString(Exception e) {
        
        return e.getLineNumber() 
            + ' | ' 
            + e.getMessage();
    }
    
    public class Response {
        
        @AuraEnabled
        public String msg;
        
        @AuraEnabled
        public boolean isSuccess;
        
        @AuraEnabled
        public object data;
        
        public Response() {}
        
        public Response(boolean isSuccess, object data, String msg) {
            
            this.msg = msg;
            this.isSuccess = isSuccess;
            this.data = data;
        }
    }
    
}