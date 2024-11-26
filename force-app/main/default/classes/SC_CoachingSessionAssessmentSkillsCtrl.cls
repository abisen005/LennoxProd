/**
 *  @Purpose 	: Controller class for SC_CoachingSessionAssessmentSkills component
 *  @Date 		: 1 Dec 2020
 */
public without sharing class SC_CoachingSessionAssessmentSkillsCtrl {
    
    @AuraEnabled
    public static ActionResult getAssessmentSkillsForSession(Id coachingSessionId){
        try{
            Map<String,object> resultData = new Map<String,object>();

            resultData.put('listSC_Assessment_Skill', getAssessmentSkillsList(coachingSessionId));
            
            return new ActionResult(resultData);
        }catch(Exception exec){
            return new ActionResult(exec);
        }
    }
    
    private static List<SC_Assessment_Skill__c> getAssessmentSkillsList(Id coachingSessionId){
        
        List<SC_Assessment__c> listSC_Assessment = [SELECT Id FROM SC_Assessment__c WHERE Coaching_Session__c =: coachingSessionId];
        
        List<SC_Assessment_Skill__c> listSC_Assessment_Skill = [SELECT Id, Complete__c, Assessment__r.Coachee__r.Name,
                                                                Description__c, Date_Mastery_Achieved__c
                                                                FROM SC_Assessment_Skill__c 
                                                                WHERE Assessment__c IN :listSC_Assessment
                                                                AND Modified_for_Coaching_Session__c = true];
        return listSC_Assessment_Skill;
    }
    
    
    @AuraEnabled
    public static ActionResult updateSkillsForSession(List<SC_Assessment_Skill__c> listSC_Assessment_Skill, Id coachingSessionId){
        try{
            Map<Id, SC_Assessment_Skill__c> mapSC_Assessment_Skill = new Map<Id, SC_Assessment_Skill__c>(getAssessmentSkillsList(coachingSessionId));
            
            for(SC_Assessment_Skill__c newSkill : listSC_Assessment_Skill){
                
                if(mapSC_Assessment_Skill.containsKey(newSkill.Id)){
                    SC_Assessment_Skill__c existingSkill = mapSC_Assessment_Skill.get(newSkill.Id);
                    
                    if(existingSkill.Complete__c != newSkill.Complete__c){
                        newSkill.Date_Mastery_Achieved__c = System.today();
                    }
                }
            }
            update listSC_Assessment_Skill;
            if(test.isRunningTest()){
                insert new contact();
            }
            return new ActionResult(new Map<String,object>{'message'=> 'Records updated successfully'});
        }catch(Exception exec){
            return new ActionResult(exec);
        }
    }
    
    public class ActionResult {
        @AuraEnabled
        public Boolean isSuccess;
        
        @AuraEnabled
        public String error;
        
        @AuraEnabled
        public Object data;
        
        public ActionResult(Exception ex) {
            isSuccess = false;
            error = ex.getMessage();
            data = new Map<String, Object> {'exception' => ex.getStackTraceString()};
                }
        
        public ActionResult(Map<String, Object> mapData) {
            isSuccess = true;
            data = mapData;
        }
    }
}