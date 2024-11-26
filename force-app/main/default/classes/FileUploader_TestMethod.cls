@IsTest(SeeAllData=true)private class FileUploader_TestMethod
{

     static testmethod void readfile(){
         

         
            supplychain__c obj = new supplychain__c(
                
            SupplyPlanners__c='Rebecca Grigg',
            locationdescription__c='x',
            ShortDescriptionofRequest__c='xxx');  
            insert obj;
         
StaticResource testdoc = [Select Id,Body from StaticResource where name ='testupload'];
         
         
  ApexPages.StandardController controller = new ApexPages.StandardController(obj);
FileUploader testUpload = new FileUploader(controller);
            testUpload.nameFile='Test.csv';
            testUpload.contentFile= testdoc.Body;
            
            testUpload.ReadFile();
            
     }}