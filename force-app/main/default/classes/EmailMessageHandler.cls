/*
* @ Purpose      : This handler is used for attach Emailmessage to Case.                   
* @ CreatedDate  : 10/09/2018
*/
public class EmailMessageHandler {
    public static boolean isCommunityMail = false;
    /* 
    * @Purpose      : this function used to attach Emailmessage to Case of siteloaction or conatct.
    * @Parameter    : List<EmailMessage> emailMessageList) 
    */
    Public static void attachEmailToCase(List<EmailMessage> emailMessageList){
        System.debug('In EmailMessageHandler');
        Map <Id, Home_Owners__c> siteLocationMap;
        Map <Id, Contact> contactMap;
        Map<String, List<CASE>> siteloactionToCaseMap;
        Map<String, List<CASE>> contactToCaseMap;
        
        try{
            String fromAddress = getFromAdresses(emailMessageList);
            system.debug('fromAddress '+fromAddress);
            if(String.isNotBlank(fromAddress)){                
                siteLocationMap = getSiteLocations(fromAddress);
                contactMap = getContacts(fromAddress);
                system.debug('contactMap '+contactMap);
            }
            
            List<Case> listCaseToDelete = new List<Case>();
            
            if(siteLocationMap != null && !siteLocationMap.isEmpty()){
                siteloactionToCaseMap = getSiteloactionToCaseMap(siteLocationMap.keySet());
            }
            if(contactMap != null && !contactMap.isEmpty()){
                contactToCaseMap = getContactToCaseMap(contactMap.keySet());
                system.debug('contactToCaseMap '+contactToCaseMap);
            }
            
            Boolean isAttached = false;
            if(!emailMessageList.isEmpty() && fromAddress == emailMessageList[0].FromAddress){
                if(siteloactionToCaseMap != null && !siteloactionToCaseMap.isEmpty()){                                                
                    isAttached = attachEmailMessageToSiteLocationCase(siteLocationMap.values(), emailMessageList[0], siteloactionToCaseMap);
                }
                
                if(contactToCaseMap != null && !contactToCaseMap.isEmpty() && !isAttached){                        
                    isAttached = attachEmailMessageToContactCase(contactMap.values(), emailMessageList[0], contactToCaseMap);
                }              
                
                if(isAttached && emailMessageList[0].RelatedToId != emailMessageList[0].ParentId) {
                    listCaseToDelete.add(new Case(Id = emailMessageList[0].RelatedToId));
                }
            }
            
            if(!listCaseToDelete.isEmpty()) {
                delete listCaseToDelete;
            }
            
        }
        catch(Exception ex){
            System.debug('Error '+ex.getLineNumber()+ ' '+ ex.getStackTraceString());
        }
    }
    
    /* 
    * @Purpose      : this function used to create set of fromAdresses.
    * @Parameter    : List<EmailMessage> emailMessageList 
    * @Returntype   : set<String>
    */
    private static String getFromAdresses(List<EmailMessage> emailMessageList){
        String fromAdress;
        
        if(!emailMessageList.isEmpty()){
            if(!emailMessageList[0].FromAddress.contains('@lennox')){
                fromAdress = emailMessageList[0].FromAddress;
            }
        }
        return fromAdress;
    }
    
    /* 
    * @Purpose      : this function used to get filter list of Home_Owners__c object .
    * @Parameter    : set<String> fromAdresses  
    * @Returntype   : List<Home_Owners__c>
    */
    private static Map <Id, Home_Owners__c> getSiteLocations(String fromAddress){
        
        Map <Id, Home_Owners__c> siteLocationMap = new Map <Id, Home_Owners__c>([SELECT Id,Email__c,Email2__c,Email3__c 
                                                                                 FROM Home_Owners__c 
                                                                                 WHERE Email__c =: fromAddress
                                                                                 OR Email2__c =: fromAddress
                                                                                 OR Email3__c =: fromAddress]);
        
        return siteLocationMap;
    }
    
    /* 
    * @Purpose      : this function used to get filter list of Contact object .
    * @Parameter    : set<String> fromAdresses  
    * @Returntype   : List<Contact>
    */
    private static Map <Id, Contact> getContacts(String fromAddress){
        
        system.debug('in contactMap ');
        Map <Id, Contact> contactMap = new Map <Id, Contact>([SELECT Id, email, contact_email__c 
                                                              FROM Contact 
                                                              WHERE (contact_email__c != null AND contact_email__c =: fromAddress)
                                                              OR (email != null AND email =: fromAddress)]);
        
        return contactMap;
    }
    
