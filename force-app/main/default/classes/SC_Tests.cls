@isTest
private class SC_Tests {



    //Trigger tests
    @isTest static void testCoachingRoleTriggers() {
        SC_Initiative__c init = createTestInitiative(); 
        SC_Coaching_Session__c cs = createTestCoachingSession(init.Id);        
        SC_CoachingAcceptModuleController.updateCoachingSession(cs, true);
        CoachingUtils.respondToInvite(true, string.valueOf(cs.Id), string.valueOf(cs.Id));
    }


    @isTest static void testReapondToinvite(){
        
    }

    //Controller tests
    @isTest static void testControllerMethods() {

        /*
            Test the triggers and set up user and coaching role
        */
        Id adminId = UserInfo.getUserId();
        User admin = [SELECT Id FROM User WHERE Id = :adminId];
        User u = createTestUser();
        User coachee = createTestCoachee();

        SC_Coaching_Type__c type = createTestCoachingtype();

        SC_Coaching_Role__c role = createTestCoachingRole();
        role.Coaching_Type__c = type.Id;

        SC_Coaching_Role_Assignment_Criterion__c criterion = createTestCoachingAssignmentCriterion(role.Id);

        SC_Coaching_Role__c createdRole = [SELECT Generated_SOQL__c, User_Ids__c FROM SC_Coaching_Role__c WHERE Id = :role.Id LIMIT 1];
        String initialVal = createdRole.Generated_SOQL__c;
        List<String> roleUserIds = createdRole.User_Ids__c.split(',');
        String coacheeId = roleUserIds[0];

        System.assert(!String.isEmpty(initialVal));

        criterion.value__c = 'new value';
        update criterion;

        SC_Coaching_Role__c updatedRole = [SELECT Generated_SOQL__c FROM SC_Coaching_Role__c WHERE Id = :role.Id LIMIT 1];
        String secondaryVal = updatedRole.Generated_SOQL__c;

        System.assertNotEquals(initialVal, secondaryVal);

        delete criterion;

        SC_Coaching_Role__c roleDeletedCriterion = [SELECT Generated_SOQL__c FROM SC_Coaching_Role__c WHERE Id = :role.Id LIMIT 1];
        System.assert(String.isEmpty(roleDeletedCriterion.Generated_SOQL__c));

        //add it back so u.Id is there
        createTestCoachingAssignmentCriterion(role.Id);
        System.debug('new role ' + [SELECT Id, Name, Generated_SOQL__c, User_Ids__c FROM SC_Coaching_Role__c WHERE Id = :role.Id LIMIT 1]);

        //Create the event as system user first; can't create it running as test user below
        Event evtSession = createTestEvent();


        System.runAs(u) {
            User retrievedUser = SC_CoacheeDetailController.getUser(UserInfo.getUserId());
            System.assertEquals(UserInfo.getUserId(), retrievedUser.Id);
            CoachingInfo info = CoachingUtils.getCoachingInfo(coacheeId);


            SC_Initiative__c init = createTestInitiative();
            SC_Initiative__c childInit = createTestInitiative();
            childInit.Parent_Initiative__c = init.Id;
            update init;


            SC_Initiative_Question__c initCoachQuestion = createTestInitiativeQuestion(childInit.Id, 'Coach');
            SC_Initiative_Question__c initCoacheeQuestion = createTestInitiativeQuestion(childInit.Id, 'Coachee');

            SC_Skill__c skill = createSkill(childInit.Id);
            createRoleSkillAssignment(createdRole.Id, skill.Id);
            System.debug('coachee from test: ' + coachee);
            List<SC_Assessment_Skill__c> assessmentSkills = SC_CoacheeAssessmentController.getAssessmentSkills(coachee.Id, childInit.Id);
            System.assert(assessmentSkills.size() > 0, 'There are no assessment skills');
            
            init.Coaching_Type__r = createTestCoachingtype();
            SC_Initiative__c retrievedInit = SC_InitiativeDetailController.getInitiative(init.Id);
            System.assertEquals(retrievedInit.Id, init.Id);

            List<SC_Initiative__c> inits = SC_SelectInitiativesController.getInitiatives('Test Type', init.Id);
            SC_Initiative__c initReports = SC_NewCoachingSessionController.getInitReports(init.Id);
            System.assert(inits.size() == 0);

            SC_Coaching_Session__c cs = createTestCoachingSession(init.Id);

            evtSession.Coaching_Session__c = cs.Id;
            update evtSession;

            EventRelation attendee = new EventRelation();
            attendee.EventId = evtSession.Id;
            attendee.RelationId = coachee.Id;
            insert attendee;

            SC_Coaching_Session_Note__c sessionNote = createTestSessionNote(cs.Id, 'Coach');

            List<SC_Coaching_Session__c> upcomingSessions = SC_UserSessionsController.getCoachingSessions(coachee.Id, NULL, true, false, 10, 0);
            List<SC_Coaching_Session__c> pastSessions = SC_UserSessionsController.getCoachingSessions(coachee.Id, NULL, false, false, 10, 0);
            // test public static List<SC_Coaching_Session__c> getSessionsByOwner(String ownerId, Boolean returnFutureSessions, Boolean returnPastSessions, Integer queryLimit, Integer offset)
            List<SC_Coaching_Session__c> sessionsByOwner = SC_UserSessionsController.getSessionsByOwner(u.Id, false, false, 10, 0);
            System.assert(upcomingSessions.size() > 0);
            System.assert(pastSessions.size() == 0);
            System.assert(sessionsByOwner.size() > 0);



            //getSessionAttendeesAsString
            String sessionAttendeesStr = CoachingUtils.getSessionAttendeesAsString(cs.Id);

            //test the CoachingSessionController
            
            SC_Coaching_Session__c coachingSession = SC_CoachingSessionController.getCoachingSession(upcomingSessions[0].Id);
            //SC_Coaching_Session__c coachingSession1 = SC_CoachingAcceptModuleController.getCoachingSession(upcomingSessions[0].Id);
            //SC_CoachingAcceptModuleController.updateAttendeeStatus('Rescheduled and Accepted by Coach', coachingSession1.Id, coachingSession1.OwnerId, true);
            List<SC_Initiative_Question__c> initQuestions = SC_CoachingSessionController.getInitiativeQuestions(childInit.Id, true, true);
            System.debug('initQuestions ' + initQuestions); 
            SC_CoachingSessionController.updateCoachingSession(coachingSession, true);
            //SC_CoachingAcceptModuleController.updateCoachingSession(coachingSession, true);
            SC_Coaching_Session__c clonedCoachingSession = coachingSession.clone(false, true, false, false);
            SC_CoachingSessionController.deleteCoachingSession(clonedCoachingSession.Id, string.valueof(cs.Start_Date__c));
            //test checkIfAttendeeAccepted
            String relationId = (String)SC_CoachingSessionController.checkIfAttendeeAccepted(upcomingSessions[0].Id, coachee.Id);
            // test public static Object respondToInvite(Boolean isAccepted, String relationId) {
            //SC_CoachingSessionController.respondToInvite(true, attendee.RelationId, cs.id);
           // SC_CoachingAcceptModuleController.respondToInvite(true, attendee.RelationId, cs.id);

            System.assert(coachingSession.get('Name') != NULL, 'The coaching session should was not retrieved');
            System.assert(!initQuestions.isEmpty(), 'There should be initiative questions associated with this initiative');

            try {
                sessionNote.Note__c = 'update the note';
                SC_CoachingSessionNoteController.updateSessionNote(sessionNote);
            } catch(Exception e) {
                System.debug('problem with updateSessionNotes: ' + e.getMessage());
            }


            System.assert(sessionNote.Note__c == 'update the note', 'The note should have been updated.');



            SC_Assignment__c completeAss = createTestAssignment(coachee, cs, true);
            SC_Assignment__c incompleteAss = createTestAssignment(coachee, cs, false);
            List<SC_Assignment__c> retrievedIncompleteAssignments = SC_UserAssignmentsController.getAssignments(new List<String>{coachee.Id}, init.Id, NULL, false, false, 1, 0);
            List<SC_Assignment__c> retrievedCompleteAssignments = SC_UserAssignmentsController.getAssignments(new List<String>{coachee.Id}, init.Id, NULL, true, false, 1, 0);
            List<SC_Assignment__c> retrievedAllAssignments = CoachingUtils.getAssignments(new List<String>{coachee.Id}, init.Id, NULL, 1, 0);
            System.assert(retrievedIncompleteAssignments.size() > 0, 'not more than one incomplete assignments');
            System.assert(retrievedCompleteAssignments.size() > 0, 'not more than one completed assignments');
            System.assert(retrievedAllAssignments.size() > 0, 'not more than one assignments');

            //test createAssignments(SC_Assignment__c assignment, String[] userIds)
            SC_Assignment__c[] assignmentsTest = (List<SC_Assignment__c>)CoachingUtils.createAssignments(completeAss, new List<String>{coachee.Id});
            SC_NewAssignmentController.createAssignments(completeAss, new List<String>{coachee.Id});
            System.assert(assignmentsTest.size() > 0, 'Should have received a list of assignments');


            SC_Assignment__c retrievedAssignment = retrievedIncompleteAssignments[0];
            //test getting an assignment
            SC_AssignmentController.getAssignment(retrievedAssignment.Id);
            //test incrementing assignment progress
            SC_AssignmentController.updateAssignmentProgress(retrievedAssignment, true);
            //test completing an assignment
            SC_AssignmentController.completeAssignment(retrievedAssignment);
            //test updating the assignments
            Boolean isUpdated = SC_AssignmentController.updateAssignment(retrievedAssignment);
            System.assert(isUpdated, 'This assignment should have been updated');

            //set up creating a coaching sessions
            Event evt = new Event();
            evt.StartDateTime = System.now();
            evt.DurationInMinutes = 60;
            insert evt;
            String JSONevt = JSON.serialize(evt);
            EventRelation er = new EventRelation(EventId = evt.Id, RelationId = coacheeId);
            insert er;

            for(SC_Assessment_Skill__c assSkill :assessmentSkills) {
                assSkill.OwnerId__c = coachee.Id;
            }
            String JSONskills = JSON.serialize(assessmentSkills);
 
            String JSONinit = JSON.serialize(init);
            SC_Coaching_Session__c session = SC_NewCoachingSessionController.createCoachingSession(JSONevt, JSONskills, JSONinit, true);
            //TODO: add system.assert for this test
            
            SC_NewCoachingSessionController.createAssessments(JSONskills, session.Id);
            SC_CoachingAcceptModuleController.getEventRelationId(new List<Event>{evt});


            //Coaching session is created... simulate retrieving the initial assessment that was created as part of createCoachingSession
            SC_Assessment__c retrievedAssessment = SC_SkillMasteryController.getAssessment(coachee.Id, init.Id);
            System.assert(retrievedAssessment != NULL, 'An Assessment was not created when createCoachingSession was invoked.');

            //Simulate viewing the My Coaching component as a coachee
            User retrievedCoachee = SC_MyCoachingController.getUser(coacheeId);
            System.assert(retrievedCoachee != NULL, 'The User does not exist');

            //Simulate viewing the InitiativeUser Component (get an initiative);
            SC_Initiative__c retrievedInit2 = SC_InitiativeUserDetailController.getInitiative(init.Id);
            System.assert(retrievedInit2 != NULL, 'SC_InitiativeUserDetailController.getInitiative returned a NULL object.');

            //TODO: add system.assert for this test
            SC_InitiativeUserDetailController.getInitiativeSkills(childInit.Id);

            //Simulate viewing the Doashboard Reports Page
            PageReference drPageRef = Page.SC_DashboardReports;
            SC_DashboardReportsController drController = new SC_DashboardReportsController();
            Test.setCurrentPage(drPageRef);
            ApexPages.currentPage().getParameters().put('reportId', '123,456');
            drController = new SC_DashboardReportsController();

            //Simulate viewing the history chart controller
            SC_CoachingHistoryChartController.getAssessments(coachee.Id, init.Id);

            /*******
                TEST Badges
            *******/
            WorkBadgeDefinition testBadge = createWorkBadge();

            List<WorkBadgeDefinition> badges = (List<WorkBadgeDefinition>)SC_GiveBadgeController.getBadges();
            WorkBadge givenBadge = (WorkBadge)SC_GiveBadgeController.giveBadge(badges[0].Id, admin.Id, 'thanks message');
            List<WorkBadge> userBadges = (List<WorkBadge>)SC_UserBadgesConroller.getUserBadges(u.Id, 10, 0);
            //System.assert(!badges.isEmpty(), 'badges list should not be empty :(');
            //System.assert(!userBadges.isEmpty(), 'user badges list should not be empty :(');





            /*******
                TEST VIEWING ASSESSMENTS/ASSESSMENT DETAIL
            *******/
            List<SC_Assessment__c> assessments = (List<SC_Assessment__c>)SC_AssessmentsController.getAssessments(coachee.Id, init.Id, session.Id, 1, 0); //should return 1 assessment
            /*System.assert(assessments.size() == 1, 'SC_AssessmentsController.getAssessments did not return any assessments. Expected 1 result');
            SC_Assessment__c assessment = (SC_Assessment__c)SC_AssessmentDetailController.getAssessmentDetails(assessments[0].Id);
            System.assert(assessment.Id == assessments[0].Id, 'SC_AssessmentDetailController.getAssessmentDetails should return the same record as getAssessments');*/

            //test getMyCoachingInfo
            //CoachingUtils.getMyCoachingInfo();
            SC_ContainerController.getCoachingInfo();

            SC_Coaching_Role__c anotherRole = createTestCoachingRole();
            SC_Coaching_Role_Relationship__c rel = new SC_Coaching_Role_Relationship__c();
            rel.Can_Coach__c = role.Id;
            rel.Coaching_Role__c = anotherRole.Id;
            rel.Field_Filter__c = 'SAP_Sales_Office__c';
            Insert rel;
            ApexPages.StandardController sCnt = new ApexPages.StandardController(rel);
            SC_NewEditCoachingRoleRelationshipExt cExt = new SC_NewEditCoachingRoleRelationshipExt(sCnt);

            Planning__c p = new Planning__c();
            insert p;
            Planning_Topic__c pt = new Planning_Topic__c();
            pt.Planning__c = p.Id;
            insert pt;
            SC_PlanningTopicController.updateTopicStrategy(pt.Id, 'strategy');

            SessionController.getSessionId();

        }
    }

