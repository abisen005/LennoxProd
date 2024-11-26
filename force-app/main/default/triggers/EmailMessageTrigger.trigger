trigger EmailMessageTrigger on EmailMessage (before insert) {
    if(!EmailMessageHandler.isCommunityMail){
        if(Trigger.isInsert && Trigger.isbefore){
            System.debug('In EmailMessageTrigger');
            EmailMessageHandler.attachEmailToCase(Trigger.New);
        }    
    }
}