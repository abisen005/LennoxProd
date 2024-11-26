/*
* @ Purpose      : Unknown Leads & Known Leads (Contact) Handler for Trigger
* @ CreatedDate  : 10-10-2019
*/
public class LeadTriggerHandler 
{
    
    //class variables
    public static boolean g_isFromBachJob ;
    public static boolean g_isFromUploadAPI = false;
    private boolean g_isExecuting = false;
    private integer g_BatchSize = 0;
    private static Map<string, BDM_Mapping__c> g_BdmDistMap;
    private static Map<string,Campaign> g_Campaigns;
    private static List <Scorecard__c> g_existingScorecardList;
    private static map<Id, User> g_ownerUserMap;
    private static User currentUser;
    private static Id g_PardotLeadQueueId;
    private static Id g_ClosedLeadRecTypId;
    private static Id g_OpenLeadRecTypId;
    private static Id g_IntgrtMKTuser;
    private static Id g_StoreLeadRecTypId;
    private static map<Id, User> g_CSTUserMap;


    
    
    //Static variables initialization    
    static{
        //Get BDM-District Mapping table
        g_BdmDistMap = New Map<string, BDM_Mapping__c>();
        for(BDM_Mapping__c BDM : [select District_Desc__c, BDM__r.email from BDM_Mapping__c]){
        	g_BdmDistMap.put(BDM.District_Desc__c, BDM);
        }
        System.debug('**g_BdmDistMap: ' + g_BdmDistMap );
        //Get Pardot Lead queue Id
        List<queuesobject> PardotLeadQueueList = [select Id, QueueId from queuesobject where queue.name = 'Pardot Lead Queue' limit 1];
        g_PardotLeadQueueId = PardotLeadQueueList[0].QueueId;
        //Get IntgrtMKT user Id
        List<User> 	 IntgrtMKTuserList = [select Id from User where Name = 'Lennox IntgrtMKTuser' limit 1];
        g_IntgrtMKTuser = IntgrtMKTuserList[0].Id;
        //Get Store Lead Record Type Id
        g_StoreLeadRecTypId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Store Lead').getRecordTypeId();
        //Get Closed Lead Record Type Id
        g_ClosedLeadRecTypId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Closed Lead').getRecordTypeId();
        //Get Open Lead Record Type Id
        g_OpenLeadRecTypId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Digital Marketing Record Type').getRecordTypeId();

        //get list of Lead Validators
        Set<Id> cst = new Set<Id>();
        for(PermissionSetAssignment p : [SELECT Assignee.Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Lead_Initial_Validation']) {
             cst.add(p.Assignee.Id);
        }
 		if(!cst.isEmpty()){
            g_CSTUserMap = new Map<Id, User>([select Id,Username,Profile_Name__c,UserRole.Name
                                               from User 
                                              where Id in :cst]);
            System.debug('**g_CSTUserMap: ' + g_CSTUserMap  );
        }        
        
    }
    

    /*
    * @Purpose  : Constructor for Class LeadTriggerHandler 
    * @Param    : boolean isExecuting, integer size, List<Lead> newLead
    */            
    public LeadTriggerHandler(boolean isExecuting, integer size, List<Lead> newLead, List<Contact> newKLead)
    {
        IsExecuting    = isExecuting;
        g_BatchSize    = size;
        
        GetSearchRangesFromLead(newLead, newKLead);
        currentUser = [select Id, name, Admin_Bypass__c from User where Id = : system.userInfo.getUserId()];
    }
    

    /*
    * @Purpose  : Fetch collection od users details for input lead owner users Ids
    * @Param    : List<Lead> newLead
    * @Return   : Map<Id, User>
    */        
    public static void GetSearchRangesFromLead(List<Lead> newLead, List<Contact> newKLead)
    {      
        //Get Lead(s) owners Ids 
        set<Id> ownerIDs = new set<Id>();
        set<string> CampaignNames = new set<string>();
        
        if (newLead != null){
            System.debug('**for Lead ');
            for (Lead ld : newLead){
                if (ld.OwnerId != null){ownerIDs.add(ld.OwnerId); }
                if (ld.Nurture_Option__c != null){CampaignNames.add(ld.Nurture_Option__c); }
            }
        }else if (newKLead != null){
            System.debug('**for Contact ');
            for (Contact ld : newKLead){
                 ownerIDs.add(ld.OwnerId); 
            }
        }
        System.debug('**list of ownerIDs: ' + ownerIDs  );
        System.debug('**list of CampaignNames: ' + CampaignNames  );
        
        //get User record information for those owners and create a collection for search purposes
        if(!ownerIDs.isEmpty()){
            g_ownerUserMap = new Map<id, User>([select Id,Username,Profile_Name__c,UserRole.Name,SAP_Sales_Office__c,ManagerId,Manager.email
                                                  from User 
                                                 where Id in :ownerIDs]);
            System.debug('**g_ownerUserMap from leads: ' + g_ownerUserMap  );
        }

        //get Campaigns information and create a collection for search purposes
        if(!CampaignNames.isEmpty()){
            g_Campaigns = new Map<String,Campaign>();
            for(Campaign cmp : [select Id, Name 
                                  from Campaign 
                                 where Name in :CampaignNames ])
            g_Campaigns.put(cmp.Name, cmp);                
                                
            System.debug('**g_Campaigns from leads: ' + g_Campaigns  );
        }
        

    }
    
    
    
    /*
    * @Purpose  : Method to run the logic Lead Trigger On Before Insert
    * @Param    : List<Lead> newLead
    * @Return   : 
    */               
    public static void OnBeforeInsert(List<Lead> newLead)
    {
		GetSearchRangesFromLead(newLead, null);
        
        for (Lead ld : newLead){
            //set lead values based on the owner
            LeadUpdatedBasedOnOwner(ld);
        }  
    }
    
    
    
    /*
    * @Purpose  : Method to run the logic Lead Trigger On After Insert
    * @Param    : List<Lead> newLead
    * @Return   : 
    */                   
    public static void OnAfterInsert(List<Lead> newLead)
    {
        system.debug('Lead Trigger On After Insert');

    }
    
    
    /*
    * @Purpose  : Method to run the logic Lead Trigger On Before Update
    * @Param    : List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap , Map<ID, Lead> oldLeadMap
    * @Return   : 
    */                   
    public static void OnBeforeUpdate( List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap , Map<ID, Lead> oldLeadMap )
    {
        //Validate lead data before update & set lead values
                
        system.debug('** OnBeforeUpdate: Lead Trigger On Before Update ');
        
        List<CampaignMember> memList = new List<CampaignMember>();
        
        
        for (Lead ld : newLead){  //------------------------------------------------------------------------
            
			if (ld.IsConverted && !oldLeadMap.get(ld.Id).IsConverted){
                system.debug('** OnBeforeUpdate: Lead is being Converted');
                if (!IsLeadOKToContinue(ld)){continue;}                    
            }
            
            // when Lead status is closed it cannot be changed! at least you're an Admin
            if (oldLeadMap.get(ld.ID).Status == 'Closed') {
                if (!currentUser.Admin_Bypass__c){
                    ld.addError(System.label.Lead_Closed_Error, true);
                    continue;                        
                }
            }
            
            //if lead Owner changed
            if (ld.OwnerId != oldLeadMap.get(ld.Id).OwnerId){
                system.debug('** OnBeforeUpdate: Lead Owner changed from ' + ld.OwnerId);
                //update lead based on the new owner
                if (!LeadUpdatedBasedOnOwner(ld)){continue;}
            }
            
            //if Assignment changed
            else if (ld.Lead_Assignment__c != oldLeadMap.get(ld.ID).Lead_Assignment__c){
                
                system.debug('** OnBeforeUpdate: Assignment changed');
                switch on ld.Lead_Assignment__c{
                    
                    //When Lead Assignment is "District Manager" 
                    when 'District Manager'{   
                        // When Lead assigned to a DM the Owner should be a DM
                        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
                        System.debug('**Lead Assignment to DM and Owner is a ' + LeadOwnerType );
                        if ((LeadOwnerType != 'DM') && (LeadOwnerType != 'ASM')){
                            if (!currentUser.Admin_Bypass__c){
                                ld.addError(System.Label.LeadAssignmentDM, true); 
                                continue;
                            }
                        }
                    }
                    
                    //When Lead Assignment is Territory Manager" 
                    when 'Territory Manager'{   
                        // When Lead assigned to a TM the Owner should be a TM
                        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
                        System.debug('**Lead Assignment to TM and Owner is a ' + LeadOwnerType );
                        if(LeadOwnerType != 'TM'){
                            if (!currentUser.Admin_Bypass__c){
                                ld.addError(System.label.Lead_Assignment_to_TM, true);
                                continue;
                            }
                       }
                    }
                    
                    //When Lead Assignment is "Lennox Stores" 
                    when 'Lennox Stores'{  
                        System.debug('**Lead Assignment Lennox Stores '  );
                        
                        // When Lead assigned to Stores the Campaign must be selected
                        if(ld.Nurture_Option__c == null){
                            ld.addError(System.label.Lead_Store_Opp_No_Nurture_Opt, true);
                            continue;
                         
                        //If lead is NOT OK to continue
                        }else if (!IsLeadOKToContinue(ld)){
                            continue;  
                            
                            
                        // If all Good >> set Lead Values
                        }else{          
                            System.debug('**Store Lead looks good, about to set default values '  );
                            ld.Lead_Stage__c      = '4 - Stores Qualified';
                            ld.Status             = 'Closed';
                            ld.OwnerId            = g_IntgrtMKTuser;
                            ld.RecordTypeId	      = g_ClosedLeadRecTypId; 
                            ld.Lead_Assignment__c = 'Marketing'; 
                            //if a Nurture Option was selected add the lead to the corresponding Campaign                           
                            AddLeadToCampaign(ld, memList);
                        }
                    }
               } //end switch on Lead Assignment 
            }
            
            
            // If Status changed 
            else if (ld.Status != oldLeadMap.get(ld.ID).Status){
                
                //If Lead is being re-opened 
                system.debug('** OnBeforeUpdate: Status changed Admin bypass ' + currentUser );
                if (oldLeadMap.get(ld.ID).Status == 'Closed') {
                        // when Lead status is closed it cannot be changed! at least you're an Admin
                        if (!currentUser.Admin_Bypass__c){
                            ld.addError(System.label.Lead_Closed_Error, true);
                            continue;                        
                        }else{
                            ld.RecordTypeId = g_OpenLeadRecTypId; 
                            System.debug('**g_OpenLeadRecTypId: ' + g_OpenLeadRecTypId );
                            LeadUpdatedBasedOnOwner(ld);
                        }
                }
                               
                switch on ld.Status{
                    
                   //When "Convert" 
                    when 'Conversion in progress'{  
                        if (!IsLeadOKToContinue(ld)){
                            continue;                            
                        }
                    }

                   //When "Field Review" 
                    when 'Field Review'{  
                        if (!IsLeadOKToContinue(ld)){
                            continue;                            
                        }
                        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
                        if ( (LeadOwnerType != 'DM')&&(LeadOwnerType != 'TM')&&(LeadOwnerType != 'ASM') ){
                            if (!currentUser.Admin_Bypass__c){
                                ld.addError(system.label.Lead_Status_Field_Sales_bad_Owner, true);
                                continue;
                            }
                       }
                        
                    }

                   //When "No Opportunity" Button Pressed
                    when 'Closed'{  
                        if (ld.Status_Reason__c == null){
                            ld.addError(system.label.Lead_Status_Closed_no_Reason, true);
                            continue;
                        }
                        
                        //When Need Nurturing reason is selected
                        else if (ld.Status_Reason__c == 'Need Nurturing'){
                            if (ld.Nurture_Option__c == null){
                                ld.addError(system.label.Lead_Closed_Need_Nurturing_no_Nurture_Opt, true);
                                continue;
                            }
							if (!IsLeadOKToContinue(ld)){
                            	continue;                            
                        	}                            
                            ld.OwnerId            = g_IntgrtMKTuser;
                            ld.Lead_Assignment__c = 'Marketing';
                            ld.Lead_Stage__c      = '3 - No Further Sales Follow-up';
                            //if a Nurture Option was selected add the lead to the corresponding Campaign
                            AddLeadToCampaign(ld, memList);
                        
                        //Set values on Close
                        }else{
                            ld.Lead_Stage__c      = '5 - Not a Valid Lead';
                        }
                        ld.RecordTypeId           = g_ClosedLeadRecTypId;                         
                    }                     
                }//end switch lead status
            }
            
            
            //If Campaign changed 
            else if (ld.Nurture_Option__c != oldLeadMap.get(ld.ID).Nurture_Option__c){
                system.debug('** OnBeforeUpdate: Campaign changed');
                if (ld.Nurture_Option__c == null ){
                    // if a Nurture Option was not selected and lead status is Closed or 
                    // lead is assigned to Stores, send an error
                    if ( ld.Lead_Assignment__c == 'Lennox Stores') {
                        ld.addError(system.label.Lead_Nurture_Option_Error, true);
                        continue;
                    }else if (ld.Status == 'Closed' && ld.Status_Reason__c == 'Need Nurturing'){
                        ld.addError(system.label.Lead_Closed_Need_Nurturing_no_Nurture_Opt, true);
                        continue;
                    }
                }else{
                    //if a Nurture Option was selected add the lead to the corresponding Campaign
                    AddLeadToCampaign(ld, memList);
                }
            }

        }//end for Lead //--------------------------------------------------------------------------------------
        
        //If Leads were added to campaigns make sure to insert them
        if (!memList.isEmpty()){
            system.debug('**OnBeforeUpdate: Add Campaigns from memList ' + memList );
            try{
              insert memList;   
              system.debug('**OnBeforeUpdate: Add Campaigns from memList GOOD inserting ' + memList );
            }catch (DmlException e){
                //nothing
                system.debug('**OnBeforeUpdate: Add Campaigns from memList ERROR inserting ' + memList );
            }
                     
        }
    } 
    
    
    
    /*
    * @Purpose  : Method to run the logic Lead Trigger On After Update
    * @Param    : List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap , Map<ID, Lead> oldLeadMap
    * @Return   : 
    */                       
    public static void OnAfterUpdate( List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap , Map<ID, Lead> oldLeadMap )
    {
        system.debug('Lead Trigger On After Update ');
        
        //Lead Actions - update or create opp scorecard
        OppScorecardUpsert(newLead, oldLeadMap);
    }

    
    
    /*
    * @Purpose  : Method to validate the Lead is OK to be Converted/Assigned
    * @Param    : Lead ld
    * @Return   : Boolean
    */     
    public static boolean IsLeadOKToContinue(Lead ld) {
        system.debug('**IsLeadOKToContinue: Primary Role Address ' + ld.Primary_Role__c + ' ' + ld.Address);
        //validate primary role is selected
        if (ld.Primary_Role__c == null){
            system.debug('**IsLeadOKToContinue: no Primary Role ' + ld);
            ld.addError(system.label.Lead_Primary_Role_Error, true);
            return false;
        
        //validate the address is completed
        }else if (
             ld.Street     == null ||
             ld.City       == null || 
             ld.State      == null ||
             ld.PostalCode == null ||
             ld.Street     == ''   ||
             ld.City       == ''   || 
             ld.State      == ''   ||
             ld.PostalCode == ''   ) {
            system.debug('**IsLeadOKToContinue: Address is not completed ' + ld);
            ld.addError(system.label.Lead_Address_Error, true);
            return false;
        
        //all good!
        }else{
           return true;              
        }
    }
    
    

    
    
   /*
    * @Purpose  : Add Lead to Campaign
    * @Param    : Lead ld
    * @Return   : 
    */                       
    public static void AddLeadToCampaign( Lead ld, List<CampaignMember> CampaignMemberList)
    {
        CampaignMember mem;
        
        try{
            //if a Nurture Option was selected add the lead to the corresponding Campaign
            Id cmpid = g_Campaigns.get(ld.Nurture_Option__c).id;
            if (cmpid != null){
                system.debug('**AddLeadToCampaign: campaign Id found for ' + ld.Nurture_Option__c );
                mem = new CampaignMember(campaignid = cmpid, leadid = ld.id);
                if (mem != null){
                    CampaignMemberList.add(mem);
                }else{
                    system.debug('**AddLeadToCampaign: ERROR no member created' );
                    ld.addError(system.label.Lead_No_Active_Campaign_for_Nurture_Opt, true);
                }
            }else{
                system.debug('**AddLeadToCampaign: ERROR campaing Id not found for ' + ld.Nurture_Option__c);
                ld.addError(system.label.Lead_No_Active_Campaign_for_Nurture_Opt, true);
            }
        }catch(Exception e){
            system.debug('**AddLeadToCampaign: Exception/ERROR ' + CampaignMemberList.size() + CampaignMemberList );
        }
        system.debug('**AddLeadToCampaign: exiting method memList ' + CampaignMemberList.size() + CampaignMemberList );
    }
    
    
    
    
    /*
    * @Purpose  : Fetch user details for input lead owner user Id
    * @Param    : Id OwnerId
    * @Return   : User
    */   
    public static User GetCurrentLeadOwnerUser(Id OwnerId)
    {        
        // Get new Lead owner user record
        System.debug('**GetCurrentLeadOwnerUser Map/OwnerId:' + g_ownerUserMap + OwnerId );
        
        User ownerUser;
        ownerUser = g_ownerUserMap.get(OwnerId);
        System.debug('**Get ownerUser:' + ownerUser  );
        
        return ownerUser; 
    }
      
    
  
    
    /*
    * @Purpose  : Get New Lead Owner Type [DM, TM, CCS, etc] for input user Id
    * @Param    : String districtNumber
    * @Return   : string
    */       
    public static string LeadOwnerType(Id OwnerId)
    {
        try{  
            // Get new Lead owner Id User Record
            User ownerUsrRec = GetCurrentLeadOwnerUser(OwnerId);

            //Get Lead owner Role and Profile
            if (OwnerId == g_PardotLeadQueueId){
                return 'PLQ'; //Owner to Pardot Lead Queue    
            }else if (g_CSTUserMap.containsKey(OwnerId) ){  
                return 'CSS'; //Owner to CSS          
            }else if (ownerUsrRec.UserRole.Name.contains('District Manager')){                                                           
                return 'DM';  //Owner to DM
			}else if (ownerUsrRec.UserRole.Name.contains('Area Sales Manager')){                                                           
                return 'ASM'; //Owner to ASM
            }else if (ownerUsrRec.UserRole.Name.contains('Territory')){  
                return 'TM';  //Owner to TM             
            }else{
                return 'Other';              
            }
        }catch (Exception e){ 
           return 'Other';
        }
    }
    
    
    

    /*
    * @Purpose  : Create or Update Accout Opportunity Scorecard for list of converted Leads
    * @Param    : List<Lead> newLead, Map<ID, Lead> oldLeadMap
    * @Return   : 
    */                       
    public static void OppScorecardUpsert(List<Lead> newLead, Map<ID, Lead> oldLeadMap)
    {
        string      updateOrInsert;
        integer     i;
    
        //variables declaration
        List <Scorecard__c> scorecardToUpsert     = new List <Scorecard__c> ();
        List <Task>         tskList               = new List <Task> ();
        Scorecard__c        OppScorecard;
        
        //Get Opp Scorecard List
        if (g_existingScorecardList == null){
            g_existingScorecardList = GetOppScorecardList(newLead);
        }
        
        for (Lead ld : newLead){
            //if lead was Converted
            if (ld.IsConverted && !oldLeadMap.get(ld.Id).IsConverted){
                //See if there is an existing opp scorecard
                OppScorecard = GetExistingOppScorecard(ld, g_existingScorecardList);
                if ( OppScorecard == null){
                    // if there is not one create a new opp scorecard
                    OppScorecard		    = new Scorecard__c ();
                    OppScorecard.account__c	= ld.convertedAccountId;
                    OppScorecard.name  	    = ld.company;                    
                }
                OppScorecard.Dealer_has_a_Storefront__c					 = ld.Dealer_has_a_Storefront__c;
                OppScorecard.Distance_to_the_closest_Lennox_warehouse__c = ld.Miles_to_closest_Lennox_Warehouse__c;
                OppScorecard.Total_Number_of_Service_Technicians__c		 = ld.Total_Number_of_Service_Technicians__c;
                OppScorecard.Total_Number_of_Employees__c				 = ld.Total_Number_of_Employees__c;
                OppScorecard.Total_Number_of_Retail_Sales_People__c		 = ld.Total_Number_of_Retail_Sales_People__c;
                OppScorecard.Years_with_current_supplier__c				 = ld.Years_with_current_supplier__c;
                OppScorecard.Estimated_annual_HVAC_purchases__c			 = ld.Estimated_annual_HVAC_purchases__c;
                OppScorecard.Existing_or_past_Lennox_relationship__c	 = ld.Existing_or_past_Lennox_relationship__c; // not on contact
                OppScorecard.Would_participate_in_Lennox_promotions__c	 = ld.Would_participate_in_Lennox_promotions__c;
                OppScorecard.Dealer_has_experienced_recent_change__c	 = ld.Dealer_has_experienced_recent_change__c;
                OppScorecard.Has_a_clear_vision_of_their_goals__c		 = ld.Has_a_clear_vision_of_their_goals__c;
                OppScorecard.Customer_leadership_support_at_all_level__c = ld.Customer_leadership_support_at_all_level__c;
                OppScorecard.Established_a_decision_deadline__c			 = ld.Established_a_decision_deadline__c;
                OppScorecard.Understands_Lennox_value_proposition__c	 = ld.Understands_Lennox_value_proposition__c;
                OppScorecard.Satisfied_with_their_current_supplier__c	 = ld.Satisfied_with_their_current_supplier__c;
                OppScorecard.Dealer_has_Partnership_Mentality__c		 = ld.Dealer_has_Partnership_Mentality__c;
                OppScorecard.Scorecard_Stage__c							 = '3 - TM: Under Review';
                scorecardToUpsert.add(OppScorecard);
                
                //create a task
                Task t = CreateConvertedLeadTask(ld);
                tskList.add(t);
                System.debug('**Task created ' + t );
                
            }//end if converted
        }//end for
        //Create or Update Opp Scorecard
        if (scorecardToUpsert.size() > 0){
        	Upsert scorecardToUpsert;    
        }
        //Create Task upon Lead Conversion
        System.debug('**Method OppScorecardUpsert tskList.size ' + tskList.size() + tskList);
        if (tskList.size() > 0){	
            insert tskList;
        }
    }   
    
    
    
    /*
    * @Purpose  : Get list of Account Opp Scorecards for input list of converted Leads
    * @Param    : List <Lead> newLead
    * @Return   : List <Scorecard__c>
    */        
    public static List<Scorecard__c> GetOppScorecardList(List <Lead> newLead)
    {    
        
        List <Scorecard__c> existingScorecardList = new List <Scorecard__c> ();
        set  <String>       AcctIDs               = new set<string>();

        //Get list of Lead converted Account Ids 
        for (Lead ld : newLead){
           try{
                AcctIDs.add(ld.convertedAccountId); 
           }catch (Exception e){
                System.debug('**Error getting converted AcctId: ' + e.getMessage() );        
           }
        }
        // Get Opp Scorecard for those Accounts
        existingScorecardList = [Select Id, Account__c 
                                   From Scorecard__c 
                                  where Account__c in : AcctIDs];
        return existingScorecardList; 
    } 
    

    
    /*
    * @Purpose  : Get Account Opp Scorecards for a given Lead
    * @Param    : List <Lead> newLead
    * @Return   : Scorecard__c
    */            
    public static Scorecard__c  GetExistingOppScorecard(Lead lead, List<Scorecard__c> existingScorecardList)
    {   
        integer      i              = 0;
        Scorecard__c sc             = null;
        
        //get existing opp scorecard if there is one
        if (lead.convertedAccountId != null){
            while (i < existingScorecardList.size()){
                if (existingScorecardList[i].account__c == lead.convertedAccountId){
                    sc = existingScorecardList[i];
                    break;
                }i++;
            }
        }
        return sc;      
    } 
     

    
    /*
    * @Purpose  : Update a lead [Assignment, Stage and Status] based on the lead owner selected
    * @Param    : Lead ld
    * @Return   : 
    */            
    public static boolean LeadUpdatedBasedOnOwner(Lead ld)
    {
        // Update Lead based on Lead Owner Role
        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
        System.debug('**Method: LeadUpdatedBasedOnOwner -- LeadOwnerType is ' + LeadOwnerType);
        switch on LeadOwnerType{
            when 'DM', 'ASM'{
                if(!IsLeadOKToContinue(ld)){
                    Return false;
                }
                ld.Lead_Assignment__c = 'District Manager';  
                ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';
                ld.Status             = 'Field Review';
                ld.RecordTypeId       = g_OpenLeadRecTypId;
                ld.Status_Reason__c   = ''; 
                ld.Nurture_Option__c  = '';
                //get BDM email for email notification
                user ownerUsrRec = GetCurrentLeadOwnerUser(ld.OwnerId);
                try{
                    string BDMemail  = g_BdmDistMap.get(ownerUsrRec.SAP_Sales_Office__c).BDM__r.email;  
                    System.debug('**BDMemail ' + BDMemail);
                    ld.Email_BDM__c       = BDMemail;
                }catch (Exception e){
                    System.debug('**BDMemail ERROR not found ' );
                }
            }
            when 'TM'{
                if(!IsLeadOKToContinue(ld)){
                    Return false;
                }
                ld.Lead_Assignment__c = 'Territory Manager';
                ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';
                ld.Status             = 'Field Review';   
                ld.RecordTypeId       = g_OpenLeadRecTypId;
                ld.Status_Reason__c   = ''; 
                ld.Nurture_Option__c  = '';
                ld.RecordTypeId       = g_OpenLeadRecTypId;
                //get BDM email for email notification
                user ownerUsrRec = GetCurrentLeadOwnerUser(ld.OwnerId);
                try{
                    string BDMemail  = g_BdmDistMap.get(ownerUsrRec.SAP_Sales_Office__c).BDM__r.email;  
                    System.debug('**BDMemail ' + BDMemail);
                    ld.Email_BDM__c       = BDMemail;
                }catch (Exception e){
                    System.debug('**BDMemail ERROR not found ' );
                }
            }
            when 'CSS'{
                ld.Lead_Assignment__c = 'Sales Qualification Team';
                ld.Lead_Stage__c      = 'Marketing Qualified (MQL)';
                ld.Status             = 'In Progress';
                ld.RecordTypeId       = g_OpenLeadRecTypId;
                ld.Email_DM__c        = '';
                ld.Status_Reason__c   = ''; 
                ld.Nurture_Option__c  = '';  
            }
            when 'PLQ'{
                ld.Lead_Assignment__c = 'Marketing';
                ld.Lead_Stage__c      = 'Marketing Qualified (MQL)';
                ld.Status             = 'New';  
                ld.RecordTypeId       = g_OpenLeadRecTypId;
                ld.Email_DM__c        = '';
                
            }
            when 'Other'{
                // nothing for now
            }
        }//end switch  
        System.debug('**Method LeadUpdatedBasedOnOwner updated Lead Assignment Stage Status Email DM/BDM Status Reason Nurture Option ' + ld.Lead_Assignment__c + ld.Lead_Stage__c + ld.Status + ld.Email_DM__c + ld.Email_BDM__c + ld.Status_Reason__c + ld.Nurture_Option__c );  
        Return true;
    }
       
     
    
    /*
    * @Purpose  : Create a task assigned to the lead owner for a coverted lead
    * @Param    : Lead ld
    * @Return   : 
    */                           
    public static task CreateConvertedLeadTask(Lead ld)
    {
        System.debug('**Method: CreateConvertedLeadTask(Lead ld) ');
        //create a task
        Task tsk          = new Task();
        tsk.Subject       = 'Finish completing Opportunity Scorecard';
        tsk.WhoId         = ld.ConvertedContactId; //Lead or Contact 
        tsk.WhatId        = ld.convertedAccountId; //Account 
        tsk.OwnerId       = ld.OwnerId;
        tsk.ActivityDate  = date.today().addDays(14);
        tsk.Task_Type__c  = 'Sales Process Action';
        tsk.Task_Topic__c = 'Update Scorecard';
        tsk.Priority      = 'High';
        tsk.Description   = 'This is a reminder to update all open fields on the Opportunity Scorecard for this new account.';
        return tsk;
    }
    
    ///////////////////////////////////////////////// C O N T A C T //////////////////////////////////////////////////
    
    /*
    * @Purpose  : Update known lead (Contact) if contact is flagged as lead to prospect
    * @Param    : List<Contact> newContact
    * @Return   : 
    */                                   
    public static void OnContactBeforeInsert(List<Contact> newContact)
    {
        system.debug('Contact Trigger On Before Insert');
        
        for (Contact c : newContact){
            //set lead values based on the owner
            if (c.Lead_to_Prospect__c){
            	SetNewKnownLead(c);
            }
        }        
    }

    
    
    /*
    * @Purpose  : Update known lead (Contact) if contact is flagged as lead to prospect
    * @Param    : List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap
    * @Return   : 
    */                                       
    public static void OnContactBeforeUpdate( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap )
    {
        for (Contact ld : newContact) {
            // if Lead to Prospect flag has been checked on the contact >> assign to CST
            if ( ld.Lead_to_Prospect__c && !oldContactMap.get(ld.Id).Lead_to_Prospect__c){
				SetNewKnownLead(ld);     
                
            }else if (ld.OwnerId != oldContactMap.get(ld.Id).OwnerId){
                updateContactBasedOnOwner(ld);
                
            }else if(ld.Lead_Assignment__c != oldContactMap.get(ld.ID).Lead_Assignment__c){

                switch on ld.Lead_Assignment__c{
                    
                    //When Lead Assignment is "District Manager" 
                    when 'District Manager'{   
                        // When Lead assigned to a DM the Owner should be a DM
                        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
                        System.debug('**Lead Assignment to DM and Contact Owner is a ' + LeadOwnerType );
                        if ((LeadOwnerType != 'DM') && (LeadOwnerType != 'ASM')){
                            if (!currentUser.Admin_Bypass__c){
                                ld.addError(system.label.LeadAssignmentDM, true);
                                continue;
                            }
                        }
                        ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';
                    }
                    
                    //When Lead Assignment is Territory Manager" 
                    when 'Territory Manager'{   
                        // When Lead assigned to a TM the Owner should be a TM
                        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
                        System.debug('**Lead Assignment to TM and Contact Owner is a ' + LeadOwnerType );
                        if(LeadOwnerType != 'TM'){
                            if (!currentUser.Admin_Bypass__c){
                                ld.addError(system.label.Lead_Assignment_to_TM, true);
                                continue;
                            }
                        }
                        ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';
                    }
                }
            }
        }
    }    

    
    
    /*
    * @Purpose  : set known lead (contact) values when contact is flagged as lead to prospect
    * @Param    : Lead ld
    * @Return   : 
    */                               
    public static void SetNewKnownLead(Contact c){
        //get prospecting contact record Id
        Id ProspectRecTypId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Prospecting Contact').getRecordTypeId();
		//set contact values for known lead
        c.RecordTypeId        = ProspectRecTypId;  
        c.Lead_Assignment__c  = 'Sales Qualification Team'; 
        c.Lead_Stage__c       = '0 - Marketing Qualified (MQL)'; 
        System.debug('**SetNewKnownLead() Contact was updated to prospecting contact Lead Assignment was updated to CST for: ' + c.FirstName + c.LastName );        
    	System.debug('**SetNewKnownLead() RecordType Lead Assignment and Stage were updated for: ' + c.FirstName + c.LastName );        
    }
        
    

    /*
    * @Purpose  : Update a Contact [Assignment, Stage and Status] based on the owner selected
    * @Param    : Lead ld
    * @Return   : 
    */            
    public static void updateContactBasedOnOwner(Contact ld)
    {
        // Update Lead based on Lead Owner Role
        string LeadOwnerType = LeadOwnerType(ld.OwnerId);
        switch on LeadOwnerType{
            when 'DM', 'ASM'{
                ld.Lead_Assignment__c = 'District Manager';  
                ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';
                
				user ownerUsrRec = GetCurrentLeadOwnerUser(ld.OwnerId);
                string BDMemail  = g_BdmDistMap.get(ownerUsrRec.SAP_Sales_Office__c).BDM__r.email;  
                System.debug('**BDMemail ' + BDMemail);
                ld.Email_BDM__c       = BDMemail;
            }
            when 'TM'{
                ld.Lead_Assignment__c = 'Territory Manager';
                ld.Lead_Stage__c      = '1 - Sales Pre-Qualification';

				user ownerUsrRec = GetCurrentLeadOwnerUser(ld.OwnerId);
                string BDMemail  = g_BdmDistMap.get(ownerUsrRec.SAP_Sales_Office__c).BDM__r.email;  
                System.debug('**BDMemail ' + BDMemail);
                ld.Email_BDM__c       = BDMemail;
            }
            when 'CSS'{
                ld.Lead_Assignment__c = 'Sales Qualification Team';
                ld.Lead_Stage__c      = 'Marketing Qualified (MQL)';
            }
        }//end switch 
        System.debug('**New Lead Assignment is: ' + ld.Lead_Assignment__c );
    }
    
    
}