    @isTest
    public static void testCheckRecursive(){
        checkRecursive.runOnce();
        checkRecursive.runOnce();
    }

    public static testmethod void test(){
        
        SC_Coaching_Session__c session = new SC_Coaching_Session__c();
        session.Start_Date__c = system.now();
        session.Duration__c = 60;
        insert session;
        
        SC_Assessment__c assessment = new SC_Assessment__c();
        assessment.Coaching_Session__c = session.Id;
        insert assessment;
        
        SC_Assessment_Skill__c skil = new SC_Assessment_Skill__c();
        skil.Description__c = 'Consistently updates and maintains an accurate forecast.';
        skil.Assessment__c = assessment.Id;
        skil.Session_Date_Time__c = session.Start_Date__c;
        insert skil;
        List<SC_Assessment_Skill__c> skilList = new List<SC_Assessment_Skill__c>();
        skilList.add(skil);
        string json = JSON.serialize(skilList);
        SC_CoacheeAssessmentController.resetMasterySkills(json);
        
        SC_Coaching_Session_Attendee__c attendee = new SC_Coaching_Session_Attendee__c();
        attendee.User__c = UserInfo.getUserId();
        attendee.Coaching_Session__c = session.Id;
        
        SC_CoachingAcceptModuleController.getCoachingSession(session.Id);
        SC_CoachingSessionAssessmentSkillsCtrl.getAssessmentSkillsForSession(session.Id);
        SC_CoachingSessionAssessmentSkillsCtrl.updateSkillsForSession(skilList, session.Id);
        string status = 'Rescheduled and Accepted by Coach';
        SC_CoachingAcceptModuleController.updateAttendeeStatus(status, session.Id, UserInfo.getUserId(), false);
        SC_CoachingSessionController.updateAttendeeStatus(status, session.Id, UserInfo.getUserId(), false);
        SC_Assessment__c assessments = (SC_Assessment__c)SC_AssessmentDetailController.getAssessmentDetails(assessment.Id);
        CoachingUtils.deleteCoachingSession(session.Id, string.valueOf(session.Start_Date__c));
        SC_People_Controller.getCoacheeTeam('test', UserInfo.getUserId());
        
        
        
        /*******
        TEST PLANNING
        *******/
        
        User currentPlanningUser = SC_PlanningController.getUser('');
        String planningId = String.valueOf(SC_PlanningController.newPlanning('', System.Today().year()));
        SC_PlanningController.getPlanningHistory('');
        SC_PlanningController.getPlanning(currentPlanningUser.Id, planningId);
        
    }
    static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='132435465780testuser0897866443zas@test.com');
        insert u;
        return u;
    }

    static User createTestCoachee() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='coacheetest@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Coachee', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='132435465780testcoachee@test.com');
        insert u;
        return u;
    }

    static SC_Coaching_Type__c createTestCoachingType() {
        SC_Coaching_Type__c type = new SC_Coaching_Type__c();
        type.Name = 'Test Type';
        insert type;
        return type;
    }

    static SC_Coaching_Role__c createTestCoachingRole() {
        SC_Coaching_Role__c role = new SC_Coaching_Role__c();
        role.Name = 'Test Role';
        insert role;
        return role;
    }

    static SC_Initiative__c createTestInitiative() {
        SC_Initiative__c init = new SC_Initiative__c();
        init.Name = 'Test Init';
        insert init;
        return init;
    }

    static SC_Initiative_Question__c createTestInitiativeQuestion(String initId, String type) {
        SC_Initiative_Question__c initQuestion = new SC_Initiative_Question__c();
        initQuestion.Content__c = 'test content';
        initQuestion.Initiative__c = initId;
        initQuestion.Type__c = type;
        insert initQuestion;
        return initQuestion;
    }

    static Event createTestEvent() {
        Event evt = new Event();
        evt.Subject = 'Test';
        evt.ActivityDateTime = System.now().addDays(1);
        evt.DurationInMinutes = 60;
        insert evt;
        return evt;
    }

    static SC_Coaching_Session__c createTestCoachingSession(String initId) {
        SC_Coaching_Session__c cs = new SC_Coaching_Session__c();
        cs.Start_Date__c = System.now().addDays(1);
        cs.Initiative__c = initId;
        insert cs;
        return cs;
    }

    static SC_Assignment__c createTestAssignment(User coachee, SC_Coaching_Session__c session, Boolean isComplete) {
        SC_Assignment__c ass = new SC_Assignment__c();
        ass.Assignee__c = coachee.Id;
        ass.Coaching_Session__c = session.Id;
        ass.Description__c = 'test';
        ass.Due_Date__c = System.today();
        ass.Status__c = isComplete ? 'Complete' : 'Incomplete';
        ass.Progress_Assignment__c = TRUE;
        ass.to_Complete__c = 4;
        ass.Complete__c = 0;
        insert ass;
        return ass;
    }

    static SC_Coaching_Session_Note__c createTestSessionNote(String sessionId, String type) {
        SC_Coaching_Session_Note__c note = new SC_Coaching_Session_Note__c();
        note.Category__c = 'trst';
        note.Coaching_Session__c = sessionId;
        note.Note__c = 'test note';
        note.Type__c = type;
        insert note;
        return note;
    }


    static SC_Coaching_Role_Assignment_Criterion__c createTestCoachingAssignmentCriterion(Id coachingRoleId) {
        SC_Coaching_Role_Assignment_Criterion__c criterion = new SC_Coaching_Role_Assignment_Criterion__c();
        criterion.Coaching_Role__c = coachingRoleId;
        criterion.Field__c = 'Profile';
        criterion.Operator__c = 'Equals';
        criterion.Value__c = 'System Administrator';
        insert criterion;
        return criterion;
    }

    static SC_Skill__c createSkill(String initId) {
        SC_Skill__c skill = new SC_Skill__c();
        skill.Description__c = 'test skill';
        skill.Initiative__c = initId;
        insert skill;
        return skill;
    }

    static SC_Coaching_Role_Skill_Assignment__c createRoleSkillAssignment(String roleId, String skillId) {
        SC_Coaching_Role_Skill_Assignment__c roleSkillAssignment = new SC_Coaching_Role_Skill_Assignment__c();
        roleSkillAssignment.Skill__c = skillId;
        roleSkillAssignment.Coaching_Role__c = roleId;
        insert roleSkillAssignment;
        return roleSkillAssignment;
    }

    static WorkBadgeDefinition createWorkBadge() {
        WorkBadgeDefinition result = new WorkBadgeDefinition();
        Document document = new Document();
        document.Body = Blob.valueOf('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAABGdBTUEAALGPC/xhBQAAABtJREFUGBlj/A8EDEQAJiLUgJWMKsQbUkQHDwBpmgQQ1BZY8AAAAABJRU5ErkJggg==');
        document.ContentType = 'image/png';
        document.DeveloperName = 'test_d_o_cument';
        document.IsPublic = true;
        document.Name = 'My Test Document ---';
        document.FolderId = [select Id from folder where name = 'Shared Documents'].Id;
        insert document;
        result.isActive = true;
        result.Description = 'test badge';
        result.Name = 'Test name';
        result.ImageUrl = document.Id;
        insert result;
        return result;
    }



}