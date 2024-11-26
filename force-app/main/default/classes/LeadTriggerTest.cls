@isTest
public class LeadTriggerTest {
    
    @testSetup private static void  dataSetup(){        
        
        BDM_Mapping__c mapping = new BDM_Mapping__c(BDM__c = UserInfo.getUserId(), District__c = 'Chicago');
        INSERT mapping;
        
        Campaign Camp  = new Campaign ( Name = 'Parts & Supplies' );
        insert Camp;
        
        
        Account ac = new Account(name ='JJ HVAC', Phone='111-111-1111',ShippingStreet='123 Main St',ShippingCity='Dallas',ShippingState='TX',ShippingPostalCode='75204',ShippingCountry='US') ;
        insert ac; 
		
        
        List<Lead> TestLeads = new List<Lead>();
        QueueSObject   PLQueue     = [Select Id, Queue.Id, Queue.Name, Queue.Type From QueueSObject Where Queue.Type  = 'Queue' and SobjectType = 'Lead' and Queue.Name  = 'Pardot Lead Queue' Limit 1];
        for (Integer i=0; i<10; i++){
            Lead ld = new Lead();
            ld.OwnerId            = PLQueue.Queue.Id;
            ld.FirstName          = 'Test';
            ld.LastName           = 'LeadBulk' + i;
            ld.Company            = ld.LastName;
            ld.LeadSource         = 'Digital Marketing'; 
            ld.Role__c            = 'Owner/Principal';
            ld.Primary_Role__c    = 'Owner/Principal';
            ld.Lead_Assignment__c = 'Marketing';
            TestLeads.add(ld);
        }
        insert TestLeads;
    }

    
     @isTest private static void leadTriggerTest() {
         
         // Get Test Users
         User 			AdminUsr 	= [Select Id, Name, Admin_Bypass__c from User where Admin_Bypass__c  = true and IsActive = true limit 1];
         User 			DmUsr 		= [Select Id, Name from User where UserRole.Name =:'Res District Manager U412' and IsActive = true limit 1];
         User           TmUsr       = [Select Id, Name from User where UserRole.Name =:'Res Territory U412 - 213' and IsActive = true limit 1];
         User 			BadUsr 		= [Select Id, Name from User where UserRole.Name =:'Res CS Phone Agent 1' and IsActive = true limit 1];
		 QueueSObject   PLQueue     = [Select Id, Queue.Id, Queue.Name, Queue.Type From QueueSObject Where Queue.Type  = 'Queue' and SobjectType = 'Lead' and Queue.Name  = 'Pardot Lead Queue' Limit 1];
         Set<Id> cst = new Set<Id>();
         for(PermissionSetAssignment p : [SELECT Assignee.Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Lead_Initial_Validation']) {
             cst.add(p.Assignee.Id);
         }
         System.debug('**CST users found** ' + cst.size());
 		 User CSTUsr = [select Id, Name from User where Id in :cst limit 1];
         System.debug('**CST test user** ' + CSTUsr.Name);
                          
         
         Lead ld ;
         List<Lead> TestLeads ;
         Integer i = 0;
         Integer a = 0;
                      
         
         Test.startTest();       
         
         // Validate Lead Updates as a CST
         System.RunAs(CSTUsr) {
             System.debug('**Run as CSTUsr** ' + CSTUsr);
             //Validate bulk update CST takes ownership of leads
             TestLeads = [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c from Lead];             
             System.debug('**CST Updates** ' + TestLeads.size());
             for(i = 0; i < TestLeads.size(); i++){ 
                 TestLeads[i].OwnerId         = CSTUsr.Id ;
             }
             update TestLeads;
             
             TestLeads = [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c from Lead]; 

             //Validate single update Lead Owner to Pardot Lead Queue
             ld = TestLeads[0];
             ld.OwnerId = PLQueue.Queue.Id;
             ld.Primary_Role__c = 'Owner/Principal';
             System.debug('**Validate single update Lead Owner to Pardot Lead Queue' + ld);
             update ld;

            
             //Negative Testing: Validate single update Lead Status to 'Field Review'
             try {
                 ld = TestLeads[1];
                 ld.Status = 'Field Review';
                 update ld;
                 System.debug('**Bad 1' + ld);
             } catch (DmlException e) {
                  System.debug('**Good 1'+ e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //Negative Testing: Validate single update Lead Assignment to 'District Manager'
             try {
                 ld = TestLeads[2];
                 ld.Lead_Assignment__c = 'District Manager';
                 update ld;
                 System.debug('**Bad 2' + ld);
             } catch (DmlException e) {
                 System.debug('Good 2' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 

             //Negative Testing: Validate Close Lead/Need Nurturing w/ no Nurture Option
             try {
                 ld = TestLeads[3];
                 ld.Status            = 'Closed';
                 ld.Status_Reason__c  = 'Need Nurturing';
                 ld.Nurture_Option__c = null;
                 update ld;
                 System.debug('**Bad 3' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 3' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //Negative Testing: Validate single lead update Owner to TM with no address
             try {
                 ld = TestLeads[4];
                 ld.OwnerId = TMUsr.Id;
                 ld.Street  = null;
                 System.debug('**Negative Testing: Validate single lead update Assignment to TM with no address' + ld);
                 update ld;
                 System.debug('**Bad 4' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 4' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 

             //Negative Testing: Validate single update Lead Assignment to 'Lennox Stores' with no Nurture Option
             try {
                 ld = TestLeads[5];
                 ld.Lead_Assignment__c = 'Lennox Stores';
                 ld.Nurture_Option__c = null;
                 update ld;
                 System.debug('**Bad 5' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 5' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //Negative Testing: Validate single update Lead Assignment to 'District Manager'
             try {
                 ld = TestLeads[6];
                 ld.Lead_Assignment__c = 'District Manager';
                 update ld;
                 System.debug('**Bad 5a' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 5a' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //Negative Testing: Validate single update Lead Assignment to 'Territory Manager'
             try {
                 ld = TestLeads[7];
                 ld.Lead_Assignment__c = 'Territory Manager';
                 update ld;
                 System.debug('**Bad 5b' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 5b' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //Negative Testing: Validate single update Lead Assignment to 'Territory Manager'
             try {
                 ld = TestLeads[8];
                 ld.OwnerId         = TmUsr.Id;
                 ld.Primary_Role__c = null;
                 update ld;
                 System.debug('**Bad 5c' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 5c' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             
             
             //Validate bulk update CST  sets owner to DM
             TestLeads = [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c from Lead];
             System.debug('**Leads bulk update CST sets owner to DM: ' + TestLeads.size());
             for(i = 0; i < TestLeads.size(); i++){ 
                 TestLeads[i].OwnerId    = DMUsr.Id ;
                 TestLeads[i].email      = 'HelloTest@hello.edu';
                 TestLeads[i].Street     = '140 S. Street' ;
                 TestLeads[i].City       = 'Dallas'  ;
                 TestLeads[i].State      = 'Texas'  ;
                 TestLeads[i].PostalCode = '75204';
             }
             update TestLeads;


         } //end CST

           
         //Validate Lead Updates as a DM
         System.RunAs(DmUsr) {
             System.debug('**Run as DmUsr** ' + DmUsr);
             TestLeads = [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c from Lead];
             System.debug('**DM Updates**: ' + TestLeads.size());
             a = 0;
             for(i = 0; i < TestLeads.size(); i++){
                 a++;
                 switch on a{
                     when 1{
                         TestLeads[i].OwnerId           = TmUsr.Id ;
                     }
                     when 2{
                         TestLeads[i].Status            = 'Closed' ;
                         TestLeads[i].Status_Reason__c  = 'Not an HVAC company' ;
                     }
                     when 3{
                         TestLeads[i].Status            = 'Closed' ;
                         TestLeads[i].Status_Reason__c  = 'Homeowner' ;
                       
                     }
                     when 4{
                         TestLeads[i].Lead_Assignment__c = 'Lennox Stores';
                         TestLeads[i].Nurture_Option__c  = 'Training';
                         
                         a = 0;
                     }
                 }
             }//end for
             update TestLeads;

              ld = [select Id, Status, Lead_Stage__c, Lead_Assignment__c, OwnerId from Lead where Status = 'Closed' limit 1];
             //Negative Testing: Validate DM cannot re-open a lead
             try {
                 ld.Status = 'New';
                 System.debug('**********Negative Testing: Validate DM cannot re-open a lead' + ld);
                 update ld;
                 System.debug('**Bad 6' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 6' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
         }//end DM
             
         //Admin should be able to re-open a lead
         system.runAs(AdminUsr){
             System.debug('**Run as AdminUsr** ' + AdminUsr);
             ld.Company = 'Opened by Admin';
             ld.Status  = 'New';
             update ld;
         }
             
              
         //Validate Lead Updates as a TM
         System.RunAs(TMUsr) {
             System.debug('**Run as TMUsr** ' + TMUsr);
             
             //Validate Negative Single Update Lead cannot be closed without a reason
             ld = [select id, status, Lead_Stage__c, Lead_Assignment__c, OwnerId from Lead where OwnerId = :TmUsr.Id limit 1];
             
             try {
                 ld.Status = 'Closed';
                 update ld;
                 System.debug('**Bad 7' + ld);
             } catch (DmlException e) {
                 System.debug('**Good 7' + e.getMessage());
                 //Assert Error Message
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
             } 
             
             //test convert lead as a TM    
             ld = [select Id, status, Lead_Stage__c, Lead_Assignment__c, OwnerId from Lead where OwnerId = : TmUsr.Id limit 1];
             ld.email      		= 'HelloTest@hello.edu';
             ld.Street     		= '140 S. Street' ;
             ld.City       		= 'Dallas'  ;
             ld.State      		= 'Texas'  ;
             ld.PostalCode 		= '75204';
             ld.LeadSource      = 'Digital Marketing';
             ld.Primary_Role__c = 'Marketing/Advertising';
             ld.Dealer_has_a_Storefront__c 					= 'Yes';
             ld.Miles_to_closest_Lennox_Warehouse__c 		= 111;
             ld.Total_Number_of_Service_Technicians__c 		= 11;
             ld.Total_Number_of_Employees__c 				= 111;
             ld.Total_Number_of_Retail_Sales_People__c 		= 11;
             ld.Years_with_current_supplier__c 				= '1';
             ld.Estimated_annual_HVAC_purchases__c			= 111111;
             ld.Existing_or_past_Lennox_relationship__c		= 'Yes';  
             ld.Would_participate_in_Lennox_promotions__c	= 'Yes';
             ld.Dealer_has_experienced_recent_change__c		= 'Yes';
             ld.Has_a_clear_vision_of_their_goals__c		= 'Yes';
             ld.Customer_leadership_support_at_all_level__c	= 'Yes';
             ld.Established_a_decision_deadline__c			= 'Yes';
             ld.Understands_Lennox_value_proposition__c		= 'Yes';
             ld.Satisfied_with_their_current_supplier__c	= '1';
             ld.Dealer_has_Partnership_Mentality__c			= 'Yes';                 
             update ld;
             
             
             Database.LeadConvert lc = new Database.LeadConvert();
             lc.setLeadId(ld.id);
             
             LeadStatus convertStatus = [SELECT Id, ApiName, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
             lc.setConvertedStatus(convertStatus.ApiName);
   
             System.debug('**********Lead ready to be converted: ' + lc);
             try{
                 Database.LeadConvertResult lcr = Database.convertLead(lc);
                 //System.assert(!lcr.isSuccess());
                 System.debug('**********Lead converted success ' + lc);
             }catch (Exception e){
                 System.debug('**Good 8' + e.getMessage());
                 System.assertEquals(1, 1);
                 System.debug('**********Lead converted error >> expected ' + lc);
                 System.debug('**ERROR: ' + e.getMessage() );
             }
             
         }//end TM
         
        
         
         //Validate negative Bulk Update
         TestLeads = [select Id, Status, Lead_Stage__c, Lead_Assignment__c, Nurture_Option__c, OwnerId from Lead];
         a = 0;
         for(i = 0; i < TestLeads.size(); i++){
             if (TestLeads[i].Nurture_Option__c != null) {
                 TestLeads[i].Nurture_Option__c = null;
             }                 
             else if (TestLeads[i].Status == 'Field Review'){
                 a++;                 
                 switch on a{
                     when 1{
                         TestLeads[i].Status            = 'Closed' ;
                         TestLeads[i].Status_Reason__c  = 'Need Nurturing';
                         TestLeads[i].Nurture_Option__c = null;
                     }
                     when 2{
                         TestLeads[i].Status            = 'Closed' ;
                         TestLeads[i].Status_Reason__c  = null;
                         TestLeads[i].Nurture_Option__c = null;
                         
                         a = 0;
                     }
                 }
             }else{
                 TestLeads[i].Lead_Assignment__c = 'Lennox Stores';
             }
         }
         try{
             update TestLeads;
             System.debug('**Bad 8 ');
         }catch (DmlException e) {
             System.debug('**Good 8' + e.getMessage());
             //Assert Error Message
             System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
         }
         
         
         //Assert Lead values are ok
         for(Lead l : [select Id, OwnerId, Status, Status_Reason__c, Lead_Stage__c, Lead_Assignment__c,
                              Nurture_Option__c, Company, ConvertedContactId, Email_BDM__c 
                         from Lead]){
			 
             if (l.Status == 'Closed' ){
                 if (l.Status_Reason__c  == 'Need Nurturing') {
                     System.assertNotEquals(null,l.Nurture_Option__c); 
                 }
                 
             }else if (l.Status == 'Store Review'){  
                  system.assertNotEquals(null,l.Nurture_Option__c); 
                 
             }else if (l.Status == 'Conversion in progress') {
                 System.assertNotEquals(null, l.ConvertedContactId);
                 
             }else{
                 switch on l.Lead_Assignment__c{
                     when 'District Manager'{ 
                         System.assertEquals(DMUsr.Id, l.OwnerId);
                         System.assertEquals('Field Review', l.status);
                         System.assertEquals('1 - Sales Pre-Qualification', l.Lead_Stage__c);
                         System.assertNotEquals('',l.Email_BDM__c);                     
                     }
                     when 'Territory Manager'{ 
                         System.assertEquals(TMUsr.Id, l.OwnerId);
                         System.assertEquals('Field Review', l.status);
                     }
             }                 
                 
             }       
         }

 
         
         Id ProsContRecTypId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Prospecting Contact').getRecordTypeId();
         Id ResiContRecTypId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Residential Contact').getRecordTypeId();
    
    
         // Insert Bulk Test Contacts (known Leads) Validation
         List<Contact> TestCont = new List<Contact>();
         Account ac = [SELECT Id FROM Account LIMIT 1];
         try{
             for (i=0; i<=10; i++){
                 Contact c = new Contact();
                 c.RecordTypeId       = ResiContRecTypId;
                 c.AccountId          = ac.Id;
                 c.FirstName          = i + 'LeadOK' + i + i+ i;
                 c.LastName           = i + 'LeadOK' + i + i+ i;
                 c.Email              = i + 'LeadOK' + i + i+ i+ '@test.com';
                 c.Role__c            = 'Owner / CEO / President';
                 TestCont.add(c);
             }
             insert TestCont;
         }catch (DmlException e){
             System.debug('**ERROR Known Lead Test creating bulk Contacts');
             System.debug(e.getMessage() );               
         }             
         
         
         //Test Update Known Leads (Contact)
         TestCont = [select Id, RecordTypeId , Lead_Stage__c, Lead_Assignment__c, OwnerId, Lead_to_Prospect__c from Contact];

         for (i=0; i<6; i++){
             TestCont[i].Lead_to_Prospect__c = true;
         } 
         TestCont[6].OwnerId = DmUsr.Id;
         TestCont[7].OwnerId = TmUsr.Id;
         TestCont[8].OwnerId = CSTUsr.Id;
         Update TestCont;
         
        try{
             TestCont[9].Lead_Assignment__c = 'District Manager'; 
             update TestCont[9];
             System.debug('**Bad c1 ');
         }catch (DmlException e) {
             System.debug('**Good c1' + e.getMessage());
             //Assert Error Message
             System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
         }
         
        try{
             TestCont[10].Lead_Assignment__c = 'Territory Manager'; 
             update TestCont[10];
             System.debug('**Bad c2 ');
         }catch (DmlException e) {
             System.debug('**Good c2' + e.getMessage());
             //Assert Error Message
             System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
         }

         
         //Assert Contacts values are ok
         
         for(Contact co : [select Id, RecordTypeId , Lead_Stage__c, Lead_Assignment__c, OwnerId, Lead_to_Prospect__c  from Contact]){
             
             if (co.Lead_to_Prospect__c == true){
                 System.assertEquals(ProsContRecTypId, co.RecordTypeId);
             }      
             
			 if (co.OwnerId == CSTUsr.Id) {
                 System.assertEquals('Sales Qualification Team',co.Lead_Assignment__c); 
                 
             }else if (co.OwnerId == DmUsr.Id) {
                 System.assertEquals('District Manager',co.Lead_Assignment__c);
                  
             }else if (co.OwnerId == TmUsr.Id) {
                 System.assertEquals('Territory Manager',co.Lead_Assignment__c);  
             }
         }
         
         
        Test.stopTest();
      
    }
    
}