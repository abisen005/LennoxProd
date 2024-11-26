@isTest

    private class testArchiveCSTasks
    {
       

public static testMethod void myUnitTest() {

 
       
        
        Task a = new Task(subject='Tester', recordtypeid='0123c000000Qfvm',createddate=Date.today().addDays(-1095));
            insert a;
     

Test.startTest();
      

         
String CRON_EXP = '0 0 0 15 3 ? *';
 String jobId = System.schedule('testArchiveCSTasks', CRON_EXP, new scheduleBatchArchiveCSTasks());

    
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
    
    Task tConfirm = [Select Id, IsDeleted from Task WHERE Id = :a.Id ALL ROWS];
      System.assertEquals(tConfirm.isdeleted, false);
    
        Test.StopTest();



      
 }}