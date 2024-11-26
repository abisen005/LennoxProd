public with sharing class SPEEDCheckviewv2{


        public ChecklistReports__c cl;
        public SPEED_Check_List__c sp;
        public list<ChecklistReports__c > reportList{get;set;}
        public list<ChecklistReports__c > showroomList{get;set;}
        public list<ChecklistReports__c > safetyList{get;set;}
        public list<ChecklistReports__c > discussionsList{get;set;}
        public Integer totalCount {get;set;}
        public Integer totalCount2 {get;set;}
        public Integer totalCount3 {get;set;}
        public Integer totalCount4 {get;set;}
        public String currentTabName;

        
        
          public SPEEDCheckviewv2(ApexPages.StandardController controller) {
                sp= (SPEED_Check_List__c) controller.getRecord();
                 
                 
      reportList = [Select Assessor_Action__c,AssessorAction__c,section__c, Audit__c, AuditCategory__c,status__c,URL__c, URL_name__c,report_comments__c,review__c, Additionalinformation__c,Business_Requirements__c,  PF__c,PassFailCriteria__c from ChecklistReports__c where SPEEDCheckList__c=:sp.id AND section__c='Reports'  ORDER BY audit__c asc];
         totalCount = reportList.size();
         
                          
      showroomList = [Select Assessor_Action__c,AssessorAction__c,section__c, Audit__c, AuditCategory__c,status__c,URL__c, URL_name__c,report_comments__c, review__c, Additionalinformation__c,Business_Requirements__c,  PF__c,PassFailCriteria__c from ChecklistReports__c where SPEEDCheckList__c=:sp.id AND section__c='Showroom'  ORDER BY audit__c asc];
         totalCount2 = showroomList.size();
         
                                   
      safetyList = [Select Assessor_Action__c,section__c, AssessorAction__c,Audit__c,AuditCategory__c, URL__c, URL_name__c,status__c, report_comments__c, review__c,Additionalinformation__c,Business_Requirements__c,  PF__c,PassFailCriteria__c from ChecklistReports__c where SPEEDCheckList__c=:sp.id AND section__c='Safety'  ORDER BY audit__c asc];
         totalCount3 = safetyList.size();
         
               discussionsList = [Select Assessor_Action__c,AssessorAction__c,section__c,  Audit__c,status__c,URL__c, URL_name__c,report_comments__c, review__c,AuditCategory__c,Additionalinformation__c,Business_Requirements__c,  PF__c,PassFailCriteria__c from ChecklistReports__c where SPEEDCheckList__c=:sp.id AND section__c='Discussions'  ORDER BY audit__c asc];
         totalCount4 = discussionsList.size();
                 
         }
         
  

         public PageReference save() {
              try{    
         upsert reportList;
         upsert showroomList;
         upsert discussionsList;
         upsert safetyList;
         PageReference pageRef = new PageReference('/'+ sp.id);
                pageRef.getParameters().put('id',sp.Id);
                return pageRef;
        }
        catch(Exception ex){
        ApexPages.addMessages(ex);
        }
        return null;
        }
        
        
        
        public String SelectedTab {
        
        get { return currentTabName; }}
        
        public String setActiveTab(){
        string para = Apexpages.currentpage().getparameters().get('tabname');
        System.debug('current tab is' + para);

        return selectedTab;
    }   
    
    public PageReference returntorecord() {
        

                //return (new ApexPages.StandardController(visit)).view();
                PageReference pageRef = new PageReference('/'+ sp.id);
                pageRef.getParameters().put('id',sp.Id);
                pageRef.setRedirect(true);
                return pageRef;
        }
  }