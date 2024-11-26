trigger updatePreCallPlanner on Event(after update) {
    Set<String> precallSet = new Set<String>();
    List<PreCallPlanner__c> pcPlannerList = new List<PreCallPlanner__c>();
    List<PreCallPlanner__c> pcptoUpdate = new List<PreCallPlanner__c>();
    List<Event> eList = new List<Event>();
    Map<id,PreCallPlanner__c> precallMap = new Map<id,PreCallPlanner__c>();
    
    
    for(Event e : Trigger.new){
        if((e.StartDateTime != trigger.oldMap.get(e.Id).StartDateTime) || (e.Location != trigger.oldMap.get(e.Id).Location) || (e.DurationInMinutes != trigger.oldMap.get(e.Id).DurationInMinutes) || (e.WhatId != trigger.oldMap.get(e.Id).WhatId) || (e.OwnerId != trigger.oldMap.get(e.Id).OwnerId)){
            if(e.PreCallPlanner__c != null)
            {
                PreCallPlanner__c pcp = new PreCallPlanner__c();
                pcp.Id = e.PreCallPlanner__c;
                pcp.Meeting_Length__c = e.DurationInMinutes;
                pcp.Meeting_Location__c = e.Location;
                pcp.Meeting_Date_Time__c = e.StartDateTime;
                pcp.Dealer_Name__c = e.WhatId;
                pcp.OwnerId = e.OwnerId;
                pcptoUpdate.add(pcp);
            }
        }   
    }
    if(pcptoUpdate.size()>0){
        update pcptoUpdate;
    }
}