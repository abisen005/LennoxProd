public with sharing class AcctPathNCController {
    
    // Public methods

    @AuraEnabled
    public static Response getRecords(String accountId) {

        try {

            Map<String, Object> responseMap = new Map<String, Object>();

            List<Account> accountList = [
                SELECT Id, Account_Plan__c, Conversion__c, Opportunity_Scorecard__c, Proposal_Close__c, NC_Path__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
            ];

            if (!accountList.isEmpty()) {

                Account account = accountList[0];
                responseMap.put('Account', account);

                List<Scorecard__c> opportunityScorecardList = [
                    SELECT Id 
                    FROM Scorecard__c 
                    WHERE Id = :account.Opportunity_Scorecard__c
                    LIMIT 1
                ];

                if (!opportunityScorecardList.isEmpty()) {

                    responseMap.put('opportunityScorecard', opportunityScorecardList[0].Id);
                }

                List<Account_Planning__c> accountPlanList = [
                    SELECT Id
                    FROM Account_Planning__c
                    WHERE Id = :account.Account_Plan__c
                    LIMIT 1
                ];

                if (!accountPlanList.isEmpty()) {

                    responseMap.put('accountPlan', accountPlanList[0].Id);
                }

                List<Opportunity> proposalAndCloseList = [
                    SELECT Id
                    FROM Opportunity
                    WHERE Id = :account.Proposal_Close__c
                    LIMIT 1
                ];

                if (!proposalAndCloseList.isEmpty()) {

                    responseMap.put('proposalAndClose', proposalAndCloseList[0].Id);
                }

                List<Conversion_Velocity__c> conversionList = [
                    SELECT Id
                    FROM Conversion_Velocity__c
                    WHERE Id = :account.Conversion__c
                    LIMIT 1
                ];

                if (!conversionList.isEmpty()) {

                    responseMap.put('conversion', conversionList[0].Id);
                }

                return new Response(responseMap, true, null);
            } else {

                return new Response(null, false, 'Invalid Account. Please provide a valid Account.');
            }
        } catch (Exception e) {

            return new Response(null, false, getExceptionString(e));
        }
    }

    // Private methods

    private static String getExceptionString(Exception e) {

        return e.getLineNumber()
            + ' | '
            + e.getMessage();
    }

    // Wrappers

    public class Response {

        @AuraEnabled
        public Object data;

        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String message;

        public Response(Object data, Boolean isSuccess, String message) {

            this.data = data;
            this.isSuccess = isSuccess;
            this.message = message;
        }
    }
}