public class SC_CoachingSessionTriggerHandler {

    public static void afterinsert(List<SC_Coaching_Session__c> sessions) {
        CoachingUtils.createCoachSessionNotes(sessions);
    }



    public static void afterupdate(Map<Id, SC_Coaching_Session__c> newMap, Map<Id, SC_Coaching_Session__c> oldMap) {
        Map<Id, SC_Coaching_Session__c> updatedSessionsMap = new Map<Id, SC_Coaching_Session__c>();
        for(Id sessionId :newMap.keySet()) {
            if(newMap.get(sessionId).Duration__c != oldMap.get(sessionId).Duration__c ||
               newMap.get(sessionId).Start_Date__c != oldMap.get(sessionId).Start_Date__c) {
                   updatedSessionsMap.put(sessionId, newMap.get(sessionId));
               }
        }
        CoachingUtils.syncSessionEventTimes(updatedSessionsMap);
    }



}