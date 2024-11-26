trigger WarrantyEmailDeleteTrigger on EmailMessage (before delete) {

    User u = new User();
    for(EmailMessage record: Trigger.new==null? Trigger.old: Trigger.new) {
        
              u = [Select Functional_Group__c From User Where Id = :UserInfo.getUserId()];

        
        if (u.Functional_Group__c!='Sales Effectiveness'){
        record.addError('You do not have permission to delete an email from a case.');
    }
}
        
        


}