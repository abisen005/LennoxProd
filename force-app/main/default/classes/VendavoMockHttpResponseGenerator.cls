@isTest
global class VendavoMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        String body;
        String endpoint = req.getEndpoint();
        if(endpoint.contains('/rest/agreement/')) {
			body = VendavoAgreementsTest.getAgreementsTestJson();
        } else if(endpoint.contains('rest/agreements')) {
            body = VendavoAgreementsTest.getAgreementsTestJson();
        } else if(endpoint.contains('/rest/login')) {
            body = '{"auth-token":"faketoken"}';
        }
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}