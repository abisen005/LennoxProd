@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getResponseBody());
        res.setStatusCode(200);
        return res;
    }
    
    private static string getResponseBody(){
        return '"html_attributions" : [],' +
   	'"result" : {' +
      '"address_components" : [' +
         '{'+
            '"long_name" : "5",'+
            '"short_name" : "5",'+
            '"types" : [ "floor" ]'+
         '},'+
         '{'+
            '"long_name" : "48",'+
            '"short_name" : "48",'+
            '"types" : [ "street_number" ]'+
         '},'+
         '{'+
           '"long_name" : "Pirrama Road",'+
            '"short_name" : "Pirrama Rd",'+
            '"types" : [ "route" ]'+
         '},'+
         '{'+
            '"long_name" : "Pyrmont",'+
            '"short_name" : "Pyrmont",'+
            '"types" : [ "locality", "political" ]'+
         '},'+
         '{'+
            '"long_name" : "Council of the City of Sydney",'+
            '"short_name" : "Sydney",'+
            '"types" : [ "administrative_area_level_2", "political" ]'+
         '},'+
         '{'+
            '"long_name" : "New South Wales",'+
            '"short_name" : "NSW",'+
            '"types" : [ "administrative_area_level_1", "political" ]'+
         '},'+
         '{'+
            '"long_name" : "Australia",'+
            '"short_name" : "AU",'+
            '"types" : [ "country", "political" ]'+
         '},'+
         '{'+
            '"long_name" : "2009",'+
            '"short_name" : "2009",'+
            '"types" : [ "postal_code" ]'+
         '}'+
             ']}';
    }
}