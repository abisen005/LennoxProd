public with sharing class SC_NewEditCoachingRoleRelationshipExt {

    public List<SelectOption> userFields {get; set;}


    public SC_NewEditCoachingRoleRelationshipExt(ApexPages.StandardController stdController) {
        userFields = new List<SelectOption>();
        Set<String> OK_FIELD_TYPES = new Set<String>{'URL', 'TEXTAREA', 'STRING', 'REFERENCE', 'PICKLIST', 'MULTIPICKLIST', 'ID', 'EMAIL'};
        for(Schema.FieldSetMember f :SObjectType.User.FieldSets.Coaching_Role_Relationship_Filter.getFields()) {
            if(OK_FIELD_TYPES.contains(String.valueOf(f.getType()))) {
                userFields.add(new SelectOption(f.getFieldPath(), f.getLabel()));
            }
        }
    }


}