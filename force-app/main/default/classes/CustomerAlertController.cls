/*
* @ Purpose      : This class is used to get account record related to case.                   
* @ CreatedDate  : 12/12/2018
*/
public class CustomerAlertController {
    
    /* 
    * @Purpose      : this function used to get account record related to sobject type recordId.
    * @Parameter    : String strRecordId. 
    * @Returntype   : response.
    */
    @AuraEnabled
    Public static response getOnloadData(string strRecordId){
        Account acc;
        string customerId;
        String objectName;
        Integer numOfActivity;
        
        if(String.isNotBlank(strRecordId)){
            try{
                objectName = (Id.valueof(strRecordId)).getSObjectType().getDescribe().getName();
                System.debug('objectName '+ objectName);
                System.debug('strRecordId '+ strRecordId);
                
                if(objectName != null && objectName.equals('Case')){
                    customerId = getCustomerId(strRecordId, objectName);
                    numOfActivity = getnumberOfActivities(strRecordId, objectName);
                }
                
                if(objectName != null && objectName.equals('Contact')){
                    customerId = getCustomerId(strRecordId, objectName);
                    numOfActivity = getnumberOfActivities(strRecordId, objectName);
                }
                
                if(objectName != null && objectName.equals('Account')){
                    customerId = strRecordId;
                    numOfActivity = getnumberOfActivities(strRecordId, objectName);
                }
                
                if(String.isNotBlank(customerId)){
                    acc = getCustomersRecord(customerId);
                    
                    if(acc != null){
                        return new response('', true, acc, numOfActivity);
                    }
                    return new response('Customer Record not Found', false, acc, numOfActivity);
                }
                return new response('Case has no customer record', false, null, numOfActivity);
            }
            catch(exception ex){
                return new response(ex.getMessage(), false, null, null);
            }
            
        }else{
            return new response('RecordId not found', false, null, null);
        }
        
    }
    
    private static Account getCustomersRecord(String strRecordId){
        
        Account acc = [SELECT Id, Name, Segmentation__c, Special_Instruction__c, SAP_Customer_Group__c,
                       Escalation_Code__c, SAP_Customer_Group_Id__c, DM_Adjusted_Segmentation__c 
                       FROM Account 
                       WHERE Id =: strRecordId];
        return acc;
    }
    
    /* 
    * @Purpose      : this function used to get accountId related to sobject.
    * @Parameter    : String strRecordId. 
    * @Returntype   : string.
    */
    private static string getCustomerId(String strRecordId, String objectName){
        
        String query = 'SELECT Id, AccountId FROM '+ objectName +' WHERE Id = \''+ strRecordId +'\'';
        System.debug('query '+ query);
        sObject sobjectRecord = Database.query(query);

        /*Case caseRecord = [SELECT Id, AccountId 
                           FROM objectName 
                           WHERE Id =: caseId];*/
        
        if(sobjectRecord != null){
            return String.valueOf(sobjectRecord.get('AccountId'));
        }
        return null;
    }
    
    /* 
    * @Purpose      : this function used to get number of task record related to case.
    * @Parameter    : String caseId. 
    * @Returntype   : Integer.
    */
    public static Integer getnumberOfActivities(String strRecordId, String parentType){
        String type = 'Call';
        String query = 'SELECT Id FROM Task WHERE Type =\'' + type + '\'' +' AND CreatedDate = LAST_N_DAYS:30 ';
        
        if(parentType.equals('Case') || parentType.equals('Account')){
            query = query + 'AND What.type =\'' + parentType + '\'' + ' AND WhatId =\'' + strRecordId + '\'';
        }
        
        if(parentType.equals('Contact')){
            query = query + 'AND Who.type  =\'' + parentType + '\'' + ' AND WhoId =\'' + strRecordId + '\'';
        }
        System.debug('query '+ query);
        List<sObject> sobjList = Database.query(query);
        
        /*List<task> taskList = [SELECT Id, WhatId  
                               FROM Task 
                               WHERE What.type  = 'case'
                               AND WhatId =: strRecordId
                               AND Type = 'Call'
                               AND CreatedDate = LAST_N_DAYS:30];*/
        
        System.debug('taskList '+ sobjList.size());
        if(sobjList != null && !sobjList.isEmpty()){
            return sobjList.size();
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
        Public Integer numberOfCalls;
        
        public response(String message, boolean isSuccess, Account customer, Integer numberOfCalls){
            this.message = message;
            this.isSuccess = isSuccess;
            this.customer = customer;
            this.numberOfCalls = numberOfCalls;
        }
    }
}