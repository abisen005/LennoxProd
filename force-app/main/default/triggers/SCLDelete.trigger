trigger SCLDelete on SupplyChain__c (before delete) {
bypasstrigger__c settings=bypasstrigger__c.getInstance('SCL');
String ObjectPrimary=settings.primary_object__c;
Boolean bypass_triggers=settings.bypass_triggers__c;


if(bypass_triggers !=true){

    User u = new User();
    for(SupplyChain__c record: Trigger.new==null? Trigger.old: Trigger.new) {
        
              u = [Select mergepermission__c From User Where Id = :UserInfo.getUserId()];

        
        if (( !getCurrentUserProfileName().equals('System Administrator'))  &&(u.mergepermission__c!=true)) {
        record.addError('You do not have permission to delete a request.');
    }
}}
        
        
    private String getCurrentUserProfileName() {
    
        List<Profile> p = [ select name from profile where id = : UserInfo.getProfileId() ];
        
        if ( p.size() == 1 ) 
            return p[0].name;
        else
            return 'PROFILE_NOT_FOUND';
        
   } 

}