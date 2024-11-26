public with sharing class SelectPrecallPlannerScenarioController {
    
    @AuraEnabled
    public static List<Pre_Call_Planner_Scenario__c> getPrecallPlannerScenarios(String templateId) {
        System.debug('templateId--' + templateId);
        try {
            String query = 'SELECT Name, Description__c, ';
            query += '(SELECT Objection__c, Objective__c, Our_Response__c FROM Pre_Call_Planner_Scenario_Objectives__r ORDER BY Sort_Order__c), ';
            query += '(SELECT Question__c, Type__c FROM Pre_Call_Planner_Scenario_Questions__r ORDER BY Type__c, Sort_Order__c), ';
            query += '(SELECT Field__c, Value__c FROM Pre_Call_Planner_Scenario_Default_Values__r) ';
            query += 'FROM Pre_Call_Planner_Scenario__c';
            if(String.isNotBlank(templateId)) {
                query+= ' WHERE Id = :templateId';
            }
            
            query+= ' ORDER BY Sort_Order__c';
            
            System.debug('query--' + query);
            
            return Database.query(query);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,List<Pre_Call_Planner_Scenario__c>> getPrecallPlannerScenario(String templateId){
        
        System.debug('templateId--' + templateId);
        
        String query = 'SELECT Name, Description__c, Bucket__c, ';
        query += '(SELECT Objection__c, Objective__c, Our_Response__c FROM Pre_Call_Planner_Scenario_Objectives__r ORDER BY Sort_Order__c), ';
        query += '(SELECT Question__c, Type__c FROM Pre_Call_Planner_Scenario_Questions__r ORDER BY Type__c, Sort_Order__c), ';
        query += '(SELECT Field__c, Value__c FROM Pre_Call_Planner_Scenario_Default_Values__r) ';
        query += 'FROM Pre_Call_Planner_Scenario__c';
        if(String.isNotBlank(templateId)) {
            query+= ' WHERE Id = :templateId';
        }
        query+= ' ORDER BY Sort_Order__c';
        
        System.debug('query--' + query);
        
        try{
            Map<String,List<Pre_Call_Planner_Scenario__c>> bucketToPreCallScenarioMap = new Map<String,List<Pre_Call_Planner_Scenario__c>>();
            List<Pre_Call_Planner_Scenario__c> preCallPlannerScenarioList = Database.query(query);
            System.debug('preCallPlannerScenarioList--' + preCallPlannerScenarioList);
            
            for(Pre_Call_Planner_Scenario__c scenario : preCallPlannerScenarioList){
                system.debug('scenario.Bucket__c'+scenario.Bucket__c);
                if(String.isNotBlank( scenario.Bucket__c )){                    
                    
                    if( String.isNotBlank( scenario.Bucket__c ) ){
                        if(bucketToPreCallScenarioMap.containsKey(scenario.Bucket__c)){
                            bucketToPreCallScenarioMap.get(scenario.Bucket__c).add(scenario);
                        }else{
                            bucketToPreCallScenarioMap.put(scenario.Bucket__c, new List<Pre_Call_Planner_Scenario__c>());
                            bucketToPreCallScenarioMap.get(scenario.Bucket__c).add(scenario);
                        }
                    }
                    else{
                        if(bucketToPreCallScenarioMap.containsKey(scenario.Name)){
                            bucketToPreCallScenarioMap.get(scenario.Name).add(scenario);
                        }else{
                            bucketToPreCallScenarioMap.put(scenario.Name, new List<Pre_Call_Planner_Scenario__c>());
                            bucketToPreCallScenarioMap.get(scenario.Name).add(scenario);
                        }
                    }
                }
            }
            System.debug('bucketToPreCallScenarioMap--' + bucketToPreCallScenarioMap.values().size());
            return bucketToPreCallScenarioMap;
            
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static PreCallPlanner__c upsertPreCallPlanner(PreCallPlanner__c preCallPlanner) {
        System.debug(preCallPlanner + 'parameter');
        try {
            
            if(preCallPlanner.Id != NULL) {
                String[] fieldsToQuery = new List<String>{
                    'Primary_Objective__c', 'Secondary_Objective__c', 'Objections_to_Primary_Objective__c',
                        'Objections_to_Secondary_Objective__c', 'Response_to_Primary_Objections__c',
                        'Response_to_Secondary_Objections__c', 'Situation_Questions__c', 'Problem_Questions__c',
                        'Implication_Questions__c', 'Need_Payoff_Questions__c'
                        };
                            String query = 'SELECT ' + String.join(fieldsToQuery, ',') + ' FROM PreCallPlanner__c WHERE Id = \'' + preCallPlanner.Id + '\' LIMIT 1';
                System.debug('query'+ query);
                PreCallPlanner__c[] existingPreCallPlanner = Database.query(query);
                
                if(!existingPreCallPlanner.isEmpty()) {
                    for(String field :fieldsToQuery) {
                        String oldValue = existingPreCallPlanner[0].get(field) != null ? existingPreCallPlanner[0].get(field) + '<br />' : '';
                        oldValue+= preCallPlanner.get(field) != null ? preCallPlanner.get(field) : '' ;
                        preCallPlanner.put(field, oldValue);
                    }
                }
                System.debug(preCallPlanner + 'before upsert');
            }
            
            upsert preCallPlanner Id;
            System.debug(preCallPlanner + 'after upsert');
            return preCallPlanner;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*@AuraEnabled
public static Event updateEvent(String eventId, String templateName){
Event event;
if(String.isNotBlank(eventId) && String.isNotBlank(templateName)){

event = new Event();
event.Id = eventId;
event.Pre_Call_Planner_Template__c = templateName;

Update event;
}   

return event;
}*/  
}