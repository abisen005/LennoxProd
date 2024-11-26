public with sharing class printPDFController {

    // public Contact con {get;set;}


    public printPDFController() {}


    public Map<String, List<String>> getPicklistValuesMap() {
        Map<String, List<String>> picklistValuesMap = new Map<String, List<String>>();

        // get object describe
        Schema.DescribeSObjectResult conObj = Contact.SObjectType.getDescribe();

        picklistValuesMap.put('Contact_Type__c', getPicklistValues(conObj, 'Contact_Type__c'));
        picklistValuesMap.put('Role__c', getPicklistValues(conObj, 'Role__c'));
        picklistValuesMap.put('Secondary_Roles__c', getPicklistValues(conObj, 'Secondary_Roles__c'));
        return picklistValuesMap;
    }

    private List<String> getPicklistValues(Schema.DescribeSObjectResult sObj, String fieldName) {
        List<String> picklistValues = new List<String>();
        for(Schema.PicklistEntry pickListVal : sObj.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
            picklistValues.add(pickListVal.getLabel());
        }
        return picklistValues;
    }



    @RemoteAction
    public static Id saveContact(Contact con) {
        insert con;
        return con.id;
    }

    @RemoteAction
    public static Contact addEmail(String contactId, String email) {
        Contact con = new Contact(Id = contactId);
        con.Email = email;
        update con;
        return con;
    }




    @RemoteAction
    public static List<Contact> getContacts(String accId) {
        List<Contact> result = [SELECT FirstName, LastName, Email, Id FROM Contact WHERE AccountId = :accId ORDER BY LastName LIMIT 1000];
        return result;
    }



    @RemoteAction
    public static List<User> searchUsers(String query) {
        if(!String.isEmpty(query) && query.length() > 2) {
            query = query + '*';
            List<List<User>> result = [FIND :query IN NAME FIELDS RETURNING USER(Id, Name, Email, SmallPhotoUrl WHERE IsActive = TRUE)];
            System.debug(result[0]);
            return result[0];
        }
        return new List<User>();
    }

    @RemoteAction
    public static List<Contact> searchContacts(String query, String accId) {
        if(!String.isEmpty(query) && query.length() > 2) {
            query = query + '*';
            List<List<Contact>> result = [FIND :query IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName, Email, Title, Role__c WHERE AccountId = :accId)];
            System.debug(result[0]);
            return result[0];
        }
        return new List<Contact>();
    }




    @RemoteAction
    public static void sendEmail(String html, String attachmentFileName, List<String> toAddresses, 
                                 String subject, String body, Boolean copyMyself, 
                                 String orientation, String border) {

        Blob pdfBlob = getPdfBlob(html, orientation, border);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attachmentFileName + '.pdf');
        efa.setBody(pdfBlob);
        email.setSubject( subject );
        email.setToAddresses(toAddresses);
        if(copyMyself) email.setCCAddresses(new List<String>{UserInfo.getUserEmail()});
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        email.setPlainTextBody( body );
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

    private static Blob getPdfBlob(String html, String orientation, String border) {
        String API_ENDPOINT = 'https://www.ventastools.com/api/html2pdf';
        RequestWrapper body = new RequestWrapper();
        OptionsWrapper pdfOptions = new OptionsWrapper();
        pdfOptions.orientation = orientation;
        pdfOptions.base = 'https://lennox--intgrtdsb--c.cs13.visual.force.com';
        pdfOptions.type = 'pdf';
        pdfOptions.border = border;

        body.html = html;
        body.options = pdfOptions;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT);
        req.setMethod('POST');

        req.setHeader('accept', 'application/pdf');
        req.setHeader('Content-Type','application/json');
        req.setBody(json.serialize(body));

        Http http = new Http();
        HTTPResponse res = http.send(req);
        Blob responseBody = res.getBodyAsBlob();
        return responseBody;
    }



    @RemoteAction
    public static String saveEvent(String whatId, String subject, String description, String documentType) {
        Map<String, String> documentTypeEventTopicMap = new Map<String, String>{
            'Area Rollup Summary'           => 'Roll-up Summary Review',
            'TM Territory Roll-Up Summary'  => 'Roll-up Summary Review',
            'District Rollup Summary'       => 'Roll-up Summary Review',
            'Rollup Summary'                => 'Roll-up Summary Review',
            'Dealer Sales Summary'          => 'Sales Summary Review',
            'Dealer Benefit Report'         => 'Marketing Benefit Review',
            'Costco Scorecard'              => 'Costco Performance Review',
            'Lowe\'s Scorecard'             => 'Lowe\'s Performance Review',
            'Home Depot Scorecard'          => 'Home Depot Performance Review',
            'TM Pre-Call Planner'           => 'Pre-Call Plan Agenda',
            ''                              => 'Other (Include Details)'
        };
        Event evt = new Event();
        evt.Event_Type__c = 'Email';
        evt.Event_Topic__c = documentTypeEventTopicMap.get(documentType);
        evt.Subject = subject;
        evt.Description = description;
        evt.StartDateTime = System.now();
        evt.EndDateTime = System.now();
        if(String.isNotBlank(whatId)) evt.WhatId = whatId;
        insert evt;
        return evt.id;
    }



    public class RequestWrapper {
        public String html {get;set;}
        public OptionsWrapper options {get;set;}
    }

    public class OptionsWrapper {
        public String orientation {get;set;}
        public String base {get;set;}
        public String type {get;set;}
        public String border{get;set;}
    }

}