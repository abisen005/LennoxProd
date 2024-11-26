@isTest(SeeAllData=true)
private class testSiteLocationTrigger {
    static testmethod void SiteLocationStaticTestMethod(){

            home_owners__c s = new home_owners__c(
            address__c='111 Main',
            site_type__c = 'Residential',
            city__c='Mexia',
            name='x',
            site_location_contact__c = 'John Doe',
            state__c='TX',
            postal_code__c='99999',
            phone__c='555-555-5555');
            insert s;

    
        try {  
    delete s;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException em){  
    System.assert(false, 'Deletion failed appropriately');
}}}