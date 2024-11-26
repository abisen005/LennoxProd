/**
* @Purpose : Controller for HoldScreen lightning component
**/
public class HoldScreenComponentController {
	
    @AuraEnabled
    public static Case getCase(String caseId){
    	
        try{
            return [SELECT Id, Model_Number__c, SAP_Error_Message__c, Serial_Number_Search__c
                    FROM Case
                    WHERE Id = :caseId];
        }catch(Exception exp){
            System.debug('Exception ::: '+exp.getMessage());
        }
        return null;
    }
}