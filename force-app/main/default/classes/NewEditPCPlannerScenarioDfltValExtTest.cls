@isTest
private class NewEditPCPlannerScenarioDfltValExtTest {

    @isTest static void testPlannerScenarioDefaultValExt() {

        PageReference pref = Page.NewEditPCPlannerScenarioDefaultValue;
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(new Pre_Call_Planner_Scenario_Default_Value__c());
        NewEditPCPlannerScenarioDefaultValueExt ext = new NewEditPCPlannerScenarioDefaultValueExt(con);

        System.assert(!ext.fields.isEmpty(), '"fields" should have some values :(');
    }


}