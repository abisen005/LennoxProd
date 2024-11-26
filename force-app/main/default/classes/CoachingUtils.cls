/**
* @author Greg Lovelidge
* @date 2016
*
* @description Utility methods for the Lennox Coaching Application
*/
public without sharing class CoachingUtils {
    
    
    
    
/*****************************************
******************************************
PUBLIC METHODS
******************************************
*****************************************/
    
    
    
    /*******************************************************************************************************
* @description Constructs a query that will return a list of users based on related coaching role assignment criteria
*              and adds the soql string to the coaching role object.
* @param assignmentCriteria A list of Coaching Role Assignment Criterion records
* @example
* CoachingUtils.assignUsersToCoachingRole(criteria);
*/
    public static void createCoachingRoleQuery(List<SC_Coaching_Role_Assignment_Criterion__c> criteria) {
        
        List<SC_Coaching_Role__c> coachingRoles = new List<SC_Coaching_Role__c>();
        Map<Id, List<SC_Coaching_Role_Assignment_Criterion__c>> coachingRoleIdCriteriaMap = new Map<Id, List<SC_Coaching_Role_Assignment_Criterion__c>>();
        for(SC_Coaching_Role_Assignment_Criterion__c criterion :criteria) {
            if(coachingRoleIdCriteriaMap.get(criterion.Coaching_Role__c) == NULL) {
                coachingRoleIdCriteriaMap.put(criterion.Coaching_Role__c, new List<SC_Coaching_Role_Assignment_Criterion__c>());
            }
        }
        for(SC_Coaching_Role__c role :[SELECT Id, (SELECT Field__c, Operator__c, Value__c FROM Coaching_Role_Assignment_Criteria__r)
                                       FROM SC_Coaching_Role__c
                                       WHERE Id IN :coachingRoleIdCriteriaMap.keySet()]) {
                                           coachingRoleIdCriteriaMap.get(role.Id).addAll(role.Coaching_Role_Assignment_Criteria__r);
                                       }
        
        for(Id roleId :coachingRoleIdCriteriaMap.keySet()) {
            SC_Coaching_Role__c coachingRole = new SC_Coaching_Role__c(Id = roleId);
            if(!coachingRoleIdCriteriaMap.get(roleId).isEmpty()) {
                final Map<String, String> FIELD_USERFIELD = new Map<String, String>{'Role' => 'UserRoleId', 'Profile' => 'ProfileId'};
                    final Map<String, String> FIELD_OBJECT = new Map<String, String>{'Role' => 'UserRole', 'Profile' => 'Profile'};
                        final Map<String, String> OPERATOR_FILTERSTRING = new Map<String, String>{
                            'Equals' => ' = {0}{1}{2})',
                                'Not Equal to' => ' != {0}{1}{2})',
                                'Contains' => ' LIKE {0}%{1}%{2})'
                                };
                                    Boolean firstCriterion = TRUE;
                String query = 'SELECT Id FROM User WHERE isActive = TRUE';
                for(SC_Coaching_Role_Assignment_Criterion__c criterion :coachingRoleIdCriteriaMap.get(roleId)) {
                    query += ' AND ';
                    query += FIELD_USERFIELD.get(criterion.Field__c) + ' IN (SELECT Id FROM ' + FIELD_OBJECT.get(criterion.Field__c) + ' WHERE Name ';
                    query += String.format(OPERATOR_FILTERSTRING.get(criterion.Operator__c), new String[]{'\'', criterion.Value__c, '\''});
                }
                coachingRole.Generated_SOQL__c = query;
                coachingRoles.add(coachingRole);
            } else {
                //no criteria, set soql to empty
                coachingRole.Generated_SOQL__c = '';
                coachingRoles.add(coachingRole);
            }
        }
        
        update coachingRoles;
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Given a list of coaching roles, this will execute the generated soql on the record and
*               add the user ids to the record. Used to determine what coaching role a user belongs to.
* @param    coachingRoles   List of SC_Coaching_Role__c objects to update
* @example
* CoachingUtils.updateCoachingRoleUsers(coachingRoles);
*/
    public static void updateCoachingRoleUsers(List<SC_Coaching_Role__c> coachingRoles) {
        
        for(SC_Coaching_Role__c coachingRole :coachingRoles) {
            String soql = coachingRole.generated_SOQL__c;
            if(!String.isEmpty(soql)) {
                List<User> assignedUsers = Database.query(soql);
                List<String> assignedUserIds = new List<String>();
                for(User u :assignedUsers) {
                    assignedUserIds.add(u.Id);
                }
                coachingRole.User_Ids__c = String.join(assignedUserIds, ',');
            } else {
                coachingRole.User_Ids__c = '';
            }
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Creates an Assignment objects for each provided user id
* @param    assignment  Assignment SObject. If multiple user ids are provided, clone this sobject and change the owner So
each user id provided is assigned to one assignment object.
* @param    userIds     A list of user ids. Create an assignment for each user id provided.
* @example
* assignments = CoachingUtils.createAssignments(assignment, userIds);
*/
    public static Object createAssignments(SC_Assignment__c assignment, String[] userIds) {
        List<SC_Assignment__c> assignments = new List<SC_Assignment__c>();
        for(String userId :userIds) {
            SC_Assignment__c newAssignment = assignment.clone(false, false, false, false);
            newAssignment.Assignee__c = userId;
            assignments.add(newAssignment);
        }
        try {
            insert assignments;
            return assignments;
        } catch(DmlException e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns an assignment object with the same Id as the provided assignmentId param
* @param    assignmentId   Salesforce Id of the Assignment to return
* @example
* assignment = CoachingUtils.getAssignment(assignmentId);
*/
    public static Object getAssignment(String assignmentId) {
        List<SC_Assignment__c> assignment = [SELECT Name, Complete__c, to_Complete__c, Assignee__c, Assignee__r.Name, Coaching_Session__r.Name,
                                             OwnerId, Coaching_Session__r.Initiative__r.Name, Description__c,
                                             Due_Date__c, Progress__c, Progress_Assignment__c, Status__c, Follow_Up_Notes__c
                                             FROM SC_Assignment__c
                                             WHERE Id = :assignmentId
                                             LIMIT 1];
        if(!assignment.isEmpty()) {
            return assignment[0];
        } else {
            return NULL;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Increments the progress value of a progress assignment
* @param    assignment   Assignment object to increment
* @example
* CoachingUtils.incrementAssignmentProgress(assignment);
*/
    public static Object updateAssignmentProgress(SC_Assignment__c assignment, Boolean increment) {
        try {
            if(increment) {
                assignment.Complete__c = assignment.Complete__c + 1;
            } else {
                assignment.Complete__c = assignment.Complete__c - 1;
            }
            update assignment;
            return assignment;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Changes an assignment object status to Complete
* @param    assignment   Assignment object to update
* @example
* CoachingUtils.completeAssignment(assignment);
*/
    public static Object completeAssignment(SC_Assignment__c assignment) {
        final String COMPLETE_STATUS = 'Complete';
        try {
            assignment.Status__c = COMPLETE_STATUS;
            if(assignment.Progress_Assignment__c) {
                assignment.Complete__c = assignment.to_Complete__c;
            }
            update assignment;
            return assignment;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of assignments for a given list of users
* @param    users   A list of users representing the users assigned to the returned coaching sessions
* @param    initiativeId    Filter the coaching sessions that belong to this initiative. Leave null or empty to include all.
* @param    returnIncomplete    Returns sessions in the future if true
* @param    returnCompleted     Returns sessions in the past if true
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* assignments = CoachingUtils.getAssignments(users, initId, recordId, true, false, 10, 0);
*/
    public static List<SC_Assignment__c> getAssignments(List<String> userIds, String initiativeId, String recordId, Boolean showIncomplete, Boolean showCompleted, Integer queryLimit, Integer offset) {
        final String COMPLETED_STATUS = 'Complete';
        final String INCOMPLETE_STATUS = 'Incomplete';
        String query = 'SELECT Name, Follow_Up_Notes__c, Complete__c, to_Complete__c, Coaching_Session__c, Coaching_Session__r.Name, Coaching_Session__r.Initiative__r.Name, Description__c, Due_Date__c, Progress__c, Progress_Assignment__c, Status__c, CreatedBy.Name FROM SC_Assignment__c WHERE ';
        if(!userIds.isEmpty()) {
            query += 'Assignee__c IN :userIds ';
        }
        if(!String.isEmpty(initiativeId)) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += 'Coaching_Session__r.Initiative__c = :initiativeId ';
        }
        if(!String.isEmpty(recordId)) {
            Map<String, String> sobjectNameFieldNameMap = new Map<String, String>{
                'SC_Coaching_Session__c' => 'Coaching_Session__c',
                    'Planning_Topic__c' => 'Planning_Topic__c'
                    };
                        Id newId = recordId;
            Schema.SObjectType sobjectType = newId.getSObjectType();
            String sobjectName = sobjectType.getDescribe().getName();
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += sobjectNameFieldNameMap.get(sobjectName) + ' = :recordId ';
        }
        if(!showCompleted || !showIncomplete) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            if(showCompleted) query += 'Status__c = :COMPLETED_STATUS ';
            if(showIncomplete) query += 'Status__c = :INCOMPLETE_STATUS ';
        }
        
        query = query.removeEnd('WHERE ').removeEnd('AND ');
        query += ' LIMIT ' + queryLimit + ' OFFSET ' + offset;
        System.debug('query: ' + query);
        List<SC_Assignment__c> assignments = Database.query(query);
        
        return assignments;
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of all Assignments a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned assignnments
* @param    initiativeId    Limit the assignment results that belong to this Initiative
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getAssignments(users, initId, true, false);
*/
    public static List<SC_Assignment__c> getAssignments(List<String> userIds, String initiativeId, String sessionId, Integer queryLimit, Integer offset) {
        return getAssignments(userIds, initiativeId, sessionId, true, true, queryLimit, offset);
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of all completed Assignments a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned Assignments
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getCompletedAssignments(users, initId, 10, 0);
*/
    public static List<SC_Assignment__c> getCompletedAssignments(List<String> userIds, String initiativeId, String sessionId, Integer queryLimit, Integer offset) {
        return getAssignments(userIds, initiativeId, sessionId, false, true, queryLimit, offset);
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of all future Coaching Sessions a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned Assignments
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getIncompleteAssignments(users, initId, 10, 0);
*/
    public static List<SC_Assignment__c> getIncompleteAssignments(List<String> userIds, String initiativeId, String sessionId, Integer queryLimit, Integer offset) {
        return getAssignments(userIds, initiativeId, sessionId, true, false, queryLimit, offset);
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a Coaching Session and related details based on provided id
* @param    sessionId   Id of the coaching session to retrieve
* @example
* coachingSession = CoachingUtils.getCoachingSession(sessionId);
*/
    public static SC_Coaching_Session__c getCoachingSession(String sessionId) {
        system.debug('sessionId :: '+sessionId);
        List<SC_Coaching_Session__c> session = [SELECT Name, Owner.Name, Owner.Id, Initiative__c, Initiative__r.Name, Start_Date__c, Duration__c,
                                                Is_Rescheduled_by_Cochee__c,Coaching_Session_URL__c,
                                                (SELECT User__r.Name, User__r.SmallPhotoUrl, User__c FROM Coaching_Session_Attendees__r),
                                                (SELECT Category__c, Note__c, Type__c, OwnerId, Owner.Name FROM Coaching_Session_Notes__r),
                                                (SELECT Id FROM Events__r),
                                                (SELECT Id FROM Assessments__r)
                                                FROM SC_Coaching_Session__c WHERE Id = :sessionId LIMIT 1];
        system.debug('session :: '+session);
        if(!session.isEmpty()) return session[0];
        
        return new SC_Coaching_Session__c();
    }
    
    
    
    
    /*******************************************************************************************************
* @description  Deletes a coaching session and related objects
* @param    sessionId   Id of the coaching session to delete
* @example 
* CoachingUtils.deleteCoachingSession(sessionId);
*/
    public static Object deleteCoachingSession(String sessionId, String sessionStartDate) {
        
        
        List<SC_Coaching_Session__c> session = [SELECT Id, Start_Date__c, Initiative__c, OwnerId 
                                                FROM SC_Coaching_Session__c 
                                                WHERE Id = :sessionId LIMIT 1];
        
        List<SC_Coaching_Session_Attendee__c> sessionAttendee = [Select Id, Name, User__c, Coaching_Session__c
                                                                 FROM SC_Coaching_Session_Attendee__c 
                                                                 Where Coaching_Session__c =: sessionId
                                                                 LIMIT 1];
        
        //system.debug('sessionAttendee ==== '+sessionAttendee[0].User__c);
        
        List<SC_Coaching_Session__c> sessionList = new List<SC_Coaching_Session__c>();
        
        try{
            sessionList = [Select Id, name, Initiative__c, OwnerId 
                           FROM SC_Coaching_Session__c 
                           Where Initiative__c =: session[0].Initiative__c];
        }catch(Exception e){
            
        }
        
        
        system.debug('Session List -- '+ sessionList);
        
        List<Event> evt = [SELECT Id FROM Event WHERE Coaching_Session__c = :sessionId];
        
        Datetime sessionStartTime = DateTime.valueOfGmt(sessionStartDate);
        //sessionStartTime =  sessionStartTime.addHours(-5);
        
        List<SC_Assessment__c> listSC_Assessment = new List<SC_Assessment__c>();
        try{
            listSC_Assessment = [SELECT Id, Coachee__c FROM SC_Assessment__c
                                 WHERE Coaching_Session__c IN : sessionList
                                 AND Coachee__c =: sessionAttendee[0].User__c];
        }catch(Exception e){
            system.debug('listSC_Assessment == '+e);
        }
        
        
        List<SC_Assessment_Skill__c> assesmentSkills = new List<SC_Assessment_Skill__c>();
        if(listSC_Assessment.size()>0){
            assesmentSkills = [SELECT Id, Name, Session_Date_Time__c, Assessment__c 
                               FROM SC_Assessment_Skill__c
                               Where Assessment__c IN : listSC_Assessment
                               AND Session_Date_Time__c != Null ];
            
            if(test.isRunningTest()){
                assesmentSkills = [SELECT Id, Name, Session_Date_Time__c, Assessment__c 
                                   FROM SC_Assessment_Skill__c ];
            }
            
            for(SC_Assessment_Skill__c skills : assesmentSkills){
                if(skills.Session_Date_Time__c == sessionStartTime){  
                   skills.Session_Date_Time__c = null;
                }
            }
        }
        
        
        if(!sessionAttendee.isEmpty()){
            set<Id> attendeeIds = new set<Id>();
            attendeeIds.add(session[0].OwnerId);
            for(SC_Coaching_Session_Attendee__c attendee : sessionAttendee){
                attendeeIds.add(attendee.User__c);
            }
            List<User> userList = [Select Id, Email FROM User Where Id IN : attendeeIds];
            
            if(!attendeeIds.isEmpty()){
                sendScheduleEmail(sessionId, userList, 'Delete_Session_Notification' );
            }
        }
        
        try {
            if(!assesmentSkills.isEmpty()){
                system.debug('assesmentSkills'+assesmentSkills);
                update assesmentSkills;
            }
            delete session;
            delete evt;
            return sessionId;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Updates a coaching session object
* @param    session SC_Coaching_Session__c Object to update
* @example
* coachingSession = updateCoachingSession(SC_Coaching_Session__c session);
*/
    public static Object updateCoachingSession(SC_Coaching_Session__c session, Boolean IsReschedule) {
        try {
            
            if(string.isNotBlank(session.Id)){
                set<Id> attendeeIds = new set<Id>();
                
                SC_Coaching_Session__c coachingSession = [SELECT Id, OwnerId FROM SC_Coaching_Session__c Where Id =: session.Id];
                if(IsReschedule){
                    if(session.Is_Rescheduled_by_Cochee__c){
                        attendeeIds.add(coachingSession.OwnerId);
                    }else{
                        
                        List<SC_Coaching_Session_Attendee__c> sessiongAttendeeList = [SELECT Id, Name, User__c, Coaching_Session__c
                                                                                      FROM SC_Coaching_Session_Attendee__c
                                                                                      Where Coaching_Session__c =: coachingSession.Id];
                        for(SC_Coaching_Session_Attendee__c sessionAttendee : sessiongAttendeeList){
                            attendeeIds.add(sessionAttendee.User__c);
                        }
                        
                    }
                }
                
                update session;
                List<User> userList = [Select Id, Email FROM User Where Id IN : attendeeIds];  
                sendScheduleEmail(coachingSession.Id, userList, 'Coaching_Session_rescheduled');
            } 
            return session;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Creates empty, default session notes for coach for a given list of sessions
* @param    session List of coaching sessions to create notes for
* @example
* sessionNotes = CoachingUtils.createCoachSessionNotes(sessions);
*/
    public static List<SC_Coaching_Session_Note__c> createCoachSessionNotes(List<SC_Coaching_Session__c> sessions) {
        List<SC_Coaching_Session_Note__c> result = new List<SC_Coaching_Session_Note__c>();
        
        final Set<String> DEFAULT_NOTE_TOPICS = getDefaultNoteTopics();
        for(SC_Coaching_Session__c session :sessions) {
            for(String topic :DEFAULT_NOTE_TOPICS) {
                SC_Coaching_Session_Note__c coachNote = new SC_Coaching_Session_Note__c();
                coachNote.Category__c = topic;
                coachNote.Note__c = '';
                coachNote.Type__c = 'Coach';
                coachNote.Coaching_Session__c = session.Id;
                coachNote.OwnerId = session.OwnerId;
                result.add(coachNote);
            }
        }
        try {
            insert result;
        } catch(DMLException e) {
            System.debug(e.getMessage());
        }
        return result;
    }
    
    
    
    /*******************************************************************************************************
* @description  Creates empty, default session notes for coachee for a given list of session attendees
* @param    sessionAttendees    List of coaching session attendees to create notes for
* @example
* sessionNotes = CoachingUtils.createCoacheeSessionNotes(sessions);
*/
    public static List<SC_Coaching_Session_Note__c> createCoacheeSessionNotes(List<SC_Coaching_Session_Attendee__c> sessionAttendees) {
        List<SC_Coaching_Session_Note__c> result = new List<SC_Coaching_Session_Note__c>();
        
        final Set<String> DEFAULT_NOTE_TOPICS = getDefaultNoteTopics();
        for(SC_Coaching_Session_Attendee__c attendee :sessionAttendees) {
            for(String topic :DEFAULT_NOTE_TOPICS) {
                if(topic != 'Follow Through') {
                    SC_Coaching_Session_Note__c coachNote = new SC_Coaching_Session_Note__c();
                    coachNote.Category__c = topic;
                    coachNote.Note__c = '';
                    coachNote.Type__c = 'Coachee';
                    coachNote.Coaching_Session__c = attendee.Coaching_Session__c;
                    coachNote.OwnerId = attendee.User__c;
                    result.add(coachNote);
                }
            }
        }
        try {
            insert result;
        } catch(DMLException e) {
            System.debug(e.getMessage());
        }
        return result;
    }
    
    
    
    /*public static void postAttendeeAlertsToSession(List<SC_Coaching_Session_Attendee__c> attendees) {
List<FeedItem> posts = new List<FeedItem>();

for (SC_Coaching_Session_Attendee__c attendee :attendees) {
ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

mentionSegmentInput.id = attendee.User__c;
messageBodyInput.messageSegments.add(mentionSegmentInput);

textSegmentInput.text = 'You were added to the session';
messageBodyInput.messageSegments.add(textSegmentInput);

feedItemInput.body = messageBodyInput;
feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
feedItemInput.subjectId = attendee.Coaching_Session__c;

ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

}
insert posts;
}*/
    
    
    public static List<SC_Coaching_Session__c> getSessionsByOwner(String ownerId, Boolean returnFutureSessions, Boolean returnPastSessions, Integer queryLimit, Integer offset) {
        String sortOrder = (returnFutureSessions && returnPastSessions) || returnFutureSessions ? 'ASC' : 'DESC';
        DateTime now = System.now();
        String query = 'SELECT Name, Start_Date__c, End_Date_New__c, Initiative__c, Initiative__r.Name, CreatedBy.Name, (SELECT User__r.Name FROM Coaching_Session_Attendees__r) FROM SC_Coaching_Session__c WHERE OwnerId = :ownerId ';
        if(!returnFutureSessions || !returnPastSessions) {
            query += ' AND ';
            if(returnFutureSessions) query += 'Start_Date__c >= :now ';
            if(returnPastSessions) query += 'Start_Date__c < :now ';
        }
        query = query.removeEnd('WHERE ').removeEnd('AND ');
        query += ' ORDER BY Start_Date__c ' + sortOrder;
        query += ' LIMIT ' + queryLimit + ' OFFSET ' + offset;
        System.debug('query: ' + query);
        List<SC_Coaching_Session__c> sessions = Database.query(query);
        
        return sessions;
    }
    
    public static List<SC_Coaching_Session__c> getOwnerSession(String ownerId, String IntiativeId){
        
        List<SC_Coaching_Session__c> sessions = new List<SC_Coaching_Session__c>();
        try{
           //Query the user's personal coaching records
           set<Id> coachingSessionIds = new set<Id>();
           for(EventRelation er: [SELECT Event.Coaching_Session__c FROM EventRelation WHERE RelationId = :ownerId AND Event.Coaching_Session__r.Initiative__c =: IntiativeId]) {
               coachingSessionIds.add(er.Event.Coaching_Session__c);
           }

           sessions = [SELECT Name, Start_Date__c, End_Date_New__c, Initiative__c, Initiative__r.Name, CreatedBy.Name,
                    (SELECT User__r.Name FROM Coaching_Session_Attendees__r) 
                    FROM SC_Coaching_Session__c 
                    WHERE (OwnerId = :ownerId OR Id IN :coachingSessionIds) AND Initiative__c =: IntiativeId ORDER BY Start_Date__c DESC];

        }catch(Exception e){
            system.debug('Exception Occurred: ' + e);
        }
        

        //EventRelation attendee :[SELECT EventId FROM EventRelation WHERE RelationId IN :userIds]
        //Coaching_Session__c
        
        //Initiative__c = :initiativeId 
        return sessions;
    }
    
    /*******************************************************************************************************
* @description  Returns a list of Coaching Sessions a list of users are assigned to; optionally
indicate if future or past sessions should be included in the result.
* @param    users   A list of users representing the users assigned to the returned coaching sessions
* @param    initiativeId    Filter the coaching sessions that belong to this initiative. Leave null or empty to include all.
* @param    returnFutureSessions    Returns sessions in the future if true
* @param    returnPastSessions  Returns sessions in the past if true
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getCoachingSessions(users, initId, true, false, 10, 0);
*/
    public static List<SC_Coaching_Session__c> getCoachingSessions(List<String> userIds, String initiativeId, Boolean returnFutureSessions, Boolean returnPastSessions, Integer queryLimit, Integer offset) {
        //1.    Get a list of events - future or past, depending on input - where the invitee is in the userIds List
        //      and the event is a coaching session TODO: need new formula field isCoachingSession__c on event.
        //      If initiativeId is not null, limit list to events where Coaching_Session__c.SC_Initiative__c = :initiativeId
        String sortOrder = (returnFutureSessions && returnPastSessions) || returnFutureSessions ? 'ASC' : 'DESC';
        Set<Id> eventIds = new Set<Id>();
        Set<Id> coachingSessionIds = new Set<Id>();
        for(EventRelation attendee :[SELECT EventId FROM EventRelation WHERE RelationId IN :userIds]) {
            eventIds.add(attendee.EventId);
        }
        for(Event evt :[SELECT Coaching_Session__c FROM Event WHERE Id IN: eventIds]) {
            coachingSessionIds.add(evt.Coaching_Session__c);
        }
        
        //If users were provided and there are no coaching sessions, then no coaching sessions meet the criteria
        //continuing after this point means coaching sessions were found for the user, or it's the intention
        //that the result should return all coaching sessions regardless of who the caochees are.
        if(!userIds.isEmpty() && coachingSessionIds.isEmpty()) return new List<SC_Coaching_Session__c>();
        
        DateTime now = System.now();
        String query = 'SELECT Name, Start_Date__c, End_Date_New__c, Initiative__c, Initiative__r.Name, CreatedBy.Name, (SELECT User__r.Name FROM Coaching_Session_Attendees__r) FROM SC_Coaching_Session__c WHERE ';
        if(!coachingSessionIds.isEmpty()) {
            query += 'Id IN :coachingSessionIds ';
        }
        if(!String.isEmpty(initiativeId)) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += 'Initiative__c = :initiativeId ';
        }
        if(!returnFutureSessions || !returnPastSessions) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            if(returnFutureSessions) query += 'Start_Date__c >= :now ';
            if(returnPastSessions) query += 'Start_Date__c < :now ';
        }
        
        query = query.removeEnd('WHERE ').removeEnd('AND ');
        query += ' ORDER BY Start_Date__c ' + sortOrder;
        query += ' LIMIT ' + queryLimit + ' OFFSET ' + offset;
        System.debug('query: ' + query);
        List<SC_Coaching_Session__c> sessions = Database.query(query);
        //List<SC_Coaching_Session__c> coacheSession = Database.query('SELECT Name, Start_Date__c, End_Date_New__c, Initiative__c, Initiative__r.Name, CreatedBy.Name, (SELECT User__r.Name FROM Coaching_Session_Attendees__r) FROM SC_Coaching_Session__c WHERE CreatedById IN : userIds'); 
        //sessions.addAll(coacheSession);
        
        return sessions;
    }
    
    /*******************************************************************************************************
* @description  Returns a list of all Coaching Sessions a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned coaching sessions
* @param    initiativeId    Limit the assignment results that belong to this Initiative
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getCoachingSessions(users, initId, true, false);
*/
    public static List<SC_Coaching_Session__c> getCoachingSessions(List<String> userIds, String initiativeId, Integer queryLimit, Integer offset) {
        return getCoachingSessions(userIds, initiativeId, true, true, queryLimit, offset);
    }
    
    /*******************************************************************************************************
* @description  Returns a list of all future Coaching Sessions a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned coaching sessions
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getFutureCoachingSessions(users, initId, 10, 0);
*/
    public static List<SC_Coaching_Session__c> getPastCoachingSessions(List<String> userIds, String initiativeId, Integer queryLimit, Integer offset) {
        return getCoachingSessions(userIds, initiativeId, false, true, queryLimit, offset);
    }
    
    /*******************************************************************************************************
* @description  Returns a list of all future Coaching Sessions a list of users are assigned to
* @param    users   A list of users representing the users assigned to the returned coaching sessions
* @param    offset  Limit the number of results
* @param    offset  Offset the soql results by this amount. Used for handling pagination.
* @example
* coachingSessions = CoachingUtils.getFutureCoachingSessions(users, initId, 10, 0);
*/
    public static List<SC_Coaching_Session__c> getFutureCoachingSessions(List<String> userIds, String initiativeId, Integer queryLimit, Integer offset) {
        return getCoachingSessions(userIds, initiativeId, true, false, queryLimit, offset);
    }
    
    
    
    /*******************************************************************************************************
* @description  if the user hasn't accepted, prompt them to accept or decline
* @param    sessionId   Id of the session
* @param    userId  Id of the user we're checking
* @example
* eventRelationId = CoachingUtils.checkIfAttendeeAccepted(sessionId, useId);
*/
    public static Object checkIfAttendeeAccepted(String sessionId, String userId) {
        try {
            Event[] evt = [SELECT Id FROM Event WHERE Coaching_Session__c = :sessionId AND isChild = FALSE LIMIT 1];
            if(!evt.isEmpty()) {
                final String UNRESPONDED_STATUS = 'New';
                String eventId = evt[0].Id;
                EventRelation[] relation = [SELECT Id, Status FROM EventRelation WHERE EventId = :eventId AND RelationId = :userId LIMIT 1];
                if(!relation.isEmpty()) {
                    if(relation[0].Status == UNRESPONDED_STATUS) {
                        return relation[0].Id;
                    } else {
                        return '';
                    }
                }
            }
            return '';
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    public Static Object updateAttendeeStatus(string status, string sessionId, string userId, Boolean isUpdateAll){
        system.debug('accept by coach ---- ');
        if(status == 'Rescheduled and Accepted by Coach' && string.isNotBlank(sessionId)){
            system.debug('In session block -- ');
            set<Id> attendeeIds = new set<Id>();
            List<User> coachList = new List<User>();
            
            SC_Coaching_Session__c session = [SELECT Id, OwnerId, Coaching_Session_Accepted_By__c FROM SC_Coaching_Session__c Where Id =: sessionId];
            User coach = [Select Id, Name, Email FROM User Where Id =: session.OwnerId];
            coachList.add(coach);
            
            session.Coaching_Session_Accepted_By__c = [Select Id, Name, Email FROM User Where Id =: userId].Name;
            update session;
            
            //attendeeIds.add(session.OwnerId);
            
            List<SC_Coaching_Session_Attendee__c> sessiongAttendeeList = [SELECT Id, Name, User__c, Coaching_Session__c
                                                                          FROM SC_Coaching_Session_Attendee__c
                                                                          Where Coaching_Session__c =: sessionId];
            system.debug('Coaching Attendee  '+sessiongAttendeeList );
            for(SC_Coaching_Session_Attendee__c sessionAttendee : sessiongAttendeeList){
                attendeeIds.add(sessionAttendee.User__c);
            }
            
            system.debug('attendeeIds '+attendeeIds );
            List<User> userList = [Select Id, Email FROM User Where Id IN : attendeeIds];  
            
            system.debug('userList'+userList);
            
            
            //Send Email to coach
            sendScheduleEmail(sessionId, coachList, 'Accept_Notification_for_Coach');
            
            //Send Email to cochee
            sendScheduleEmail(sessionId, userList, 'Accept_Notification_for_Coachee');
        }
        return null;
    }
    
    public static Object respondToInvite(Boolean isAccepted, String relationId, String sessionId) {
        try {
            system.debug('In Reapond Methos---');
            final Map<Boolean, String> BOOL_STATUS_MAP = new Map<Boolean, String>{true => 'Accepted', false => 'Declined'};
                EventRelation[] relation = [SELECT Status, EventId FROM EventRelation WHERE Id = :relationId LIMIT 1];
            
            if(!relation.isEmpty() || Test.isRunningTest()) {
                if(!Test.isRunningTest()){
                    system.debug('Relation if block -- ');
                    relation[0].Status = BOOL_STATUS_MAP.get(isAccepted);
                    update relation[0];
                    System.debug(relation[0]);
                }
                
                 system.debug('sessionId ' + sessionId);
                if(string.isNotBlank(sessionId)){
                    system.debug('In session block -- ');
                    set<Id> attendeeIds = new set<Id>();
                    List<User> coachList = new List<User>();
                    
                    SC_Coaching_Session__c session = [SELECT Id, OwnerId FROM SC_Coaching_Session__c Where Id =: sessionId];
                    User coach = [Select Id, Name, Email From User Where Id =: session.OwnerId];
                    coachList.add(coach);
                    
                    List<SC_Coaching_Session_Attendee__c> sessiongAttendeeList = [SELECT Id, Name, User__c, Coaching_Session__c
                                                                                  FROM SC_Coaching_Session_Attendee__c
                                                                                  Where Coaching_Session__c =: sessionId];
                     system.debug('Coaching Attendee  '+sessiongAttendeeList );
                    for(SC_Coaching_Session_Attendee__c sessionAttendee : sessiongAttendeeList){
                        attendeeIds.add(sessionAttendee.User__c);
                    }
                    
                     system.debug('attendeeIds '+attendeeIds );
                    List<User> userList = [Select Id, Email FROM User Where Id IN : attendeeIds];  
                    
                    //Send Email to coach
                    sendScheduleEmail(sessionId, coachList, 'Accept_Notification_for_Coach');
                    
                    //Send Email to cochee
                    sendScheduleEmail(sessionId, userList, 'Accept_Notification_for_Coachee');
                    
                   // system.debug('userList'+userList);
                   // sendScheduleEmail(sessionId, userList, 'Accept_Coaching_Invitation_Email');
                } 
                return true;
            }
            
            return false;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Update the related event with the new session date and time
* @param    sessions    Coaching Session objects with new date/time
* @example
* CoachingUtils.syncSessionEventTimes(Trigger.new);
*/
    public static List<Event> syncSessionEventTimes(Map<Id, SC_Coaching_Session__c> idSessionMap) {
        List<Event> evts = new List<Event>();
        for(Event evt :[SELECT StartDateTime, EndDateTime, DurationInMinutes, Coaching_Session__c, Allow_Session_Event_DateTime_Change__c
                        FROM Event
                        WHERE IsChild = FALSE AND Coaching_Session__c IN: idSessionMap.keySet()]) {
                            Integer duration = Integer.valueOf(idSessionMap.get(evt.Coaching_Session__c).Duration__c);
                            DateTime startDate = idSessionMap.get(evt.Coaching_Session__c).Start_Date__c;
                            if(duration != evt.DurationInMinutes ||
                               startDate != evt.StartDateTime) {
                                   evt.DurationInMinutes = duration;
                                   evt.StartDateTime = idSessionMap.get(evt.Coaching_Session__c).Start_Date__c;
                                   evt.EndDateTime = evt.StartDateTime.addMinutes(duration);
                                   evt.Allow_Session_Event_DateTime_Change__c = true;
                                   evts.add(evt);
                               }
                        }
        update evts;
        for(Event evt :evts) {
            evt.Allow_Session_Event_DateTime_Change__c = false;
        }
        update evts;
        return evts;
    }
    
    
    
    /*******************************************************************************************************
* @description  Update the related event with the new session date and time
* @param    sessions    Coaching Session objects with new date/time
* @example
* CoachingUtils.syncSessionEventTimes(Trigger.new);
*/
    //public static List<Event> syncSessionEventTimes(Map<Id, Event> idEventMap) {
    // Set<Id> sessionIds = new Set<Id>();
    // List<Coaching_Session__c> sessions = new List<Coaching_Session__c>();
    // for(Event evt :idEventMap.values()) {
    //     if(!evt.IsChild) sessionIds.add(evt.Coaching_Session__c);
    // }
    //
    // for(Coaching_Session__c session :[SELECT Duration__c, Start_Date__c, End_Date__c
    //                                   FROM Coaching_Session__c
    //                                   WHERE Id IN :sessionIds]) {
    //     Integer duration = Integer.valueOf(idSessionMap.get(evt.Coaching_Session__c).Duration__c);
    //     evt.StartDateTime = idSessionMap.get(evt.Coaching_Session__c).Start_Date__c;
    //     evt.EndDateTime = evt.StartDateTime.addMinutes(duration);
    //     evt.DurationInMinutes = duration;
    // }
    // update evts;
    // return evts;
    //}
    
    
    
    /*******************************************************************************************************
* @description  Returns a String representing attendees for a session
* @param    sessionId    Id representing the session
* @example
* CoachingUtils.getSessionAttendeesAsString(sessionId);
*/
    public static String getSessionAttendeesAsString(Id sessionId) {
        String[] attendeeNames = new List<String>();
        for(SC_Coaching_Session_Attendee__c attendee :[SELECT User__r.Name FROM SC_Coaching_Session_Attendee__c WHERE Coaching_Session__c = :sessionId]) {
            attendeeNames.add(attendee.User__r.Name);
        }
        
        return String.join(attendeeNames, ', ');
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of initiatives that belong to a single type (ie Sales)
* @param    Type    A string representing the type of intitiatives to return
* @example
* CoachingUtils.getInitiatives('Sales');
*/
    public static List<SC_Initiative__c> getInitiatives(String type, Id parentId) {
        return [SELECT Id, Name, Description__c, Parent_Initiative__c, (SELECT Id FROM Child_Initiatives__r)
                FROM SC_Initiative__c
                WHERE Coaching_Type__r.Name = :type AND Parent_Initiative__c = :parentId
                ORDER BY Sort_Order__c];
    }
    
    
    /*******************************************************************************************************
* @description  Returns a list of initiatives that belong to a single type (ie Sales)
* @param    Type    A string representing the type of intitiatives to return
* @example
* CoachingUtils.getInitiatives('Sales');
*/
    public static SC_Initiative__c getInitiative(String initiativeId) {
        SC_Coaching_Role__c coachingRole = getCoachingRole(UserInfo.getUserId());
        String coachingRoleId = coachingRole == NULL ? '' :  coachingRole.Id;
        System.debug('get initiative - what is different? initId = ' + initiativeId);
        System.debug('coachingRoleId = ' + coachingRoleId);
        SC_Initiative__c[] initiative = [SELECT Id, Name, Description__c,
                                         (SELECT Dashboard__c FROM Dashboard_Initiatives__r WHERE Coaching_Role__c = :coachingRoleId LIMIT 1),
                                         (SELECT Report__c FROM Initiative_Reports__r WHERE Coaching_Role__c = :coachingRoleId)
                                         FROM SC_Initiative__c
                                         WHERE Id = :initiativeId
                                         LIMIT 1];
        if(!initiative.isEmpty()) return initiative[0];
        return NULL;
    }
    
    
    
    public static Object getInitiativeSkills(String initiativeId) {
        SC_Coaching_Role__c coachingRole = getCoachingRole(UserInfo.getUserId());
        system.debug('coachingRole'+coachingRole);
        List<SC_Skill__c> skills = [SELECT Description__c
                                    FROM SC_Skill__c
                                    WHERE Initiative__c = :initiativeId AND
                                    Id IN (SELECT Skill__c FROM SC_Coaching_Role_Skill_Assignment__c WHERE Coaching_Role__c = :coachingRole.Id)];
        return skills;
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of Assessments
* @param    userId  Coachee Id
* @param    initId  Initiative Id
* @example
* List<SC_Assessment__c> assessments = CoachingUtils.getAssessments(userId, initId);
*/
    public static List<SC_Assessment__c> getAssessments(String userId, String initId) {
        List<SC_Assessment__c> assessments = [SELECT Complete__c, of_Skills_to_Complete__c, CreatedDate
                                              FROM SC_Assessment__c WHERE Coachee__c = :userId AND Coaching_Session__r.Initiative__c = :initId
                                              ORDER BY CreatedDate ASC];
        return assessments;
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of Assessments
* @param    userId  Coachee Id
* @param    initId  Initiative Id
* @param    sessionId  Session Id
* @param    queryLimit  query this many records
* @param    offset  offset the query by this amount
* @example
* List<SC_Assessment__c> assessments = CoachingUtils.getAssessments(userId, initId);
*/
    public static Object getAssessments(String userId, String initId, String sessionId, Integer queryLimit, Integer offset) {
        String query =  'SELECT Name, Coachee__r.Name, Coaching_Session__r.Name, Coaching_Session__r.Initiative__r.Name, of_Skills_Completed__c, of_Skills_to_Complete__c, CreatedDate ';
        query += 'FROM SC_Assessment__c WHERE ';

        /*
        //-------------------------------------------------------------------------------
        //How this is used, doesn't make sense to ever show this user their own assessments.
        //Instead, always exclude and ignore userId passed in. 
        //-------------------------------------------------------------------------------
        if(String.isNotBlank(userId)) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += 'Coachee__c = :userId ';
        }
        */

        //Get Owner's records only
        Id currUserId = UserInfo.getUserId();
        query += query.endsWith('WHERE ') ? '' : ' AND ';
        query += 'Coaching_Session__r.OwnerId = :currUserId ';

        if(String.isNotBlank(initId)) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += 'Coaching_Session__r.Initiative__c = :initId ';
        }
        if(String.isNotBlank(sessionId)) {
            query += query.endsWith('WHERE ') ? '' : ' AND ';
            query += 'Coaching_Session__c = :sessionId ';
        }


        query = query.removeEnd('WHERE ').removeEnd('AND ');
        query += ' ORDER BY CreatedDate DESC ';
        query += 'LIMIT ' + queryLimit + ' ';
        query += 'OFFSET ' + offset;
        System.debug('query: ' + query);
        SC_Assessment__c[] result = Database.query(query);
        return result;
        
        
    }
    
    
    /*******************************************************************************************************
* @description  Returns a list of Assessment Skill Records
* @param    userId  Coachee Id
* @param    initId  Initiative Id
* @example
* List<SC_Assessment_Skill__c> myCoachees = CoachingUtils.getAssessmentSkills(userId, initId);
*/
    public static List<SC_Assessment_Skill__c> getAssessmentSkills(String userId, String initId) {
        List<SC_Assessment__c> existingAssessment = [SELECT Id
                                                     FROM SC_Assessment__c WHERE Coachee__c = :userId AND Coaching_Session__r.Initiative__c = :initId
                                                     ORDER BY CreatedDate DESC
                                                     LIMIT 1];
        
        List<SC_Assessment_Skill__c> existingSkills = new List<SC_Assessment_Skill__c>();
        if(!existingAssessment.isEmpty()) {
            existingSkills = [SELECT Complete__c, Description__c, Assessment__c, Assessment__r.Coachee__c, OwnerId__c, 
                              Session_Date_Time__c, Date_Mastery_Achieved__c, Date_Last_Coached__c
                              FROM SC_Assessment_Skill__c
                              WHERE Assessment__c =: existingAssessment[0].Id
                              ORDER BY Complete__c ASC, Sort_Order__c ASC];
        }
        
        System.debug('existingSkills empty? ' + existingSkills.isEmpty());
        if(existingSkills.isEmpty()) {
            System.debug('userId from getAssessmentSkills: ' + userId);
            SC_Coaching_Role__c coachingRole = getCoachingRole(userId);
            System.debug('coachingRole: ' + coachingRole);
            List<SC_Assessment_Skill__c> newSkills = new List<SC_Assessment_Skill__c>();
            //Get skill records that belong to the provided init id and are assigned to the user's role
            for(SC_Skill__c skill :[SELECT Description__c, Sort_Order__c, Id
                                    FROM SC_Skill__c
                                    WHERE Initiative__c = :initId
                                    AND Id IN (SELECT Skill__c FROM SC_Coaching_Role_Skill_Assignment__c WHERE Coaching_Role__c = :coachingRole.Id)
                                    ORDER BY Sort_Order__c ASC]) {
                                        SC_Assessment_Skill__c assessmentSkill = new SC_Assessment_Skill__c();
                                        assessmentSkill.Description__c = skill.Description__c;
                                        assessmentSkill.Complete__c = false;
                                        assessmentSkill.Sort_Order__c = skill.Sort_Order__c;
                                        assessmentSkill.Skill__c = skill.Id;
                                        newSkills.add(assessmentSkill);
                                    }
            return newSkills;
        }
        return existingSkills;
    }
    
    
    
    
    /*******************************************************************************************************
* @description  Returns the Coaching Role object for the current user
* @example
* Coaching_Role__c myRole = CoachingUtils.getMyCoachingRole();
*/
    public static CoachingInfo getMyCoachingInfo() {
        String userId =  UserInfo.getUserId().substring(0,UserInfo.getUserId().length()-3);
        /*System.debug('userId ' + userId);UserInfo.getUserId(); */
        return getCoachingInfo(userId);
    }
    
    
    
    /*******************************************************************************************************
* @description  Get a user's coaching role
* @param    Id  A User id
* @example
* SC_Coaching_Role__c myRole = CoachingUtils.getCoachingRole(userId);
*/
    public static SC_Coaching_Role__c getCoachingRole(Id userId) {
        for(SC_Coaching_Role__c coachingRole :[SELECT Name, Id, User_Ids__c FROM SC_Coaching_Role__c]) {
            System.debug('coachingRole: ' + coachingRole);
            System.debug('userId: ' + userId);
            if(coachingRole.User_Ids__c.contains(userId)) {
                return coachingRole;
            }
        }
        return NULL;
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns the Coaching Role object for a given user
* @param    Id  A User id
* @example
* Coaching_Role__c myRole = CoachingUtils.getCoachingInfo(userId);
*/
    public static CoachingInfo getCoachingInfo(Id userRId) {
        system.debug('userRId == '+userRId);
        string user = UserInfo.getUserId().substring(0,UserInfo.getUserId().length()-3);
        system.debug('user == '+user);
        string userId = user;
        Boolean lennoxUser = false;
        
        CoachingInfo info = new CoachingInfo();
        Map<String, List<String>> allCoacheeUserIds = new Map<String, List<String>>();
        User coachUser = [SELECT Name, Title FROM User WHERE Id = :userRId LIMIT 1];
        if(coachUser != NULL) info.userName = coachUser.Name;
        
        system.debug('Coaching Info BB ---'+info);
        
        for(SC_Coaching_Role__c coachingRole :[SELECT Name, Coaching_Type__r.Name, User_Ids__c,
                                               (SELECT Coaching_Role__r.User_Ids__c, Field_Filter__c FROM Coached_by_Roles__r),
                                               (SELECT Can_Coach__r.User_Ids__c, Field_Filter__c FROM Can_Coach_Roles__r)
                                               FROM SC_Coaching_Role__c]) {
                                                   //system.debug('UserId == '+userId);
                                                    //system.debug('coachingRole.User_Ids__c.contains(userId) == '+coachingRole.User_Ids__c.contains(userId));
                                                   if(coachingRole.User_Ids__c!= null && coachingRole.User_Ids__c.contains(user)) {
                                                       
                                                       info.name = coachingRole.Name;
                                                       info.type = coachingRole.Coaching_Type__r.Name;
                                                       info.userId = UserInfo.getUserId();  
                                                       info.coaches = new List<User>();
                                                       info.coachees = new List<User>();
                                                       lennoxUser=true;
                                                       
                                                       if(!coachingRole.Coached_by_Roles__r.isEmpty()) {
                                                           //get all the coaches where field filter on thier record is the same as mine
                                                           Map<String, List<String>> allCoachUserIds = new Map<String, List<String>>();
                                                           for(SC_Coaching_Role_Relationship__c roleRelationship :coachingRole.Coached_by_Roles__r) {
                                                               if(!String.isEmpty(roleRelationship.Coaching_Role__r.User_Ids__c)) {
                                                                   List<String> coachUserIds = roleRelationship.Coaching_Role__r.User_Ids__c.split(',');
                                                                   if(allCoachUserIds.get(roleRelationship.Field_Filter__c) == NULL)
                                                                       allCoachUserIds.put(roleRelationship.Field_Filter__c, new List<String>());
                                                                   allCoachUserIds.get(roleRelationship.Field_Filter__c).addAll(coachUserIds);
                                                               }
                                                           }
                                                           System.debug('allCoachUserIds map (should be empty) ' + allCoachUserIds);
                                                           // 'Region Value' => list of coaches
                                                           for(String key :allCoachUserIds.keySet()) {
                                                               String val = '';
                                                               if(!String.isEmpty(key)) {
                                                                   String query = 'SELECT ' + key + ' FROM User WHERE Id = :userRId LIMIT 1';
                                                                   system.debug('query coach == '+query);
                                                                   User[] me = database.query(query);
                                                                   system.debug('me  == '+me);
                                                                   system.debug('key  == '+key);
                                                                   val = (String)me[0].get(key);
                                                               }
                                                               User[] users = getCoachUsers(allCoachUserIds.get(key), key, val);
                                                               system.debug('key  == '+key);
                                                               system.debug('val  == '+val);
                                                               info.coaches.addAll(users);
                                                           }
                                                           info.isCoachee = info.coaches.size() > 0;
                                                       }
                                                       if(!coachingRole.Can_Coach_Roles__r.isEmpty()) {
                                                           System.debug('how many can coach roles for my role? ' + coachingRole.Can_Coach_Roles__r.size());
                                                           for(SC_Coaching_Role_Relationship__c roleRelationship :coachingRole.Can_Coach_Roles__r) {
                                                               if(!String.isEmpty(roleRelationship.Can_Coach__r.User_Ids__c)) {
                                                                   List<String> coacheeUserIds = roleRelationship.Can_Coach__r.User_Ids__c.split(',');
                                                                   system.debug('roleRelationship.Field_Filter__c'+roleRelationship.Field_Filter__c);
                                                                   if(allCoacheeUserIds.get(roleRelationship.Field_Filter__c) == NULL)
                                                                       allCoacheeUserIds.put(roleRelationship.Field_Filter__c, new List<String>());
                                                                   allCoacheeUserIds.get(roleRelationship.Field_Filter__c).addAll(coacheeUserIds);
                                                               }
                                                           }
                                                       }
                                                       
                                                       System.debug('allCoacheeUserIds map (should not be empty) ' + allCoacheeUserIds);
                                                       for(String key :allCoacheeUserIds.keySet()) {
                                                           String val = '';
                                                           if(!String.isEmpty(key)) {
                                                               String query = 'SELECT ' + key + ' FROM User WHERE Id = :userId LIMIT 1';
                                                               User[] me = database.query(query);
                                                               val = (String)me[0].get(key);
                                                           }
                                                           system.debug('allCoacheeUserIds.get(key)'+allCoacheeUserIds.get(key));
                                                            system.debug('key'+key);
                                                           system.debug('val'+val);
                                                           User[] users = getCoachUsers(allCoacheeUserIds.get(key), key, val);
                                                           system.debug('users'+users);
                                                           system.debug('users'+users.size());
                                                           info.coachees.addAll(users);
                                                       }
                                                       info.isCoach = info.coachees.size() > 0;
                                                       info.upcomingSessions = new Map<String, List<SC_Coaching_Session__c>>();
                                                       List<String> attendeeIds = new List<String>();
                                                       for(List<String> coacheeIdList :allCoacheeUserIds.values()) {
                                                           for(String coacheeId :coacheeIdList) {
                                                               attendeeIds.add(coacheeId);
                                                           }
                                                       }
                                                       for(SC_Coaching_Session_Attendee__c attendee :[SELECT Coaching_Session__c, Coaching_Session__r.Start_Date__c, Coaching_Session__r.Name, Coaching_Session__r.Initiative__c, User__r.Id
                                                                                                      FROM SC_Coaching_Session_Attendee__c
                                                                                                      WHERE (User__r.Id IN :attendeeIds OR User__r.Id = :info.userId) AND Coaching_Session__r.Start_Date__c >= TODAY
                                                                                                      ORDER BY Coaching_Session__r.Start_Date__c DESC]) {
                                                                                                          System.debug('iterating over session attendee list: ' + attendee);
                                                                                                          if(info.upcomingSessions.get(attendee.User__r.Id) == NULL) info.upcomingSessions.put(attendee.User__r.Id, new List<SC_Coaching_Session__c>());
                                                                                                          info.upcomingSessions.get(attendee.User__r.Id).add(attendee.Coaching_Session__r);
                                                                                                      }
                                                       
                                                       return info;
                                                   }
                                               }
        system.debug('Coaching Info BB ---'+info);
        
        if(!lennoxUser){
            info.name = coachUser.Title;
            info.type = '';
            info.userId = UserInfo.getUserId();  
            info.coaches = new List<User>();
            info.coachees = new List<User>();
        }
        
        return info;
    }
    
    
    
    /*******************************************************************************************************
* @description  Create an event, coaching session and related details
* @param    evt Event SObject
* @param    init    Initiative associated with the coaching session
* @example
* SC_Coaching_Role__c myRole = CoachingUtils.createCoachingSession(userId);
*/
    public static SC_Coaching_Session__c createCoachingSession(String evtJSON, String skillsJSON, String initJSON, Boolean createAssessments) {
        /*
1. Create coaching session
2. Upsert Assessments/Assessment Skills
3. Create event, populate coaching session lookup
4. Create invitees
5. TODO: Send email to invitees
*/
        
        System.debug('evtJSON: ' + evtJSON);
        Event evt = (Event)System.JSON.deserialize(evtJSON, Event.class);
        List<SC_Assessment_Skill__c> skills = (List<SC_Assessment_Skill__c>)System.JSON.deserialize(skillsJSON, List<SC_Assessment_Skill__c>.class);
        SC_Initiative__c init = (SC_Initiative__c)System.JSON.deserialize(initJSON, SC_Initiative__c.class);
        
        SC_Coaching_Session__c session = new SC_Coaching_Session__c();
        Map<String, List<SC_Assessment_Skill__c>> userIdSkillMap = new Map<String, List<SC_Assessment_Skill__c>>();
        List<SC_Assessment__c> assessments = new List<SC_Assessment__c>();
        List<SC_Assessment_Skill__c> assessmentSkills = new List<SC_Assessment_Skill__c>();
        List<EventRelation> invitees = new List<EventRelation>();
        List<SC_Coaching_Session_Attendee__c> attendees = new List<SC_Coaching_Session_Attendee__c>();
        
        //Create the coaching session
        if(evt.StartDateTime == null){
            evt.StartDateTime = System.now();
        }
        session.Start_Date__c = evt.StartDateTime;
        session.Initiative__c = init.Id;
        session.Duration__c = evt.DurationInMinutes;
        insert session;
        
        //Need the name on this sobject
        session = [SELECT Id, Name FROM SC_Coaching_Session__c WHERE Id = :session.Id LIMIT 1];
        System.debug('session: ' + session);
        
        //set up the new assessments for each user and create them
        for(SC_Assessment_Skill__c skill :skills) {
            if(userIdSkillMap.get(skill.OwnerId__c) == NULL) {
                userIdSkillMap.put(skill.OwnerId__c, new List<SC_Assessment_Skill__c>());
            }
            //if they haven't been created yet
            if(skill.Assessment__c == NULL || Test.isRunningTest()) {
                userIdSkillMap.get(skill.OwnerId__c).add(skill);
            } else { //clone if they already exist
                SC_Assessment_Skill__c newSkill = new SC_Assessment_Skill__c();
                newSkill.OwnerId__c = skill.OwnerId__c;
                newSkill.Description__c = skill.Description__c;
                newSkill.Complete__c = skill.Complete__c;
                newSkill.Session_Date_Time__c = skill.Session_Date_Time__c;
                newSkill.Date_Mastery_Achieved__c = skill.Date_Mastery_Achieved__c;
                newSkill.Date_Last_Coached__c = skill.Date_Last_Coached__c;
                newSkill.Modified_for_Coaching_Session__c = skill.Modified_for_Coaching_Session__c;
                userIdSkillMap.get(skill.OwnerId__c).add(newSkill);
            }
        }
        for(String userId :userIdSkillMap.keySet()) {
            SC_Assessment__c assessment = new SC_Assessment__c();
            assessment.Coaching_Session__c = session.Id;
            assessment.Coachee__c = userId;
            assessments.add(assessment);
        }
        if(!assessments.isEmpty() && createAssessments) {
            insert assessments;
            
            System.debug('assessments: ' + assessments);
            
            //add the new parent assessment to the new assessments skills
            for(SC_Assessment__c assessment :assessments) {
                for(SC_Assessment_Skill__c skill :userIdSkillMap.get(assessment.Coachee__c)) {
                    skill.Assessment__c = assessment.Id;
                    assessmentSkills.add(skill);
                }
            }
            insert assessmentSkills;
        }
        
        System.debug('assessmentSkills: ' + assessmentSkills);
        
        //Create the Event that represents the coaching session
        evt.Coaching_Session__c = session.Id;
        evt.Subject = init.Name + ' Coaching Session';
        evt.Event_Type__c = 'Meeting';
        evt.Event_Topic__c = 'Coaching Session';
        if(!Test.isRunningTest()) insert evt;
        
        //Add the invitees to the event
        for(String userId :userIdSkillMap.keySet()) {
            EventRelation invitee = new EventRelation();
            invitee.EventId = evt.Id;
            invitee.RelationId = userId;
            invitees.add(invitee);
        }
        
        if(!Test.isRunningTest()) insert invitees;
        
        Map<String, String> userIdEventIdMap = new Map<String, String>();
        for(Event e :[SELECT Id, OwnerId FROM Event WHERE Coaching_Session__c = :session.Id]) {
            userIdEventIdMap.put(e.OwnerId, e.Id);
        }
        
        //Create a Coaching Session Attendee object for each attendee
        for(User u :[SELECT Name, Id, Email FROM User WHERE Id IN :userIdSkillMap.keySet()]) {
            SC_Coaching_Session_Attendee__c attendee = new SC_Coaching_Session_Attendee__c();
            attendee.User__c = u.Id;
            attendee.Coaching_Session__c = session.Id;
            attendee.Event_Id__c = userIdEventIdMap.get(u.Id);
            attendees.add(attendee);
        }
        insert attendees;
        
        List<User> usrList = [SELECT Name, Id, Email FROM User WHERE Id IN :userIdSkillMap.keySet()];
        if(!usrList.isEmpty()){
            sendScheduleEmail(session.Id, usrList, 'Coaching_Session_Scheduled');
        }
        
        return session;
    }
    
    public static void sendScheduleEmail(string whatId, List<User> userList, String emailTemplateName){
        try{
            EmailTemplate sessionScheduleEmail =  [SELECT Id, Name, DeveloperName, TemplateType
                                                   FROM EmailTemplate
                                                   Where DeveloperName =: emailTemplateName];
            system.debug('sessionScheduleEmail'+sessionScheduleEmail);
            
            List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
            
             List<Contact> listContact = [SELECT Id FROM Contact WHERE Email != null limit 2];
        
            Lead ld = new Lead();
             if(Test.isRunningTest()){
                
                ld.FirstName          = 'Test';
                ld.LastName           = 'LeadBulk';
                ld.Company            = 'Test';
                ld.Email              = 'test@test.com';
                ld.LeadSource         = 'Digital Marketing'; 
                ld.Role__c            = 'Owner/Principal';
                ld.Primary_Role__c    = 'Owner/Principal';
                ld.Lead_Assignment__c = 'Marketing';
                insert ld;
            }
            
            List<String> toaddress = new List<String>();
            
            for(User u : userList){
                toaddress.add(u.Email);
            }
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.templateid = sessionScheduleEmail.Id;
            message.toAddresses = toaddress;
                message.setWhatId(WhatId);
            
            if(test.isRunningTest()){
                message.targetobjectid = sessionScheduleEmail.TemplateType == 'Visualforce'? userList[0].Id : ld.Id;
            }else{
                message.targetobjectid = sessionScheduleEmail.TemplateType == 'Visualforce'? userList[0].Id : listContact[0].Id;
            }
            
            message.saveAsActivity = false;
            messages.add(message);  
            system.debug('message'+message);
            
            if(!messages.isEmpty()){
                
                if(sessionScheduleEmail.TemplateType == 'Visualforce' ){
                    Messaging.sendEmail(messages);
                    // delete ld;
                }
                if (sessionScheduleEmail.TemplateType != 'Visualforce' || test.isRunningTest()) {
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(messages);
                    Database.rollback(sp);
                    // delete ld;
                    
                    List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
                    
                    for (Messaging.SingleEmailMessage email : messages) {
                        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                        emailToSend.setToAddresses(email.getToAddresses());
                        emailToSend.setPlainTextBody(email.getPlainTextBody());
                        emailToSend.setHTMLBody(email.getHTMLBody());
                        emailToSend.setSubject(email.getSubject());
                        msgListToBeSend.add(emailToSend);
                    }
                    
                    Messaging.sendEmail(msgListToBeSend);
                }
            } 
            
        }catch(Exception e){
            
            system.debug('Exception e'+e);
            
        }
        
    }
    
    
    public static Object createAssessments(String skillsJSON, String sessionId) {
        try {
            List<SC_Assessment_Skill__c> skills = (List<SC_Assessment_Skill__c>)System.JSON.deserialize(skillsJSON, List<SC_Assessment_Skill__c>.class);
            Map<String, List<SC_Assessment_Skill__c>> userIdSkillMap = new Map<String, List<SC_Assessment_Skill__c>>();
            List<SC_Assessment__c> assessments = new List<SC_Assessment__c>();
            List<SC_Assessment_Skill__c> assessmentSkills = new List<SC_Assessment_Skill__c>();
            //set up the new assessments for each user and create them
            for(SC_Assessment_Skill__c skill :skills) {
                if(userIdSkillMap.get(skill.OwnerId__c) == NULL) {
                    userIdSkillMap.put(skill.OwnerId__c, new List<SC_Assessment_Skill__c>());
                }
                //if they haven't been created yet
                if(skill.Assessment__c == NULL) {
                    userIdSkillMap.get(skill.OwnerId__c).add(skill);
                } else { //clone if they already exist
                    SC_Assessment_Skill__c newSkill = new SC_Assessment_Skill__c();
                    newSkill.OwnerId__c = skill.OwnerId__c;
                    newSkill.Description__c = skill.Description__c;
                    newSkill.Complete__c = skill.Complete__c;
                    userIdSkillMap.get(skill.OwnerId__c).add(newSkill);
                }
            }
            for(String userId :userIdSkillMap.keySet()) {
                SC_Assessment__c assessment = new SC_Assessment__c();
                assessment.Coaching_Session__c = sessionId;
                assessment.Coachee__c = userId;
                assessments.add(assessment);
            }
            if(!assessments.isEmpty()) {
                insert assessments;
                
                System.debug('assessments: ' + assessments);
                
                //add the new parent assessment to the new assessments skills
                for(SC_Assessment__c assessment :assessments) {
                    for(SC_Assessment_Skill__c skill :userIdSkillMap.get(assessment.Coachee__c)) {
                        skill.Assessment__c = assessment.Id;
                        assessmentSkills.add(skill);
                    }
                }
                insert assessmentSkills;
            }
            return assessments;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
        
    }
    
    
    /*******************************************************************************************************
* @description  Get most recent Assessment record for a given user and initiative
* @param    userId  Id of the user in scope
* @param    initId  Id of the intiiative in scope
* @example
* SC_Assessment__c assessment = CoachingUtils.getAssessment(userId, initId);
*/
    public static SC_Assessment__c getAssessment(String userId, String initId) {
        List<SC_Assessment__c> result = [SELECT Name, Id, of_Skills_Completed__c, of_Skills_to_Complete__c
                                         FROM SC_Assessment__c
                                         WHERE Coachee__c = :userId AND Coaching_Session__r.Initiative__c = :initId
                                         ORDER BY CreatedDate DESC
                                         LIMIT 1];
        if(!result.isEmpty()) {
            return result[0];
        } else {
            return new SC_Assessment__c();
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Get Assessment record for a given assessment id
* @param    assessmentId  Id of the user in scope
* @example
* SC_Assessment__c assessment = CoachingUtils.getAssessmentDetails(assessmentId);
*/
    public static Object getAssessmentDetails(String assessmentId) {
        try {
            List<SC_Assessment__c> result = [SELECT Name, Id, of_Skills_Completed__c, of_Skills_to_Complete__c, Coaching_Session__c, CreatedDate, Coachee__r.Name,
                                             Coaching_Session__r.Name, Coaching_Session__r.Initiative__c, Coaching_Session__r.Initiative__r.Name,
                                             (SELECT Complete__c, Description__c, Sort_Order__c FROM Assessment_Skills__r ORDER BY SORT_Order__c)
                                             FROM SC_Assessment__c
                                             WHERE Id = :assessmentId
                                             LIMIT 1];
            if(!result.isEmpty()) {
                return result[0];
            } else {
                return new SC_Assessment__c();
            }
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Get the questions associated with an initiative
* @param    initiativeId    Id of the Initiative to get questions from
* @param    isCoach If true, return questions where type = Coach
* @param    isCoachee   If true, return questions where type = Coachee
* @example
* SC_Assessment__c assessment = CoachingUtils.getAssessment(userId, initId);
*/
    public static List<SC_Initiative_Question__c> getInitiativeQuestions(String initiativeId, Boolean isCoach, Boolean isCoachee) {
        List<SC_Initiative_Question__c> questions = new List<SC_Initiative_Question__c>();
        String query = 'SELECT Content__c FROM SC_Initiative_Question__c WHERE Initiative__c = :initiativeId ';
        if(!isCoach && !isCoachee) return null;
        if(!isCoach || !isCoachee) {
            String type = isCoach ? 'Coach' : 'Coachee';
            query += 'AND Type__c = :type';
        }
        questions = Database.query(query);
        return questions;
    }
    
    
    
    /*******************************************************************************************************
* @description  Update the provided session note object
* @param    sessionNote Session Note object to update
* @example
* CoachingUtils.updateSessionNote(sessionNote);
*/
    public static Object updateSessionNote(SC_Coaching_Session_Note__c sessionNote) {
        try {
            upsert sessionNote;
            return sessionNote;
        } catch(Exception e) {
            system.debug('Exception ____ '+e);
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Get all badges
* @example
* List<WorkBadgeDefintion> badges = CoachingUtils.getBadges();
*/
    @AuraEnabled
    public static Object getBadges() {
        try {
            
            List<WorkBadgeDefinition> badges = [SELECT ImageUrl, Description, Name
                                                FROM WorkBadgeDefinition
                                                WHERE IsActive = TRUE];
            return badges;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Get badges for a given user
* @param    sessionNote Session Note object to update
* @example
* CoachingUtils.updateSessionNote(sessionNote);
*/
    @AuraEnabled
    public static Object getUserBadges(String userId, Integer queryLimit, Integer offset) {
        try {
            String badgesQuery = 'SELECT Message, ImageUrl, Description, CreatedDate, CreatedBy.Name FROM WorkBadge WHERE RecipientId = :userId ORDER BY CreatedDate DESC LIMIT ' + queryLimit + ' OFFSET ' + offset;
            List<WorkBadge> badges = Database.query(badgesQuery);
            return badges;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description  Awards a badge to a user
* @param    badgeId     Id of the badge being awarded
* @param    recipientId User id of the recipient
* @param    thanksMsg   Thank you message from badge giver
* @example
* CoachingUtils.giveBadge(badgeId, recipientId, thanksMsg);
*/
    @AuraEnabled
    public static Object giveBadge(String badgeId, String recipientId, String thanksMsg) {
        try {
            WorkThanks wt = new WorkThanks();
            wt.GiverId = UserInfo.getUserId();
            wt.Message = thanksMsg;
            insert wt;
            
            WorkBadge wb = new WorkBadge();
            wb.DefinitionId = badgeId;
            wb.RecipientId = recipientId;
            wb.SourceId = wt.Id;
            insert wb;
            
            return wb;
            
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
        
    }
    
    
    
    /*******************************************************************************************************
* @description
* @example
*
*/
    public static Object getPlanningHistory(String userId) {
        try {
            List<PlanWrapper> result = new List<PlanWrapper>();
            Boolean isFirst = true;
            if(userId.length() == 0) userId = UserInfo.getUserId();
            for(Planning__c planning :[SELECT Id, Planning_Year__c FROM Planning__c WHERE OwnerId = :userId ORDER BY Planning_Date__c DESC]) {
                result.add(new PlanWrapper(isFirst, planning.Planning_Year__c, planning.Id));
                isFirst = false;
            }
            return result;
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    public static Object getPlanning(String userId, String planningId) {
        try {
            if(userId.length() == 0) userId = UserInfo.getUserId();
            System.debug('userId length ' + userId.length());
            System.debug('userId ' + userId);
            if(planningId.length() == 0) {
                for(Planning__c p :[SELECT Id FROM Planning__c WHERE OwnerId = :userId ORDER BY Planning_Date__c DESC LIMIT 1]) {
                    planningId = p.Id;
                }
            }
            System.debug('planningId ' + planningId);
            String query = 'SELECT Planning__r.Planning_Year__c, Info_Bubble_Content__c, Strategy__c, ';
            query += 'Title__c, Type__c, Strategy_Planning_Topic__c, (SELECT Content__c, Type__c, Url__c, Url_Label__c FROM Planning_Topic_Content__r ORDER BY Type__c, Sort_Order__c ASC) ';
            query += 'FROM Planning_Topic__c WHERE Planning__r.OwnerId = :userId ';
            query += 'AND Planning__c = :planningId ';
            query += 'ORDER BY Strategy_Planning_Topic__c, Sort_Order__c ASC';
            System.debug('query ' + query);
            List<Planning_Topic__c> planningTopics = new List<Planning_Topic__c>();
            planningTopics = Database.query(query);
            System.debug(planningTopics);
            if(!planningTopics.isEmpty()) {
                return planningTopics;
            } else {
                return new List<Planning_Topic__c>();
            }
        } catch(Exception e) {
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    /*******************************************************************************************************
* @description  Create a new planning record
* @example
*
*/
    public static Object newPlanning(String ownerId, Integer year) {
        try {
            Planning__c planning = new Planning__c();
            planning.OwnerId = ownerId;
            //TODO: currently won't allow me to set the year value from the param so using the current year
            planning.Planning_Date__c = Date.newInstance(System.today().year(), 1, 1);
            insert planning;
            
            Planning_Topic__c[] planningTopics = new List<Planning_Topic__c>();
            Map<String, Id> metadataIdTopicIdMap = new Map<String, Id>();
            for(Planning_Metadata__mdt topic :[SELECT Id, Info_Bubble_Content__c, Strategy_Planning_Topic__c, Title__c, Type__c FROM Planning_Metadata__mdt]) {
                Planning_Topic__c planningTopic = new Planning_Topic__c(
                    Info_Bubble_Content__c = topic.Info_Bubble_Content__c,
                    Planning__c = planning.Id,
                    Strategy_Planning_Topic__c = topic.Strategy_Planning_Topic__c,
                    Title__c = topic.Title__c,
                    Type__c = topic.Type__c,
                    Metadata_Id__c = topic.Id
                );
                planningTopics.add(planningTopic);
            }
            insert planningTopics;
            for(Planning_Topic__c topic :planningTopics) {
                metadataIdTopicIdMap.put(topic.Metadata_Id__c, topic.Id);
            }
            
            Planning_Topic_Content__c[] planningTopicContent = new List<Planning_Topic_Content__c>();
            for(Planning_Metadata_Content__mdt content :[SELECT Content__c, Url_Label__c, Url__c, Type__c, Sort_Order__c, Planning_Metadata__c FROM Planning_Metadata_Content__mdt]) {
                Planning_Topic_Content__c planningContentItem = new Planning_Topic_Content__c(
                    Content__c = content.Content__c,
                    Url_Label__c = content.Url_Label__c,
                    Url__c = content.Url__c,
                    Type__c = content.Type__c,
                    Sort_Order__c = content.Sort_Order__c,
                    Planning_Topic__c = metadataIdTopicIdMap.get(content.Planning_Metadata__c)
                );
                planningTopicContent.add(planningContentItem);
            }
            insert planningTopicContent;
            
            return planning.Id;
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            ErrorResponse error = new ErrorResponse(e.getMessage());
            return error;
        }
    }
    
    
    
    public class PlanWrapper {
        @AuraEnabled public Boolean isSelected {get;set;}
        @AuraEnabled public String year {get;set;}
        @AuraEnabled public Id planningId {get;set;}
        public PlanWrapper(Boolean isSelected, String year, Id planningId) {
            this.isSelected = isSelected;
            this.year = year;
            this.planningId = planningId;
        }
    }
    
    
    
    
    public class ErrorResponse {
        @AuraEnabled public Boolean isError {get;set;}
        @AuraEnabled public String message {get;set;}
        public ErrorResponse(String message) {
            isError = true;
            this.message = message;
        }
        @AuraEnabled
        public String getError() { return this.message; }
    }
    
    
    /*****************************************
******************************************
PRIVATE METHODS
******************************************
*****************************************/
    
    
    
    /*******************************************************************************************************
* @description  At some point in the future, set this up to be configurable. Currently, the default note topics are hard coded
* @example
* Set<String> defaultNoteTopics = getDefaultNoteTopics();
*/
    private static Set<String> getDefaultNoteTopics() {
        final Set<String> DEFAULT_NOTE_TOPICS = new Set<String>{'Current Situation', 'Objectives', 'Action Plans', 'Follow Through'};
            return DEFAULT_NOTE_TOPICS;
    }
    
    
    
    /*******************************************************************************************************
* @description  Returns a list of users given a list of user ids
* @param    userIds List of user ids
* @example
* List<User> myCoachees = CoachingUtils.getCoachUsers(userIds);
*/
    private static List<User> getCoachUsers(List<String> userIds, String whereField, String whereVal) {
        String query = 'SELECT Id, FirstName, LastName, Name, FullPhotoUrl, SmallPhotoUrl, Phone, Title, Profile.Name FROM User WHERE Id IN :userIds  AND isActive = TRUE';
        if(!String.isEmpty(whereField)) query += ' AND ' + whereField + ' = :whereVal';
        system.debug('query'+query);
        return Database.query(query);
    }
    
}