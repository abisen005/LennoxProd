@isTest
public class ICSControllerTest {
    
    @testsetup
    public static void createTestDate(){
        
        Event e = new Event();
        e.StartDateTime = system.now();
        e.EndDateTime = system.now().adddays(1);
        e.Description = 'testing';
        e.IsAllDayEvent =  false;
        Insert e;
       
    }
    public static testmethod void deletePagetest(){
        Test.StartTest();
        
        Event e = [Select Id From Event Limit 1];
        DeleteEvtComp.deleteEvt(e.Id);
        
        Test.stopTest();
    }
    
    public static testmethod void deletePagetestNegative(){
        Test.StartTest();
        DeleteEvtComp.deleteEvt('e.Id');
        
        Test.stopTest();
    }
    
    public static testMethod void ICSTest() 
    {
        Test.StartTest(); 
        
        Event e = [Select Id From Event Limit 1];
        
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(e.Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(e);
        ICSController ics = new ICSController(sc);
        ics.updateEvent();
        AddToCalendarController.getEventRecord(String.valueOf(e.Id));
        AddToCalendarController.addtoCalendar(String.valueOf(e.Id));
        Test.StopTest();
        
    }
}