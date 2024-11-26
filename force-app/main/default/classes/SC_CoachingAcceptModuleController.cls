public class SC_CoachingAcceptModuleController {
    
    @AuraEnabled
    public static SC_Coaching_Session__c getCoachingSession(String sessionId) {
        return CoachingUtils.getCoachingSession(sessionId);
    }
    
    @AuraEnabled
    public static Object respondToInvite(Boolean isAccepted, String relationId, String sessionId) {
        return CoachingUtils.respondToInvite(isAccepted, relationId, sessionId);
    }
    
    @AuraEnabled
    public static Object updateCoachingSession(SC_Coaching_Session__c session, Boolean IsReschedule) {
        return CoachingUtils.updateCoachingSession(session, IsReschedule);
    }
    
    @AuraEnabled
    public static EventRelation getEventRelationId(List<Event> eventList) {
        
        if(eventList != null && !eventList.isEmpty()){
            
            List<EventRelation> relation = [Select Id, EventId, Status, RelationId
                                            FROM EventRelation
                                            Where EventId IN : eventList AND 
                                            Status = 'New'];
            
            system.debug('relation :: '+relation);
            if(!relation.isEmpty()) return relation[0];
        }
        return new EventRelation() ;
    }
    
    @AuraEnabled
    public Static Object updateAttendeeStatus(string status, string sessionId, string userId, Boolean isUpdateAll){
        system.debug('updateAttendeeStatus in method ---- ');
        return CoachingUtils.updateAttendeeStatus(status, sessionId, userId, isUpdateAll);
    }
    
}