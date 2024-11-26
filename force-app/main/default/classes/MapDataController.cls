/***************************************************************
    Object: MapDataController
    Company: Lennox
    Author: Mukesh Bhardwaj (Ventas Consulting)
    Description: Controller for Map Data Component
    Changes:
    Mar 27, 2014        Initial Draft        Mukesh Bhardwaj
*****************************************************************/
 
public class MapDataController {
    public List<Account> premierDealers {get;set;}
   
    public List<Account> strategicDealers {get;set;}
   
    public List<Account> allOtherDealers {get;set;}
    public List<Account> allOtherDealers2 {get;set;}
    public List<Account> allOtherDealers3 {get;set;}
    public List<Account> allOtherDealers4 {get;set;}
    public List<Account> allOtherDealers5 {get;set;}
   
    public List<Account> strategicProspects {get;set;}
   
    public List<Account> allOtherProspects {get;set;}
    public List<Account> allOtherProspects2 {get;set;}
    public List<Account> allOtherProspects3 {get;set;}
    public List<Account> allOtherProspects4 {get;set;}
    public List<Account> allOtherProspects5 {get;set;}
   
    public List<Account> houseAccounts {get;set;}
    public List<Account> houseAccounts2 {get;set;}
    public List<Account> houseAccounts3 {get;set;}
    public List<Account> houseAccounts4 {get;set;}
    public List<Account> houseAccounts5 {get;set;}
   
    public List<Account> cashAccounts {get;set;}
    public List<Account> cashAccounts2 {get;set;}
    public List<Account> cashAccounts3 {get;set;}
    public List<Account> cashAccounts4 {get;set;}
    public List<Account> cashAccounts5 {get;set;}

    public List<Account> LPPAccounts {get;set;}
   
    public List<User> allTerritories {get;set;}
    public String mode {get;set;}
   
