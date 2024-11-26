public with sharing class HighPriorityAlertsController2
{
    @AuraEnabled public Wrapper wrap{get;set;}
    public HighPriorityAlertsController2()
    {}
    
    @AuraEnabled 
    public Static List<Wrapper> getHighPriorityList()
    {
        Integer rowCount;
        Map<String, String> mapActionType = new Map<String, String>();
        
        List<Alert_Management__c> alertMgmtList = [SELECT Name, Action_Type__c, Event_Type__c, Event_Topic__c FROM Alert_Management__c where Is_Active__c=true];
        Set<String> alertTypeIdSet = new Set<String>();
        HomePageLimits__c limitCS = HomePageLimits__c.getInstance('HighPriorityAlertsLimit');
        Integer HPALimit = (Integer)limitCS.Limit__c;
        if(HPALimit == null)
            HPALimit = 5;
        String key;
        
        for(Alert_Management__c a: alertMgmtList)
        {
            key = a.Name;
            alertTypeIdSet.add(key);
            mapActionType.put(key, a.Action_Type__c);
            
        }
        
        String ownerId = UserInfo.getUserId();
        
        List<Task> taskList = [select Type, What.Name, Subject, Record_To_Navigate_to__c, WhatId, Id, ActivityDate, STATUS, PRIORITY, Task_Type__c, Task_Topic__c, Description, Alert_Type_Id__c from Task where Status != 'Completed' and Status != 'Closed by Admin' and Status != 'Closed' and Alert_Type_Id__c in :alertTypeIdSet AND OwnerId=:ownerId ORDER BY ACTIVITYDATE LIMIT :HPALimit];
        rowCount = 0;
        List<Wrapper> wrapList = new List<Wrapper>();
        for(Task t : taskList)
        {
            Wrapper w = new Wrapper();
            w.tsk = t;
            w.rowIndex = rowCount++;
            key = t.Alert_Type_Id__c;
            if(mapActionType.containsKey(key))
                w.actionType = mapActionType.get(key);
            else
                w.actionType = 'Auto-Complete';
            wrapList.add(w);
        }
        
        System.debug('wrapList:::'+wrapList);
        System.debug('wraplist size:::'+wrapList.size());
        
        return wraplist;
    }
    
    @AuraEnabled
    public Static Wrapper showPopup(integer rIndex) {
        List<Wrapper> wrapList = HighPriorityAlertsController2.getHighPriorityList();
        System.debug('rIndex:::'+rIndex);
        System.debug('wrapList:::'+wrapList);
        //System.debug('ind:::'+wrapList.get(rIndex));
        Wrapper currentWrapper = wrapList.get(rIndex);
        System.debug('currentWrapper'+currentWrapper);
        return currentWrapper;
    }
    
    
    public class Wrapper
    {
        @AuraEnabled public Task tsk {get;set;}
        @AuraEnabled public Integer rowIndex {get;set;}
        @AuraEnabled public String actionType {get;set;}
    }
    
    @AuraEnabled
    public static String autoCompleteT(integer rIndex)
    {
        String pageURL = '';
        List<Wrapper> actToComplete = new List<Wrapper>();
        List<Wrapper> wrapList = HighPriorityAlertsController2.getHighPriorityList();
        Wrapper currentWrapper = wrapList.get(rIndex);
        
        for(integer i = 0; i < wrapList.size(); i++)
        {
            Wrapper w = wrapList.get(i);
            if(w.rowIndex == rIndex)
            {
                actToComplete.add(wrapList.get(i));
                wrapList.remove(i);
                break;
            }
            
        }
        List<Task> taskToComplete = new List<Task>();
        Task t;
        for(Wrapper w : actToComplete)
        {
            t = w.tsk;
            t.Status = 'Completed';
            taskToComplete.add(t); 
            //currentTask = w.tsk;
        }
        
        if(taskToComplete.size() >0)
            update taskToComplete;
        
        pageURL = '';
        return pageURL;
    }
    
    @AuraEnabled
    public static String createEventT(integer rIndex)
    {
        String evtTopic = 'Dummy';
        String evtType = 'Dummy';
        String pageURL = '';
        Map<String, String> mapEventType = new Map<String, String>();
        Map<String, String> mapEventTopic = new Map<String, String>();
        List<Wrapper> actToComplete = new List<Wrapper>();
        List<Wrapper> wrapList = HighPriorityAlertsController2.getHighPriorityList();
        Wrapper currentWrapper = wrapList.get(rIndex);
        
        for(Alert_Management__c a: [SELECT Name, Action_Type__c, Event_Type__c, Event_Topic__c FROM Alert_Management__c where Is_Active__c=true])
        {
            String key = a.Name;
            if(a.Action_Type__c == 'New Event')
            {
                mapEventType.put(key,a.Event_Type__c);
                mapEventTopic.put(key,a.Event_Topic__c);
            }
        }
        for(integer i = 0; i < wrapList.size(); i++)
        {
            Wrapper w = wrapList.get(i);
            if(w.rowIndex == rIndex)
            {
                actToComplete.add(wrapList.get(i));
                wrapList.remove(i);
                break;
            }
            
        }
        List<Task> taskToComplete = new List<Task>();
        Task t;
        for(Wrapper w : actToComplete)
        {
            t = w.tsk;
            t.Status = 'Completed';
            taskToComplete.add(t); 
        }
        String key = t.Alert_Type_Id__c;
        if(mapEventType.containsKey(key))
            evtType = mapEventType.get(key);
        if(mapEventTopic.containsKey(key))
            evtTopic = mapEventTopic.get(key);
        
        if(taskToComplete.size() >0)
            update taskToComplete;
        
        
        if(t!=null)
        {
            String objType;
            if(t.WhatId != null)
                objType = String.valueOf(currentWrapper.tsk.WhatId).substring(0,3);
            else if(t.WhoId != null)
                objType = String.valueOf(currentWrapper.tsk.WhoId).substring(0,3);
            Event e = new Event();
            e.OwnerId = UserInfo.getUserId();
            e.WhatId = currentWrapper.tsk.WhatId;
            e.Event_Topic__c = evtTopic;
            e.Event_Type__c = evtType;
            e.StartDateTime = System.now();
            e.EndDateTime = System.now().addHours(1);
            insert e;
            
            pageURL = '/'+e.Id+'/e?retUrl=/'+e.Id;
        }
        System.debug('pageURL:::Create Event'+pageURL);
        return pageURL;
    }
    
    @AuraEnabled
    public static String navigateToRecordT(integer rIndex)
    {
        String pageURL = '';
        List<Wrapper> actToComplete = new List<Wrapper>();
        List<Wrapper> wrapList = HighPriorityAlertsController2.getHighPriorityList();
        Wrapper currentWrapper = wrapList.get(rIndex);
        for(integer i = 0; i < wrapList.size(); i++)
        {
            Wrapper w = wrapList.get(i);
            if(w.rowIndex == rIndex)
            {
                actToComplete.add(wrapList.get(i));
                wrapList.remove(i);
                break;
            }
            
        }
        List<Task> taskToComplete = new List<Task>();
        Task t;
        for(Wrapper w : actToComplete)
        {
            t = w.tsk;
            t.Status = 'Completed';
            taskToComplete.add(t); 
        }
        
        if(taskToComplete.size() >0)
            update taskToComplete;
        
        if(t!=null)
        {   
            if(t.Record_To_Navigate_to__c != null && t.Record_To_Navigate_to__c != '')
            { 
                pageURL = '/'+t.Record_To_Navigate_to__c;  
            }
            else
            {
                pageURL = 'Record to navigate is not properly specified. Please contact your system administrator for help.';
            }
        }
        System.debug('pageURL:::Navigate To Rec'+pageURL);
        return pageURL;
    }
    
}