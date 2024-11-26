@istest(SeeAllData=true)
private class TestHomeEquiploader {
     static testmethod void readfile(){

   Account a = new Account(
            name='Tester',
            SAP_Customer_Number__c='B9999');
            insert a;
         
             Lennox_LSA__c obj=new lennox_lsa__c(
            account__c=a.id,
            requested_dollar_amount__c = 200,
            requestor_comments__c = 'xxxx',
            Application__c='residential',
            reason_for_reimbursement__c='Excessive Calls',
            home_owner__c='a39C0000002PyvJ',
            order_reason__c='Motor/Blower',
             Request_outside_of_LSA_process__c = 'Yes');
            insert obj;
StaticResource testdoc = [Select Id,Body from StaticResource where name ='homeequipupload'];
         
         
  ApexPages.StandardController controller = new ApexPages.StandardController(obj);
homeEquiploader testUpload = new homeEquiploader(controller);
            testUpload.nameFile='Test.csv';
            testUpload.contentFile= testdoc.Body;
            
            testUpload.ReadFile();
            
     }}