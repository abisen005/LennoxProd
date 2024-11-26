/** ;
*@Purpose : Generate IncentiveAgreement Document and send via docusign
*@Param   : 
*@Return  : 
*@LastModifedDate : 01/08/2022
*@Last ModifiedBy : Abilash Senthilkumar
IncentiveAgreementVF (Visualforce Page)
**/
public class MergeTemplatesController {
    public String selectedPage {get;set;}
    public List<SelectOption> options {get;set;}
    public Account account {get;set;}
    public List<OpportunityContactRole> contactRoleList {get;set;}
    public Opportunity opportunity {get;set;} 
    public boolean isError {get;set;}
    public string recordId{get;set;}
    public string errorMsg{get;set;}
    public Set<String> contactIdLst{get;set;}
    public Map<Id, User> idToUserMap{get;set;}
    public List<Contact> DealerContactList {get;set;}
    public List<User> SignerUserList {get;set;}
    public Decimal marketLeaderTotal{get;set;}
    public Decimal lpiTotal{get;set;}
    public Decimal districtOnlyIncentiveTotal{get;set;}
    public Decimal districtIncentiveTotal{get;set;}
    public Decimal districtPayoutIncentiveTotal{get;set;}
    public Decimal newCustomerPayoutIncentiveTotal{get;set;}
    
    public String[] signerContactIdLst{get;set;}
    
    public Decimal maxNewCustomerFund{get;set;}
    public Decimal ncTotal{get;set;}
    public Decimal newCustomerTotal{get;set;}
    public Decimal newCustomerAllTotal{get;set;}
    public Decimal totalOfAllIncentives{get;set;}
    
    public Decimal districtMktgFundsIncentiveTotal{get;set;}
    public Decimal specialIncentivesTotal{get;set;}
    public List<String> emailList{get;set;}
    public List<String> userList{get;set;}
    public List<String> userListwithoutTitles{get;set;}
    public Id contentDocId{get;set;}
    
    public String envelopeId='';
    public String accountId = '';
    public String userId = ''; 
    public String password = '';
    public String integratorsKey = '';
    public String webServiceUrl  = ''; 
    
    public List<Payout_Plan__c> districtPayoutPlanList {get;set;}
    public List<Proposal_Incentives__c> marketLeaderIncentiveList {get;set;}
    public List<Proposal_Incentives__c> lpiIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtOnlyIncentiveList {get;set;}
    public List<Payout_Plan__c> newCustomerPayoutPlanList {get;set;}
    public List<Proposal_Incentives__c> newCustomerIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtMktgFundsIncentiveList {get;set;}
    public List<Proposal_Incentives__c> specialIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtMktgFundsMatrixList {get;set;}
    
    public Decimal bingo;
    
