public class AlertComponentController {
    
    /* 
    * @Purpose      : this function used to get account and site location record related to case.
    * @Parameter    : String strRecordId. 
    * @Returntype   : response.
    */
    @AuraEnabled
    Public static response getOnloadData(string strRecordId){
        Account acc;
        Case caseRecord;
        String objectName;
        Home_Owners__c siteLocation;
        
        if(String.isNotBlank(strRecordId)){
            try{
                objectName = (Id.valueof(strRecordId)).getSObjectType().getDescribe().getName();
                System.debug('objectName '+ objectName);
                System.debug('strRecordId '+ strRecordId);
                
                if(objectName != null && objectName.equals('Case')){
                    
                    caseRecord = getCaseRecord(strRecordId);
                }
                
                if(caseRecord != null && (String.isNotBlank(caseRecord.AccountId) 
                                          || String.isNotBlank(caseRecord.Home_Owner__c))){
                    
                    acc = getCustomersRecord(caseRecord.AccountId);
                    siteLocation = getSiteLocationRecord(caseRecord.Home_Owner__c);
                    
                    if(acc != null || siteLocation != null){
                        
                        return new response('', true, acc, siteLocation);
                    }
                    return new response('Records not Found', false, null, null);
                }
                return new response('Records not Found', false, null, null);
            }
            catch(exception ex){
                return new response(ex.getMessage(), false, null, null);
            }
            
        }else{
            return new response('RecordId not found', false, null, null);
        }
        
    }
    
    private static Account getCustomersRecord(String strRecordId){
        
        Account acc = [SELECT Id, Name, Segmentation__c, Special_Instructions_TS__c
                       FROM Account 
                       WHERE Id =: strRecordId];
        return acc;
    }
    
    private static Home_Owners__c getSiteLocationRecord(String strRecordId){
        if(String.isNotBlank(strRecordId)){
            Home_Owners__c siteLocation = [SELECT Id, Special_Instructions__c	
                                           FROM Home_Owners__c 
                                           WHERE Id =: strRecordId];
            return siteLocation;
        }
        return null; 
    }
    
    /* 
    * @Purpose      : this function used to get case record.
    * @Parameter    : String strRecordId. 
    * @Returntype   : Case.
    */
    private static Case getCaseRecord(String strRecordId){
        if(String.isNotBlank(strRecordId)){
            Case caseRecord = [SELECT Id, AccountId, Home_Owner__c 
                               FROM Case
                               WHERE Id =: strRecordId];
            
            return caseRecord;
        }
        return null;
    }
    
    
    
    public class response{
        @AuraEnabled
        Public String message;
        @AuraEnabled
        Public boolean isSuccess;
        @AuraEnabled
        Public Account customer;
        @AuraEnabled
        Public Home_Owners__c siteLocation;
        
        public response(String message, boolean isSuccess, Account customer, Home_Owners__c siteLocation){
            this.message = message;
            this.isSuccess = isSuccess;
            this.customer = customer;
            this.siteLocation = siteLocation;
        }
    }

}