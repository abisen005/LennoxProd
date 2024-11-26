public class ICSController {
    
    public Event evt{get;set;}
    
    public ICSController(Apexpages.StandardController ctrl){
        evt = (Event)ctrl.getRecord();
        evt = [select Id, StartDateTime,EndDateTime,Event_Topic__c,Description,Subject,Added_to_Calendar__c From Event Where Id =: evt.Id];
        system.debug('evt'+evt);
    }
    
    public void updateEvent(){
        evt.Added_to_Calendar__c = true;
        update evt;
    } 
    
}