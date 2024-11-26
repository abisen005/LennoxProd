public class AutoCompleteAddressCtrl {
    
      //TODO : Move key to custom setting OR function.
   @AuraEnabled
   public static string getAddressAutoComplete(String input, String types) {
       
       String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
           + EncodingUtil.urlEncode(input, 'UTF-8')
           + '&types=' + types
           + '&key=' + DV_Flow_AP__PlacesAPI__c.getInstance().DV_Flow_AP__key__c;
       
       system.debug('response API ::: '+AutoCompleteAddressCtrl.getHttp(url));
       
       return AutoCompleteAddressCtrl.getHttp(url);
   }
    
    @AuraEnabled
   public static string getPlaceDetail(String placeId) {
       
       String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id='+ placeId 
                    + '&key=' + DV_Flow_AP__PlacesAPI__c.getInstance().DV_Flow_AP__key__c;
       
       return AutoCompleteAddressCtrl.getHttp(url);
   }
   
   public static String getHttp(String url) {
       HttpRequest req = new HttpRequest();
       Http http = new Http();
       req.setMethod('GET');
       req.setEndpoint(url);
       HTTPResponse res = http.send(req);
       System.debug('response '+ res.getBody());
       return res.getBody();
   }
    
    public static string getKey(){
        String key = DV_Flow_AP__PlacesAPI__c.getInstance().DV_Flow_AP__key__c;
        string output = '&key=' + key;	 
        return output;
    }
}