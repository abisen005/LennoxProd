public class RedirectPreCallerController {

    public Event evtrecord {get;set;} 
    public String eId {get;set;}
    public RedirectPreCallerController( ApexPages.StandardController stdController) {
        //this.evtrecord = (Event)stdController.getRecord();
        evtrecord = new Event();
        eId = ApexPages.currentPage().getParameters().get('id');
        if( String.isNotBlank( eId ) ){
            this.evtrecord = [SELECT WhoId,WhatId, Type,  SystemModstamp, Subject, StartDateTime, ShowAs,Id, 
                              		RecurrenceActivityId, RecordTypeId,
                             		OwnerId, OriginalInstanceDateTime,
                              		ActivityDateTime, ActivityDate, AccountId, Event_Type__c 
                              FROM Event where Id = :eId ORDER BY CreatedDate DESC Limit 1
                             ];
        }
    }    
    public PageReference redirect(){
        if( evtrecord.Event_Type__c  == 'Phone Call - Outbound' ){
            PageReference pageRef = new PageReference('/apex/OutboundPhoneCallrequest?id='+ evtrecord.Id );
            return pageRef;
        } else{
            PageReference pageRef = new PageReference('/apex/TMPreCallPlanner?id='+ evtrecord.Id );
            return pageRef;
        }
    }
}