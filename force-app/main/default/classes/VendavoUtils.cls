public class VendavoUtils {
    
    
    /*******************************************************************************************************
    * @description Utility method for invoking Vendavo REST API calls
    * @param endpoint endpoint url without the server url. For example: 'rest/agreements'
    * @param method Callout Type
    * @param body http request body
    * @example
	* String json = vRequest('rest/agreement/{agreementid}', 'POST', '{'update':'value'}');
    */
    public static String vRequest(String endpoint, String method, String token, String body) {
        Vendavo_API_Credentials__c vendavoSettings = Vendavo_API_Credentials__c.getOrgDefaults();
        String serverUrl = vendavoSettings.serverUrl__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        HTTPResponse res;

        req.setEndpoint(serverUrl + endpoint);
        req.setMethod(method);
        req.setHeader('auth-token', token);
        req.setHeader('content-type', 'application/json');
        if(body != null)
        	req.setBody(body);
        if(Test.isRunningTest()) {
            VendavoMockHttpResponseGenerator responseGenerator = new VendavoMockHttpResponseGenerator();
            res = responseGenerator.respond(req);
        } else {
            res = h.send(req);
        }
        return res.getBody();
    }
    
    /*******************************************************************************************************
    * @description vRequest method overload for sending 2 params with GET requests without a body
    * @param endpoint endpoint url without the server url. For example: 'rest/agreements'
    * @param method 'GET' or 'POST'
    * @example
	* String json = vRequest('rest/agreements', 'GET');
    */
    public static String vRequest(String endpoint, String method, String token) {
        return vRequest(endpoint, method, token, null);
    }
    
    /*******************************************************************************************************
    * @description Return auth token for Vendavo REST API
    * @return String Authorization Token
    * @example
    * String authToken = getAuthToken();
    */
    public static String getAuthToken(String username, String password) {
        Vendavo_API_Credentials__c vendavoSettings = Vendavo_API_Credentials__c.getOrgDefaults();
        if(username == null || password == null) {
            username = vendavoSettings.Username__c;
            password = vendavoSettings.Password__c;
        }
        String serverUrl = vendavoSettings.serverUrl__c;
        Http h = new Http(); 
        HttpRequest req = new HttpRequest(); 
		HTTPResponse res;
        req.setEndpoint(serverUrl + '/rest/login');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        system.debug('{ "username": "' + username + '", "password": "' + password + '"}');
        req.setBody('{ "username": "' + username + '", "password": "' + password + '"}');
        
        if(Test.isRunningTest()) {
            VendavoMockHttpResponseGenerator responseGenerator = new VendavoMockHttpResponseGenerator();
            res = responseGenerator.respond(req);
        } else {
            res = h.send(req);            
        }

        JSONParser parser = JSON.createParser(res.getBody());
        system.debug(res.getBody());
        parser.nextToken();
        parser.nextValue();
        String authToken = parser.getText();
        return authToken;
    }
    
    public static String getAuthToken() {
        return getAuthToken(null, null);
    }
    
    /*******************************************************************************************************
    * @description Get value of first instance of the Id property in a JSON string
    * @param jsonString JSON to be find Id in
    * @return String first id value form json
    * @example
    * String newId = getJSONId(json);
    */
    public static String getJSONId(String jsonString) {
        JSONparser parser = JSON.createParser(jsonString);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentName() == 'id')) {
                parser.nextToken();
                return parser.getText();
            }
        }
        return null;
    }

	/*******************************************************************************************************
    * @description Returns all Vendavo agreements
    * @return String result as json string
    * @example
    * String agreementsJSON = getAgreements();
    */
    public static String getAgreements(String token, Integer perPage, Integer page) {
        String json = vRequest('/rest/agreements?perPage='+perPage+'&page='+page+'&state=approved', 'GET', token);
        json = json.replace('"from"', '"fromDate"');
        json = json.replace('"_paging"', '"paging"');
        return json;
    }
    
    /*******************************************************************************************************
    * @description Returns agreement object from Vendavo REST API
    * @param agreementKey Pass in the VID as a key to grab the agreement
    * @return String json result
    * @example
    * String agreementJSON = getAgreement('00017328-1');
    */
    public static String getAgreement(String agreementKey, String token) {
        return vRequest('/rest/agreements?fields=VID&text=' + agreementKey, 'GET', token);
    }
    
    /*******************************************************************************************************
    * @description Returns copied agreement object
    * @param agreementId Vendavo agreement id
    * @return String json result
    * @example
    * String agreementJSON = copyAgreement('xyz');
    */
    public static String copyAgreement(String agreementId, String token) {
        return vRequest('/rest/agreement/' + agreementId + '/copy', 'POST', token);
    }
    
    /*******************************************************************************************************
    * @description Return valid date from vendavo date value.  If year is 9900, change to an allowed year for salesforce database.
    * @param dateVal Date value from Vendavo agreement object 
    * @return Date Valid salesforce data
    * @example
    * Date dt = getDateVal(dt);
    */
    public static Date getDateVal(String dateVal) {
        dateVal = dateVal.replace('9900', '2050');
        Date returnDate = date.parse(dateVal.substringBefore(' '));
        return returnDate;
    }
    
}