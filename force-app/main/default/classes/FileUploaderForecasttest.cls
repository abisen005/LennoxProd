@IsTest(SeeAllData=true)private class FileUploaderForecasttest
{

     static testmethod void readfile(){
         

         
            supplychain__c obj1 = new supplychain__c(
                
            SupplyPlanners__c='Rebecca Grigg',
            locationdescription__c='x',
            ShortDescriptionofRequest__c='xxx');  
            insert obj1;
         
StaticResource testdoc1 = [Select Id,Body from StaticResource where name ='testupload1'];
         
         
  ApexPages.StandardController controller = new ApexPages.StandardController(obj1);
FileUploaderforLPPIncrease testUpload1 = new FileUploaderforLPPIncrease(controller);
            testUpload1.nameFile='Test.csv';
            testUpload1.contentFile= testdoc1.Body;
            
            testUpload1.ReadFile();
            
     }}