    public MapDataController(){
        try {
            String show = ApexPages.currentPage().getParameters().get('show');
            Boolean showIsNull = true;
            String currentUserId = ApexPages.currentPage().getParameters().get('u');
            String selectedTerritories = ApexPages.currentPage().getParameters().get('t');
            String selectedDistrict = ApexPages.currentPage().getParameters().get('d');
            allTerritories = new List<User>();
           
            if(currentUserId == null || currentUserId == ''){
                currentUserId = UserInfo.getUserId();
            }
            User currentUser;
            String currentUserRegion = [SELECT SAP_Sales_District__c FROM User WHERE Id = :currentUserId].SAP_Sales_District__c;
            
            currentUser = [select UserRoleId, ManagerId, SAP_Sales_Group__c, SAP_Sales_Office__c, SAP_Sales_District__c from User where Id = :currentUserId];
            
            String currentRoleId = currentUser.UserRoleId;
            String currentRoleName = [select Name from UserRole where Id = :currentRoleId].Name;
            String currentDistrictNumber = currentUser.SAP_Sales_Office__c; //district#
            String currentTerritoryNumber = currentUser.SAP_Sales_Group__c; //territory#
            String currentUsersManagerId = currentUser.ManagerId;

            if(currentRoleName.contains('Res Territory')) {
                mode = 'TM';
            } else if(currentRoleName.contains('Res District Manager')) {
                mode = 'DM';
            } else if(currentRoleName.contains('Res Area Sales Manager')) {
                mode = 'ASM';
            } else {
                mode = 'Global';
            }
            System.debug(mode);
           
            if(show=='' || show==null) {
                show='pd~sd~aod~sp~aop';
            } else {
                showIsNull = false;
            }

            //Expecting show as pd~sd~ca
            //pd, sd, aod, sp, aop, ha, ca
            List<String> showSetList = show.split('~');
            Set<String> showSet = new Set<String>();
            for(String s : showSetList) {
                showSet.add(s);
            }

            premierDealers = new List<Account>();
            strategicDealers = new List<Account>();
            allOtherDealers = new List<Account>();
            allOtherDealers2 = new List<Account>();
            allOtherDealers3 = new List<Account>();
            allOtherDealers4 = new List<Account>();
            allOtherDealers5 = new List<Account>();
           
            strategicProspects  = new List<Account>();
            allOtherProspects  = new List<Account>();
            allOtherProspects2  = new List<Account>();
            allOtherProspects3  = new List<Account>();
            allOtherProspects4  = new List<Account>();
            allOtherProspects5  = new List<Account>();
           
            houseAccounts = new List<Account>();
            houseAccounts2 = new List<Account>();
            houseAccounts3 = new List<Account>();
            houseAccounts4 = new List<Account>();
            houseAccounts5 = new List<Account>();
           
            cashAccounts = new List<Account>();
            cashAccounts2 = new List<Account>();
            cashAccounts3 = new List<Account>();
            cashAccounts4 = new List<Account>();
            cashAccounts5 = new List<Account>();

            LPPAccounts = new List<Account>();
            String LPPRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName='LPP_Store' LIMIT 1].Id;
            
            List<Account> accountList = new List<Account>();
            String query;
            Set<Id> ownerIdSet = new Set<Id>();
            Set<String> selectedTerritoriesSet = new Set<String>();
            if(mode=='DM' || mode=='ASM') {
                allTerritories = [select District_Description_Formula__c, SAP_Sales_Group__c, SAP_Sales_Office__c, Id, FirstName, LastName from User where isActive = true AND SAP_Sales_Office__c =: currentDistrictNumber AND SAP_Sales_Group__c != null ORDER BY District_Description_Formula__c];
            } else if (mode =='Global' ) {
                if(currentUserRegion == null || currentUserRegion == '') { //removed || currentProfileName != 'Lennox - Res Sales AM' when changed currentProfileName to currentRoleName
                    allTerritories = [select District_Description_Formula__c, SAP_Sales_Group__c, SAP_Sales_Office__c, SAP_Sales_District__c, Id, FirstName, LastName from User where isActive = true AND SAP_Sales_Group__c != null ORDER BY District_Description_Formula__c];    
                } else {
                    allTerritories = [select District_Description_Formula__c, SAP_Sales_Group__c, SAP_Sales_Office__c, SAP_Sales_District__c, Id, FirstName, LastName from User where isActive = true AND SAP_Sales_District__c = :currentUserRegion and SAP_Sales_Group__c != null ORDER BY District_Description_Formula__c]; 
                }
            }
            if(mode == 'DM' || mode == 'Global' || mode == 'ASM') {
                
                if(selectedTerritories != null && selectedTerritories != '') {
                    List<String> selectedTerritoriesList = selectedTerritories.split('~');
                    for(String s : selectedTerritoriesList) {
                        selectedTerritoriesSet.add(s);
                    }
                }
                List<User> userList = new List<User>();
                if(mode == 'DM' || mode == 'ASM') {
                    if(selectedTerritoriesSet.size() > 0){
                        userList = [select Id from User where SAP_Sales_Group__c in : selectedTerritoriesSet];
                    } else {
                        userList = [select Id from User where SAP_Sales_Office__c =: currentDistrictNumber];
                    }
                } else if (mode == 'Global') {
                    if(selectedTerritoriesSet.size() > 0){
                        userList = [select Id from User where SAP_Sales_Group__c in : selectedTerritoriesSet];
                    }
                }

                for(User u : userList) {
                    ownerIdSet.add(u.Id);
                }
                //Inlcude DMs in the owner id set so house accounts, cash accounts and lpp stores in included in accountList
                if(selectedTerritoriesSet.size() == 0 || mode == 'DM') {
                    ownerIdSet.add(currentUserId);
                }
            }
            

            if(mode=='DM') {
                //DMs are the owners of house accounts, cash accounts and lpp stores, so we perform a broader query to include those accounts in accountList if either of those filters are selected
                if(showSet.contains('ha') || showSet.contains('ca') || showSet.contains('lpp')) {
                    accountList = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, isHouseAccount__c, isCashAccount__c, RecordTypeId from Account where OwnerId in :ownerIdSet AND location__longitude__s != null AND Geocode_Status__c != 'LOW_RELEVANCE' AND location__latitude__s != null];
                } else {
                    accountList = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, isHouseAccount__c, isCashAccount__c, RecordTypeId from Account where OwnerId in :ownerIdSet AND location__longitude__s != null AND location__latitude__s != null AND Geocode_Status__c != 'LOW_RELEVANCE' AND OwnerId != :currentUserId]; 
                } 
            } else if((mode=='Global' && !showIsNull ) || mode == 'ASM') {
                system.debug('show is not null - performed a query on accounts');
                accountList = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, isHouseAccount__c, isCashAccount__c, RecordTypeId from Account where OwnerId in :ownerIdSet AND location__longitude__s != null AND location__latitude__s != null AND Geocode_Status__c != 'LOW_RELEVANCE'];
            } else if(mode == 'TM') {   //if(mode=='TM')
                accountList = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, isHouseAccount__c, isCashAccount__c, RecordTypeId from Account where OwnerId = :currentUserId AND location__longitude__s != null AND location__latitude__s != null AND Geocode_Status__c != 'LOW_RELEVANCE'];
            }
           
            for(Account a: accountList) {
                
                if(showSet.contains('pd') && a.SAP_Customer_Number__c != null && a.isPremier__c)
                    premierDealers.add(a);
                   
                
                if(showSet.contains('sd') && a.SAP_Customer_Number__c != null && a.isStrategic__c)
                    strategicDealers.add(a);
                Integer listsize = 1000;
                if(Test.isRunningTest())
                    listsize = 2;
                if(showSet.contains('aod') && a.SAP_Customer_Number__c != null && !a.isPremier__c && !a.isStrategic__c && !a.isHouseAccount__c && !a.isCashAccount__c)
                {   
                    
                    if(allOtherDealers.size() < listsize)
                        allOtherDealers.add(a);
                    else if(allOtherDealers2.size() < listsize)
                        allOtherDealers2.add(a);
                    else if(allOtherDealers3.size() < listsize)
                        allOtherDealers3.add(a);
                    else if(allOtherDealers4.size() < listsize)
                        allOtherDealers4.add(a);
                    else if(allOtherDealers5.size() < listsize)
                        allOtherDealers5.add(a);
                }
                if(showSet.contains('sp') && a.SAP_Customer_Number__c == null && a.isStrategic__c)
                    strategicProspects.add(a);
                if(showSet.contains('aop') && a.SAP_Customer_Number__c == null && !a.isStrategic__c && !a.isPremier__c && !a.isHouseAccount__c && !a.isCashAccount__c)
                {   
                    if(allOtherProspects.size() < listsize)
                        allOtherProspects.add(a);
                    else if(allOtherProspects2.size() < listsize)
                        allOtherProspects2.add(a);
                    else if(allOtherProspects3.size() < listsize)
                        allOtherProspects3.add(a);
                    else if(allOtherProspects4.size() < listsize)
                        allOtherProspects4.add(a);
                    else if(allOtherProspects5.size() < listsize)
                        allOtherProspects5.add(a);
                }
               
                if(showSet.contains('ha') && a.isHouseAccount__c)
                {   
                    if(houseAccounts.size() < listsize)
                        houseAccounts.add(a);
                    else if(houseAccounts2.size() < listsize)
                        houseAccounts2.add(a);
                    else if(houseAccounts3.size() < listsize)
                        houseAccounts3.add(a);
                    else if(houseAccounts4.size() < listsize)
                        houseAccounts4.add(a);
                    else if(houseAccounts5.size() < listsize)
                        houseAccounts5.add(a);
                }
               
                if(showSet.contains('ca') && a.isCashAccount__c)
                {
                    if(cashAccounts.size() < listsize)
                        cashAccounts.add(a);
                    else if(cashAccounts2.size() < listsize)
                        cashAccounts2.add(a);
                    else if(cashAccounts3.size() < listsize)
                        cashAccounts3.add(a);
                    else if(cashAccounts4.size() < listsize)
                        cashAccounts4.add(a);
                    else if(cashAccounts5.size() < listsize)
                        cashAccounts5.add(a);
                }

                if(showSet.contains('lpp') && a.RecordTypeId == LPPRecordTypeId)
                    LPPAccounts.add(a);
                    
            }
           
            //For Cash and House Accounts and LPP Stores
            if(mode == 'TM' || mode == 'Global' || mode == 'ASM') {
                List<Account> hcAccs = new List<Account>();
                Integer listsize = 1000;
                
                if(Test.isRunningTest())
                    listsize = 2;
                String selectedDistrictQuery;
                if(selectedDistrict != null && selectedDistrict != '') {
                    selectedDistrictQuery = selectedDistrict.substring(0, 4);
                }

                //if TM or ASM, find accounts owned by current user's manager (the dm)
                if(mode == 'TM' || mode == 'ASM')
                    hcAccs = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, SAP_Email__c, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Website, SAP_YTD_Sales__c, SAP_Previous_FY_s_Sales__c, SAP_Credit_Limit__c, New_Customer_Program__c, HD_Retail_Sales_YTD_all_brands__c, NumberOfEmployees, isHouseAccount__c, isCashAccount__c, Phone, SAP_Cell_Phone__c from Account where OwnerId = :currentUsersManagerId AND location__longitude__s != null AND location__latitude__s != null AND (isHouseAccount__c=true OR isCashAccount__c=true OR RecordTypeId = :LPPRecordTypeId)];
                //If global users, find accounts by looking at the selected district
                else if(mode == 'Global')
                    hcAccs = [Select Owner.Name, Name, Id, SAP_Customer_Number__c, isStrategic__c, isPremier__c, location__longitude__s, location__latitude__s, SAP_Email__c, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Website, SAP_YTD_Sales__c, SAP_Previous_FY_s_Sales__c, SAP_Credit_Limit__c, New_Customer_Program__c, HD_Retail_Sales_YTD_all_brands__c, NumberOfEmployees, isHouseAccount__c, isCashAccount__c, Phone, SAP_Cell_Phone__c from Account where SAP_Sales_Office__c = :selectedDistrictQuery AND location__longitude__s != null AND location__latitude__s != null AND (isHouseAccount__c=true OR isCashAccount__c=true OR RecordTypeId = :LPPRecordTypeId)];

                for(Account a: hcAccs) {
                    if(a.Name.contains('\''))
                        a.Name = a.Name.replace('\'','\\\'');
                    if(a.ShippingStreet != null && a.ShippingStreet.contains('\''))
                        a.ShippingStreet = a.ShippingStreet.replace('\'','\\\'');
                    if(a.ShippingCity != null && a.ShippingCity.contains('\''))
                        a.ShippingCity = a.ShippingCity.replace('\'','\\\'');
                    if(a.ShippingStreet != null)
                        a.ShippingStreet = a.ShippingStreet.replace('\r\n',' ');
                    if(a.ShippingCity != null)
                        a.ShippingCity = a.ShippingCity.replace('\r\n',' ');
                    if(showSet.contains('ha') && a.isHouseAccount__c)
                    {   
                        if(houseAccounts.size() < listsize)
                            houseAccounts.add(a);
                        else if(houseAccounts2.size() < listsize)
                            houseAccounts2.add(a);
                        else if(houseAccounts3.size() < listsize)
                            houseAccounts3.add(a);
                        else if(houseAccounts4.size() < listsize)
                            houseAccounts4.add(a);
                        else if(houseAccounts5.size() < listsize)
                            houseAccounts5.add(a);
                    }
                    if(showSet.contains('ca') && a.isCashAccount__c)
                    {
                        if(cashAccounts.size() < listsize)
                            cashAccounts.add(a);
                        else if(cashAccounts2.size() < listsize)
                            cashAccounts2.add(a);
                        else if(cashAccounts3.size() < listsize)
                            cashAccounts3.add(a);
                        else if(cashAccounts4.size() < listsize)
                            cashAccounts4.add(a);
                        else if(cashAccounts5.size() < listsize)
                            cashAccounts5.add(a);
                    }
                    if(showSet.contains('lpp') && a.RecordTypeId == LPPRecordTypeId)
                        LPPAccounts.add(a);
                }
            }
    
        } catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Something is wrong with the map. Please contact System Admin :'+e.getMessage());
            ApexPages.addMessage(myMsg);
            System.debug('Exception in map:'+e.getMessage());
        }
    }
}