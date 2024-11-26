public class SC_CoacheeAssessmentController {

    @AuraEnabled
    public static List<SC_Assessment_Skill__c> getAssessmentSkills(String userId, String initId) {
        System.debug('userId from controller: ' + userId);
        return CoachingUtils.getAssessmentSkills(userId, initId);
    }
    
    @AuraEnabled
    public static void resetMasterySkills(String skillsJSON){
        if(string.isNotBlank(skillsJSON)){
            List<SC_Assessment_Skill__c> skills = (List<SC_Assessment_Skill__c>)System.JSON.deserialize(skillsJSON, List<SC_Assessment_Skill__c>.class);
            update skills;
        }
    }

}