@isTest  
public class TestSCLAlerts {
    

	static testmethod void testMethod1(){
    
    
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
            testSCL1.URLforfiles__c='yahoo.com';
       lstSCL.add(testSCL1);
          
        
        insert lstSCL;
    
test.startTest();
    SCLAlerts sc= new SCLAlerts();
 //   ApexPages.StandardSetController standardsetcontroller= sc.ssc;  
	List<SupplyChainUpdate__c > mylist=sc.getchains();
    
    
    Test.stopTest();
    system.assertEquals(2,mylist.size());
  
        
    
    }}