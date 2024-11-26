/* 
* @Class Name 	: QuickLinksLightningHomePageController
* @Purpose 		: Fatch the current user's data check the permission of ech tab for the quick links lightning component.
				  Ligthning Component Name - QuickLinksLighningHomePageComp.
*/
public class QuickLinksLightningHomePageController {
    
    /* 
	* @Purpose 		: Fatch the Current User Details, Grt the count of approved CDQ Account Opportunity, get the number of items to approve
					  Create the wrapper of data and retun in response
	* Return		: Response
	*/
    @AuraEnabled 
    public static Response fetchUser(){
        try{
            User u = [SELECT Id, Profile.Name FROM User where id =: userInfo.getUserId()];
            Quick_Links_Cmp_Setting__c quickLinksConfig; //= Quick_Links_Cmp_Setting__c.getValues(u.Profile.Name);
            //We can no longer use Custom Setting Name because the profile is longer than 40 characters. We've ended up using a custom field "Profile Name". 
            Map<String, Quick_Links_Cmp_Setting__c> mcs = Quick_Links_Cmp_Setting__c.getAll();
            for(Quick_Links_Cmp_Setting__c s : mcs.values()){
                if(s.Profile_Name__c==u.Profile.Name){
                    quickLinksConfig=s;
                    break;
                }
            }

            //string profileName = u.Profile.Name;
            
            if(quickLinksConfig != NULL){
               
                tapPermissionsWrapper tabPermission = new tapPermissionsWrapper();
                tabPermission.currentUser = u;
                tabPermission.CDQ = quickLinksConfig.CDQ__c;
                tabPermission.MapTool = quickLinksConfig.MapTool__c;
                tabPermission.SFMaps = quickLinksConfig.Salesforce_Maps__c;
                tabPermission.TerritoryRollupSummary = quickLinksConfig.TerritoryRollupSummary__c;
                tabPermission.DistrictRollupSummary = quickLinksConfig.DistrictRollupSummary__c;
                tabPermission.RegionRollupSummary = quickLinksConfig.RegionRollupSummary__c;
                tabPermission.RollupSummary = quickLinksConfig.RollupSummary__c;
                tabPermission.Approvalrequests = quickLinksConfig.Approvalrequests__c;
                tabPermission.ManagerRollup = quickLinksConfig.Store_Manager_Rollup__c;
                tabPermission.ZoneRollup = quickLinksConfig.Store_Zone_Rollup__c;
                tabPermission.RegionRollup = quickLinksConfig.Store_Region_Rollup__c;
                tabPermission.ExecutiveRollup = quickLinksConfig.Store_Executive_Rollup__c;
                
                /*tabPermission.Approvalrequests = true;
    tabPermission.BaseURL = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm() );
    
    if( profileName.contains('Res Sales TM') || profileName.contains('FDC - Lennox - Inside Sales - CDQ')){
    tabPermission.CDQ = true;
    }
    if(profileName.contains('Lennox - Res Sales TM') || profileName.contains( 'Lennox - Res Sales TM Pilot' )){
    tabPermission.TerritoryRollupSummary = true;
    }
    if(profileName.contains('Lennox - Res Sales DM') || profileName.contains('Lennox - Res Sales DM Pilot') || profileName.contains('Lennox - Res Sales ASM')){
    tabPermission.DistrictRollupSummary = true;
    }
    if(profileName.contains('Lennox - Res Sales AM') || profileName.contains('Lennox - Res Sales AM Pilot') || profileName.contains('Lennox - Res Sales RBM') || profileName.contains('Lennox - Res Sales BDM')){
    tabPermission.RegionRollupSummary = true;
    }
    if(profileName.contains('Lennox Business Administrator Super') || profileName.contains( 'Lennox Business Administrator') || profileName.contains('Lennox - Res Sales - EXE') || profileName.contains( 'Lennox - Res Sales - BDM' )){
    tabPermission.RollupSummary = true;
    } 
    if(profileName.contains('FDC - Lennox - LPP CSA')){               //CSA
    tabPermission.MapTool = true;
    tabPermission.Approvalrequests = false;
    }
    if(profileName.contains('FDC - Lennox - LPP Store_Zone Mgr')) {   //SM - store manager
    tabPermission.MapTool = true;
    tabPermission.Approvalrequests = false;
    }
    if(profileName.contains('FDC - Lennox - LPP ZM/AZM/RZD')) {       //ZM - zone Manager
    tabPermission.MapTool = true;
    tabPermission.Approvalrequests = false;
    }*/
                
                //Integer numItems = ItemsToApprove();
                //string label = 'Items to Approve ('+numItems+')';
                tabPermission.numItems = ItemsToApprove();
                tabPermission.ApprovedCDQ = getApprovedCDQAccountOppsCount();
                return new Response(true,tabPermission,'user Record Found');
            }else{
                return new Response(false,null,'Could not found record for this User profile in Custom Settings');
            }
            
        }catch(exception e){
            
            system.debug('Exception Occure +++ '+e);
            return new Response(false, null ,'Error While fetching user');
        }
    }
    
