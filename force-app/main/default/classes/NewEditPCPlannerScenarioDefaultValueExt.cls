public with sharing class NewEditPCPlannerScenarioDefaultValueExt {

    public List<SelectOption> fields {get; set;}

    public NewEditPCPlannerScenarioDefaultValueExt(ApexPages.StandardController stdController) {
        fields = new List<SelectOption>();
        for(Schema.FieldSetMember f :SObjectType.PreCallPlanner__c.FieldSets.Pre_Populated_Fields.getFields()) {
            fields.add(new SelectOption(f.getFieldPath(), f.getLabel()));
        }
    }

}