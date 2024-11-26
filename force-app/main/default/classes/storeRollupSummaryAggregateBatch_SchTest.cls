@isTest
public with sharing class storeRollupSummaryAggregateBatch_SchTest {
    @IsTest
    static void testCurrentYear(){
        
        Test.startTest();
        storeRollupSummaryAggregateBatch_Sch batch = new storeRollupSummaryAggregateBatch_Sch();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test ExecutiveSummary_Sch', sch, batch); 
        // add system asserts to check your expected behaviour
        Test.stopTest();
        
    }
    @IsTest
    static void testPreviousYear(){
        
        Test.startTest();
        storeRollupSummaryAggregateBatchPY_Sch batch = new storeRollupSummaryAggregateBatchPY_Sch();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test ExecutiveSummary_Sch', sch, batch); 
        // add system asserts to check your expected behaviour
        Test.stopTest();
        
    }
}