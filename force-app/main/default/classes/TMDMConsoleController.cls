public with sharing class TMDMConsoleController {
    
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        List<Retention__c> CurrentYearRetentionRecords = new List<Retention__c>();
        CurrentYearRetentionRecords = [ SELECT Id, Retention_Calendar_Date__c 
                                        FROM Retention__c 
                                        WHERE Account__c = :accountId AND Retention_Calendar_Date__c = THIS_YEAR ];
        
        String currentYear = String.valueOf(System.Today().year() ); 
        String prevYear = String.valueOf(System.Today().year() - 1);
        
        String accPlanCurrentYear = currentYear; 
        String accPlanPrevYear = prevYear;
        
        
        if(CurrentYearRetentionRecords.isEmpty()){
            currentYear = String.valueOf(System.Today().year() - 1);
            prevYear = String.valueOf(System.Today().year() - 2);
        }
        
        
        Account acc = [SELECT Name, Id, SAP_Sales_Group__c, Segmentation__c, Forecast_Last_Modified_Date__c, Current_Year_Sales_Forecast__c, SAP_YTD_Sales__c, 
                       Delta_YTD_Sales_Year_to_Year__c, SAP_Customer_Group_Id__c, Risk_Grade__c, Escalation_Code__c, Qualifies_for_NC_Program__c, NC_Commitment__c, 
                       Submit_for_NC_Program__c, NC_Load_Date__c, Parts_YTD_Sales_of_Total_YTD_Sales__c, LastModifiedDate, ShippingStreet, ShippingCity,
                       ShippingState, ShippingPostalCode, Prior_Year_YTD_Sales__c, Lowe_s_Dealer__c, Costco_Dealer__c,
                       (SELECT Id FROM Conversion__r WHERE Conversion_Status__c != 'Completed'),
                       (SELECT Id FROM Scorecards__r LIMIT 1),
                       (SELECT Id, Account_Plan_Year__c FROM Account_Plans__r where Account_Plan_Year__c= :accPlanCurrentYear OR Account_Plan_Year__c=:accPlanPrevYear  ORDER BY Account_Plan_Year__c DESC LIMIT 2),
                       (SELECT Id, Retention_Calendar_Date__c FROM Retention__r ORDER BY Retention_Calendar_Date__c DESC LIMIT 1),
                       (SELECT Id, Retention_Calendar_Date__c FROM Retention_Historys__r WHERE Retention_Calendar_Year__c = :prevYear ORDER BY Retention_Calendar_Date__c DESC LIMIT 1),
                       (SELECT Id FROM Retail_Sales_Tracker__r LIMIT 1)
                       FROM Account 
                       WHERE Id = :accountId 
                       LIMIT 1];
     
        if(acc != NULL) {
            //acc.Account_Plans__r = accountPlans;
            return acc;
        } else {
            return NULL;
        }
    }
    
    
    @AuraEnabled
    public static List<Contact> getAccountContacts(String accountId) {
        return [SELECT Name, Phone 
                FROM Contact 
                WHERE AccountId = :accountId 
                ORDER BY LastModifiedDate DESC
                LIMIT 100];
    }
    
    
    @AuraEnabled
    public static Account_Planning__c getCurrentAccountPlan(String accountId) {
        String currentYear = String.valueOf(System.Today().year());
        Account_Planning__c[] ap = [SELECT Id, Name 
                                  FROM Account_Planning__c 
                                  WHERE Dealer__c = :accountId AND Account_Plan_Year__c = :currentYear ];
        if(ap.isEmpty()) return null;
        return ap[0];
    }
    
    
    @AuraEnabled
    public static List<Retention_Opportunity__c> getOpenRetentionOpportunities(String accountPlanId) {
        return [SELECT Name, Id, Dealer_Account_Plan__c, Retention_Opportunity_Type__c, Retention_Opportunity__c, Retention_Opportunity_Notes__c, Potential_CRI_Points__c 
                FROM Retention_Opportunity__c 
                WHERE Dealer_Account_Plan__c = :accountPlanId AND 
                    (Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'In Progress')];
    }
    
    /*@AuraEnabled
    public static List<Account_Opportunty__c> getAccountOppsAndActionPlans(String accountPlanId) {
        return [SELECT Name, Id, (SELECT Name, Id, Action__c, Action_Type__c FROM Action_Plans__r WHERE Action_Status__c = 'Not Started' OR Action_Status__c = 'In Progress') 
                FROM Account_Opportunty__c
                WHERE Dealer_Account_Plan__c =: accountPlanId AND (Opportunity_Status__c = 'Not Started' OR Opportunity_Status__c = 'In Progress')];
    }*/
    
    @AuraEnabled
    public static List<Action_Plan__c> getActionPlans(String accountPlanId) {
        return [SELECT Name, Id, Action__c, Action_Type__c 
                FROM Action_Plan__c 
                WHERE Account_Plan__c =: accountPlanId AND Action_Status__c IN ('Not Started','In Progress')];
    }
    
    @AuraEnabled 
    public static List<Account_Opportunty__c> getAccountOpps(String accountPlanId) {
        return [SELECT Name, Id, Opportunity_Type__c, Opportunity_Status__c
                FROM Account_Opportunty__c
                WHERE Dealer_Account_Plan__c =: accountPlanId AND Opportunity_Status__c IN ('Not Started','In Progress')];
    }

    @AuraEnabled
    public static Event getLatestMeeting(Id accountId) {
        Event[] events = [SELECT StartDateTime, Id 
                          FROM Event 
                          WHERE WhatId = :accountId AND (Event_Type__c = 'Meeting' OR Event_Type__c = 'Training' OR Event_Type__c = 'Retail Outlet Review') 
                          ORDER BY StartDateTime DESC LIMIT 1];
        return events.isEmpty() ? null : events[0];
    }
    
    @AuraEnabled
    public static MetricDetail getRetentionHistoryData(Id accountId) {
        System.debug('Account Id:' +accountId);
        MetricDetail retentionData = new MetricDetail();
        Retention__c latestRetention;
        List<Retention__c> latestRetentions = [SELECT CRI_Score__c, Retention_Calendar_Date__c 
                                               FROM Retention__c 
                                               WHERE Account__c = :accountId 
                                               ORDER BY Retention_Calendar_Date__c DESC];
        if(!latestRetentions.isEmpty()){
            latestRetention = latestRetentions[0];
        }
        Retention_History__c pyRetention;
        if(latestRetention != NULL) {
            retentionData.primaryValue = String.valueOf(latestRetention.CRI_Score__c);
            Date priorYear = latestRetention.Retention_Calendar_Date__c.addYears(-1);
            try {
                pyRetention = [SELECT CRI_Score__c
                               FROM Retention_History__c 
                               WHERE Dealer_Name__c = :accountId AND Retention_Calendar_Date__c >= :priorYear AND Retention_Calendar_Date__c <= :priorYear 
                               Limit 1];
                if(pyRetention != NULL) {
                    retentionData.secondaryValue = String.valueOf(pyRetention.CRI_Score__c);
                }
            } catch(QueryException e) {
                System.debug(e.getMessage());
                retentionData.secondaryValue = null;
                return retentionData;
            }
            
        }
        System.debug(retentionData);
        return retentionData;
    }
    
    @AuraEnabled
    public static Event newEvent(String evt) {
        Event newEvt = (Event)JSON.deserialize(evt, Event.class);
        insert newEvt;
        return newEvt;
    }
    
    @AuraEnabled
    public static Event getNewEvent(Id accountId) {
        Event evt = new Event();
        evt.WhatId = accountId;
        return evt;
    }
    
    @AuraEnabled
    public static Map<string, List<string>> getpicklistValues() {
        //List<String> eventTopicList = new List<String>();
        Map<String,string> sobjectoptionsMap = new Map<String,string>();
        sobjectoptionsMap.put('Event_Topic__c','Custom_Event_Configurtion__mdt');
        sobjectoptionsMap.put('Event_Type__c','Custom_Event_Configurtion__mdt');
        //eventTopicList = getPicklistValues('Custom_Event_Configurtion__mdt', 'Event_Topic__c');
        List<string> options;
        Map<string, List<string>> optionsMap = new Map<string,List<string>>();
        
        try{
            for(String field_name : sobjectoptionsMap.keySet()){
                options = new List<string>();
                String objectName = sobjectoptionsMap.get(field_name);
                Schema.SObjectType sobject_type = Schema.getGlobalDescribe().get(objectName);
                Schema.DescribeSObjectResult descResult = sobject_type.getDescribe();
                Map<String, Schema.SObjectField> field_map = descResult.fields.getMap(); 
                List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); 
                List<selectOption> optionsList = new List<selectOption>();
                for (Schema.PicklistEntry picklistEntryRecord : pick_list_values) {                 
                    options.add(picklistEntryRecord.getValue());
                }
                optionsMap.put(field_name, options);
            }
        }catch (Exception e) {
            
            System.debug('The following exception has occurred' + e.getMessage());
            return null;
        }    
        system.debug('optionsMap '+optionsMap);
        return optionsMap;
    }
    
    /*private static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        return lstPickvals;
    }*/
    
    @AuraEnabled
    public static Account getYTDSalesData(Id accountId) {
        Account acc = [SELECT SAP_YTD_Sales__c, Delta_YTD_Sales_Year_to_Year__c FROM Account WHERE Id = :accountId LIMIT 1];
        if(acc != NULL) {
            return acc;
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static Account_Planning__c getAccountPlanAndAccountOpps(Id accountId) {
        String currentYear = String.valueOf(System.Today().year());
        Account_Planning__c accPlan = [SELECT Id, Name, (SELECT Id, Name FROM Account_Opportunities__r) 
                                       FROM Account_Planning__c 
                                       WHERE Account_Plan_Year__c = :currentYear 
                                       LIMIT 1];
        return accPlan;
    }
    
    
    @AuraEnabled
    public static Scorecard__c getOpportunityScorecard(Id accountId) {
        Scorecard__c[] scorecard = [SELECT Id, Adjusted_LNX_prods_purch_growth_opportun__c, Last_Changed_Date__c, Scorecard_Grade__c, Percent_of_Purchases_that_are_Lennox__c,  Account__r.Name, Account__r.Id
                                  FROM Scorecard__c 
                                  WHERE Account__c = :accountId 
                                  LIMIT 1];
        if(!scorecard.isEmpty()) {
            return scorecard[0];
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static Account upsertAccount(Account acc) {
        System.debug('acc: ' + acc);
        upsert acc;
        return acc;
    }
    
    public class MetricDetail {
        @AuraEnabled
        public String primaryValue;
        @AuraEnabled
        public String secondaryValue;
    }
    
    
    
}