    /* 
	* @Purpose 		: get count of Appprove CDQ Account Opportunity
	* Return		: Integer 
	*/    
    public static Integer getApprovedCDQAccountOppsCount() {
        return [SELECT COUNT() FROM Account_Opportunty__c 
                WHERE isApproved__c = TRUE AND Opportunity_Type__c = 'CDQ Request' AND (Opportunity_Status__c = 'In Progress' OR Opportunity_Status__c = 'Not Started')
                AND dealer_name__r.OwnerId = :UserInfo.getUserId()];
    }
 
    /* 
	* @Purpose 		: Get the count of Items to approve
	* Return		: Integer 
	*/ 
    public static Integer ItemsToApprove(){
        Integer numItems = 0;
        String userId = UserInfo.getUserId();
        //System.debug('User Id : ' + userId);
        /*
        List<ProcessInstance> process = [
            Select Id, TargetObjectId, isDeleted, Status,
            (
                Select Id, ProcessInstanceId, ActorId, Actor.Name, StepStatus, Comments 
                From StepsAndWorkItems
                Where 
                StepStatus = 'Pending'  and
                isDeleted = false and
                ActorId = :userId                   
            )
            From ProcessInstance
            Where
            Status = 'Pending' and
            isDeleted = false                   
        ];  
        
        for(ProcessInstance processIns:process){
            numItems = numItems + processIns.StepsAndWorkItems.size(); 
            //if(processIns.StepsAndWorkItems.size()> 0 )
            // System.debug('Size: ' + processIns.status  + ' , ' + processIns.targetObjectId + ' ,' + processIns.targetobjectid);       
        }       
        */
        List<ProcessInstanceWorkitem> pIW = [
            SELECT Id 
            FROM ProcessInstanceWorkitem 
            WHERE ActorId = :userId AND ProcessInstance.Status = 'Pending'];
        numItems = pIW != null ? pIW.size() : 0;

        return numItems;
    }
    
    /* 
	* @Purpose 		: Wrapper Class to send the data to lighnting comp
	*/    
    public class tapPermissionsWrapper{
         @AuraEnabled public User currentUser;
         @AuraEnabled public Boolean CDQ;
         @AuraEnabled public Boolean MapTool;
         @AuraEnabled public Boolean TerritoryRollupSummary;
         @AuraEnabled public Boolean DistrictRollupSummary;
         @AuraEnabled public Boolean RegionRollupSummary;
         @AuraEnabled public Boolean RollupSummary;
         @AuraEnabled public Boolean ManagerRollup;
         @AuraEnabled public Boolean ZoneRollup;
         @AuraEnabled public Boolean RegionRollup;
         @AuraEnabled public Boolean ExecutiveRollup;         
         @AuraEnabled public Boolean Approvalrequests;
         @AuraEnabled public string  BaseURL;
         @AuraEnabled public Integer numItems;
         @AuraEnabled public Integer ApprovedCDQ;
        @AuraEnabled public Boolean SFMaps;
        
         public tapPermissionsWrapper(){
             
             this.CDQ = false;
             this.MapTool = false;
             this.TerritoryRollupSummary = false;
             this.DistrictRollupSummary = false;
             this.RegionRollupSummary = false;
             this.RollupSummary = false;
             this.ManagerRollup = false;
             this.ZoneRollup = false;
             this.ExecutiveRollup = false;
             this.RegionRollup = false;             
             this.Approvalrequests = true;
             this.SFMaps = false;
             this.BaseURL = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm() );
         }
    }

    /* 
	* @Purpose 		: Response Class
	*/    
    public class Response{
        @AuraEnabled
        public string msg;
        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public object data;
        
        public Response(boolean isSuccess, object data, string msg){
            this.isSuccess = isSuccess;
            this.data = data;
            this.msg = msg;
        }
    }
}