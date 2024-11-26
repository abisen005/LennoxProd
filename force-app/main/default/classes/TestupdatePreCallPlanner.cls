@isTest
public class TestupdatePreCallPlanner  {
    
    static testmethod void test1() {
    Test.startTest();
    Account a = new Account();
        a.Name = 'test account';
        
        insert a;
        
        Profile p1 = [select id from profile where name='System Administrator'];

        User u = new User(alias = 'Tester', email='test11test@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p1.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test20170429@noemail.com');
        insert u;
        
        PreCallPlanner__c p = new PreCallPlanner__c();
        p.Dealer_Name__c=a.id;
        insert p ;
        
    Event e = new Event();
    e.WhatId = a.id;
    e.OwnerId = u.id;   
    e.StartDateTime  = system.now();
    e.Event_Type__c = 'Meeting';
    e.Event_Topic__c = 'Prospecting';
    e.EndDateTime = system.now();
    e.PreCallPlanner__c = p.id;
    e.Location = 'delhi';
    insert e;
    
    e.Location = 'Mumbai';
    update e;
    
    PreCallPlanner__c pcp = new PreCallPlanner__c();
        pcp.Event_Id__c = e.id;
        pcp.Meeting_Location__c = 'Mumbai';
        pcp.Meeting_Date_Time__c = system.now();
        pcp.Dealer_Name__c=a.id;
        upsert pcp ;
    
        Test.stopTest();
    }
    
}