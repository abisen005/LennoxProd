@isTest
private class OutboundPhoneCallReqCntrlTest {

	@testSetup static void testSetup() {

		final Integer CHILD_RECORD_COUNT = 3; //how many child records to create?

		List<Schema.FieldSetMember> defaultValFields = SObjectType.PreCallPlanner__c.FieldSets.Pre_Populated_Fields.getFields();

		List<Pre_Call_Planner_Scenario_Question__c> questions = new List<Pre_Call_Planner_Scenario_Question__c>();
		List<Pre_Call_Planner_Scenario_Default_Value__c> defaultValues = new List<Pre_Call_Planner_Scenario_Default_Value__c>();
		List<Pre_Call_Planner_Scenario_Objective__c> objectives = new List<Pre_Call_Planner_Scenario_Objective__c>();
		List<sObject> insertObjects = new List<sObject>();

		//Create Parent pre-call planner scenario
		Pre_Call_Planner_Scenario__c scenario = new Pre_Call_Planner_Scenario__c();
		scenario.Name = 'Test Scenario';
        scenario.Bucket__c =  'Existing Customer Engagement / Growth';
		scenario.Description__c = 'Test Scenario Description.';
		insert scenario;

        Pre_Call_Planner_Scenario__c scenario1 = new Pre_Call_Planner_Scenario__c();
		scenario1.Name = 'Outbound Phone Call';
        scenario1.Bucket__c =  'Outbound Phone Call';
		scenario1.Description__c = 'Outbound Phone Call';
		insert scenario1;
        
        PreCallPlanner__c planner = new PreCallPlanner__c();
        planner.Primary_Objective__c = 'test objective';
        insert planner;

		for(Integer i = 0; i < CHILD_RECORD_COUNT; i++) {
			insertObjects.add(
				new Pre_Call_Planner_Scenario_Question__c(
					Pre_Call_Planner_Scenario__c = scenario.Id,
					Question__c = 'test question',
					Type__c = 'Situation'
				)
			);
			if(defaultValFields.size() > CHILD_RECORD_COUNT) {
				insertObjects.add(
					new Pre_Call_Planner_Scenario_Default_Value__c(
						Pre_Call_Planner_Scenario__c = scenario.Id,
						Field__c = defaultValFields[i].getFieldPath(),
						Value__c = 'Test value'
					)
				);
			}
			insertObjects.add(
				new Pre_Call_Planner_Scenario_Objective__c(
					Pre_Call_Planner_Scenario__c = scenario.Id,
					Objection__c = 'test objection',
					Objective__c = 'Test objective',
					Our_Response__c = 'test response'
				)
			);
		}
		insert insertObjects;

	}

	@isTest static void test_getPrecallPlannerScenarios() {
		Pre_Call_Planner_Scenario__c[] scenario = [SELECT Id FROM Pre_Call_Planner_Scenario__c WHERE Name = 'Test Scenario' LIMIT 1];
		if(!scenario.isEmpty()) {
			List<Pre_Call_Planner_Scenario__c> result = OutboundPhoneCallRequestController.getPrecallPlannerScenarios(scenario[0].Id);
            Map<String,List<Pre_Call_Planner_Scenario__c>> result1 = OutboundPhoneCallRequestController.getPrecallPlannerScenario(scenario[0].Id);
            System.assert(result.size() > 0, 'The method did not return a scneario record :(');
		}
	}
    
    @isTest static void test_getPrecallPlannerScenarios2() {
		Pre_Call_Planner_Scenario__c[] scenario = [SELECT Id FROM Pre_Call_Planner_Scenario__c WHERE Name = 'Outbound Phone Call' LIMIT 1];
		if(!scenario.isEmpty()) {
			List<Pre_Call_Planner_Scenario__c> result = OutboundPhoneCallRequestController.getPrecallPlannerScenarios(scenario[0].Id);
            Map<String,List<Pre_Call_Planner_Scenario__c>> result1 = OutboundPhoneCallRequestController.getPrecallPlannerScenario(scenario[0].Id);
            System.assert(result.size() > 0, 'The method did not return a scneario record :(');
		}
	}

	@isTest static void test_getPrecallPlannerScenariosNoId() {
		List<Pre_Call_Planner_Scenario__c> result = OutboundPhoneCallRequestController.getPrecallPlannerScenarios('');
       Map<String,List<Pre_Call_Planner_Scenario__c>> result1 = OutboundPhoneCallRequestController.getPrecallPlannerScenario('');
        System.assert(result.size() > 0, 'The method did not return a scneario record :(');
	}

    @isTest static void test_upsertPreCallPlanner() {
		PreCallPlanner__c[] planner = [SELECT Id, Primary_Objective__c, Secondary_Objective__c, Objections_to_Primary_Objective__c,
                                               Objections_to_Secondary_Objective__c, Response_to_Primary_Objections__c,
                                               Response_to_Secondary_Objections__c, Situation_Questions__c, Problem_Questions__c,
                                               Implication_Questions__c, Need_Payoff_Questions__c
                                       FROM PreCallPlanner__c LIMIT 1];
		if(!planner.isEmpty()) {
            String newValue = 'new value';
            planner[0].Primary_Objective__c = newValue;
			PreCallPlanner__c result = OutboundPhoneCallRequestController.upsertPreCallPlanner(planner[0]);
            System.assert(result.Primary_Objective__c.contains(newValue), 'It doesn\'t look like the planner record was updated :(');
		}
	}

    @isTest static void test_upsertPreCallPlannerFail() {
        try {
			PreCallPlanner__c planner = new PreCallPlanner__c(Id = '123456789123456');
            PreCallPlanner__c result = OutboundPhoneCallRequestController.upsertPreCallPlanner(planner);
        } catch(Exception e) {
            System.assert(String.isNotBlank(e.getMessage()), 'Negative test case failed. Should have received error from passing bad id :(');
        }
    }

}