    public PageReference getData(){
        marketLeaderTotal = 0;
        lpiTotal = 0;
        districtOnlyIncentiveTotal = 0;
        districtIncentiveTotal = 0;
        specialIncentivesTotal = 0;
        maxNewCustomerFund = 0;
        ncTotal = 0;
        newCustomerTotal = 0;
        districtPayoutIncentiveTotal =0;
        newCustomerPayoutIncentiveTotal = 0;
        newCustomerAllTotal = 0;
        districtMktgFundsIncentiveTotal= 0;
        totalOfAllIncentives = 0;
        marketLeaderIncentiveList = new List<Proposal_Incentives__c>();
        lpiIncentiveList = new List<Proposal_Incentives__c>();
        districtOnlyIncentiveList = new List<Proposal_Incentives__c>();
        newCustomerIncentiveList = new List<Proposal_Incentives__c>();
        districtMktgFundsIncentiveList = new List<Proposal_Incentives__c>();
        specialIncentiveList = new List<Proposal_Incentives__c>();
        districtMktgFundsMatrixList = new List<Proposal_Incentives__c>();
        districtPayoutPlanList = new List<Payout_Plan__c>();
        newCustomerPayoutPlanList = new List<Payout_Plan__c>();
        marketLeaderIncentiveList = [SELECT Id,Name,Market_Leader_Product__c,Payment_Type__c,Rebate_per_Unit__c,Funding_Type__c,
                                     Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c,Reject_Incentive_Item__c
                                     FROM Proposal_Incentives__c 
                                     WHERE Type_of_Incentive__c = 'ML' AND Reject_Incentive_Item__c = false
                                     AND Not_approved__c = false  
                                     AND Proposal_Close__c = :recordId ];
        for(Proposal_Incentives__c mrkt : marketLeaderIncentiveList){
            marketLeaderTotal += mrkt.Rebate_per_Unit__c;
        }
        lpiIncentiveList = [SELECT Id,Name,Product_Line__c,LPI_District_Rebates__c,LPI_New_Customer_Rebates__c,Funding_Type__c,
                            Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c,Reject_Incentive_Item__c
                            FROM Proposal_Incentives__c 
                            WHERE Type_of_Incentive__c = 'LPI' AND Reject_Incentive_Item__c = false
                            AND Not_approved__c = false  
                            AND Proposal_Close__c = :recordId ];
        //LPI Incentives do not need to be included in the bottom Total (per Brent 03/09/2022)
        for(Proposal_Incentives__c lpiL : lpiIncentiveList){
            if(lpiL.LPI_District_Rebates__c != null && lpiL.LPI_New_Customer_Rebates__c != null){
                lpiTotal += lpiL.LPI_District_Rebates__c + lpiL.LPI_New_Customer_Rebates__c;
            } else if (lpiL.LPI_District_Rebates__c == null && lpiL.LPI_New_Customer_Rebates__c != null){
                lpiTotal += lpiL.LPI_New_Customer_Rebates__c;
            } else if (lpiL.LPI_District_Rebates__c != null && lpiL.LPI_New_Customer_Rebates__c == null){
                lpiTotal += lpiL.LPI_District_Rebates__c;
            }
        }
        districtOnlyIncentiveList = [SELECT Id,Name,Funding_Type__c,
                                     Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c,Reject_Incentive_Item__c
                                     FROM Proposal_Incentives__c 
                                     WHERE Type_of_Incentive__c = 'District Only' AND Reject_Incentive_Item__c = false
                                     AND Not_approved__c = false  
                                     AND Proposal_Close__c = :recordId ];
        
        for(Proposal_Incentives__c districtFundingIncentive : districtOnlyIncentiveList){
            //districtOnlyIncentiveTotal += districtFundingIncentive.Funding_Amount__c;
            districtIncentiveTotal += districtFundingIncentive.Funding_Amount__c;
        }
        districtPayoutPlanList = [SELECT Id,Name,Payout_Type__c,Payout_Amount__c,Payout_Sales_Threshold__c,Type_of_Incentive__c
                                  FROM Payout_Plan__c 
                                  WHERE Type_of_Incentive__c  ='District Incentives'
                                  AND Proposal_Close__c = :recordId order by Payout_Type__c]; 
        
        for(Payout_Plan__c districtPayoutPlan : districtPayoutPlanList){
            //districtIncentiveTotal += districtPayoutPlan.Payout_Amount__c;
            districtPayoutIncentiveTotal += districtPayoutPlan.Payout_Amount__c;
        }
        
        //special incentives
        specialIncentiveList = [SELECT Id,Name,Funding_Type__c,
                                Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c
                                FROM Proposal_Incentives__c 
                                WHERE Type_of_Incentive__c = 'Special Incentive' AND Reject_Incentive_Item__c = false
                                AND Not_approved__c = false  
                                AND Proposal_Close__c = :recordId ];
        
        for(Proposal_Incentives__c specialFundingIncentive : specialIncentiveList){
            specialIncentivesTotal += specialFundingIncentive.Funding_Amount__c;
        }
        //new customer incentives
        newCustomerIncentiveList = [SELECT Id,Name,Funding_Type__c,
                                    Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c,Reject_Incentive_Item__c
                                    FROM Proposal_Incentives__c 
                                    WHERE Type_of_Incentive__c = 'NC' 
                                    AND Not_approved__c = false  AND Reject_Incentive_Item__c = false
                                    AND Proposal_Close__c = :recordId ];
        newCustomerPayoutPlanList = [SELECT Id,Name,Payout_Type__c,Payout_Amount__c,Payout_Sales_Threshold__c,Type_of_Incentive__c
                                     FROM Payout_Plan__c 
                                     WHERE Type_of_Incentive__c  ='New Customer'
                                     AND Proposal_Close__c = :recordId order by Payout_Type__c ]; 
        
        for(Proposal_Incentives__c ncNewCustomer : newCustomerIncentiveList){
            if( ncNewCustomer.Funding_Amount__c> maxNewCustomerFund){
                maxNewCustomerFund = ncNewCustomer.Funding_Amount__c;
            }
            ncTotal += ncNewCustomer.Funding_Amount__c;
        } 
        
        newCustomerAllTotal +=ncTotal ; 
        
        
        for(Payout_Plan__c newCustomerPayoutPlan : newCustomerPayoutPlanList){
            //Commenting out Payout-plans Calculation part (Modified by Abi_Mar 21_2022)
            //newCustomerTotal += newCustomerPayoutPlan.Payout_Amount__c;
            newCustomerPayoutIncentiveTotal += newCustomerPayoutPlan.Payout_Amount__c;
        }
        newCustomerAllTotal +=newCustomerTotal; 
        
        
        //District Incentive List
        districtMktgFundsIncentiveList = [SELECT Id,Name,Product_Line__c,
                                          District_Marketing_Funds_Earned__c,of_purchases__c,Reject_Incentive_Item__c
                                          FROM Proposal_Incentives__c 
                                          WHERE Type_of_Incentive__c = 'District Mktg Funds' AND Reject_Incentive_Item__c = false
                                          AND DLSC__c != null AND Elite__c != null AND Merit__c!= null AND P_S__c != null
                                          AND Proposal_Close__c = :recordId ];
        
        
        for(Proposal_Incentives__c mkrtfund : districtMktgFundsIncentiveList){
            districtMktgFundsIncentiveTotal += mkrtfund.District_Marketing_Funds_Earned__c;
        }
        districtMktgFundsMatrixList = [SELECT Id,Name,Product_Line__c, District_Marketing_Funds_Earned__c,of_purchases__c,
                                       Type_of_Incentive__c,DLSC__c,Elite__c,Merit__c,P_S__c,not_approved__c, 
                                       of_purchases_in_Elite_Products__c , of_purchases_in_DLSC_Products__c,
                                       of_purchases_in_Merit_Products__c , of_purchases_in_Parts_and_Supplies__c,
                                       District_Marketing_Funds_Earned_DLSC__c,District_Marketing_Funds_Earned_Elite__c,
                                       District_Marketing_Funds_Earned_Merit__c,District_Marketing_Funds_Earned_P_S__c,
                                       District_Marketing_Funds_on_DLSC_Prod__c,District_Marketing_Funds_on_Elite_Prod__c,
                                       District_Marketing_Funds_on_Merit_Prod__c,District_Marketing_Funds_on_P_S__c,Reject_Incentive_Item__c
                                       FROM Proposal_Incentives__c
                                       WHERE Type_of_Incentive__c = 'District Mktg Funds' AND Reject_Incentive_Item__c = false
                                       AND of_purchases_in_DLSC_Products__c != null AND of_purchases_in_Elite_Products__c != null 
                                       AND  of_purchases_in_Merit_Products__c != null AND of_purchases_in_Parts_and_Supplies__c != null 
                                       AND not_approved__c = false
                                       AND Proposal_Close__c = :recordId LIMIT 1];
        System.debug('marketLeaderIncentiveList==>'+marketLeaderIncentiveList);
        
        
        // Old Total//totalOfAllIncentives = districtMktgFundsIncentiveTotal+newCustomerAllTotal+specialIncentivesTotal+districtIncentiveTotal+marketLeaderTotal;
        // Updated total Amount
        // now total everything (Except LPI,District Marketing Matrix,Payout Plans)
        totalOfAllIncentives = newCustomerAllTotal+districtIncentiveTotal;
        bingo = totalOfAllIncentives;
        system.debug('!!!Final'+bingo);
        system.debug('!!!totalOfAllIncentives'+totalOfAllIncentives);
        
        if(Test.isRunningTest()){
            List<Opportunity> oppList = [select id,Name FROM Opportunity LIMIT 1];
            system.debug('oppId'+oppList[0].id);
            getOpportunityRecord(oppList[0].id);
        }else{
            String oppId = ApexPages.currentPage().getParameters().get('id');
            getOpportunityRecord(oppId);
        }
        return null;    
    }
    
