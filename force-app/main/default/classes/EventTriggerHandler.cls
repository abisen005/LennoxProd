/*
* @ Purpose      : This handler is used for Create, Update and Delete Event.                   
* @ CreatedDate  : 12/06/2019
*/
public class EventTriggerHandler {
    
    public static boolean hasExecuted = false;
    
    /* 
    * @Purpose      : this function used to create Event records.
    * @Parameter    : List<Event> eventList 
    */
    public static void createEvent(List<Event> eventList){
        
        System.debug('In createEvent');
        
        List<Event> eventListToInsert = new List<Event>();
        //User currentUser = [SELECT Id, Name FROM User WHERE Id =: userinfo.getUserId()];
        String userName  = userinfo.getFirstName();
        
        String currentTime = String.valueof(system.Now());
        
        Id ftlEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Feel The Love Event').getRecordTypeId();
        System.debug('hasExecuted '+ hasExecuted);
        
        //if(!hasExecuted){
            
            List<User> provisionUserList = getProvisionedUsers();
            System.debug('provisionUserList '+ provisionUserList.size());  
            
            
            if(provisionUserList != null && !provisionUserList.isEmpty()){
                
                Event e;
                
                for(Event event : eventList){
                    
                    
                    System.debug('IsVisibleInSelfService  '+ event.IsVisibleInSelfService);  
                    if(event.IsVisibleInSelfService && event.RecordTypeId == ftlEventRecordTypeId){
                        System.debug('In If Block  ');  
                        
                        event.GroupingEvent__c = userName+currentTime;
                        //decimal durationInMinute = getTimeDurationInMinutes(event.StartDateTime, event.EndDateTime);
                            
                        for(User user : provisionUserList){
                           System.debug('event ownerId  '+user.Id);   
                            e = new Event();
                            e.OwnerId = user.Id;
                            e.Subject = event.Subject;
                            e.IsAllDayEvent = event.IsAllDayEvent;
                            e.IsVisibleInSelfService = event.IsVisibleInSelfService;
                            e.WhatId = user.AccountId;
                            e.WhoId = user.ContactId;
                            e.StartDateTime = event.StartDateTime;
                            e.EndDateTime = event.EndDateTime;
                            //e.DurationInMinutes = Integer.valueof(durationInMinute);
                            e.Description = event.Description;
                            e.Location = event.Location;
                            
                            e.RecordTypeId = ftlEventRecordTypeId;
                            e.GroupingEvent__c = event.GroupingEvent__c;
                            
                            eventListToInsert.add(e);
                        }
                    }
                }
            }
        //}
        
        
        if(eventListToInsert != null && !eventListToInsert.isEmpty()){
            
            Insert eventListToInsert;
            System.debug('eventListToInsert '+ eventListToInsert.size());
        }
    }
    
    /* 
    * @Purpose      : this function used get provision User record.
    * @Parameter    : - 
    * @Returntype   : List<User>
    */
    private static List<User> getProvisionedUsers(){
        
        List<User> userList = [SELECT Id, ContactId, AccountId  
                               FROM User 
                               WHERE IsActive = true
                               AND Contact.FTL_Program_Status__c = 'Enrolled'
                               AND Contact.FTL_Provisioned__c = true
                               AND Profile.Name = 'Customer Community Plus - FTL'];
        
        return userList;
    }
    
    /* 
    * @Purpose      : this function used to delete Event records.
    * @Parameter    : List<Event> eventList 
    */
   /* public static void deleteEvent(List<Event> eventList){
        system.debug('eventList '+ eventList);
        List<Event> eventListToDelete = new List<Event>();
        
        Set<String> groupingEventValues = new Set<String>();
        Set<Id> eventIds = new Set<Id>();
        
        //if(!hasExecuted){
            
            for(Event event : eventList){
                
                groupingEventValues.add(event.GroupingEvent__c);
                eventIds.add(event.Id);
            }
          system.debug('groupingEventValues '+ groupingEventValues);  
            eventListToDelete = [SELECT Id 
                                 FROM Event 
                                 WHERE GroupingEvent__c IN : groupingEventValues
                                 AND Id Not IN : eventIds];
            
            system.debug('eventListToDelete '+ eventListToDelete.size());  
        //}
        
        
        
        if(eventListToDelete != null && !eventListToDelete.isEmpty()){
            
            Delete eventListToDelete;
            system.debug('deleted '+ eventListToDelete.size());  
        }
    }*/
    
