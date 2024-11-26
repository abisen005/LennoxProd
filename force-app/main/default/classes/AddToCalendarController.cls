public class AddToCalendarController {
    
    @AuraEnabled
    public static response getEventRecord(string eventId){
        response res = new response(); 
        system.debug('eventId'+eventId);
        Event evt = new Event();
        try{
            if(String.isNotBlank(eventId)){
                
                evt = [Select Id, Type, Subject, StartDateTime, EndDateTime, Added_to_Calendar__c 
                      From Event 
                      Where Id =: eventId]; 
            }
            
        }catch(Exception e){
            
        }
        res.evt = evt;
        res.redirectURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ICS?id='+evt.Id;
        return res;
    }
    
    @AuraEnabled
    public static void addtoCalendar(string eventId){
        
        try{
            system.debug('eventId'+eventId);
            Event evt = new Event();
            evt.Id = eventId;
            evt.Added_to_Calendar__c = true;
            update evt;
            system.debug('evt '+evt);
           
        }catch(Exception e){
            system.debug('e.getMessage() ::: '+e.getMessage());
        }
    }
    
    public class response{
        @AuraEnabled
        public Event evt;
        @AuraEnabled
        public String redirectURL;
    }

}