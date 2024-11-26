@isTest
public class FTL_NominationCounter_Test {
    @isTest
    public static void test() {

        Id rt = Schema.SObjectType.FTL_Program_Form__c.getRecordTypeInfosByDeveloperName().get('Nomination_Form').getRecordTypeId();



        List<FTL_Program_Form__c> forms = new List<FTL_Program_Form__c>();

        FTL_Program_Form__c a = new FTL_Program_Form__c();
        a.Nominee_Zip_Code__c = '78250';
        a.Nominee_Street_Address__c = '15900 La Cantera Pkwy';
        a.Nominee_City__c = 'San Antonio';
        a.Archived__c = False;
        a.Nominee_State__c = 'TX';
        a.RecordTypeId = rt;
        forms.add(a);

        FTL_Program_Form__c b = new FTL_Program_Form__c();
        b.Nominee_Zip_Code__c = '78250';
        b.Nominee_Street_Address__c = '15900 La Cantera Pkwy';
        b.Nominee_City__c = 'San Antonio';
        b.Archived__c = False;
        b.Nominee_State__c = '';
        b.RecordTypeId = rt;
        forms.add(b);

        insert forms;

        FTL_NominationCounter.Nominations n = FTL_NominationCounter.getAggregateData();
        system.assert(n!=null);
    }
}