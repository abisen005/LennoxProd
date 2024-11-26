public with sharing class PrecallPlannerExtension {
    
    public Event evt {get;set;}
    public PreCallPlanner__c precallPlannerObj {get;set;}
    public Retention__c rt;
    public List<Retention__c> rtList; // Added by richa on 04,May
    public Account acc {get;set;}
    public Boolean showRetention {get;set;}
    public String eId {get;set;}
    public String defaultTemplateId {get;set;}
    
    public PrecallPlannerExtension(ApexPages.StandardController stdController) {
        showRetention = false;
        String accId = ApexPages.currentPage().getParameters().get('aid');
        eId = ApexPages.currentPage().getParameters().get('id');
        System.debug('accId: ' + accId);
        System.debug('eid: ' + eId);
        //Check for is this page is invoked from Action
        String isCallFromAction = ApexPages.currentPage().getParameters().get('isCallFromAction');
        
        if( String.isNotBlank(isCallFromAction) && isCallFromAction.equalsIgnoreCase('True')){
            //Get template Id from Custom setting
            OutboundPhoneCalltemplate__c OutboundPhoneCalltemplate = OutboundPhoneCalltemplate__c.getOrgDefaults();
            defaultTemplateId = OutboundPhoneCalltemplate.Template_Id__c;
        }
        
        if((eId == null || eId == '') && accId != null && accId != '')
        {
            List<Event> eventList = [SELECT WhoId,WhatId,Type, 
                                     Subject, StartDateTime, ReminderDateTime,
                                     RecurrenceType, RecurrenceTimeZoneSidKey,
                                     RecurrenceStartDateTime, RecurrenceMonthOfYear, 
                                     RecurrenceInterval, RecurrenceInstance, 
                                     RecurrenceEndDateOnly, RecurrenceDayOfWeekMask, 
                                     RecurrenceDayOfMonth, RecurrenceActivityId, 
                                     RecordTypeId, OwnerId, OriginalInstanceDateTime, Location,  IsReminderSet, IsRecurrence, IsPrivate, IsGroupEvent, 
                                     IsException, IsDeleted, IsClientManaged, 
                                     IsChild, IsArchived, IsAllDayEvent, Id, GroupEventType,PreCallPlanner__c,
                                     EventSubtype, EndDateTime, DurationInMinutes, Description, CreatedDate, CreatedById,
                                     ActivityDateTime, ActivityDate, AccountId, Event_Type__c FROM Event where AccountId = :accId ORDER BY CreatedDate DESC Limit 1];
            
            if(!eventList.isEmpty()){
                this.evt = eventList[0];
            } 
        }
        else if(eId != '' && eId != null)
        {
            //Changed by MB on 29 Mar 2018
            //this.evt = (Event)stdController.getRecord();
            
            List<Event> eventList =  [SELECT WhoId,WhatId, Type,  SystemModstamp, Subject, StartDateTime, ShowAs, 
                                      ReminderDateTime,  RecurrenceType, RecurrenceTimeZoneSidKey, RecurrenceStartDateTime, RecurrenceMonthOfYear,
                                      RecurrenceInterval, RecurrenceInstance, RecurrenceEndDateOnly, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
                                      RecurrenceActivityId, RecordTypeId,
                                      OwnerId, OriginalInstanceDateTime,
                                      Location, LastModifiedDate, LastModifiedById, IsReminderSet, IsRecurrence, IsPrivate, IsGroupEvent, IsException, IsDeleted, IsClientManaged, 
                                      IsChild, IsArchived, IsAllDayEvent, Id, GroupEventType,
                                      EventSubtype, EndDateTime, DurationInMinutes, Description, 
                                      CreatedDate, CreatedById, PreCallPlanner__c,
                                      ActivityDateTime, ActivityDate, AccountId, Event_Type__c FROM Event where Id = :eId ORDER BY CreatedDate DESC Limit 1];
            if(!eventList.isEmpty()){
                this.evt = eventList[0];
            } 
        }
        
        if(accId != null && accId != '')
        {
            //rt = [SELECT CRI_Score__c, E_Invoice__c, HVAC_LS_Part_Y_N__c, DaveNet_Range__c, Premier_Dealer_Type_Code__c, Product_Mix__c, CAP_Package__c, Spiffs__c, Rebates_Total__c, Marketing_Rolloff__c, Stocking__c, Mktg_Program_Benefit_Range__c, Mktg_Program_Benefit__c, DLPD__c FROM Retention__c WHERE Account__c =: accId LIMIT 1];
            // Added by richa on 04,May
            rtList = [SELECT CRI_Score__c, E_Invoice__c, HVAC_LS_Part_Y_N__c,
                      DaveNet_Range__c, Premier_Dealer_Type_Code__c, Product_Mix__c, 
                      CAP_Package__c, Spiffs__c, Rebates_Total__c, Marketing_Rolloff__c,
                      Stocking__c, Mktg_Program_Benefit_Range__c, Mktg_Program_Benefit__c,
                      DLPD__c FROM Retention__c WHERE Account__c =: accId LIMIT 1];
            system.debug('rtList!!!'+rtList);
            acc = [SELECT Name, SAP_Customer_Number__c, SAP_YTD_Sales__c, AccountNumber,
                   Prior_Year_YTD_Sales__c, Delta_YTD_Sales_Year_to_Year__c, Id from Account WHERE Id =: accId LIMIT 1];
            system.debug('acc@@@@@@@'+acc);
        }
        else
        {
            //rt = [SELECT CRI_Score__c, E_Invoice__c, HVAC_LS_Part_Y_N__c, DaveNet_Range__c, Premier_Dealer_Type_Code__c, Product_Mix__c, CAP_Package__c, Spiffs__c, Rebates_Total__c, Marketing_Rolloff__c, Stocking__c, Mktg_Program_Benefit_Range__c, Mktg_Program_Benefit__c, DLPD__c FROM Retention__c WHERE Account__c =: evt.WhatId LIMIT 1];
            // Added by richa on 04,May
            rtList = [SELECT CRI_Score__c, E_Invoice__c, HVAC_LS_Part_Y_N__c,
                      DaveNet_Range__c, Premier_Dealer_Type_Code__c, Product_Mix__c, CAP_Package__c, 
                      Spiffs__c, Rebates_Total__c, Marketing_Rolloff__c, Stocking__c,
                      Mktg_Program_Benefit_Range__c, Mktg_Program_Benefit__c, DLPD__c FROM Retention__c WHERE Account__c =: evt.WhatId LIMIT 1];
            system.debug('rtList!!!'+rtList);
            List<Account> acclist = [SELECT Name, SAP_Customer_Number__c, AccountNumber,
                                     SAP_YTD_Sales__c, Prior_Year_YTD_Sales__c, Delta_YTD_Sales_Year_to_Year__c, Id 
                                     FROM Account WHERE Id =: evt.WhatId LIMIT 1
                                    ];
            if( acclist <> null && !acclist.isEmpty() ){
                acc =  acclist[0];
            }
            system.debug('acc@@@@@@@'+acc);
        }
        // Added by richa on 04,May to get the Retention__c record
        
        if(rtList.size()>0){
            rt = rtList.get(0);
            showRetention = true;
        }
        
        precallPlannerObj = getPrecallPlannerObj();
        system.debug('precallPlannerObj!!!'+precallPlannerObj);
    }
    
    
    public PreCallPlanner__c getPrecallPlannerObj()
    {
        Id evtId = (Id)evt.get('Id'); //this might be null new events
        System.debug('evtId:::'+ evtId);
        // Added by richa on 4th May to check if Retention__c exists
        Id rtid = null;
        if(rt != null)
        {
            rtid = rt.id;
        }
        //try and find the precall planner obj
        //if it exists, return It
        //if it doesn't, create a new instance of the precall planner obj and return that
        PreCallPlanner__c[] precallPlanner;
        if(evtId != null)
        {
            System.debug('evtId--' + evtId);
            
            String evtIdSubstr = String.valueOf(evtId).substring(0, 15);
            precallPlanner = [SELECT Id, Implication_Questions__c, Key_Dealer_Participants__c,Key_Lennox_Participants__c,
                              Key_Reference_Insights__c, Meeting_Agenda__c, Need_Payoff_Questions__c, Next_Steps__c,
                              Objections_to_Primary_Objective__c, Objections_to_Secondary_Objective__c,   Problem_Questions__c,
                              Response_to_Primary_Objections__c, Response_to_Secondary_Objections__c, Situation_Questions__c,
                              Supporting_Insight_Materials__c,CAP_Package__c,CRI_Score__c,Customer_Number__c,DaveNet_R12_Range__c,
                              Dealer_Name__c,DLPD__c,E_Invoice__c,HVAC_LS_Participation__c,Marketing_Benefit_Range__c,Marketing_Program_Benefits__c,
                              Primary_Objective__c,Marketing_Rolloff__c,Meeting_Date_Time__c,Meeting_Length__c,Meeting_Location__c,Premier_Dealer_FP_FS__c,
                              Secondary_Objective__c,Prior_Year_YTD_Sales__c,Product_Profile__c,Rebates__c,Retention__c,
                              Spiffs__c,Stocking__c,YTD_Sales__c,YTD_Sales_Delta__c, hasBeenTemplatePrompted__c, Pre_Call_Planner_Scenario__c, 
                              Pre_Call_Planner_Scenario__r.Name 
                              FROM PreCallPlanner__c
                              WHERE Event_Id__c = :evtId OR Event_Id__c = :evtIdSubstr];
        }
        System.debug('precallPlanner--' + precallPlanner);
        
        if(!precallPlanner.isEmpty())
        {
            return precallPlanner[0];
        }
        else
        {
            System.debug('In else--' + evtId);
            return new PreCallPlanner__c( Dealer_Name__c = ( acc <> null && acc.id <> null ? acc.id : null), Retention__c = rtid,Event_Id__c = evtId,
                                         Meeting_Date_Time__c = evt.StartDateTime, Meeting_Location__c = evt.Location,
                                         Meeting_Length__c = evt.DurationInMinutes, Implication_Questions__c = '', 
                                         Key_Dealer_Participants__c = '',Key_Lennox_Participants__c = '',
                                         Key_Reference_Insights__c = '', Meeting_Agenda__c = '', Need_Payoff_Questions__c = '', Next_Steps__c = '',
                                         Objections_to_Primary_Objective__c = '', Objections_to_Secondary_Objective__c = '', Problem_Questions__c = '',
                                         Response_to_Primary_Objections__c = '', Response_to_Secondary_Objections__c = '', Situation_Questions__c = '',
                                         Supporting_Insight_Materials__c = '');
        }
    }
    
    
    public PageReference saveAndReturnToEvt() {
        saveChanges();
        
        PageReference pg = new PageReference('/'+evt.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference saveAndRefresh() {
        saveChanges();
        
        PageReference pg = Page.TMPreCallPlanner;
        pg.getParameters().put('id', eId);
        pg.getParameters().put('autoShowGeneratePdf', 'true');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference saveAndRefreshOutboundPhoneCall() {
        saveChanges();
        
        PageReference pg = Page.OutboundPhoneCallrequest;
        pg.getParameters().put('id', eId);
        pg.getParameters().put('autoShowGeneratePdf', 'true');
        pg.setRedirect(true);
        return pg;
    }
    
    public void saveChanges() {
        precallPlannerObj.Dealer_Name__c = acc.id;
        //null check added by richa on 4th,May
        if(rt != null){
            precallPlannerObj.Retention__c = rt.id;
        }
        
        precallPlannerObj.Meeting_Date_Time__c = evt.StartDateTime;
        precallPlannerObj.Meeting_Location__c = evt.Location;
        precallPlannerObj.Meeting_Length__c = evt.DurationInMinutes;
        upsert precallPlannerObj;
        
        evt.PreCallPlanner__c = precallPlannerObj.Id;
        upsert evt;
    }
    
    
}