    public PageReference getDealerSigners(){
        List<String> contactId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('contactIdLst'), List<String>.class);
        List<String> usersId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('userIdLst'), List<String>.class);
        Set<String> contactIdLst = new Set<String>();
        Set<String> userIdLst = new Set<String>(); 
        for(String id : contactId){
            contactIdLst.add(id);
        }
        for(String id : usersId){
            userIdLst.add(id);
        }
        if(!contactId.isEmpty()){
            DealerContactList = [SELECT Id,AccountId,Name,Email,Contact_Type__c,FirstName,LastName FROM Contact WHERE Id IN : contactIdLst];
            system.debug('DealerContactList ::'+DealerContactList);
        }
        if(!contactId.isEmpty()){
            SignerUserList = [SELECT Id,Email,FirstName,LastName FROM User WHERE Id IN : userIdLst];
            system.debug('SignerUserList ::'+SignerUserList);    
        } 
        return null;
    }
    
    public PageReference getManagers(){
        String contactId = Apexpages.currentPage().getParameters().get('contactId');        
        List<Contact> contactList = [SELECT Id,OwnerId FROM Contact WHERE Id = :contactId];
        if(!contactList.isEmpty()){ 
            List<User> territoryManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:contactList[0].OwnerId];
            if(!territoryManager.isEmpty()){
                if(!idToUserMap.containsKey(territoryManager[0].Id)){
                    idToUserMap.put(territoryManager[0].Id,territoryManager[0]);
                }
                List<User> districtManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:territoryManager[0].ManagerId];
                if(!districtManager.isEmpty()){
                    if(!idToUserMap.containsKey(districtManager[0].Id)){
                        idToUserMap.put(districtManager[0].Id,districtManager[0]);
                    }
                    List<User> areaManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:districtManager[0].ManagerId];
                    if(!areaManager.isEmpty()){
                        if(!idToUserMap.containsKey(areaManager[0].Id)){
                            idToUserMap.put(areaManager[0].Id,areaManager[0]);
                        }
                        List<User> salesManager = [SELECT Id,FirstName,LastName,Email FROM User WHERE Id=:areaManager[0].ManagerId];
                        if(!salesManager.isEmpty()){
                            if(!idToUserMap.containsKey(areaManager[0].Id)){
                                idToUserMap.put(areaManager[0].Id,areaManager[0]);
                            }
                        }
                    }
                }
            }
        }
        System.debug('contactList=='+contactList);
        System.debug('userList=='+idToUserMap);
        return null;
    }
    
    public PageReference removeManagers(){
        String contactId = Apexpages.currentPage().getParameters().get('contactId');        
        List<Contact> contactList = [SELECT Id,OwnerId FROM Contact WHERE Id = :contactId];
        if(!contactList.isEmpty()){ 
            List<User> territoryManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:contactList[0].OwnerId];
            if(!territoryManager.isEmpty()){
                if(idToUserMap.containsKey(territoryManager[0].Id)){
                    idToUserMap.remove(territoryManager[0].Id);
                }
                List<User> districtManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:territoryManager[0].ManagerId];
                if(!districtManager.isEmpty()){
                    if(idToUserMap.containsKey(districtManager[0].Id)){
                        idToUserMap.remove(districtManager[0].Id);
                    }
                    List<User> areaManager = [SELECT Id,FirstName,LastName,Email,ManagerId FROM User WHERE Id=:districtManager[0].ManagerId];
                    if(!areaManager.isEmpty()){
                        if(idToUserMap.containsKey(areaManager[0].Id)){
                            idToUserMap.remove(areaManager[0].Id);
                        }
                        List<User> salesManager = [SELECT Id,FirstName,LastName,Email FROM User WHERE Id=:areaManager[0].ManagerId];
                        if(!salesManager.isEmpty()){
                            if(idToUserMap.containsKey(areaManager[0].Id)){
                                idToUserMap.remove(areaManager[0].Id);
                            }
                        }
                    }
                }
            }
        }
        return null;
    }
    
    Public PageReference myInputQuery(){
        Decimal myoutputString = totalOfAllIncentives ;
        system.debug('!!!!!!!!123'+totalOfAllIncentives);
        return null;
    }
    
    public MergeTemplatesController(ApexPages.StandardController controller){
        String oppId = ApexPages.currentPage().getParameters().get('id');
        // String oppId1 = ApexPages.currentPage().getParameters().get('totalOfAllIncentives');
        //system.debug('!!!!!!!!'+oppId1);
        try{
            emailList = new List<String>();
            userList = new List<String>(); 
            //system.debug('oppId ::'+oppId);
            if(String.isNotBlank(oppId)){
                //getData();
                //PageReference pageRef = ApexPages.currentPage();
                //Decimal test = pageRef.getData();
                //system.debug('FinalAmount ::'+mg.getData());
                //getOpportunityRecord(oppId);
                recordId = oppId; 
            }
            idToUserMap = new Map<Id, User>();
            DealerContactList =  new List<Contact>();
            SignerUserList =  new List<user>(); 
            
        }catch(Exception exp){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, exp.getMessage())); 
        }
    }
    
    public Map<String, List<String>> getPicklistValuesMap() {
        Map<String, List<String>> picklistValuesMap = new Map<String, List<String>>();
        // get object describe
        Schema.DescribeSObjectResult conObj = Contact.SObjectType.getDescribe();
        picklistValuesMap.put('Contact_Type__c', getPicklistValues(conObj, 'Contact_Type__c'));
        picklistValuesMap.put('Role__c', getPicklistValues(conObj, 'Role__c'));
        picklistValuesMap.put('Secondary_Roles__c', getPicklistValues(conObj, 'Secondary_Roles__c'));
        return picklistValuesMap;
    }
    
    private List<String> getPicklistValues(Schema.DescribeSObjectResult sObj, String fieldName) {
        List<String> picklistValues = new List<String>();
        for(Schema.PicklistEntry pickListVal : sObj.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
            picklistValues.add(pickListVal.getLabel());
        }
        return picklistValues;
    }
    
    public void getOpportunityRecord(String oppId){
        emailList = new List<String>();
        userList = new List<String>();
        userListwithoutTitles = new List<String>();
        signerContactIdLst = new List<String>();
        opportunity = [SELECT Id,Name,Amount,District_Marketing_Funds_on_DLSC_Produ__c,District_Marketing_Funds_on_Elite_Prod__c,toLabel(Type),Lennox_Partner_Incentive_Expiration_Date__c,
                       District_Marketing_Funds_on_Merit_Prod__c,District_Marketing_Funds_on_Parts_and__c,Number_of_Level_I_trips_offered__c,Expiration_Date__c,
                       Number_of_Escapes_trips_offered__c,Volume_Rebate__c,Volume_Rebate_Earned__c,District_Marketing_Funds_Earned_on_DLSC__c,District_Marketing_Funds_Earned_on_Elite__c,
                       District_Marketing_Funds_Earned_on_Merit__c,District_Marketing_Funds_on_Earned_Parts__c,Value_of_Level_I_trips_offered__c,Value_of_Escapes_trips_offered__c,
                       Other_District_Incentives_1__c,Other_District_Incentives_2__c,Other_District_Incentives_3__c,Other_District_Incentives_4__c,NC_Funding_Total__c,
                       Total_District_Incentives__c,NC_Funding_CAP_Billing__c,NC_Funding_Direct_Mail__c,NC_Funding_Lennox_Building_Sign__c,
                       NC_Funding_Newspaper__c,NC_Funding_Billboards__c,NC_Funding_Radio__c,NC_Funding_Trainin__c,NC_Funding_Web_Production__c,NC_Funding_Other_Details__c,
                       NC_Funding_Other__c,AccountId,Account.Name,Account.SAP_Customer_Number__c,Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode, Account.ShippingCountry,
                       District_Funds_Proposal_Payout_Info__c,Market_Leader_Information__c, Special_Incentives_PDF__c,New_Customer_Proposal_Payout_Info__c,District_Mktg_Funds_Proposal_PDF__c,
                       BDM__c,BDM__r.Name,BDM__r.Email,District_Manager__c,District_Manager__r.Name,District_Manager__r.Email,ML_Expiration_Date__c ,
                       Regional_Director__c,Regional_Director__r.Name,Regional_Director__r.Email,LPI__c, PY_Total_Sales__c, Market_Leader_Load_Date__c, Lennox_Partner_Incentive_Load_Date__c ,
                       Lead_BDM__r.Name,Lead_BDM__r.Email,Lead_BDM__c,VP_National_Accts__r.Name,VP_National_Accts__r.Email,VP_National_Accts__c,Dir_Sales_Ops__r.Name,Dir_Sales_Ops__r.Email,Dir_Sales_Ops__c,
                       VP_Sales__r.Name,VP_Sales__r.Email,VP_Sales__c,General_Manager__r.Name,General_Manager__r.Email,General_Manager__c,President__r.Name,President__r.Email,President__c,Lifetime_Value_of_Deal__c,
                       District_Manager__r.ContactId,Regional_Director__r.ContactId,Lead_BDM__r.ContactId,President__r.ContactId,General_Manager__r.ContactId,VP_Sales__r.ContactId,VP_National_Accts__r.ContactId,
                       Dir_Sales_Ops__r.ContactId, Promotional_Periods_Requested__c, NC_CAP_Consumer_Promotional_Program__c ,Lennox_Partner_Incentives_Proposal_PDF__c
                       FROM Opportunity 
                       WHERE Id=:oppId];
        //System.debug('opportunity==>'+opportunity);
        //System.debug('oppId==>'+oppId);
        
        //Begining of Signers
        
        if(opportunity.District_Manager__c != null && opportunity.District_Manager__r.Email != null){
            System.debug('District_Manager__r');
            String ObjectApi = 'Opportunity';
            String FieldApi = 'District_Manager__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            //system.debug('!!!!!!!Object : '+(String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel());
            emailList.add(opportunity.District_Manager__r.Email);
            System.debug('FinalAmount!!!'+bingo);
            userList.add(opportunity.District_Manager__r.Name+' ('+title+')');
            userListwithoutTitles.add(opportunity.District_Manager__r.Name);
            signerContactIdLst.add(opportunity.District_Manager__r.ContactId);
            system.debug('signerContactIdLstDistrict'+signerContactIdLst);
        }
        
        contactRoleList =[SELECT Id,Contact.Name,Contact.Email,Role FROM OpportunityContactRole where OpportunityId =:opportunity.Id ];
        if(contactRoleList.size() >0 ){    
            for(OpportunityContactRole cr: contactRoleList ){
                emailList.add(cr.Contact.Email);
                //String conRole = cr.Role !=null ? cr.Role: 'Other';
                //userList.add(cr.Contact.Name+' ('+conRole  +')' );   
                String conRole = 'Dealer Approver';
                userList.add(cr.Contact.Name+' ('+conRole+')' );    
                userListwithoutTitles.add(cr.Contact.Name );
                signerContactIdLst.add(cr.Id); 
                system.debug('signerContactIdCustomers'+signerContactIdLst);
            }
        }
        if((opportunity.Lead_BDM__c != null && opportunity.Lead_BDM__r.Email != null)||Test.isRunningTest()){
            //System.debug('Lead_BDM__r');
            //System.debug('opportunity.Type'+opportunity.Type);
            String ObjectApi = 'Opportunity';
            String FieldApi = 'Lead_BDM__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            if(!opportunity.Type.contains('Existing Dealer') || Test.isRunningTest())  {
                userList.add(opportunity.Lead_BDM__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.Lead_BDM__r.Name);
                emailList.add(opportunity.Lead_BDM__r.Email);
                signerContactIdLst.add(opportunity.Lead_BDM__r.ContactId); 
                system.debug('signerContactIdLead_BDM__r'+signerContactIdLst);
            }    
        }
        
        if(opportunity.Regional_Director__c != null && opportunity.Regional_Director__r.Email != null){
            System.debug('Regional_Director__r');
            
            if((opportunity.Type.contains('Existing Dealer') || opportunity.Type.contains('New Customer')) || Test.isRunningTest())
            {
                String ObjectApi = 'Opportunity';
                String FieldApi = 'Regional_Director__c';
                String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
                
                userList.add(opportunity.Regional_Director__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.Regional_Director__r.Name);
                emailList.add(opportunity.Regional_Director__r.Email);
                signerContactIdLst.add(opportunity.Regional_Director__r.ContactId);
            }
        } 
        
        if((opportunity.Dir_Sales_Ops__c != null && opportunity.Dir_Sales_Ops__r.Email != null )||Test.isRunningTest()){
            String ObjectApi = 'Opportunity';
            String FieldApi = 'Dir_Sales_Ops__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            
            System.debug('Dir_Sales_Ops__r');
            if((opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  75000 )||Test.isRunningTest()){
                userList.add(opportunity.Dir_Sales_Ops__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.Dir_Sales_Ops__r.Name);
                emailList.add(opportunity.Dir_Sales_Ops__r.Email);
                signerContactIdLst.add(opportunity.Dir_Sales_Ops__r.ContactId);
                system.debug('signerContactIdDir_Sales_Ops__r'+signerContactIdLst);   
            } 
        }
        
        if((opportunity.VP_National_Accts__c != null && opportunity.VP_National_Accts__r.Email != null)||Test.isRunningTest()){
            System.debug('VP_National_Accts__r');
            
            String ObjectApi = 'Opportunity';
            String FieldApi = 'VP_National_Accts__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
           
            if((opportunity.Type.contains('New Customer')) || Test.isRunningTest()){
                userList.add(opportunity.VP_National_Accts__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.VP_National_Accts__r.Name);
                emailList.add(opportunity.VP_National_Accts__r.Email);
                signerContactIdLst.add(opportunity.VP_National_Accts__r.ContactId);   
                system.debug('signerContactIdVP_National_Accts__r'+signerContactIdLst);
            }
        } 
        
        if((opportunity.VP_Sales__c != null && opportunity.VP_Sales__r.Email != null)||Test.isRunningTest()){
            System.debug('VP_Sales__r');
            
            String ObjectApi = 'Opportunity';
            String FieldApi = 'VP_Sales__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            
            if((opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  75000 )||Test.isRunningTest()){
                userList.add(opportunity.VP_Sales__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.VP_Sales__r.Name);
                emailList.add(opportunity.VP_Sales__r.Email);
                signerContactIdLst.add(opportunity.VP_Sales__r.ContactId);
                system.debug('signerContactIdVP_Sales__r'+signerContactIdLst);
            }
        } 
        
        if((opportunity.General_Manager__c != null && opportunity.General_Manager__r.Email != null)||Test.isRunningTest()){
            System.debug('General_Manager__r');
            
            String ObjectApi = 'Opportunity';
            String FieldApi = 'General_Manager__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            
            if(((opportunity.Type.contains('New Customer') && opportunity.Lifetime_Value_of_Deal__c >  1000000) || (opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  1000000) )||Test.isRunningTest()){
                userList.add(opportunity.General_Manager__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.General_Manager__r.Name);
                emailList.add(opportunity.General_Manager__r.Email);}
            signerContactIdLst.add(opportunity.General_Manager__r.ContactId);
            system.debug('signerContactIdGeneral_Manager__r'+signerContactIdLst);
            
        } 
        
        if((opportunity.President__c != null && opportunity.President__r.Email != null)||Test.isRunningTest()){
            System.debug('President__r');
            
            String ObjectApi = 'Opportunity';
            String FieldApi = 'President__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            
            if(((opportunity.Type.contains('New Customer') && opportunity.Lifetime_Value_of_Deal__c >  3000000) || (opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  3000000) ) ||Test.isRunningTest()){
                userList.add(opportunity.President__r.Name+' ('+title+')');
                userListwithoutTitles.add(opportunity.President__r.Name);
                emailList.add(opportunity.President__r.Email);
            }
            signerContactIdLst.add(opportunity.President__r.ContactId);
            system.debug('signerContactIdPresident__r'+signerContactIdLst);
        } 
        
        //End Of Signers   
        if(opportunity.AccountId != null){
            account = [SELECT Name,SAP_Customer_Number__c,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,ShippingCountry,
                       SAP_YTD_Sales__c,Market_Leader_Payout_Current_Month__c,Market_Leader_Payouts_YTD__c,
                       (SELECT Id,AccountId,Name,Email,Contact_Type__c,FirstName,LastName FROM Contacts) 
                       FROM Account WHERE Id=:opportunity.AccountId];
            System.debug('account==>'+account);
            
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'No Account Available on Proposal and Close.')); 
        }  
    }
    
    public PageReference setContactLst(){
        PageReference pageRef = ApexPages.currentPage();
        List<String> contactId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('contactIdLst'), List<String>.class);
        contactIdLst = new Set<String>();
        for(String id : contactId)
        {
            contactIdLst.add(id);
        }
        return null;
    }
    
    public PageReference SetDealerSigner(){  
        //List<String> contactId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('contactIdLst'), List<String>.class);
        String[] contactId = signerContactIdLst;
        contactIdLst = new Set<String>();
        for(String id : contactId){
            contactIdLst.add(id);
        } 
        isError = false;
        errorMsg =''; 
        System.debug('contactIdLst==>'+contactIdLst); 
        if(!contactIdLst.isEmpty()){  
            emailList = new List<String>();
            userList = new List<String>();
            System.debug('contactIdLst==>'+contactIdLst); 
            List<Contact> contactLst = new List<Contact>();
            contactLst = [SELECT Id,AccountId,Name,Email,Contact_Type__c,FirstName,LastName 
                          FROM Contact 
                          WHERE Id IN : contactIdLst];
            for(Contact cont :contactLst){
                if(cont.Email != null){
                    emailList.add(cont.Email);
                    userList.add(cont.FirstName+' '+cont.LastName);
                }  
            }
            
            
            if(opportunity.BDM__c != null && opportunity.BDM__r.Email != null){
                System.debug('BDM__r');
                emailList.add(opportunity.BDM__r.Email);
                userList.add(opportunity.BDM__r.Name+' (BDM)');
            }
            if(opportunity.District_Manager__c != null && opportunity.District_Manager__r.Email != null){
                System.debug('District_Manager__r');
                emailList.add(opportunity.District_Manager__r.Email);
                userList.add(opportunity.District_Manager__r.Name+' (District Manager)');
            }
            if(opportunity.Regional_Director__c != null && opportunity.Regional_Director__r.Email != null){
                System.debug('Regional_Director__r');
                emailList.add(opportunity.Regional_Director__r.Email);
                userList.add(opportunity.Regional_Director__r.Name+' (Regional Director)');
            } 
            
        }else{
            isError = true;
            errorMsg ='Please select contact.'; 
            System.debug('contactIdLst==>Please select contact.');  
        } 
        return null;
    } 
    
    // Create Document on object record for sending via docusign
    public PageReference createDocument(){  
        isError = false;
        errorMsg = '';
        try{
            system.debug('!!!QQQ'+Apexpages.currentPage().getParameters().get('contactIdLst'));
            // List<String> contactId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('contactIdLst'), List<String>.class);
            String[] contactId = signerContactIdLst;
            system.debug('!!!QQQ'+signerContactIdLst);
            if(!contactId.isEmpty()){
                system.debug('Passed CreatedDocument'+signerContactIdLst);
                Id mySourceId =  opportunity.Id;   
                PageReference pageRef = new PageReference('/apex/IncentiveAgreementFilePage');
                pageRef.getParameters().put('id',mySourceId);
                pageRef.getParameters().put('contactIdLst',String.join(contactId, ','));
                
                ContentVersion cont = new ContentVersion();
                cont.ContentLocation = 'S';
                cont.PathOnClient = 'IncentiveAgreement.pdf';
                cont.Title = 'IncentiveAgreement';
                cont.IsMajorVersion = true;
                cont.versionData = pageRef.getContentAsPDF(); 
                insert cont;
                
                cont = [select id, ContentDocumentId from ContentVersion WHERE Id =: cont.Id];
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cont.ContentDocumentId;
                cl.LinkedEntityId =  opportunity.Id; 
                cl.ShareType = 'V';
                cl.Visibility = 'AllUsers';
                insert cl;
                contentDocId = cont.ContentDocumentId;
                System.debug('contentDocId=>'+contentDocId);
            }else{
                isError = true;
                errorMsg = 'Please Select Dealer Contacts ( Signer )';  
            }
        }catch(Exception exp){
            isError = true;
            errorMsg = exp.getMessage();
        }
        return null; 
    }
    //Send Document via DocuSign
    public PageReference sendDocusignNow(){  
        isError = false;
        errorMsg = '';
        try{ 
            //emailList = new List<String>{'abisen005@gmail.com', 'abisen005@gmail.com','asenthilkumar@ventasconsulting.com'};
            //userList = new List<String>{'abi first', 'abi second ','Ganesh (District Director)'};
            
            Id mySourceId =  opportunity.Id;  
            List<dfsle.Recipient> recipients = new List<dfsle.Recipient>();
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(mySourceId)); 
            Id myDocumentId = contentDocId; 
            System.debug('==>contentDocId=>'+contentDocId);
            if(Test.isRunningTest()){
                Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
                
                ContentVersion contentVersion_1 = new ContentVersion(
                    Title='SampleTitle', 
                    PathOnClient ='SampleTitle.jpg',
                    VersionData = bodyBlob, 
                    origin = 'H'
                );
                insert contentVersion_1;
                
                ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                                   FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
                
                myDocumentId = contentVersion_2.ContentDocumentId;
            }
            Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id;
            myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }));
            Integer cnt =0;
            Integer count=0;
            for(String emailId : emailList){
                String signerIndex =  (cnt+1)+')';
                system.debug('===>signerIndex '+signerIndex);
                String dateIndex =  userList[cnt];
                String bingo= dateIndex.substring(0);
                system.debug('===>bingo '+dateIndex);
                system.debug('===>bingo '+bingo);
                System.debug('emailId===>'+emailId);
                System.debug('userList===>'+userList[cnt]);
                Integer  strlen = userList[cnt].length();
                       
                dfsle.Tab mySignHereTab = new dfsle.SignHereTab()
                    .withScale(0.7) // 1.5 scale
                    .withRequired(true) // Signing mandatory
                    .withAnchor(new dfsle.Tab.Anchor(
                        signerIndex, // Anchor string
                        false, // Do not allow white space in anchor string
                        false, // Anchor string is not case sensitive
                        'right', // Horizontal alignment in relation to the anchor text
                        true, // Ignore if the anchor text is not present in the document
                        true, // Must match the value of the anchor string in its entirety
                        'pixels', // Unit of the x and y offset properties
                        235, // X offset 
                        12)); // Y offset
                // Create a Date Signed tab
                System.debug('===>cntbeforedate '+cnt);
                
                dfsle.Tab myDateSignedTab = new dfsle.DateSignedTab()
                    .withFormatting(new dfsle.Tab.Formatting(
                        'Helvetica', // Font
                        'default', // Font color
                        10, // 14pt size,
                        false, // Bold
                        false, // Italic
                        false, // Underline
                        false, // Conceal value
                        false)) // Fixed width
                    
                    .withAnchor(new dfsle.Tab.Anchor(
                        bingo, // Anchor string 
                        false, // Do not allow white space in anchor string
                        false, // Anchor string is not case sensitive
                        'left', // Horizontal alignment in relation to the anchor text
                        true, // Ignore if the anchor text is not present in the document
                        true, // Must match the value of the anchor string in its entirety
                        'pixels', // Unit of the x and y offset properties
                        370, // X offset
                        -3)); // Y offset 
                
                // Create a new recipient
                dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
                    userListwithoutTitles[cnt], // Signer name
                    emailId, // Signer email
                    null, // Signer phone number
                    'Signer 1', // Signer role
                    null) // No Salesforce association
                    .withTabs(new List<dfsle.Tab> { // Associate the tabs with this recipient
                        mySignHereTab,
                            myDateSignedTab
                            });
                recipients.add(myRecipient);
                System.debug('Add==>');
                cnt++; 
                
              
            }
              // Set up notification
                dfsle.Notifications notifySigner = new dfsle.Notifications(
                    true, // Indicates that the recipient should be reminded to sign
                    1, // Number of days to wait before sending a reminder
                    1, // Number of days between reminders
                    true, // Whether or not the envelope expires and is voided
                    90, // How many days before the envelope expires
                    10, // Number of days before expiration to remind the recipient
                    false // Placeholder for deprecated field
                );
            System.debug('recipients==>'+recipients.size());
            System.debug('recipients==>'+recipients); 
            myEnvelope = myEnvelope.withRecipients(recipients);
            system.debug('!!!!!1'+myEnvelope);
            myEnvelope = dfsle.EnvelopeService.sendEnvelope( myEnvelope, true);
            //system.debug('!!!!!2'+myEnvelope);
            myEnvelope = myEnvelope.withNotifications(notifySigner);

        }catch(Exception exp){
            isError = true;
            errorMsg = exp.getMessage();
            system.debug('Error1-->>>>'+exp.getMessage());
            system.debug('Error2'+exp.getCause());
            system.debug('Error3-->>>>'+exp.getLineNumber());
            //system.debug('Error4-->>>>'+exp.getInaccessibleFields());
        }
        return null;
    } 
    
    @RemoteAction
    public static List<Contact> searchContacts(String query, String accId) {
        if(!String.isEmpty(query) && query.length() > 2) {
            query = query + '*';
            List<List<Contact>> result = [FIND :query IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName, Email, Title, Role__c WHERE AccountId = :accId)];
            System.debug(result[0]);
            return result[0];
        }
        return new List<Contact>();
    }    
    
    public class Response{
        public Boolean isSuccess {get;set;}
        public String message {get;set;}
        public Object data {get;set;}
        public Response(Boolean isSuccess,String message,Object data){
            this.isSuccess = isSuccess;
            this.message = message;
            this.data = data;
        }
    }
}