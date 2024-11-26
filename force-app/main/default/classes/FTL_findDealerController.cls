/*
@description       : 
@author            : Ventas Consulting
@group             : 
@last modified on  : 07-28-2022/20-07/2023/26-09-2024
@last modified by  : @Ventas_Abilash Senthilkumar
*/
public class FTL_findDealerController {
    private final FTL_Program_Form__c formId;
    public FTL_Program_Form__c form { get; set; }
    public List<Account> acnts { get; set; } //Only populate for ZIP CODE RESULTS
    public List<AcntWrapper> acntWraps { get; set; } //Only populate for NEARBY RESULTS
    public String paramValue { get; set; }
    public String inputValue { get; set; }
    public String errorMsg { get; set; }
    //private Map<String, String> fullStateMap = new Map<String, String>();
    //private Map<String, String> abbStateMap = new Map<String, String>();
    //private Map<Id, Account> instateAcntMap = new Map<Id, Account>();
    // constructor assigning the form
    public FTL_findDealerController(
        ApexPages.StandardController stdController
    ) {
        this.formId = (FTL_Program_Form__c) stdController.getRecord();
        form = [
            SELECT
            Id,
            Nominee_Zip_Code__c,
            Nominee_State__c,
            Nominee_Country__c,
            Nominee_City__c,
            Nominee_Street_Address__c,
            Assigned_Dealer__c
            FROM FTL_Program_Form__c
            WHERE Id = :formId.Id
        ];
        //getAcntsInZip();
        acntWraps = new List<AcntWrapper>();
    }
            /*GOOGLE API 
        public void getAcntsInZip() {
        acnts = new List<Account>(); //Init
        if (
        form.Nominee_Zip_Code__c != null &&
        form.Nominee_Zip_Code__c != ''
        ) {
        string zc = form.Nominee_Zip_Code__c;
        if (!isCanada(form.Nominee_Country__c, form.Nominee_Zip_Code__c)) {
        //USA
        if (zc.length()>5) {
        zc = zc.left(5);
        }
        }
        String zipWild = zc + '%';
        Map<Id, Account> acntsMap = new Map<Id, Account>(
        [
        SELECT
        Id,
        Name,
        ShippingCountry,
        ShippingPostalCode,
        SAP_Customer_Number__c,
        FTL_Nomination_Count__c
        FROM Account
        WHERE
        ShippingPostalCode LIKE :zipWild
        AND FTL_Eligibility__c LIKE 'Eligible%'
        ]
        );
        //Set of acnt IDs associated to dealer marketing
        Set<Id> acntIDs = new Set<Id>();
        for (Dealer_Marketing__c d : [
        SELECT Account__c
        FROM Dealer_Marketing__c
        WHERE Additional_Service_Areas__c LIKE :zipWild
        ]) {
        acntIDs.add(d.Account__c);
        system.debug('added account id ' + d.Account__c);
        }
        for (Additional_Dealer_Locator_Addresses__c a : [
        SELECT Dealer_Marketing__r.Account__c
        FROM Additional_Dealer_Locator_Addresses__c
        WHERE Zip_Postal_Code__c LIKE :zipWild
        ]) {
        acntIds.add(a.Dealer_Marketing__r.Account__c);
        system.debug(
        'added account id ' + a.Dealer_Marketing__r.Account__c
        );
        }
        if (acntIds.size() > 0) {
        acntsMap.putAll(
        [
        SELECT
        Id,
        Name,
        ShippingCountry,
        ShippingPostalCode,
        SAP_Customer_Number__c
        FROM Account
        WHERE
        Id IN :acntIds
        AND FTL_Eligibility__c LIKE 'Eligible%'
        ]
        );
        }
        if (!acntsMap.isEmpty()) {
        //acntsMap = getNomCount(acntsMap);
        acnts = acntsMap.values();
        }
        else {
        acnts = new List<Account>();
        }
        }
        }
        */
            //function for determining the # of nomination assignments
            /*  public static Map<Id, Account> getNomCount(Map<Id, Account> acntsMap) {
        //get the first day of the year to get only the nominations created this year.
        Date d = Date.newInstance(Date.today().year(), 1, 1);
        System.Debug('!!! Date: ' + d);
        System.Debug('!!! acntsMap: ' + acntsMap);
        List<FTL_Program_Form__c> ftlForms = [
        SELECT Assigned_Dealer__c
        FROM FTL_Program_Form__c
        WHERE Assigned_Dealer__c IN :acntsMap.keySet() AND CreatedDate >= :d
        AND Archived__c = FALSE AND Status__c != 'Closed'
        ];
        System.Debug('!!! FTLForms: ' + ftlForms);
        /*for (Id a : acntsMap.keySet()) {
        //set the nom count to 0
        acntsMap.get(a).FTL_Nomination_Count__c = 0;
        }
        for (FTL_Program_Form__c f : ftlForms) {
        acntsMap.get(f.Assigned_Dealer__c).FTL_Nomination_Count__c += 1;
        }
        return acntsMap;
        }*/
    public void assignDealer() {
        system.debug('this.paramValue ::'+this.paramValue);
        this.form.Assigned_Dealer__c = this.paramValue;
        update this.form;
    }
            /*GOOGLE API 
        //creates 2 maps associating postal abbreviation and state name
        public void setupStateMaps() {
        Map<String, String> stateMap = new Map<String, String>{
        'Alabama' => 'AL',
        'Alaska' => 'AK',
        'Arizona' => 'AZ',
        'Arkansas' => 'AR',
        'California' => 'CA',
        'Colorado' => 'CO',
        'Connecticut' => 'CT',
        'Delaware' => 'DE',
        'Florida' => 'FL',
        'Georgia' => 'GA',
        'Hawaii' => 'HI',
        'Idaho' => 'ID',
        'Illinois' => 'IL',
        'Indiana' => 'IN',
        'Iowa' => 'IA',
        'Kansas' => 'KS',
        'Kentucky' => 'KY',
        'Louisiana' => 'LA',
        'Maine' => 'ME',
        'Maryland' => 'MD',
        'Massachusetts' => 'MA',
        'Michigan' => 'MI',
        'Minnesota' => 'MN',
        'Mississippi' => 'MS',
        'Missouri' => 'MO',
        'Montana' => 'MT',
        'Nebraska' => 'NE',
        'Nevada' => 'NV',
        'New Hampshire' => 'NH',
        'New Jersey' => 'NJ',
        'New Mexico' => 'NM',
        'New York' => 'NY',
        'North Carolina' => 'NC',
        'North Dakota' => 'ND',
        'Ohio' => 'OH',
        'Oklahoma' => 'OK',
        'Oregon' => 'OR',
        'Pennsylvania' => 'PA',
        'Rhode Island' => 'RI',
        'South Carolina' => 'SC',
        'South Dakota' => 'SD',
        'Tennessee' => 'TN',
        'Texas' => 'TX',
        'Utah' => 'UT',
        'Vermont' => 'VT',
        'Virginia' => 'VA',
        'Washington' => 'WA',
        'West Virginia' => 'WV',
        'Wisconsin' => 'WI',
        'Wyoming' => 'WY',
        //Canada
        'Newfoundland and Labrador' => 'NL',
        'Prince Edward Island' => 'PE',
        'Nova Scotia' => 'NS',
        'New Brunswick' => 'NB',
        'Quebec' => 'QC',
        'Ontario' => 'ON',
        'Manitoba' => 'MB',
        'Saskatchewan' => 'SK',
        'Alberta' => 'AB',
        'British Columbia' => 'BC',
        'Yukon' => 'YT',
        'Northwest Territories' => 'NT',
        'Nunavut' => 'NU'
        };
        fullStateMap.putAll(stateMap);
        //now reverse the map
        for (String sName : stateMap.keySet()) {
        abbStateMap.put(stateMap.get(sName), sName);
        }
        }
        */
    public void getNearbyDealers() {
        acnts = new List<Account>(); //Init <-- these are only used for zip code results!
        this.errorMsg = '';
        //Updated - Fetch Coordinates using Salesforce Maps method - geocode
        Location returnLocation = new Location();
        String salesforceAddress =  setupOriginAddress(form);
        if(salesforceAddress == null){
            this.errorMsg = nodealermsg;
        }else{
        String salesforceWithnoStreetAddress = setupOriginAddressNoStreet(form);
         //system.debug('BINGOAddress'+salesforceAddress);
        string zc, zipWild;
        if (form.Nominee_Zip_Code__c != null && form.Nominee_Zip_Code__c != '' ) {
            zc = form.Nominee_Zip_Code__c;
            zc = zc.trim();
            if (form.Nominee_Country__c == 'CA' || form.Nominee_Country__c == 'Canada' 
                || (zc != null && zc.substring(3,4).isWhitespace())) {
                // Canada
                if (zc.length()>7) {
                    zc = zc.left(7);
                }                
            } else {
                //USA
                if (zc.length()>5) {
                    zc = zc.left(5);
                }
            }
            zipWild = '%' + zc + '%';
        }
        Map<string,object> options = new Map<String,Object> {
            'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                'address' => salesforceAddress
                };
                    // Call the Geocode() method with the address.
                    Map<String, Object> response ;
            if (!Test.isRunningTest()) {
                try {
                    // Attempt to call the Geocode method
                    response = maps.API.Geocode(options);
                } catch (Exception e) {
                    // Log the error message
                    System.debug('Error occurred while calling Geocode: ' + e.getMessage());
                    // Log the exception type
                    System.debug('Exception Type: ' + e.getTypeName());
                    // Log the stack trace
                    System.debug('Stack Trace: ' + e.getStackTraceString());
                    // Optionally, you can set response to null or handle it as needed
                    response = null; // or handle the error as appropriate
                }
            } 
            else {
                Map<String, Object> fakeResponse = (Map<String, Object>) JSON.deserializeUntyped('{ "baseUrl": "https://internal.sfmapsapi.com/core/geocoding/3?address=Test+Road%2C%2C+Leander%2C+TX+78641%2C+US", "data": { "city": "Leander", "country": "USA", "fullAddress": "Tessera Pkwy, Leander, TX 78645, United States", "matchLevel": "Street", "position": { "lat": 30.48559, "lng": -97.99298 }, "postal": 78645, "score": 85, "state": "TX", "street": "Tessera Pkwy" }, "source": "http", "success": true }');
               response = fakeResponse;
            }
        String value1 = JSON.serialize(response.get('data'));
        Map<String, Object> resultsMap1 = (Map<String, Object>) JSON.deserializeUntyped(value1);
        //system.debug('BINGO'+resultsMap1.toString());
        String value2 = JSON.serialize(resultsMap1.get('position'));
            //system.debug('value2'+value2);
        Map<String, Object> resultsMap2 = (Map<String, Object>) JSON.deserializeUntyped(value2);
        // Log the resulting geographical coordinates and formatted address. 
        if(!resultsMap2.isEmpty()){
            Double lat = Double.valueOf(resultsMap2.get('lat'));
            Double lon = Double.valueOf(resultsMap2.get('lng'));
            returnLocation = Location.newInstance(lat, lon);
        }
            Location loc1  = returnLocation;  
        if(loc1.getLatitude() == null || loc1.getLatitude() == null){
            this.errorMsg = nodealermsg;
            return;
        }
                    //call function to setup state maps
                    /*GOOGLE API 
            setupStateMaps();
            //create a map with one value pair - state name and keyset
            Map<String, String> nomState = new Map<String, String>();
            if (fullStateMap.containsKey(form.Nominee_State__c)) {
            nomState.put(
            form.Nominee_State__c,
            fullStateMap.get(form.Nominee_State__c)
            );
            } else if (abbStateMap.containsKey(form.Nominee_State__c)) {
            nomState.put(
            form.Nominee_State__c,
            abbStateMap.get(form.Nominee_State__c)
            );
            }
            Integer currentYear = System.today().year();
            //Canada or USA States only
            */
        List<String> lstCountry = new List<String>();
        String zip = form.Nominee_Zip_Code__c;
        zip = zip.trim();
        String zipLike;
        if (form.Nominee_Country__c == 'CA' || form.Nominee_Country__c == 'Canada' 
            || (form.Nominee_Country__c == null && zip != null && zip.substring(3,4).isWhitespace())){
            lstCountry.add('CA');
            lstCountry.add('Canada');
            zipLike = '!!! !!!';
        } else if (form.Nominee_Country__c == 'US' || form.Nominee_Country__c == 'USA' 
            || form.Nominee_Country__c == 'United States' || form.Nominee_Country__c == 'United States of America'
            || form.Nominee_Country__c == null || form.Nominee_Country__c == ''){
            lstCountry.add('US');
            lstCountry.add('USA');
            lstCountry.add('United States');
            lstCountry.add('United States of America');
            zipLike = 'z';
        } else {
            lstCountry.add(form.Nominee_Country__c);
            zipLike = 'z';
        }
        //('##### zipLike: ' + zipLike);
        Map<Id,Account> instateAcnts = new Map<Id, Account>([
            SELECT
            Id,
            Name,
            SAP_Customer_Number__c,
            ShippingStreet,
            ShippingState,
            ShippingPostalCode,
            ShippingCity,
            ShippingCountry,
            FTL_Nomination_Count__c,
            ShippingAddress,
            (Select Id, Name from Contacts WHERE FTL_Program_Status__c='Enrolled' AND FTL_Provisioned__c=true),
            DISTANCE(ShippingAddress, :loc1, 'mi') dist
            FROM Account
            WHERE Id in (select AccountId from Contact WHERE FTL_Program_Status__c='Enrolled' AND FTL_Provisioned__c=true)
            // CALENDAR_YEAR(DS_Completion_Date__c)=:currentYear AND 
            //(ShippingState IN :nomState.values()
            // OR ShippingState IN :nomState.keySet())
            AND FTL_Eligibility__c = 'Enrolled' 
            AND (ShippingCountry IN :lstCountry OR (ShippingCountry = NULL AND ShippingPostalCode LIKE :zipLike))
            ORDER BY DISTANCE(ShippingAddress, :loc1, 'mi') ASC
            LIMIT 25
        ]);
                    system.debug('##### zipWild: ' + zipWild);
        List<String> lstDealerMarketAccountId = new List<String>();
        for (Dealer_Marketing__c d : [SELECT Id, Account__c 
                                      FROM Dealer_Marketing__c 
                                      WHERE Additional_Service_Areas__c LIKE :zipWild]){
            if(!instateAcnts.containsKey(d.Account__c)){
                lstDealerMarketAccountId.add(d.Account__c);
            }
        }
                    //system.debug('!!!!!!::'+lstDealerMarketAccountId);
        Map<Id,Account> additionalAcnts = new Map<Id, Account>([
            SELECT
                Id,
                Name,
                SAP_Customer_Number__c,
                ShippingStreet,
                ShippingState,
                ShippingPostalCode,
                ShippingCity,
                ShippingCountry,
                FTL_Nomination_Count__c,
                ShippingAddress
            FROM Account
            WHERE Id IN :lstDealerMarketAccountId  AND FTL_Eligibility__c = 'Enrolled'  ]);         
        //system.debug('instateAcnts ::'+JSON.serialize(instateAcnts));
        if (!instateAcnts.isEmpty() || !additionalAcnts.isEmpty() || Test.isRunningTest()) {
            Map<Id,Account> accountWithProvisionedContacts = new Map<Id,Account>();
            for(String key : instateAcnts.keySet()){
                Account act = instateAcnts.get(key);
                //System.debug('-->'+act);
                //System.debug('-s->'+act.ShippingAddress);
                Double dist;
                if(Test.isRunningTest()) { 
                      dist = (Double)18.79828077735537;
                }else{
                    dist = (Double)act.get('dist'); 
                }
                dist = dist * 10;
                Long distLong = dist.round();
                dist = Double.valueOf(distLong) / 10;
                Integer distInt = Integer.valueOf(dist);
                String distText = String.valueOf(dist);
                this.acntWraps.add(new AcntWrapper(act, distInt, distText));
                //system.debug('contacts ::'+instateAcnts.get(key).Contacts);
                //if(!instateAcnts.get(key).Contacts.isEmpty()){
                //    accountWithProvisionedContacts.put(instateAcnts.get(key).Id,instateAcnts.get(key));
                //}
            }
            for(String key : additionalAcnts.keySet()){
                Account act = additionalAcnts.get(key);
                this.acntWraps.add(new AcntWrapper(act, 9999, '*'));
            }
            // List<Account> accounts = getNomCount(accountWithProvisionedContacts).values();
            //parseResponses(accountWithProvisionedContacts.values(), getJsonResults(accountWithProvisionedContacts.values(), this.form));
        }
        else {
            this.errorMsg = nodealermsg;
        }
        }
    }
    //setup origin address by making it a string
    public static string setupOriginAddress(FTL_Program_Form__c f) {
        if(f.Nominee_Zip_Code__c != null && f.Nominee_City__c != null  && f.Nominee_State__c != null){
        return f.Nominee_Street_Address__c +
            ', ' +
            f.Nominee_City__c +
            ', ' +
            f.Nominee_State__c +
            ' ' +
            f.Nominee_Zip_Code__c +
            ', ' +
            f.Nominee_Country__c;}
    else{
        return null;
    }
    }
    public static string setupOriginAddressNoStreet(FTL_Program_Form__c f) {
        return f.Nominee_City__c +
            ', ' +
            f.Nominee_State__c +
            ' ' +
            f.Nominee_Zip_Code__c +
            ', ' +
            f.Nominee_Country__c;
    }    
            /*
        public static string setupDestinationAddress(Account a) {
        return a.ShippingStreet +
        ',' +
        a.ShippingCity +
        ',' +
        a.ShippingState +
        ' ' +
        a.ShippingPostalCode +
        ', ' +
        a.ShippingCountry;
        }
        */
            /*
        public static string[] setupDestinationAddress(List<Account> instateAcnts) {
        List<string> destinations = new List<string>();
        for (Account a : instateAcnts) {
        destinations.add(setupDestinationAddress(a));
        }
        return destinations;
        }
        */
            //private static Integer URL_MAX_LENGTH=2048;
            //function for calling google maps api
            //https://developers.google.com/maps/documentation/urls/url-encoding
            /*
        public static List<HTTPResponse> getJsonResults(List<Account> accounts, FTL_Program_Form__c f) {
        if (accounts == null || accounts.isEmpty()) {
        return null;
        }
        DV_Flow_AP__PlacesAPI__c  APIkey = DV_Flow_AP__PlacesAPI__c.getInstance();
        //String distanceMatrixAPIkey = APIkey.Distance_Matrix_API_Key__c; 
        String distanceMatrixAPIkey = 'AIzaSyDx_MmVXDSI-HLtT1YKDUEyusXquEtm_Ns'; 
        String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json' +
        '?mode=driving' +
        '&sensor=false' +
        '&language=en' +
        '&key='+distanceMatrixAPIkey +
        '&units=' + (isCanada(f.Nominee_Country__c, f.Nominee_Zip_Code__c) ? 'metric' : 'imperial') +
        '&origins=' + EncodingUtil.urlEncode(setupOriginAddress(f), 'UTF-8') +
        '&destinations=';
        List<HTTPResponse> responses = new List<HTTPResponse>();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        Http http = new Http();
        List<string> dest =  setupDestinationAddress(accounts);
        string destStr = '';
        boolean send = false;
        //This logic assumes 1 origin address + 1 destination address + url lenth is less than or equal to URL_MAX_LENGTH
        for(integer i = 0; i<dest.size(); i++) {
        destStr = destStr + ((destStr=='')?'':'|') + dest[i];
        if (i<dest.size()-1) {
        //Precheck next item to determine if we should send now.
        string tmpUrl = url + EncodingUtil.urlEncode(destStr + ((destStr=='')?'':'|') + dest[i+1], 'UTF-8');
        send = tmpUrl.length() > URL_MAX_LENGTH;
        }
        send =  i==(dest.size() - 1); //Always send the last item
        if (send) {
        req.setEndPoint(url + EncodingUtil.urlEncode(destStr, 'UTF-8'));
        system.debug('req.getEndPoint: ' + req.getEndPoint());
        responses.add(http.send(req));
        destStr = ''; //Reset
        send = false;
        }
        }
        return responses;
        }
        */
            /*
        private static Boolean isCanada(String country, string zip) {
        if (String.isBlank(country)){
        if (String.isBlank(zip)){
        return false;
        }
        else{
        //TODO: maybe use a regex
        string tmp = zip.replace('-', '');
        tmp = tmp.replace(' ', '');
        return !tmp.isNumeric(); //Canadian is alphanumeric; American is numeric
        }
        }
        else{
        return (country.equalsIgnoreCase('Canada') || country.equalsIgnoreCase('CA'));
        }
        }
        */
            /*
        private static Boolean hasDestinations(List<GoogleStruct> googleStructs) {
        for (GoogleStruct googleStruct : googleStructs) {
        for (String destination : googleStruct.destination_addresses) {
        if (!String.isEmpty(destination)) {
        return true;
        }
        }
        }
        return false;
        }
        */
    private static string nodealermsg = 'No nearby dealers were found. Please check that the nominee address is valid.';
            /*
        public void parseResponses(List<Account> accounts, List<HTTPResponse> responses) {
        system.debug('parsingResponses');
        this.acntWraps = new List<AcntWrapper>();
        if (responses==null || responses.isEmpty()) {
        this.errorMsg = nodealermsg;
        return;
        }
        List<GoogleStruct> googleStructs = new List<GoogleStruct>();
        system.debug('checking and extractingn structs');
        for (HTTPResponse response : responses) {
        System.debug(response.getBody());
        string body = response.getBody();
        if (body.indexOf('REQUEST_DENIED') > -1) {
        errorMsg = 'Request to the Google API was denied.';
        return;
        }
        googleStructs.add((GoogleStruct)JSON.deserialize(body, GoogleStruct.class));
        }
        system.debug('verifying destinations exist');
        if (!hasDestinations(googleStructs)) {
        this.errorMsg = nodealermsg;
        return;
        }
        integer index = 0;
        system.debug('looping structs');
        for (GoogleStruct googleStruct : googleStructs) {
        Integer addressCount = googleStruct.destination_addresses.size();
        for (GoogleElement ge : googleStruct.rows[0].elements) {
        system.debug(ge);
        if (ge.status=='OK') {
        this.acntWraps.add(new AcntWrapper(accounts[index], ge.distance.value, ge.distance.text));
        } else {
        this.acntWraps.add(new AcntWrapper(accounts[index], null, null));
        }
        index++;
        }
        }
        system.debug('sorting...');
        this.acntWraps.sort();
        system.debug('parsingResponses - END ::'+ this.acntWraps.size());
        }
        */
    //wrapper class to sort anct IDs by distance
    public class AcntWrapper implements Comparable {
        public String acntId { get; set; }
        public Integer distance { get; set; }
        public String ShippingPostalCode { get; set; }
        public String customerNum { get; set; }
        public String Name { get; set; }
        public Decimal NominationCount { get; set; }
        public string distanceText { get; set; }
        public AcntWrapper(
            Account account,
            Integer distance,
            String distanceText
        ) {
            this.acntId = account.Id;
            this.distance = distance;
            this.ShippingPostalCode = account.ShippingPostalCode;
            this.customerNum = account.SAP_Customer_Number__c;
            this.Name = account.Name;
            this.NominationCount =account.FTL_Nomination_Count__c;
            if (distance == null) {
                this.distanceText = 'Not Found';
            } else {
                this.distanceText = distanceText;
            }
        }
        public Integer compareTo(Object other) {
            Integer otherDistance = ((AcntWrapper) other).distance;
            if (otherDistance == null) return -1;
            if (distance == null) return 1;
            return Integer.valueOf(distance - otherDistance);
        }
    }
            /*
        private class GoogleData {
        public String text;
        public Integer value;
        }
        private class GoogleElement {
        public GoogleData distance;
        public GoogleData duration;
        public String status;
        }
        private class GoogleRow {
        public List<GoogleElement> elements;
        }
        public class GoogleStruct {
        public List<String> destination_addresses;
        public List<String> origin_addresses;
        public List<GoogleRow> rows;
        public String status;
        }
        */
    /*private Location getGeoLocation(FTL_Program_Form__c form){
        Location returnLocation = new Location();
        String url = 'https://geocode.maps.co/search?q=' + EncodingUtil.urlEncode(setupOriginAddress(form), 'UTF-8');
        system.debug('url: ' + url);
        HTTPResponse response = new HTTPResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        response = http.send(req);
        system.debug(response);
        if(response.getStatusCode() == 200){
            String result = response.getBody();
            system.debug(response.getBody());
            List<Object> l = (List<Object>)JSON.deserializeUntyped(result);
            if(!l.isEmpty()){
                system.debug('Check1');
                Map<String, Object> m = (Map<String, Object>)l[0];
                Double lat = Double.valueOf(m.get('lat'));
                Double lon = Double.valueOf(m.get('lon'));
                returnLocation = Location.newInstance(lat, lon);
            } else {
                system.debug('Check2');
                url = 'https://geocode.maps.co/search?q=' + EncodingUtil.urlEncode(setupOriginAddressNoStreet(form), 'UTF-8');
                system.debug('url: ' + url);
                req.setEndpoint(url);
                response = http.send(req);
                if(response.getStatusCode() == 200){
                    system.debug('Check3'+ response.getBody());
                    result = response.getBody();
                    l = (List<Object>)JSON.deserializeUntyped(result);
                    if(!l.isEmpty()){
                        system.debug('Check4');
                        Map<String, Object> m = (Map<String, Object>)l[0];
                        Double lat = Double.valueOf(m.get('lat'));
                        Double lon = Double.valueOf(m.get('lon'));
                        returnLocation = Location.newInstance(lat, lon);                        
                    }
                }
            }
        }
        return returnLocation;
    }*/
}