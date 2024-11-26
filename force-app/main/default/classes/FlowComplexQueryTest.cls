@IsTest(SeeAllData=true)
public class FlowComplexQueryTest {
    @IsTest
    static void testFetchAggregatedData() {
        // Use existing production data (not recommended)
        FlowComplexQuery.QueryInput input = new FlowComplexQuery.QueryInput();
        input.zipcode = '78613';

        List<FlowComplexQuery.QueryInput> inputs = new List<FlowComplexQuery.QueryInput>{input};

        Test.startTest();
        List<FlowComplexQuery.QueryResult> results = FlowComplexQuery.fetchAggregatedData(inputs);
        Test.stopTest();

        // Assertions
        System.assert(!results.isEmpty(), 'Expected results but got none');
    }
}