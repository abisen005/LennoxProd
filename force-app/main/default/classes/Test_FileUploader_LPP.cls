@IsTest(SeeAllData=true)private class Test_FileUploader_LPP
{

     static testmethod void readfile(){
         

         
            supplychain__c obj = new supplychain__c(
                
            SupplyPlanners__c='Rebecca Grigg',
            locationdescription__c='x',
            ShortDescriptionofRequest__c='xxx');  
            insert obj;
         
StaticResource testdoc = [Select Id,Body from StaticResource where name ='testupload1'];
         
         
  ApexPages.StandardController controller = new ApexPages.StandardController(obj);
 FileUploaderforLPPIncrease testUpload1 = new  FileUploaderforLPPIncrease(controller);
            testUpload1.nameFile='Test.csv';
            testUpload1.contentFile= testdoc.Body;
            
            testUpload1.ReadFile();
            
     }}