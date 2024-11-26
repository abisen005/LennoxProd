/*
* @ Purpose      : This class is used to test the functionality of FTL_findDealerController.                   
* @ CreatedDate  : 26/4/2019
*/
@isTest
public class FTL_findDealerControllerTest {
	
    /*
   	 * @description   : Test setup method will create all required test records. 
	*/
    @testSetup
    public static void setup(){
        
        //create dealer account for test
        Account dealerAccount = new Account();
        dealerAccount.Name = 'testDealerAccount';
        dealerAccount.ShippingPostalCode = '78250';
        dealerAccount.FTL_Eligibility__c = 'Eligible';
        dealerAccount.ShippingState = 'Texas';
        dealerAccount.ShippingStreet = '15900 La Cantera Pkwy';
        dealerAccount.ShippingCity = 'San Antonio';
        dealerAccount.ShippingPostalCode = '87654';
        dealerAccount.ShippingCountry = 'US';
        dealerAccount.Phone = '111-111-1111';
        insert dealerAccount;
        contact c1 = new contact(firstname = 'First',lastname = 'test',FTL_Program_Status__c='Enrolled', FTL_Provisioned__c=true,accountid=dealerAccount.id
                                ,email='test@gmail.com',MobilePhone='1234567890');
        insert c1;
        //create dealer account for test
        Account dealerAccount2 = new Account();
        dealerAccount2.Name = 'testDealerAccount';
        dealerAccount2.ShippingPostalCode = '78250';
        dealerAccount2.FTL_Eligibility__c = 'Enrolled';
        dealerAccount2.ShippingState = 'Texas';
        dealerAccount2.ShippingStreet = '15900 La Cantera Pkwy';
        dealerAccount2.ShippingCity = 'San Antonio';
        dealerAccount2.ShippingPostalCode = '87654';
        dealerAccount2.ShippingCountry = 'US';
        dealerAccount2.Phone = '111-111-1111';
        insert dealerAccount2;
        
        contact c2 = new contact(firstname = 'First',lastname = 'test',FTL_Program_Status__c='Enrolled', FTL_Provisioned__c=true,accountid=dealerAccount2.id
                                 ,email='test2@gmail.com',MobilePhone='1244567890');
        insert c2;
        FTL_Program_Form__c ftlForm = new FTL_Program_Form__c();
        ftlForm.Nominee_Zip_Code__c = dealerAccount.ShippingPostalCode;
        ftlForm.Nominee_State__c = 'Texas';
        ftlForm.Nominee_Street_Address__c = '15900 La Cantera Pkwy';
        ftlForm.Nominee_City__c = 'San Antonio';
        ftlForm.Nominee_Country__c = 'Us';
        insert ftlForm;
        
        List<Dealer_Marketing__c> marketingDealerList = new List<Dealer_Marketing__c>();
        for(Integer count=1;count<=10;count++){
            marketingDealerList.add(new Dealer_Marketing__c(Account__c = dealerAccount.Id,
                                                            Additional_Service_Areas__c = ftlForm.Nominee_Zip_Code__c,
                                                           Name = 'Dealer'+count));
        	
        }
        
        insert marketingDealerList;

        Additional_Dealer_Locator_Addresses__c dealerLocatorAddress = new Additional_Dealer_Locator_Addresses__c();
        dealerLocatorAddress.Name = 'TestDealerLocatorAddress';
        dealerLocatorAddress.Zip_Postal_Code__c = ftlForm.Nominee_Zip_Code__c;
        dealerLocatorAddress.Dealer_Marketing__c = marketingDealerList[0].Id;
        
        insert dealerLocatorAddress;
    }
	/* 
    * @Purpose      : this function used to test functionality of assignDealer() method.
    * @Parameter    : -
    * @Returntype   : -
    */
    @isTest
    public static void findDealerControllerTest(){

        FTL_Program_Form__c ftlForm = [SELECT Id, Nominee_Zip_Code__c, Nominee_State__c, 
                                       Nominee_Street_Address__c, Assigned_Dealer__c
                                       FROM FTL_Program_Form__c];
		Account account = [SELECT Id FROM Account WHERE FTL_Eligibility__c= :'Enrolled'];
        
        ApexPages.currentPage().getParameters().put('id',ftlForm.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(ftlForm); 

        FTL_findDealerController findDealerController = new FTL_findDealerController(standardController);
        
		System.assertEquals(ftlForm.Assigned_Dealer__c,Null);
        findDealerController.paramValue =account.Id; 
        findDealerController.assignDealer();
      	FTL_Program_Form__c form = [SELECT Id, Assigned_Dealer__c FROM FTL_Program_Form__c];
       	System.assertNotEquals(form.Assigned_Dealer__c,Null);
    }
    
    /* 
    * @Purpose      : this function used to test functionality of getNearbyDealers() positive testing.
    * @Parameter    : -
    * @Returntype   : -
    */
   		 @isTest
     static  void  getNearbyDealersCalloutTest(){
        FTL_Program_Form__c ftlForm = [SELECT Id, Nominee_Zip_Code__c, Nominee_State__c, 
                                       Nominee_Street_Address__c, Assigned_Dealer__c, Nominee_Country__c, Nominee_City__c
                                       FROM FTL_Program_Form__c];
		
        Account account = [SELECT Id, Name, SAP_Customer_Number__c, 
                           ShippingStreet, ShippingState,FTL_Eligibility__c, ShippingPostalCode, ShippingCity
                           FROM Account LIMIT 1];
        
        contact c = new contact(lastname = 'test',FTL_Program_Status__c='Enrolled', FTL_Provisioned__c=true,accountid=account.id);

         
		ApexPages.currentPage().getParameters().put('id',ftlForm.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(ftlForm); 

        FTL_findDealerController findDealerController = new FTL_findDealerController(standardController);
        
        
        
        Test.startTest();
		//Test.setMock(HttpCalloutMock.class, new FTL_FindDealerControllerMock());
        List<FTL_findDealerController.AcntWrapper> wrap = findDealerController.acntWraps;
       
        System.assertEquals(wrap.isEmpty(), true);
        
        findDealerController.getNearbyDealers();
        List<FTL_findDealerController.AcntWrapper> wrp = findDealerController.acntWraps;
        
        System.assertEquals(wrp.isEmpty(), false);
        Test.stopTest();
    }
    
    
     static testmethod void successfulCallTest() {
        FTL_Program_Form__c ftlForm = new FTL_Program_Form__c(
            Nominee_Zip_Code__c = '67301',
            Nominee_Street_Address__c = '207 E Chestnut St',
            Nominee_City__c = 'Independence',
            Nominee_State__c = 'KS',
            Nominee_Country__c = 'US'
        );
        insert ftlForm;
         Account account = [SELECT Id, Name, SAP_Customer_Number__c, 
                           ShippingStreet, ShippingState,FTL_Eligibility__c, ShippingPostalCode, ShippingCity
                           FROM Account LIMIT 1];
        contact c = new contact(lastname = 'test',FTL_Program_Status__c='Enrolled', FTL_Provisioned__c=true,accountid=account.id);
         
        ApexPages.currentPage().getParameters().put('id',ftlForm.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(ftlForm); 
 Test.startTest();   
        //Test.setMock(HttpCalloutMock.class, new FTL_FindDealerControllerMock.BaseMock());
        FTL_findDealerController findDealerController = new FTL_findDealerController(standardController);
        	findDealerController.getNearbyDealers();
        Test.stopTest();
        	
    }
  
}