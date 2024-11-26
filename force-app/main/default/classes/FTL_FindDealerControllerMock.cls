@IsTest
global class FTL_FindDealerControllerMock {
    global class BaseMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('GET', req.getMethod());
            //String resp = '{ "destination_addresses" : [ "204 E Chestnut St, Independence, KS 67301, USA" ],'+
            //    ' "origin_addresses" : [ "Absarokee, MT 59001, USA" ],'+
            //    ' "rows" : [{   "elements" : [ { "distance" : { "text" : "1227 mi", "value" : 1974756 },"duration" : {"text" : "17 hours 31 mins","value" : 63047},"status" : "OK"}]}],'+
            //    ' "status" : "OK"} ';
            // Create a fake response
            String resp = '[{"lat":"42.110153", "lon":"-92.986625"}]';
            // Create a fake response            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(resp);
            res.setStatusCode(200);
            return res;
        }
    }

    global class nullReturnMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('GET', req.getMethod());
            //String resp = '{ "destination_addresses" : [ "204 E Chestnut St, Independence, KS 67301, USA" ],'+
            //    ' "origin_addresses" : [ "Absarokee, MT 59001, USA" ],'+
            //    ' "rows" : [{   "elements" : [ { "distance" : { "text" : "1227 mi", "value" : 1974756 },"duration" : {"text" : "17 hours 31 mins","value" : 63047},"status" : "OK"}]}],'+
            //    ' "status" : "OK"} ';
            // Create a fake response
            String resp = '[]';
            // Create a fake response            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(resp);
            res.setStatusCode(200);
            return res;
        }
    }    
    
    global class CanadianTwoDestinationMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('GET', req.getMethod());
            String json = '{ "destination_addresses" : [ "209 Prestwick Estate Way SE, Calgary, AB T2Z 4H2, CA", "79 Southwest Dr SW, Medicine Hat, AB T1A 8B8, CA" ],'+
                            ' "origin_addresses" : [ "12020 Candiac Rd SW, Calgary, AB T2W 1K9, CA" ],'+
                            ' "rows" : [{   "elements" : [ { "distance" : { "text" : "14 km", "value" : 14000 },"duration" : {"text" : "15 mins","value" : 900},"status" : "OK"}, ' +
                            ' { "distance" : { "text" : "15 km", "value" : 15000 }, "duration" : {"text" : "15 mins","value" : 900},"status" : "OK"}]}],'+
                            ' "status" : "OK"} ';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(json);
            res.setStatusCode(200);
            return res;
        }
    }

    global class Texas3DestMiddleNullMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('GET', req.getMethod());
            String json = '{ "destination_addresses" : [ "15900 La Cantera Pkwy, San Antonio, TX 87654, US", "", "15902 La Cantera Pkwy, San Antonio, TX 87654, US" ],'+
                            ' "origin_addresses" : [ "15903 La Cantera Pkwy, San Antonio, TX 87654, US" ],'+
                            ' "rows" : [{   "elements" : [ { "distance" : { "text" : "20 mi", "value" : 20000 },"duration" : {"text" : "20 mins","value" : 1200},"status" : "OK"}, ' +
                			'{ "status" : "NOT FOUND" }, ' + 
                            ' { "distance" : { "text" : "15 mi", "value" : 15000 }, "duration" : {"text" : "15 mins","value" : 900},"status" : "OK"}]}],'+
                            ' "status" : "OK"} ';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(json);
            res.setStatusCode(200);
            return res;
        }
    }

    global class Texas3DestAllNullMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('GET', req.getMethod());
            String json = '{ "destination_addresses" : [ "", "", "" ],'+
                            ' "origin_addresses" : [ "15903 La Cantera Pkwy, San Antonio, TX 87654, US" ],'+
                ' "rows" : [{   "elements" : [ { "status" : "NOT FOUND" }, { "status" : "NOT FOUND" }, { "status" : "NOT FOUND"}]}], "status" : "OK" } ';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(json);
            res.setStatusCode(200);
            return res;
        }
    }
}