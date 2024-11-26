@isTest(seeAllData = true)
private class testLSADeleteTrigger {
    static testmethod void LSAStaticTestMethod(){

                           
            geo_mapping__c  g = new geo_mapping__c (
            region_director__c='00E80000000ybBwEAI',
            district_manager__c='00E80000000ybDjEAI',
            ftc_1__c='00E80000000ybBwEAI',
            ftc_2__c='',
            district__c='U432',
            region__c='West Region');
            insert g;
    
    FTCTerritorymapping__c f= new FTCTerritorymapping__c(
    ftc1__c='00580000002KPPOAA4',
    territory__c='222');
    insert f;
    
    

            Account a = new Account(
            name='Tester',
            SAP_Customer_Number__c='B9999');
            insert a;
    


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
            
            Lennox_LSA__c l=new lennox_lsa__c(
            account__c=a.id,
       
            home_owner__c = s.id,
            requested_dollar_amount__c = 200,
            requestor_comments__c = 'xxxx',
            Application__c='residential',
            reason_for_reimbursement__c='Excessive Calls',
            order_reason__c='Motor/Blower');
            insert l;


    
           Equipment_data__c e= new Equipment_data__c(
           account__c=a.id,
           home_owner__c = s.id,
           serial_number__c = '7849E97298', 
           model_number__c = 'MP2307',
           Manufacturer1__c = 'Lennox',
           type__c = 'Coil',
           system1__c = '1');
           insert e;
            
            case_equip_junction__c j = new case_equip_junction__c(
            
            lennox_lsa__c = l.id,
            site_location__c = s.id,
            equipment_data__c = e.id);
            insert j;
    






        geo_mapping__c[] d=[select district_manager__c, district__c,  ftc_1__c, ftc_2__c from geo_mapping__c where district__c =:l.district__c];
        
        
        
        if(d.size()>0){
            if(d[0].district_manager__c!=null){
                User[] u1=[select id from user where userroleid=:d[0].district_manager__c AND isactive=true LIMIT 1];
                if(u1.size()> 0)
                    l.district_manager__c=u1[0].id;
                
            }}
        

        
        
        if(d.size()>0){
            if(d[0].ftc_1__c!=null){
                User[] u3=[select id from user where userroleid=:d[0].ftc_1__c AND isactive=true LIMIT 1];
                if(u3.size()> 0)
                    l.responsible_FTC__c=u3[0].id;
                
            }}

        


  update l;


    
        try {  
    delete l;  
    System.Assert(true, 'This was supposed to fail');  
}catch(DMLException em){  
    System.assert(false, 'Deletion failed appropriately');
}}}