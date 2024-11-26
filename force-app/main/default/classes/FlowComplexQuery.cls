public with sharing class FlowComplexQuery {

    // Wrapper class for returning results to Flow
    public class QueryResult {
        @InvocableVariable
        public String accountdistrict;
        
        @InvocableVariable
        public String accountterritory;
        
        @InvocableVariable
        public Integer defCount; 
        
        @InvocableVariable
        public Integer terCount; 
        
    }

    // Wrapper class for input from Flow
    public class QueryInput {
        @InvocableVariable(required=true)
        public String zipcode; 
    }

    // Method to run the SOQL query with aggregation
    @InvocableMethod(label='Get TM DM By Zip' description='Fetches aggregated Account data based on zipcode.')
    public static List<QueryResult> fetchAggregatedData(List<QueryInput> inputs) {
        List<QueryResult> results = new List<QueryResult>();

        // Ensure we process only the first input (Flow always sends data as a list)
        if (!inputs.isEmpty() && inputs[0].zipcode != null) {
            String zipValue = inputs[0].zipcode;

            // Perform the SOQL query with dynamic input
            List<AggregateResult> aggregatedResults = [
                SELECT SAP_Sales_Office_Desc__c, COUNT(SAP_Sales_Office__c) defCount
                FROM Account
                WHERE BillingPostalCode LIKE :(zipValue + '%') and isResiRegion__c =TRUE
                GROUP BY SAP_Sales_Office_Desc__c
                ORDER BY COUNT(SAP_Sales_Office__c) DESC
                LIMIT 1
            ];
            
            
            List<AggregateResult> aggregatedResultsTerritory = [
                SELECT  SAP_Sales_Group__c, COUNT(SAP_Sales_Office__c) terCount
                FROM Account
                WHERE BillingPostalCode LIKE :(zipValue + '%') and isResiRegion__c =TRUE  and SAP_Sales_Group__c>'199' and SAP_Sales_Group__c<'599'
                GROUP BY    SAP_Sales_Group__c
                ORDER BY COUNT(SAP_Sales_Office__c) DESC
                LIMIT 1
            ];
            

            // Populate the results with the aggregated query data
            for (AggregateResult ar : aggregatedResults) {
                QueryResult result = new QueryResult();
                result.accountdistrict = (String) ar.get('SAP_Sales_Office_Desc__c');
                result.defCount = (Integer) ar.get('defCount');
                for (AggregateResult br : aggregatedResultsTerritory ) {
                    result.accountterritory= (String) br.get('SAP_Sales_Group__c');
                    result.terCount= (Integer) br.get('terCount');
                
                    results.add(result);
                }
            }
            
        }

        return results;
    }
}