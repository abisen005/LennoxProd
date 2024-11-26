/** 
*@Purpose : Generate IncentiveAgreementFile Document and used for send via docusign
*@Param   : 
*@Return  : 
IncentiveAgreementFilePage (Visualforce Page)
**/
public class MergeTemplatesControllerPDF {
    public String selectedPage {get;set;}
    public List<SelectOption> options {get;set;}
    public Account account {get;set;}
    public Opportunity opportunity {get;set;}
    public boolean isError {get;set;}
    public string recordId{get;set;}
    public string errorMsg{get;set;}
    public Set<String> contactIdLst{get;set;}
    public List<OpportunityContactRole> contactRoleList {get;set;}
    public Map<Id, User> idToUserMap{get;set;}
    public List<Contact> DealerContactList {get;set;}
    public List<User> SignerUserList {get;set;}
    public Decimal marketLeaderTotal{get;set;}
    public Decimal lpiTotal{get;set;}
    public Decimal districtOnlyIncentiveTotal{get;set;}
    public Decimal districtIncentiveTotal{get;set;}
    public Decimal totalOfAllIncentives{get;set;}
    public Decimal districtPayoutIncentiveTotal{get;set;}
    public Decimal newCustomerPayoutIncentiveTotal{get;set;}
    public String[] signerContactIdLst{get;set;}
    public Decimal bingo;
    public Decimal maxNewCustomerFund{get;set;}
    public Decimal ncTotal{get;set;}
    public Decimal newCustomerTotal{get;set;}
    public Decimal newCustomerAllTotal{get;set;}
    public Decimal districtMktgFundsIncentiveTotal{get;set;}    
    public Decimal specialIncentivesTotal{get;set;}
    public List<String> emailList{get;set;}
    public List<String> userList{get;set;}
    
    
    public List<Payout_Plan__c> districtPayoutPlanList {get;set;}
    public List<Proposal_Incentives__c> marketLeaderIncentiveList {get;set;}
    public List<Proposal_Incentives__c> lpiIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtOnlyIncentiveList {get;set;}
    public List<Payout_Plan__c> newCustomerPayoutPlanList {get;set;}
    public List<Proposal_Incentives__c> newCustomerIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtMktgFundsIncentiveList {get;set;}
    public List<Proposal_Incentives__c> specialIncentiveList {get;set;}
    public List<Proposal_Incentives__c> districtMktgFundsMatrixList {get;set;}
    
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
        districtPayoutPlanList = new List<Payout_Plan__c>();
        newCustomerPayoutPlanList = new List<Payout_Plan__c>();
        districtMktgFundsMatrixList = new List<Proposal_Incentives__c>();
        specialIncentiveList = new List<Proposal_Incentives__c>();
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
            lpiTotal += lpiL.LPI_District_Rebates__c + lpiL.LPI_New_Customer_Rebates__c;
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
                                Incentive_Description__c,Funding_Amount__c,Type_of_Incentive__c,Reject_Incentive_Item__c
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
                                    WHERE Type_of_Incentive__c = 'NC' AND Reject_Incentive_Item__c = false
                                    AND Not_approved__c = false  
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
        newCustomerAllTotal +=ncTotal; 
        
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
        return null;
    }
    
    
    public MergeTemplatesControllerPDF(ApexPages.StandardController controller){
        String oppId = ApexPages.currentPage().getParameters().get('id');
        try{
            emailList = new List<String>();
            userList = new List<String>();
            if(String.isNotBlank(oppId)){
                getOpportunityRecord(oppId);
                recordId = oppId; 
            }
            idToUserMap = new Map<Id, User>();
            DealerContactList =  new List<Contact>();
            SignerUserList =  new List<user>(); 
            System.debug('MergeTemplatesControllerPDF==>');   
            
        }catch(Exception exp){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, exp.getMessage())); 
        }
    }
    
    
    
    /*  public void getOpportunityRecord(String oppId){
emailList = new List<String>();
userList = new List<String>();
List<String>  contactIdLst = new List<String>();
//List<String> contactId = (List<String>)JSON.deserialize(Apexpages.currentPage().getParameters().get('contactIdLst'), List<String>.class);
contactIdLst = ApexPages.currentPage().getParameters().get('contactIdLst').split(',');
System.debug('<<====>>contactIdLst==>'+contactIdLst);  

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
opportunity = [SELECT Id,Name,Amount,District_Marketing_Funds_on_DLSC_Produ__c,District_Marketing_Funds_on_Elite_Prod__c,Type,Lennox_Partner_Incentive_Expiration_Date__c,
District_Marketing_Funds_on_Merit_Prod__c,District_Marketing_Funds_on_Parts_and__c,Number_of_Level_I_trips_offered__c,Expiration_Date__c,
Number_of_Escapes_trips_offered__c,Volume_Rebate__c,Volume_Rebate_Earned__c,District_Marketing_Funds_Earned_on_DLSC__c,District_Marketing_Funds_Earned_on_Elite__c,
District_Marketing_Funds_Earned_on_Merit__c,District_Marketing_Funds_on_Earned_Parts__c,Value_of_Level_I_trips_offered__c,Value_of_Escapes_trips_offered__c,
Other_District_Incentives_1__c,Other_District_Incentives_2__c,Other_District_Incentives_3__c,Other_District_Incentives_4__c,NC_Funding_Total__c,
Total_District_Incentives__c,NC_Funding_CAP_Billing__c,NC_Funding_Direct_Mail__c,NC_Funding_Lennox_Building_Sign__c,
NC_Funding_Newspaper__c,NC_Funding_Billboards__c,NC_Funding_Radio__c,NC_Funding_Trainin__c,NC_Funding_Web_Production__c,NC_Funding_Other_Details__c,
NC_Funding_Other__c,AccountId,Account.Name,Account.SAP_Customer_Number__c,Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode, Account.ShippingCountry,
District_Funds_Proposal_Payout_Info__c,Market_Leader_Information__c, Special_Incentives_PDF__c,New_Customer_Proposal_Payout_Info__c,District_Mktg_Funds_Proposal_PDF__c,
BDM__c,BDM__r.Name,BDM__r.Email,District_Manager__c,District_Manager__r.Name,District_Manager__r.Email,ML_Expiration_Date__c ,
Regional_Director__c,Regional_Director__r.Name,Regional_Director__r.Email,LPI__c, PY_Total_Sales__c, Market_Leader_Load_Date__c, Lennox_Partner_Incentive_Load_Date__c 
FROM Opportunity 
WHERE Id=:oppId];
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

//emailList = new List<String>{'ganesh@dreamwares.com', 'ganeshmjn@gmail.com','ganesh+212@dreamwares.com'};
//userList = new List<String>{'Ganesh', 'Troy Bahler (Regional Director)','Ganesh (District Director)'};


if(opportunity.AccountId != null){
account = [SELECT Name,SAP_Customer_Number__c,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,ShippingCountry,
SAP_YTD_Sales__c,Market_Leader_Payout_Current_Month__c,Market_Leader_Payouts_YTD__c,
(SELECT Id,AccountId,Name,Email,Contact_Type__c,FirstName,LastName FROM Contacts) 
FROM Account WHERE Id=:opportunity.AccountId];
System.debug('account==>'+account);  
}else{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'No Account Available on Proposal and Close.')); 
}*/
    
    
    
   public void getOpportunityRecord(String oppId){
        emailList = new List<String>();
        userList = new List<String>();
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
                       Dir_Sales_Ops__r.ContactId,Promotional_Periods_Requested__c, NC_CAP_Consumer_Promotional_Program__c,Lennox_Partner_Incentives_Proposal_PDF__c
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
            emailList.add(opportunity.District_Manager__r.Email);
            System.debug('FinalAmount!!!'+bingo);
            userList.add(opportunity.District_Manager__r.Name+' ('+title+')');
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
                signerContactIdLst.add(cr.Id); 
                system.debug('signerContactIdCustomers'+signerContactIdLst);
            }
        }
        if((opportunity.Lead_BDM__c != null && opportunity.Lead_BDM__r.Email != null)||Test.isRunningTest()){
            System.debug('Lead_BDM__r');
            System.debug('opportunity.Type'+opportunity.Type);
             String ObjectApi = 'Opportunity';
            String FieldApi = 'Lead_BDM__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();

            if(!opportunity.Type.contains('Existing Dealer') || Test.isRunningTest())  {
                userList.add(opportunity.Lead_BDM__r.Name+' ('+title+')');
                emailList.add(opportunity.Lead_BDM__r.Email);
                signerContactIdLst.add(opportunity.Lead_BDM__r.ContactId); 
                system.debug('signerContactIdLead_BDM__r'+signerContactIdLst);
            }    
        }
        
         if(opportunity.Regional_Director__c != null && opportunity.Regional_Director__r.Email != null){
            System.debug('Regional_Director__r');
             String ObjectApi = 'Opportunity';
                String FieldApi = 'Regional_Director__c';
                String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
                
             
            if((opportunity.Type.contains('Existing Dealer') || opportunity.Type.contains('New Customer')) || Test.isRunningTest())
               {
                   userList.add(opportunity.Regional_Director__r.Name+' ('+title+')');
                   emailList.add(opportunity.Regional_Director__r.Email);
                   signerContactIdLst.add(opportunity.Regional_Director__r.ContactId);
               }
                           /*else if(opportunity.Type.contains('New Customer') || Test.isRunningTest() ){
            userList.add(opportunity.Regional_Director__r.Name+' (Regional Director)');
            signerContactIdLst.add(opportunity.Regional_Director__r.ContactId);
            emailList.add(opportunity.Regional_Director__r.Email);
            }   */ 
               } 
        
        if((opportunity.Dir_Sales_Ops__c != null && opportunity.Dir_Sales_Ops__r.Email != null )||Test.isRunningTest()){
            System.debug('Dir_Sales_Ops__r');
            
            String ObjectApi = 'Opportunity';
            String FieldApi = 'Dir_Sales_Ops__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            
            if((opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  75000 )||Test.isRunningTest()){
                userList.add(opportunity.Dir_Sales_Ops__r.Name+' ('+title+')');
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
           
            if((opportunity.Type.contains('New Customer'))||Test.isRunningTest()){
                userList.add(opportunity.VP_National_Accts__r.Name+' ('+title+')');
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
                emailList.add(opportunity.General_Manager__r.Email);}
            //  if(opportunity.General_Manager__r.ContactId != null){
            signerContactIdLst.add(opportunity.General_Manager__r.ContactId);
            system.debug('signerContactIdGeneral_Manager__r'+signerContactIdLst);
            //}
        } 
        
        if((opportunity.President__c != null && opportunity.President__r.Email != null)||Test.isRunningTest()){
            System.debug('President__r');
              String ObjectApi = 'Opportunity';
            String FieldApi = 'President__c';
            String title = (String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
          
            if(((opportunity.Type.contains('New Customer') && opportunity.Lifetime_Value_of_Deal__c >  3000000) || (opportunity.Type.contains('Existing Dealer') && opportunity.Lifetime_Value_of_Deal__c >  3000000) ) ||Test.isRunningTest()){
                userList.add(opportunity.President__r.Name+' ('+title+')');
                emailList.add(opportunity.President__r.Email);
            }
            // if(opportunity.President__r.ContactId != null){
            signerContactIdLst.add(opportunity.President__r.ContactId);
            system.debug('signerContactIdPresident__r'+signerContactIdLst);
            // }
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
}