@isTest
public class FTL_Duplicate_Nomination_ControllerTest {
    static testMethod void method1(){
        Test.startTest();
        FTL_Program_Form__c record1 = new FTL_Program_Form__c(Nominee_Name__c='test',
                Nominee_Zip_Code__c='45879',
                Nominee_State__c='TX',
                Nominee_Country__c='US',
                Nominee_City__c='Houston',
                Nominee_Street_Address__c='Texas 8 Beltway,',
            	Multiple_Submissions__c=false
        );
        
        insert record1;
        
        FTL_Program_Form__c record2 = new FTL_Program_Form__c(Nominee_Name__c='test123',
                Nominee_Zip_Code__c='45879',
                Nominee_State__c='TX',
                Nominee_Country__c='US',
                Nominee_City__c='Houston',
                Nominee_Street_Address__c='Texas 8 Beltway,',
            	Multiple_Submissions__c=false
        );
        
        insert record2;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(record2);
        FTL_Duplicate_Nomination_Controller testAccPlan = new FTL_Duplicate_Nomination_Controller(sc);
        
        testAccPlan.updateMultipleSubmissions();
        PageReference pageRef = Page.FTL_Duplicate_Nomination_Forms;
        pageRef.getParameters().put('id', String.valueOf(record2.Id));
        Test.setCurrentPage(pageRef);
        
        Test.stopTest();
    }
}