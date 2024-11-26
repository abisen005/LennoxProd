@isTest(seeAllData=true)
private class TestSpeedchecklist {
static testmethod void validateStandardController(){
            
SPEED_Check_List__c sp = new SPEED_Check_List__c(
    name='test',
status__c='Not Started');
insert sp;    
    
ChecklistReports__c cl= new ChecklistReports__c(
    name='cltest',
    speedchecklist__c =sp.Id);
    insert cl;
    
    
    
    
    
         PageReference reference=Page.SPEEDChecklistviewtabv2;

       Test.setCurrentPage(reference);

ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
SPEEDCheckviewv2 ext = new SPEEDCheckviewv2(stdController);
ApexPages.currentPage().getParameters().put('id', sp.Id);

    ext.save();
    ext.returntorecord();
}
}