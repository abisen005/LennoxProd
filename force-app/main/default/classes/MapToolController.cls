public class MapToolController {

    @remoteAction
    public static List<district> getDistricts(String region) {
        system.debug('dan here is region ' + region);
        List<district> result = new List<district>();
        Set<String> checker = new Set<String>();
        List<User> users = new List<User>();
        if(region == '') {
            users = [SELECT District_Description_Formula__c, SAP_Sales_Office__c FROM User WHERE isActive = true AND SAP_Sales_Office__c != NULL AND ProfileId in (SELECT Id FROM Profile WHERE Name LIKE '%Res Sales DM%' OR NAME LIKE '%Res Sales ISR%' OR NAME LIKE '%Res Sales ISR%') ORDER BY District_Description_Formula__c];
        } else {
            users = [SELECT District_Description_Formula__c, SAP_Sales_Office__c FROM User WHERE SAP_Sales_District__c =: region AND isActive = true AND SAP_Sales_Office__c != NULL AND ProfileId in (SELECT Id FROM Profile WHERE Name LIKE '%Res Sales DM%' OR NAME LIKE '%Res Sales ISR%') ORDER BY District_Description_Formula__c];
        }

        for(User u : users) {
            if(!checker.contains(u.District_Description_Formula__c + u.SAP_Sales_Office__c)) {
                district d = new district();
                d.location = u.District_Description_Formula__c;
                d.dNumber = u.SAP_Sales_Office__c;
                result.add(d);
            }
            checker.add(u.District_Description_Formula__c + u.SAP_Sales_Office__c);
        }
        return result;
    }

    @RemoteAction
    public static List<territory> getTerritories(String district) {
        List<territory> result = new List<territory>();
        Set<String> checker = new Set<String>();
        List<User> users = new List<User>();
        users = [Select Id, Name, SAP_Sales_Group__c FROM User WHERE SAP_Sales_Office__c =: district AND isActive = true AND SAP_Sales_Group__c != NULL];
        for(User u : users) {
            territory t = new territory();
            t.userId = u.Id;
            t.userName = u.Name;
            t.territoryNumber = u.SAP_Sales_Group__c;
            t.selected = true;
            result.add(t);
        }
        return result;
    }

    @RemoteAction
    public static Boolean saveDefaultLocation(String lat, String lon, String zoom, String userId) {
        User updateUser = [SELECT Id FROM User WHERE Id = :userId];
        updateUser.Latitude__c = lat;
        updateUser.Longitude__c = lon;
        updateUser.Zoom__c = zoom;
        try {
            update updateUser;
            return true;
        } catch (DmlException e) {
            return false;
        }
    }

    @RemoteAction
    public static accountData getAccountData(String accId, String accountType) {
        accountData result = new accountData();
        for(Account a : [SELECT Id, Owner.Name, Name, Phone, SAP_Customer_Number__c, SAP_Email__c, Website, SAP_YTD_Sales__c, Prior_Year_YTD_Sales__c, Delta_YTD_Sales_Year_to_Year__c, New_Customer_Program__c, SAP_Credit_Limit__c, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE id = :accId LIMIT 1]) {
            result.owner = a.Owner.Name;
            result.name = a.Name;
            result.accId = a.Id;
            result.phone = a.Phone != null ? a.Phone : '-';
            result.shippingStreet = a.ShippingStreet;
            result.shippingCity = a.ShippingCity;
            result.shippingState = a.ShippingState;
            result.shippingZip = a.ShippingPostalCode;
            result.customerNumber = a.SAP_Customer_Number__c;
            result.email = a.SAP_Email__c != null ? a.SAP_Email__c : '-';
            result.website = a.Website != null ? a.Website : '-';
            result.YTDSales = a.SAP_YTD_Sales__c != null ? a.SAP_YTD_Sales__c : 0;
            result.priorYTDSales = a.Prior_Year_YTD_Sales__c != null ? a.Prior_Year_YTD_Sales__c : 0;
            result.salesDeltaYOY = a.Delta_YTD_Sales_Year_to_Year__c != null ? a.Delta_YTD_Sales_Year_to_Year__c : 0;
            result.newCustomerProgram = a.New_Customer_Program__c;
            result.creditLimit = a.SAP_Credit_Limit__c != null ? a.SAP_Credit_Limit__c : 0;
            result.accountType = accountType;
        }
        for(Scorecard__c sc : [SELECT Id, Calculated_Annual_HVAC_Purchases__c, Total_Number_of_Employees__c FROM Scorecard__c WHERE Account__c = :accId LIMIT 1]) {
            result.annualHVACPurchases = sc.Calculated_Annual_HVAC_Purchases__c != null ? sc.Calculated_Annual_HVAC_Purchases__c : 0;
            result.employees = sc.Total_Number_of_Employees__c != null ? sc.Total_Number_of_Employees__c : 0;
            result.scorecardId = sc.Id;
            result.hasScorecard = true;
        }
        if(result.scorecardId == null) {
            result.annualHVACPurchases = 0;
            result.employees = 0;
        }
        return result;
    }

    @RemoteAction
    public static List<geojsonWrapper> getAccounts(
                                        List<String> ownerIds,
                                        String type,
                                        List<String> allTypes,
                                        List<String> location,
                                        Decimal distance,
                                        integer offset,
                                        String tmId,
                                        List<String> filterOptions)
        {
            system.debug('!!type string in get accounts ' + type);
            system.debug('!! all types set ' + allTypes);
        
            Set<String> allTypesSet = New Set<String>();
            allTypesSet.addAll(allTypes);
            
            System.debug('ownerIds +++'+ownerIds );
            System.debug('tmId +++'+tmId );
        List<geojsonWrapper> result = new List<geojsonWrapper>();
        List<Account> accounts= new List<Account>();
        Decimal latitude = decimal.valueOf(location[0]);
        Decimal longitude = decimal.valueOf(location[1]);
        String userId;
        List<String> managerIds = new List<String> ();
        String retailType;
        String fieldFilterClause = '';
        System.debug('filterOptions');
        System.debug(filterOptions);
        Set<String> NO_FILTER_TYPES = new Set<String>{'lpp', 'lws', 'hd', 'cc'};
        Boolean useFilter = Boolean.valueOf(filterOptions[0]) && !NO_FILTER_TYPES.contains(type);
        String filterField = filterOptions[1]; //SAP_YTD_Sales__c, Prior_Year_YTD_Sales__c
        Decimal filterMin = Decimal.valueOf(filterOptions[2]);
        Decimal filterMax = Decimal.valueOf(filterOptions[3]);
        if(useFilter) {
            fieldFilterClause = ' AND (' + filterField + ' >= ' + filterMin;
            fieldFilterClause += ' AND ' + filterField + ' <= ' + filterMax + ')';
        }
        String query = 'SELECT Id, Name, ShippingLongitude, ShippingLatitude FROM Account WHERE';
        Set<String> MANAGER_OWNED_TYPES = new Set<String>{'lpp', 'ca', 'ha', 'cma', 'cc', 'hd', 'lws', 'nce', 'npp', 'cstdr', 'lwdr', 'hdr'};

        if(MANAGER_OWNED_TYPES.contains(type)) {
            if(!ownerIds.isEmpty()) {
                userId = ownerIds[0];
            } else {
                userId = tmId;
            }
            User user = [SELECT ManagerId FROM USER Where Id = :userId];
            if(user != null && user.ManagerId != null){
                managerIds.add(user.ManagerId);
                User manager =  [SELECT ManagerId FROM USER Where Id = :user.ManagerId];
                if(manager.ManagerId != null){
                    managerIds.add(manager.ManagerId);
                }
            }
        }
            System.debug(' managerIds ::' + managerIds);
            System.debug(' ownerIds ::' + ownerIds);
        if(type == 'cstdr' || type == 'lwdr' || type == 'hdr'){
          
            query = 'SELECT Id, Name, ShippingLongitude, ShippingLatitude, isPremier__c, isStrategic__c, Costco_Dealer__c, Lowe_s_Dealer__c, Home_Depot_Dealer__c,  Retail_Store__c FROM Account WHERE';
            if(type == 'cstdr'){
                retailType = 'Costco';
               query += ' (( OwnerId = :managerIds AND Retail_Store__c = :retailType ) OR (SAP_Customer_Number__c != null AND  Costco_Dealer__c = true AND OwnerId in :ownerIds ))';
            }
            if(type == 'lwdr'){
                retailType = 'Lowe\'s';
                query += ' (( OwnerId = :managerIds AND Retail_Store__c = :retailType ) OR (SAP_Customer_Number__c != null AND  Lowe_s_Dealer__c = true AND OwnerId in :ownerIds))';
            }
            if(type == 'hdr'){
                retailType = 'Home Depot';
                query += ' (( OwnerId = :managerIds AND Retail_Store__c = :retailType ) OR ( SAP_Customer_Number__c != null AND Home_Depot_Dealer__c = true AND OwnerId in :ownerIds))';
            }
        }
        else if(type == 'pd') { //Premier Dealer
            query += ' SAP_Customer_Number__c != null AND isPremier__c = TRUE AND OwnerId in :ownerIds';
        } else if (type == 'sd') { //Strategic Dealer
            query += ' SAP_Customer_Number__c != null AND isStrategic__c = TRUE AND OwnerId in :ownerIds';
        } else if (type == 'aod') { //All other dealers
            query += ' SAP_Customer_Number__c != null AND isPremier__c = FALSE AND isStrategic__c = FALSE AND isHouseAccount__c = FALSE AND isCashAccount__c = FALSE AND OwnerId in :ownerIds';
        } else if (type == 'sp') { //Strategic Prospects
            query += ' SAP_Customer_Number__c = null AND isStrategic__c = TRUE AND OwnerId in :ownerIds';
        } else if (type  == 'aop') { //all other prospects
            query += ' SAP_Customer_Number__c = null AND isPremier__c = FALSE AND isStrategic__c = FALSE AND isHouseAccount__c = FALSE AND isCashAccount__c = FALSE AND OwnerId in :ownerIds';
        } else if (type == 'ca') { //cash accounts
            query += ' isCashAccount__c = TRUE AND OwnerId = :managerIds';
        } else if (type == 'ha') { //house account
            
            //we probably got a bunch of these already when we queried over cash so let's not double dip
            if(allTypesSet.contains('ca')){
                query += ' isHouseAccount__c = TRUE AND isCashAccount__c = FALSE AND OwnerId = :managerIds';
            } else {
                query += ' isHouseAccount__c = TRUE AND OwnerId = :managerIds';
            }
            
        } else if (type == 'cma') { //commercial account
            ownerIds.addAll(managerIds);
            query += ' SAP_Sales_District__c LIKE \'%commercial%\' AND OwnerId IN :ownerIds';
        } else if (type == 'lpp') { //lpp store
            String LPPRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName='LPP_Store' LIMIT 1].Id;
            query += ' OwnerId = :managerIds AND RecordTypeId = :LPPRecordTypeId';
        } else if (type == 'cc') { //costco
            retailType = 'Costco';
            query += ' OwnerId = :managerIds AND Retail_Store__c = :retailType';
        } else if (type == 'hd') { //home depot
            retailType = 'Home Depot';
            query += ' OwnerId = :managerIds AND Retail_Store__c = :retailType';
        } else if (type == 'lws') { //Lowes
            retailType = 'Lowe\'s';
            query += ' OwnerId = :managerIds AND Retail_Store__c = :retailType';
        } else if (type == 'nce') { // NC Eligible
            String nceFilterVal = 'Yes';
            ownerIds.addAll(managerIds);
            query = 'SELECT Id, Name, ShippingLongitude, ShippingLatitude, SAP_Customer_Number__c, isCashAccount__c, isHouseAccount__c FROM Account WHERE Qualifies_for_NC_Program__c = :nceFilterVal AND OwnerId in :ownerIds';
        } else if (type == 'npp') { //NPP Dealer
            ownerIds.addAll(managerIds);
            query = 'SELECT Id, Name, ShippingLongitude, ShippingLatitude, SAP_Customer_Number__c, isCashAccount__c, isHouseAccount__c FROM Account WHERE LPP_3P_Program_Dealer__c = TRUE AND OwnerId in :ownerIds';
        } else if (type == 'nc') { //new customers
            String ncFilterVal = 'Yes';
            query += ' New_Customer_Program__c = :ncFilterVal AND OwnerId in :ownerIds';
        }
        query += fieldFilterClause;
        query += ' AND DISTANCE(ShippingAddress, GEOLOCATION('+latitude+','+longitude+'), \'km\') < ' + distance + ' AND ShippingLongitude != NULL LIMIT 1000 OFFSET ' + offset;
        System.debug('query: ************' + query);
        accounts = Database.query(query);
        for(Account a : Accounts) {
            geojsonWrapper wrapper = new geojsonWrapper();
            wrapper.type = 'Feature';

            geojsonGeometry geo = new geojsonGeometry();
            geo.type = 'Point';
            geo.coordinates = new List<Decimal>();
            geo.coordinates.add(a.ShippingLongitude);
            geo.coordinates.add(a.ShippingLatitude);

            geojsonProperties properties = new geojsonProperties();
            properties.title = a.Name;
            properties.accountId = a.Id;
            properties.accountType = type;
            if(type == 'nce' || type == 'npp') {
                properties.dealerNumber = a.SAP_Customer_Number__c;
                properties.isCashAccount = a.isCashAccount__c;
                properties.isHouseAccount = a.isHouseAccount__c;
            }
            if(type == 'cstdr' || type == 'lwdr' || type == 'hdr') {
                if(a.isPremier__c){
                    properties.accountType = 'premier';
                }else if(a.isStrategic__c){
                     properties.accountType = 'strategic';
                }else if(!a.isPremier__c &&  !a.isStrategic__c 
                         && !a.Costco_Dealer__c && !a.Lowe_s_Dealer__c 
                         && !a.Home_Depot_Dealer__c) {
                     properties.accountType = 'retail';
               }else {
                     properties.accountType = 'other';
               }
            }

            wrapper.geometry = geo;
            wrapper.properties = properties;

            result.add(wrapper);
        }
        System.debug('managerIds: ' + managerIds);
        System.debug(query);
        return result;
    }

    @RemoteAction
    public static List<geojsonWrapper> getSMADealers(String lppStoreId, List<String> location, Decimal distance, List<String> filterOptions) {
        System.debug('getSMADealers invoked');
        List<geojsonWrapper> result = new List<geojsonWrapper>();
        List<Account> smaDealers = new List<Account>();
        Decimal latitude = decimal.valueOf(location[0]);
        Decimal longitude = decimal.valueOf(location[1]);
        Account lppStore = [SELECT Id, Name, ShippingLongitude, ShippingLatitude, LPP_Plant_Code__c FROM Account WHERE Id = :lppStoreId];

        if(lppStore.LPP_Plant_Code__c != NULL) {
            String fieldFilterClause = '';
            System.debug('filterOptions');
            System.debug(filterOptions);
            Boolean useFilter = Boolean.valueOf(filterOptions[0]);
            String filterField = filterOptions[1];
            Decimal filterMin = Decimal.valueOf(filterOptions[2]);
            Decimal filterMax = Decimal.valueOf(filterOptions[3]);
            if(useFilter) {
                fieldFilterClause = ' AND (' + filterField + ' >= ' + filterMin;
                fieldFilterClause += ' AND ' + filterField + ' <= ' + filterMax + ')';
            }
            String query = 'SELECT Id, Name, ShippingLongitude, ShippingLatitude, isCashAccount__c, isHouseAccount__c, isPremier__c, isStrategic__c, SAP_Customer_Number__c FROM Account WHERE Main_LPP_Store__c LIKE \'%' + lppStore.LPP_Plant_Code__c + '%\'';
            if(String.isNotBlank(fieldFilterClause)) {
                query += fieldFilterClause;
            }
            query += ' AND DISTANCE(ShippingAddress, GEOLOCATION('+latitude+','+longitude+'), \'km\') < ' + distance + ' AND ShippingLongitude != NULL LIMIT 1000 ';
            System.debug(query);
            for(Account a :Database.query(query)) {
                String type;
                if(a.isCashAccount__c) type = 'ca';
                else if(a.isHouseAccount__c) type = 'ha';
                else if(a.isPremier__c) type = 'pd';
                else if(a.isStrategic__c && a.SAP_Customer_Number__c != NULL) type = 'sd';
                else if(a.isStrategic__c && a.SAP_Customer_Number__c == NULL) type = 'sp';
                else if(a.SAP_Customer_Number__c != NULL) type = 'aod';
                else type = 'aop';
                geojsonWrapper wrapper = new geojsonWrapper();
                wrapper.type = 'Feature';

                geojsonGeometry geo = new geojsonGeometry();
                geo.type = 'Point';
                geo.coordinates = new List<Decimal>();
                geo.coordinates.add(a.ShippingLongitude);
                geo.coordinates.add(a.ShippingLatitude);

                geojsonProperties properties = new geojsonProperties();
                properties.title = a.Name;
                properties.accountId = a.Id;
                properties.accountType = type;
                wrapper.geometry = geo;
                wrapper.properties = properties;

                result.add(wrapper);
            }
        }
        geojsonWrapper wrapper = new geojsonWrapper();
        wrapper.type = 'Feature';

        geojsonGeometry geo = new geojsonGeometry();
        geo.type = 'Point';
        geo.coordinates = new List<Decimal>();
        geo.coordinates.add(lppStore.ShippingLongitude);
        geo.coordinates.add(lppStore.ShippingLatitude);

        geojsonProperties properties = new geojsonProperties();
        properties.title = lppStore.Name;
        properties.accountId = lppStore.Id;
        properties.accountType = 'lpp';
        wrapper.geometry = geo;
        wrapper.properties = properties;

        result.add(wrapper);
        return result;
    }



    public class geojsonWrapper {
        public String type;
        public geojsonGeometry geometry;
        public geojsonProperties properties;
    }

    public class geojsonGeometry {
        public String type;
        public List<Decimal> coordinates;
    }

    public class geojsonProperties {
        public String title;
        public String accountId;
        public String dealerNumber;
        public String accountType;
        public Boolean isHouseAccount;
        public Boolean isCashAccount;
    }

    public class district {
        public String dNumber;
        public String location;
    }

    public class territory {
        public String userId;
        public String userName;
        public String territoryNumber;
        public Boolean selected;
    }

    public class accountData {
        public String owner;
        public String name;
        public String accId;
        public String phone;
        public String shippingStreet;
        public String shippingCity;
        public String shippingState;
        public String shippingZip;
        public String customerNumber;
        public String email;
        public String website;
        public Decimal YTDSales;
        public Decimal priorYTDSales;
        public Decimal salesDeltaYOY;
        public String newCustomerProgram;
        public Decimal creditLimit;
        public Decimal annualHVACPurchases;
        public Decimal employees;
        public String scorecardId;
        public Boolean hasScorecard;
        public String accountType;
    }

}