public class DeleteEvtComp {
    
    @AuraEnabled
    public static string deleteEvt(string evtId){
        try{
            Event evt = [Select Id,Account__c, WhatId From Event Where Id =: evtId];
            String AccId = evt.Account__c;
            system.debug('Accid'+AccId);
            delete evt;
            system.debug('return true');
            //return string.valueOf(evt.WhatId);
            return string.valueOf(AccId);
        }catch(Exception e){
            system.debug('Exception e'+e);
            return null;
        }
    }
    
}