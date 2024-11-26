/*
* @Purpose         : CreateResourceCase
* @since           : 31 Dec 2018
* @date            : 31 Dec 2018 - 
* @see      
*/


public class CreateResourceCaseController {
    @AuraEnabled
    public static String createCaseResource(String caseId) {
        
        String returnValue = '';
        try{
            Case parentCaseRecord = [SELECT Id, AccountId, ContactId, Description, Priority, ParentId, 
                                     Reason, RecordTypeId, Status, Subject, SuppliedEmail,
                                     Category_List__c, Serial_Number__c, Model_Number__c, 
                                     Serial_Number_Search__c, Address__c,
                                     City__c,State__c,
                                     PostalCode__c,
                                     Country__c, Customer_to_which_Serial_number_is_relat__c,Origin
                                     FROM Case
                                     WHERE Id =: caseId];
            if(parentCaseRecord!=null) {
                Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Resource').getRecordTypeId();
                Case childCaseRecord = new Case();
                childCaseRecord.RecordTypeId = caseRecordTypeId;
                childCaseRecord.AccountId = parentCaseRecord.AccountId;
                childCaseRecord.ContactId = parentCaseRecord.ContactId;
                childCaseRecord.Description = parentCaseRecord.Description;
                childCaseRecord.ParentId = parentCaseRecord.Id;
                childCaseRecord.Subject = parentCaseRecord.Subject;
                childCaseRecord.Status = 'In Progress';
                childCaseRecord.Category_List__c = parentCaseRecord.Category_List__c;
                childCaseRecord.Serial_Number__c = parentCaseRecord.Serial_Number__c;
                childCaseRecord.Model_Number__c = parentCaseRecord.Model_Number__c;
                childCaseRecord.Serial_Number_Search__c = parentCaseRecord.Serial_Number_Search__c;
                childCaseRecord.Priority = parentCaseRecord.Priority;
                //childCaseRecord.Reason = parentCaseRecord.Reason;
                childCaseRecord.Origin = parentCaseRecord.Origin;
                childCaseRecord.Address__c = parentCaseRecord.Address__c;
                childCaseRecord.City__c = parentCaseRecord.City__c;
                childCaseRecord.State__c = parentCaseRecord.State__c;
                childCaseRecord.PostalCode__c = parentCaseRecord.PostalCode__c;
                childCaseRecord.Country__c = parentCaseRecord.Country__c;
                childCaseRecord.Customer_to_which_Serial_number_is_relat__c = parentCaseRecord.Customer_to_which_Serial_number_is_relat__c;
                INSERT childCaseRecord;
                returnValue = childCaseRecord.Id;
            }
        } catch(Exception ex) {
            returnValue = ex.getMessage();
            System.debug('Database exception - '+ex.getMessage());
        }
        
        return returnValue;
    }
    
     @AuraEnabled
    public static String createCSChildCase(String caseId) {
        
        String returnValue = '';
        try{
            Case parentCaseRecord = [SELECT Id, AccountId, ContactId, Description, Priority, ParentId, 
                                     Reason, RecordTypeId, Status, Subject, SuppliedEmail 
                                     FROM Case
                                     WHERE Id =: caseId];
            if(parentCaseRecord!=null) {
                Id recordTypeId;
                //Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
                User user = [SELECT Id, Technical_Support__c 
                             FROM User 
                             WHERE Id =: userinfo.getUserId()];
                
                if(user != null && String.isNotEmpty(user.Technical_Support__c) ){
                    System.debug('Technical Support ::' + user.Technical_Support__c);
                    if(user.Technical_Support__c == 'CS Agent P&S'){
                        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Programs & Services').getRecordTypeId();    
                    }
                    else if(user.Technical_Support__c == 'CS Resource'){
                        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Resource').getRecordTypeId();    
                    }else {
                        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CS - Customer Support').getRecordTypeId();
                    }
                }                
                Case childCaseRecord = new Case();
                childCaseRecord.RecordTypeId = recordTypeId;
                childCaseRecord.AccountId = parentCaseRecord.AccountId;
                childCaseRecord.ContactId = parentCaseRecord.ContactId;
                childCaseRecord.Description = parentCaseRecord.Description;
                childCaseRecord.ParentId = parentCaseRecord.Id;
                childCaseRecord.Subject = parentCaseRecord.Subject;
                childCaseRecord.Status = 'New';
                INSERT childCaseRecord;
                returnValue = childCaseRecord.Id;
            }
        } catch(Exception ex) {
            returnValue = ex.getMessage();
            System.debug('Database exception - '+ex.getMessage());
        }
        
        return returnValue;
    }
    
    
}