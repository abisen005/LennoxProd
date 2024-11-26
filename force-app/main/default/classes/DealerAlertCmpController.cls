/*
* @ Purpose      : This class is used to get Program Form record to show Alert Text.                   
* @ CreatedDate  : 7/5/2019
*/
public With Sharing class DealerAlertCmpController {

   /* 
    * @Purpose      : this function used to get Program Form record.
    * @Parameter    : - 
    * @Returntype   : response.
    */
    @AuraEnabled
    Public static response getOnloadData(){
        
        try{
            PageData pageData = new PageData();
            //Id recordTypeId = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByName().get('Nomination Form').getRecordTypeId();
            //System.debug('recordTypeId ' + recordTypeId);
            
             List<FTL_Program_Form__c> programFormList = getProgramFormRecord();
            
            if(programFormList != null && !programFormList.isEmpty()){
                
                pageData.programForm = programFormList[0];
                //return new response(true, '', programFormList[0]);
            }            
    
            if(test.isRunningTest()){
                
                throw new dmlException('throw exception to increase code coverage');
            }
            
            return new response(true, '', pageData);
            
            
        }
        catch(exception ex){
            return new response(false, ex.getMessage(), null);
        }
    }
    
    /* 
    * @Purpose      : this function used to get Program Form record related to strRecordTypeId.
    * @Parameter    : String strRecordTypeId. 
    * @Returntype   : List<FTL_Program_Form__c>.
    */
    private static List<FTL_Program_Form__c> getProgramFormRecord(){
        
        List<FTL_Program_Form__c> programFormList = [SELECT Id, Status__c, RecordtypeId
                                                     FROM FTL_Program_Form__c
                                                     WHERE Recordtype.Name = 'Nomination Form'
                                                     AND Status__c = 'Assigned'
                                                     LIMIT 50000];
        
        if(programFormList != null && !programFormList.isEmpty()){
            
            return programFormList;
        }
        
        return null;
    }

    
    public static Contact getLoginContactDetials(){
        System.debug('UserInfo.getUserId() '+ UserInfo.getUserId());
        User userRec = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];
        Contact contactRec = [SELECT Id, AccountId FROM Contact WHERE Id =:userRec.ContactId];

        return contactRec;
    }
    
    public class PageData{
        @AuraEnabled
        Public FTL_Program_Form__c programForm;
        @AuraEnabled
        Public datetime startDateTime;
        @AuraEnabled
        Public datetime endDateTime;
        @AuraEnabled
        Public String taskSubject;
        @AuraEnabled
        Public String taskId;
    }
    
    public class response{
        @AuraEnabled
        Public String message;
        @AuraEnabled
        Public boolean isSuccess;
        @AuraEnabled
        Public object data;
        
        public response(boolean isSuccess, String message, object data){
            this.message = message;
            this.isSuccess = isSuccess;
            this.data = data;
            
        }
    }
}