    /* 
    * @Purpose      : this function used to calculate difference between two datetime fields.
    * @Parameter    : Datetime startDate, Datetime endDate 
    * @Returntype   : decimal
    */
    @TestVisible private static decimal getTimeDurationInMinutes(Datetime startDate, Datetime endDate){
        //Datetime startDate = system.now();// Start date
        //Datetime endDate = system.now().addHours(60);//End Date
        
        integer intDays =  startDate.Date().daysBetween(endDate.Date());
        system.debug('intDays ' +intDays);
        datetime sameDayEndDate = startDate.addDays(intDays);
        
        decimal decHours = ((endDate.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);
        
        decimal decMinutes = ((endDate.getTime())/1000/60) - ((sameDayEndDate.getTime())/1000/60);
        
        if(intDays > 0){
            decMinutes = decMinutes + (intDays*24*60);
        }
        
        system.debug('tminutes ' +decMinutes);
        return decMinutes ;
    }
    
    /* 
    * @Purpose      : this function used to update Event records.
    * @Parameter    : Map<Id, Event> eventReordsoldMap, Map<Id, Event> eventReordsNewMap
    */
    public static void updateEvent(Map<Id, Event> eventReordsoldMap, Map<Id, Event> eventReordsNewMap){
        
        List<Event> eventListToUpdate = new List<Event>();
        
        List<Event> eventListToClone = new List<Event>();
        
        Map<String, List<Event>> groupEventToEventlistMap;
        
        String userName  = userinfo.getFirstName();
        
        String currentTime = String.valueof(system.Now());
        
        Id ftlEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Feel The Love Event').getRecordTypeId();
        
        set<String> groupeventvalueSet = new set<String>();
        
        for(Event  event : eventReordsNewMap.values()){
            
            if(event.GroupingEvent__c != null){
                
                groupeventvalueSet.add(event.GroupingEvent__c);
            }
            
            if(event.GroupingEvent__c == null && eventReordsoldMap.get(event.Id).IsVisibleInSelfService != event.IsVisibleInSelfService
               && event.IsVisibleInSelfService && event.RecordTypeId == ftlEventRecordTypeId){
                   
                event.GroupingEvent__c = userName+currentTime;  
                eventListToClone.add(event);
            }
        }
        
        if(eventListToClone != null && !eventListToClone.isEmpty()){
            
            EventTriggerHandler.createEvent(eventListToClone);
            system.debug('eventListToClone '+eventListToClone.size());
        }
        
        List<Event> eventList;
        
        if(groupeventvalueSet != null && !groupeventvalueSet.isEmpty()){
            
            eventList = [SELECT Id, WhatId, WhoId, StartDateTime, EndDateTime, 
                         DurationInMinutes, Description, Location, GroupingEvent__c 
                         FROM Event 
                         WHERE GroupingEvent__c IN : groupeventvalueSet
                         AND Id NOT IN : eventReordsNewMap.keyset()];
            
            system.debug('eventListToUpdate ' +eventList.size()); 
        
       		groupEventToEventlistMap =  buildMap(eventList, 'GroupingEvent__c');
            system.debug('groupEventToEventlistMap ' +groupEventToEventlistMap.size()); 
        }
        
       
        
       decimal durationInMinute; 
        
        
        
        if(groupEventToEventlistMap != null && !groupEventToEventlistMap.isEmpty()){
            
                for(Event  event : eventReordsNewMap.values()){
                
                    if(!event.IsAllDayEvent && (event.StartDateTime != null && event.EndDateTime != null) && (event.StartDateTime != eventReordsoldMap.get(event.Id).StartDateTime
                                                                                     || event.EndDateTime != eventReordsoldMap.get(event.Id).EndDateTime)){
                        durationInMinute = getTimeDurationInMinutes(event.StartDateTime, event.EndDateTime);
                    }
                    else{
                                                                                                 
                       durationInMinute =  event.DurationInMinutes;                                                                   
                   }
                    
                    if(groupEventToEventlistMap.containsKey(event.GroupingEvent__c)){
                        
                        for(Event e : groupEventToEventlistMap.get(event.GroupingEvent__c)){
                            
                            e.OwnerId = event.ownerId;
                            e.Subject = event.Subject;
                            e.IsAllDayEvent = event.IsAllDayEvent;
                            e.IsVisibleInSelfService = event.IsVisibleInSelfService;
                            e.WhatId = event.WhatId;
                            e.WhoId = event.WhoId;
                            e.StartDateTime = event.StartDateTime;
                            e.EndDateTime = event.EndDateTime;
                            //if(!event.IsAllDayEvent){
                                
                                e.DurationInMinutes = Integer.valueof(durationInMinute);
                            //}
                            e.Description = event.Description;
                            e.Location = event.Location;
                            
                            
                            eventListToUpdate.add(e);
                        }
                    }
               }
        }
        
        if(eventListToUpdate != null && !eventListToUpdate.isEmpty()){
            
            Update eventListToUpdate;
            system.debug('Updated eventListToUpdate ' +eventListToUpdate.size());  
        }
        
    }
    
    /* 
    * @Purpose      : this function used to create map of groupevent value to Eventlist.
    * @Parameter    : List<SObject> listSobject, String keyFieldName
    * @Returntype   : Map<String, List<SObject>>
    */
    private static Map<String, List<SObject>> buildMap(List<SObject> listSobject, String keyFieldName) {
        Map<String, List<SObject>> mapParentToRecords = new Map<String, List<SObject>>();
        
        for(SObject sObj : listSobject) {
            String parentId = (String)sObj.get(keyFieldName);
            
            if(parentId == null) {
                continue;
            }
            
            if(!mapParentToRecords.containsKey(parentId)) {
                mapParentToRecords.put(parentId, new List<SObject>());
            }
            mapParentToRecords.get(parentId).add(sObj);
        }
        
        return mapParentToRecords;
    }    
}