/**
 * @description       : Controller for NewAccountLightningV4 Aura Component
 * @author            : Ken@VentasConsulting.com
 * @last modified on  : 09-03-2020
 * @last modified by  : Ken@VentasConsulting.com
 * Modifications Log 
 * Ver   Date         Author                     Modification
 * 1.0   09-03-2020   Ken@VentasConsulting.com   Initial Version
**/
public class NewAccountLightningCtrl {
    /**
    * @description Takes JSON string as param, deserialize it and create a new account 
    * @author Ken@VentasConsulting.com | 09-03-2020 
    * @param newAccountDataJson 
    * @return String 
    **/
    @AuraEnabled
    public static String createAccount(String newAccountDataJson, String placeDetailsJson){
        try {
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Non SAP').getRecordTypeId();
            NewAccountData newAccountData = (NewAccountData)JSON.deserialize(newAccountDataJson, NewAccountData.class);
            List<PlaceDetailsElement> placeDetailsList = (List<PlaceDetailsElement>)JSON.deserialize(placeDetailsJson, List<PlaceDetailsElement>.class);
            PlaceDetails placeDetails = new PlaceDetails(placeDetailsList);
            Account newAccount = new Account(
                Name               = newAccountData.name,
                Phone              = newAccountData.phone,
                Website            = newAccountData.website,
                Fax                = newAccountData.fax,
                ShippingStreet     = placeDetails.streetNumber + ' ' + placeDetails.route,
                ShippingCity       = placeDetails.locality,
                ShippingState      = placeDetails.state,
                ShippingCountry    = placeDetails.country,
                ShippingPostalCode = placeDetails.postalCode,
                RecordTypeId 	   = rtId
            );
            insert newAccount;
            return 'SUCCESS:' + newAccount.Id;
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }
            
    // Shape of the object that comes from the component
    public class NewAccountData {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String phone {get;set;}
        @AuraEnabled public String website {get;set;}
        @AuraEnabled public String fax {get;set;}
    }

    /* Example Google placeDetails stringified json
        [
            {"label":"street_number","value":"1614"},
            {"label":"route","value":"South Walnut Street"},
            {"label":"locality","value":"Coffeyville"},
            {"label":"administrative_area_level_2","value":"Montgomery County"},
            {"label":"administrative_area_level_1","value":"KS"},
            {"label":"country","value":"US"},
            {"label":"postal_code","value":"67337"}
        ]
    */    
    // Constructor takes list of PlaceDetailsElement (see structure above) and creates PlaceDetails object
    public class PlaceDetails {
        @AuraEnabled public String streetNumber {get;set;}
        @AuraEnabled public String route {get;set;}
        @AuraEnabled public String locality {get;set;}
        @AuraEnabled public String county {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String country {get;set;}
        @AuraEnabled public String postalCode {get;set;}

        public PlaceDetails(List<PlaceDetailsElement> elements) {
            for (PlaceDetailsElement element : elements) {
                if (element.label == 'street_number') {this.streetNumber = element.value;}
                else if (element.label == 'route') {this.route = element.value;}
                else if (element.label == 'locality') {this.locality = element.value;}
                else if (element.label == 'administrative_area_level_2') {this.county = element.value;}
                else if (element.label == 'administrative_area_level_1') {this.state = element.value;}
                else if (element.label == 'country') {this.country = element.value;}
                else if (element.label == 'postal_code') {this.postalCode = element.value;}
            }
        }
    }

    public class PlaceDetailsElement {
        public String label {get;set;}
        public String value {get;set;}
    }
}