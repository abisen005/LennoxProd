@isTest

    private class testDeleteRecords
    {
       

public static testMethod void myUnitTest() {

 
       
        
        Account a = new Account(name='Tester');
            insert a;
     
     retention_history__c ret=new retention_history__c(
            name='sss',
         createddate=Date.today().addDays(-1095),
               dealer_name__c=a.id);
                       insert ret;
Test.startTest();
      

         
String CRON_EXP = '0 0 0 15 3 ? *';
 String jobId = System.schedule('testDeleteRecords', CRON_EXP, new scheduleBatchDeleteRecords());

    
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
    
    Retention_history__c tConfirm = [Select Id, IsDeleted from   Retention_history__c WHERE Id = :ret.Id ALL ROWS];
    	System.assertEquals(tConfirm.isdeleted, false);
    
        Test.StopTest();



      
 }}