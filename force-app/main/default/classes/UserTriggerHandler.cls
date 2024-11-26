/*
* @ Purpose      : This handler is used for Create Event records for Provisioned user.                   
* @ CreatedDate  : 14/06/2019
*/
public class UserTriggerHandler {

    /* 
    * @Purpose      : this function used to create Event records.
    * @Parameter    : List<User> userList 
    */
    @future
    public static void createEvent(Set<Id> userIdSet){
        System.debug('In createEvent' + userIdSet);
        
        List<User> provisionUserList = new List<User>();
        
        List<Event> eventListToInsert = new List<Event>();
        
        
        
        if(userIdSet != null && !userIdSet.isEmpty()){
            
            List<user> insertedUserWithContactInfo = getInsertedUserWithContactInfo(userIdSet);
            
            for(user u : insertedUserWithContactInfo){
                
                if(u.contactId != null && u.Contact.FTL_Program_Status__c == 'Enrolled' && u.Contact.FTL_Provisioned__c == true){
                    
                    provisionUserList.add(u);
                }
            }
        }
        
        
        if(provisionUserList != null && !provisionUserList.isEmpty()){
            System.debug('In if '+ provisionUserList.Size());
            User user = getProvisionUser(userIdSet);
            
            if(user != null){
                System.debug('future event user '+ user.Id);
                List<Event> futureEvents = getFutureEndDateEventList(user.Id);
                System.debug('futureEvents '+ futureEvents);
                
                if(futureEvents != null && !futureEvents.isEmpty()){
                    
                    Event newEvent;
                    
                    for(user u : provisionUserList){
                        
                        for(Event event : futureEvents){
                            
                            newEvent = new Event();
                            
                            newEvent.OwnerId = u.Id;
                            newEvent.WhatId = u.AccountId;
                            newEvent.WhoId = u.ContactId;
                            newEvent.IsAllDayEvent = event.IsAllDayEvent;
                            newEvent.Subject = event.Subject;
                            newEvent.StartDateTime = event.StartDateTime;
                            newEvent.EndDateTime = event.EndDateTime;
                            newEvent.DurationInMinutes = event.DurationInMinutes;
                            newEvent.Description = event.Description;
                            newEvent.Location = event.Location;
                            newEvent.GroupingEvent__c = event.GroupingEvent__c;
                            
                            eventListToInsert.add(newEvent);
                        }
                    }
                }
            }
        }
        
        if(eventListToInsert != null && !eventListToInsert.isEmpty()){
            
            Insert eventListToInsert;
            System.debug('eventListToInsert '+ eventListToInsert.Size());
        }
    }
    
    /* 
    * @Purpose      : this function used to get user record with contact info.
    * @Parameter    : Set<Id> userIds
    * @Returntype   : List<user>
    */
    private static List<user> getInsertedUserWithContactInfo(Set<Id> userIds){
        
        List<user> userList = [SELECT Id, ContactId, AccountId, Contact.FTL_Program_Status__c,
                                   Contact.FTL_Provisioned__c, IsActive
                                   FROM User 
                                   WHERE Id IN :userIds];
        return userList;
    }
    
    /* 
    * @Purpose      : this function used get future Event records.
    * @Parameter    : String contactId 
    * @Returntype   : List<Event>
    */
    private static List<Event> getFutureEndDateEventList(String ownerId){
        
        List<Event> eventList = [SELECT Id, WhatId, WhoId, StartDateTime, EndDateTime, IsAllDayEvent, 
                                 DurationInMinutes, Description, Location, GroupingEvent__c, ownerId,
                                 subject
                                 FROM Event 
                                 WHERE GroupingEvent__c != null
                                 AND EndDateTime > :System.now()
                                 AND OwnerId =: ownerId];
        
        return eventList;
    }
    
    /* 
    * @Purpose      : this function used get provision User records.
    * @Parameter    : - 
    * @Returntype   : User
    */
    private static User getProvisionUser(Set<Id> userIds){
        
        List<User> userList = [SELECT Id, ContactId, AccountId  
                               FROM User 
                               WHERE IsActive = true
                               AND ContactId != null
                               AND Contact.FTL_Program_Status__c = 'Enrolled'
                               AND Contact.FTL_Provisioned__c = true
                               AND Profile.Name = 'Customer Community Plus - FTL'
                               AND Id NOT IN : userIds];
        
        if(userList != null && !userList.isEmpty()){
            
            return userList[0];
        }
        
        return null;
    }
}