    /* 
    * @Purpose      : this function used to attach email message to Siteloaction Case.
    * @Parameter    : List<Home_Owners__c> siteLocations
    *                 EmailMessage emailMessage  
    */
    private static Boolean attachEmailMessageToSiteLocationCase(List<Home_Owners__c> siteLocations, EmailMessage emailMessage,
                                                             Map<String, List<CASE>> siteloactionToCaseMap){
        
        for(Home_Owners__c siteLocation : siteLocations){
            if((emailMessage.FromAddress.equals(siteLocation.Email__c) || emailMessage.FromAddress.equals(siteLocation.Email2__c) || 
                emailMessage.FromAddress.equals(siteLocation.Email3__c)) &&  siteloactionToCaseMap.containsKey(siteLocation.Id)){
                   
                   System.debug('emailMessage.RelatedToId' +emailMessage.RelatedToId);
                   List<Case> CaseList = siteloactionToCaseMap.get(siteLocation.Id);
                   
                   if(!CaseList.isEmpty()){
                       //deleteCase(emailMessage.RelatedToId);
                       emailMessage.ParentId = CaseList[0].Id;
                       updateCaseEmailCountField(CaseList[0].Id);
                       return true;
                   }
                   
               }
        }
		return false;
    }
    
    /* 
    * @Purpose      : this function used to attach EmaiLmessage to Contact Case.
    * @Parameter    : List<contact> contactList
    *                 EmailMessage emailMessage  
    */
    private static Boolean attachEmailMessageToContactCase(List<contact> contactList, EmailMessage emailMessage,
                                                        Map<String, List<CASE>> contactToCaseMap){
        
        for(contact con : contactList){
            if((emailMessage.FromAddress.equals(con.email) || emailMessage.FromAddress.equals(con.contact_email__c)) &&  
                contactToCaseMap.containsKey(con.Id)){
                    
                    List<Case> CaseList = contactToCaseMap.get(con.Id);
                   
                   if(!CaseList.isEmpty()){
                       //deleteCase(emailMessage.RelatedToId);
                       emailMessage.ParentId = CaseList[0].Id;
                       return true;
                   }
               }
        }
		return false;
    }
    
    private static Map<String, List<CASE>>getSiteloactionToCaseMap(set<Id> siteLocationIds){
        Map<String, List<CASE>> siteloactionToCaseMap = new Map<String, List<CASE>>();
        
        if(siteLocationIds != null && !siteLocationIds.isEmpty()){
           List<String> closedStatusList = new List<String> {'Closed - TS' , 'Closed' , 'Spam/Junk' , 'Closed as Duplicate' , 'Closed - More Info Needed' , '	Closed with Update', 'Do Not Use'};
            List<Case> CaseList = [SELECT Id, Home_Owner__c, Email_Count__c 
                               	   FROM Case 
                                   WHERE Status NOT IN : closedStatusList
                                   AND Home_Owner__c IN : siteLocationIds
                                  ];
        
        siteloactionToCaseMap = buildMap(CaseList, 'Home_Owner__c');
        }
        
        return siteloactionToCaseMap;
    }
    
    private static Map<String, List<CASE>>getContactToCaseMap(set<Id> contactIds){
        Map<String, List<CASE>> contactToCaseMap = new Map<String, List<CASE>>();
        
        if(contactIds != null && !contactIds.isEmpty()){
            List<String> closedStatusList = new List<String> {'Closed - TS' , 'Closed' , 'Spam/Junk' , 'Closed as Duplicate' , 'Closed - More Info Needed' , '	Closed with Update', 'Do Not Use'};
            List<Case> CaseList = [SELECT Id, contactId, Email_Count__c 
                                   FROM Case 
                                   WHERE contactId IN : contactIds
                                   AND Status NOT IN : closedStatusList
                                  ];
        
        contactToCaseMap = buildMap(CaseList, 'contactId');
        }
        
        return contactToCaseMap;
    }
    
    /* 
    * @Purpose      : this function used to get map of string to sobject list.
    * @Parameter    : List<SObject> listSobject,
    *                 String keyFieldName  
    * @Returntype   : Map<String, List<SObject>>
    */
    private static Map<String, List<SObject>> buildMap(List<SObject> listSobject, String keyFieldName) {
        Map<String, List<SObject>> mapParentToRecords = new Map<String, List<SObject>>();
        
        for(SObject sObj : listSobject) {
            String parentId = (String)sObj.get(keyFieldName);
            
            if(parentId == null) {
                continue;
            }
            
            if(!mapParentToRecords.containsKey(parentId)) {
                mapParentToRecords.put(parentId, new List<SObject>());
            }
            mapParentToRecords.get(parentId).add(sObj);
        }
        
        return mapParentToRecords;
    }
    
    private static void updateCaseEmailCountField(String caseIdStr){
        
        if(String.isNotEmpty(caseIdStr)){
            List<Case> caseList = [SELECT Id, Email_Count__c 
                                   FROM Case 
                                   Where Id =: caseIdStr];
            caseList[0].Email_Count__c = caseList[0].Email_Count__c != null ? (caseList[0].Email_Count__c + 1) :  1;
            
            if(!caseList.isEmpty()){
                Update caseList[0];
            }
        }
    }
    
    /*private static void deleteCase(string caseId){
        Case caseRecord =  [SELECT Id FROM Case WHERE id =: caseId];
        Delete caseRecord;
        System.debug('Delete successfully');
    } */
}