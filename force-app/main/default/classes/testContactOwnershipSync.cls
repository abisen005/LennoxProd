@isTest

   public class testContactOwnershipSync {
    
       

public static testMethod void myContactOwnershipUnitTest() {

 

        
        
        Account s=new Account();
            s.name='KellytestRyantest';
               s.phone='543-200-0000';
    s.ownerid='005C000000BTKa1IAH';

            insert s;
     
     Contact sc=new Contact();
            sc.firstname='Baxtertest';
    sc.recordtypeid='012C00000007xB9IAI';
               sc.lastname='Ryantest';
               sc.accountid=s.id;
    	sc.Contact_Type__c='Dealer';
    sc.Role__c='Purchasing';
               sc.OwnerId='005C000000A4Az3IAF';
               sc.phone='500-110-0090';
           
            insert sc;
        Test.StartTest();
           schduleBatchUpdateContactOwners rec21 = new schduleBatchUpdateContactOwners();
           String sche= '0 0 0 15 3 ? *';
    system.schedule('Test',sche,rec21);
      Test.StopTest();

      System.assertEquals('012C00000007xB9IAI',sc.recordtypeid);
 }}