trigger AMSDelete on Vendor_Direct__c (before delete) {


    User u = new User();
    for(vendor_direct__c record: Trigger.new==null? Trigger.old: Trigger.new) {
        
              u = [Select mergepermission__c From User Where Id = :UserInfo.getUserId()];

        
        if (( !getCurrentUserProfileName().equals('System Administrator Service'))  &&(u.mergepermission__c!=true)) {
        record.addError('You do not have permission to delete this reqest.');
    }
}
        
        
    private String getCurrentUserProfileName() {
    
        List<Profile> p = [ select name from profile where id = : UserInfo.getProfileId() ];
        
        if ( p.size() == 1 ) 
            return p[0].name;
        else
            return 'PROFILE_NOT_FOUND';
        
   } 

}