@isTest
public class ExecutiveSummary_Sch_Test {
    
    @IsTest
    static void testSchedulable(){
        
        Test.startTest();
        ExecutiveSummary_Sch batch = new ExecutiveSummary_Sch();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test ExecutiveSummary_Sch', sch, batch); 
            // add system asserts to check your expected behaviour
        Test.stopTest();
        
    }

     
    @IsTest
    static void testSchedulable2(){
        
        Test.startTest();
        ExecutiveSummaryLastYear_Sch batch = new ExecutiveSummaryLastYear_Sch();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test ExecutiveSummaryBatchLastYear', sch, batch); 
            // add system asserts to check your expected behaviour
        Test.stopTest();
        
    }

}