public with sharing class TMDMConsoleControllerV2 {

    //Same getAccount(...) from old TMDMConsoleController
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        List<Retention__c> CurrentYearRetentionRecords = new List<Retention__c>();
        CurrentYearRetentionRecords = [ SELECT Id, Retention_Calendar_Date__c 
                                        FROM Retention__c 
                                        WHERE Account__c = :accountId AND Retention_Calendar_Date__c = THIS_YEAR LIMIT 1];
        
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
                       (SELECT Id, Name, Account__c, Scorecard_Stage__c, Initial_Grade__c, Scorecard_Grade__c, Calculated_Total_Dealer_Revenue__c, Total_Number_of_Employees__c, Calculated_Annual_HVAC_Purchases__c, Total_Number_of_Retail_Sales_People__c FROM Scorecards__r LIMIT 1),
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
        
    /*
    @AuraEnabled
    public static Account getAccount(Id accountId) {

        System.debug(accountId);

        String currentYear = String.valueOf(System.Today().year() );
        String prevYear = String.valueOf(System.Today().year() - 1);
        Account acc = [SELECT Name, Id, SAP_Sales_Group__c, Segmentation__c, Forecast_Last_Modified_Date__c, Current_Year_Sales_Forecast__c, SAP_YTD_Sales__c, 
                       Delta_YTD_Sales_Year_to_Year__c, SAP_Customer_Group_Id__c, Risk_Grade__c, Escalation_Code__c, Qualifies_for_NC_Program__c, NC_Commitment__c, 
                       Submit_for_NC_Program__c, NC_Load_Date__c, Parts_YTD_Sales_of_Total_YTD_Sales__c, LastModifiedDate, ShippingStreet, ShippingCity,
                       ShippingState, ShippingPostalCode, Prior_Year_YTD_Sales__c, Lowe_s_Dealer__c, Costco_Dealer__c,
                       (SELECT Id FROM Conversion__r WHERE Conversion_Status__c != 'Completed'),
                       (SELECT Id FROM Scorecards__r LIMIT 1),
                       (SELECT Id, Account_Plan_Year__c FROM Account_Plans__r where Account_Plan_Year__c= :currentYear OR Account_Plan_Year__c=:prevYear  ORDER BY Account_Plan_Year__c DESC LIMIT 2),
                       (SELECT Id, Retention_Calendar_Date__c FROM Retention__r ORDER BY Retention_Calendar_Date__c DESC LIMIT 1),
                       (SELECT Id, Retention_Calendar_Date__c FROM Retention_Historys__r WHERE Retention_Calendar_Year__c = :prevYear ORDER BY Retention_Calendar_Date__c DESC LIMIT 1),
                       (SELECT Id FROM Retail_Sales_Tracker__r LIMIT 1)
                       FROM Account 
                       WHERE Id = :accountId 
                       LIMIT 1];
 


        if(acc != NULL) {
            return acc;
        } else {
            return NULL;
        }
    } 
    */   
    
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
        Account_Planning__c[] ap = [SELECT Id, Name ,Account_Plan_Year__c
                                  FROM Account_Planning__c 
                                  WHERE Dealer__c = :accountId AND Account_Plan_Year__c = :currentYear ];
        System.debug('dws : ' + ap);
        if(ap.isEmpty()) return null;
        return ap[0];
    }
    
    @AuraEnabled
    public static User getCurrentUserInfo(){
        User user = [SELECT Id, Profile.Name
                     FROM User
                     WHERE Id = :UserInfo.getUserId()];
        
        return user;
    }
    
    @AuraEnabled
    public static List<Retention_Opportunity__c> getOpenRetentionOpportunities(String accountPlanId) {
        return [SELECT Name, Id, Dealer_Account_Plan__c, Retention_Opportunity_Type__c, Retention_Opportunity__c, Retention_Opportunity_Notes__c, Potential_CRI_Points__c 
                FROM Retention_Opportunity__c 
                WHERE Dealer_Account_Plan__c = :accountPlanId AND 
                    (Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'In Progress')];
    }
    
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
                          WHERE WhatId = :accountId AND Sales_Activities__c = TRUE 
                          ORDER BY StartDateTime DESC LIMIT 1];
        return events.isEmpty() ? null : events[0];
    }
    
    @AuraEnabled
    public static MetricDetail getRetentionHistoryData(Id accountId) {
        MetricDetail retentionData = new MetricDetail();
        Retention__c latestRetention;
        
        try{
            latestRetention = [SELECT CRI_Score__c, Retention_Calendar_Date__c 
                               FROM Retention__c 
                               WHERE Account__c = :accountId 
                               ORDER BY Retention_Calendar_Date__c DESC 
                               LIMIT 1];
        }catch(Exception e){
            System.debug(e.getLineNumber() + ' ' + e.getMessage());
        }
        Retention_History__c pyRetention;
        if(latestRetention != NULL && latestRetention.Retention_Calendar_Date__c != null) {
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
        
        // if event record type is 'Phone Call - Outbound' then assign 'Outbound Phone Call' record type else default
        if(newEvt.Event_Type__c == 'Phone Call - Outbound'){
            newEvt.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get(Label.Event_s_Outbound_Phone_Call_RT_Name).getRecordTypeId();
        }
        
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
        List<Account_Planning__c> accPlanList = [SELECT Id, Name,Account_Plan_Year__c, (SELECT Id, Name FROM Account_Opportunities__r) 
                                                 FROM Account_Planning__c 
                                                 WHERE Account_Plan_Year__c = :currentYear 
                                                 LIMIT 1];
        if(accPlanList.isEmpty()){
            return null;
        }else{
            return accPlanList[0];
        }
        
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

    @AuraEnabled
    public static Response getProfileData() {

        try {

            Map<String, Object> responseMap = new Map<String, Object>();

            String profileName = [
                SELECT Id, Name 
                FROM Profile 
                WHERE Id = :UserInfo.getProfileId() 
                LIMIT 1
            ].Name;
            responseMap.put('currentProfile', profileName);

            List<Profile_For_TMDM__mdt> profileForTmdmList = [
                SELECT Id, Label, Profile_Name__c
                FROM Profile_For_TMDM__mdt
            ];
            responseMap.put('profileForTmdmList', profileForTmdmList);

            return new Response(responseMap, true, null);
        } catch (Exception e) {

            return new Response(null, false, getExceptionString(e));
        }
    }

    private static String getExceptionString(Exception e) {

        return e.getLineNumber()
            + ' | '
            + e.getMessage();
    }
    
    public class MetricDetail {
        @AuraEnabled
        public String primaryValue;
        @AuraEnabled
        public String secondaryValue;
    }

    public class Response {

        @AuraEnabled
        public Object data;

        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String message;

        public Response(Object data, Boolean isSuccess, String message) {

            this.data = data;
            this.isSuccess = isSuccess;
            this.message = message;
        }
    }
}