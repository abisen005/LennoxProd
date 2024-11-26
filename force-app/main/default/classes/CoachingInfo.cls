global class CoachingInfo {
    /*
        The coaching role name
    */
    @AuraEnabled
    global String name {get;set;}
    /*
        The current user's name
    */
    @AuraEnabled
    global String userName {get;set;}
    @AuraEnabled
    global String type {get;set;}
    @AuraEnabled
    global String userId {get;set;}
    @AuraEnabled
    global Boolean isCoach {get;set;}
    @AuraEnabled
    global Boolean isCoachee {get;set;}
    @AuraEnabled
    global List<User> coachees {get;set;}
    @AuraEnabled
    global List<User> coaches {get;set;}
    @AuraEnabled
    global Map<String, List<SC_Coaching_Session__c>> upcomingSessions {get;set;}
    global CoachingInfo() {}
}