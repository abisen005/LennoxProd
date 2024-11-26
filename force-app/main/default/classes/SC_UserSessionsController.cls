public class SC_UserSessionsController {

    @AuraEnabled
    public static List<SC_Coaching_Session__c> getCoachingSessions(String userId, String initId, Boolean newSessions, Boolean showAll, Integer queryLimit, Integer offset) {
        List<SC_Coaching_Session__c> result = new List<SC_Coaching_Session__c>();
        List<String> userIds = new List<String>{userId};
        System.debug('userIds:' + userIds);
        if(showAll) {
            result = CoachingUtils.getCoachingSessions(userIds, initId, true, true, queryLimit, offset);
        } else {
            if(newSessions) {
                result = CoachingUtils.getFutureCoachingSessions(userIds, initId, queryLimit, offset);
            } else {
                result = CoachingUtils.getPastCoachingSessions(userIds, initId, queryLimit, offset);
            }
        }
        return result;
    }

    @AuraEnabled
    public static List<SC_Coaching_Session__c> getSessionsByOwner(String ownerId, Boolean returnFutureSessions, Boolean returnPastSessions, Integer queryLimit, Integer offset) {
        return CoachingUtils.getSessionsByOwner(ownerId, returnFutureSessions, returnPastSessions, queryLimit, offset);
    }

}