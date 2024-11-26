@isTest
public class FindSCLTest{ 
    @isTest

static void testMethod1(){
 List <supplychainupdate__c> lstSCL = new List<supplychainupdate__c>(); 
        
      supplychainupdate__c testSCL = new supplychainupdate__c();
            testSCL.URL__c='yahoo.com';
            testSCL.URLname__c='xxx';
            testSCL.Enablefile__c=true;
            testSCL.Enabled__c=true;
            testSCL.EnableURL__c=true;
            testSCL.message1__c='test';
            testSCL.prioritymessage__c=false;
            testSCL.Filedescription__c='xxx';
            testSCL.FileName__c='xxx';
    testSCL.Material_s__c='x1234';
    testSCL.Description__c='test';
            testSCL.URLforfiles__c='yahoo.com';
       lstSCL.add(testSCL);
        
                
      supplychainupdate__c testSCL1 = new supplychainupdate__c();
            testSCL1.URL__c='yahoo.com';
            testSCL1.URLname__c='xxxaadfsfd';
            testSCL1.Enablefile__c=true;
            testSCL1.Enabled__c=true;
            testSCL1.EnableURL__c=true;
            testSCL1.message1__c='test';
            testSCL1.prioritymessage__c=false;
            testSCL1.Filedescription__c='xxx';
            testSCL1.FileName__c='xxx';
     testSCL1.Material_s__c='x1234';
    testSCL1.Description__c='test';
            testSCL1.URLforfiles__c='yahoo.com';
       lstSCL.add(testSCL1);
          
        
        insert lstSCL;
   

FindSCL.getSCL();
        
    
        }}