public with sharing class SC_PlanningTopicController {

    @AuraEnabled
    public static Object updateTopicStrategy(String topicId, String strategy) {
        try {
            Planning_Topic__c topic = new Planning_Topic__c(Id = topicId);
            topic.Strategy__c = strategy;
            update topic;
            return true;
        } catch(Exception e) {
            return false;
        }
    }

}