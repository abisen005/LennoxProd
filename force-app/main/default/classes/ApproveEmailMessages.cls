public class ApproveEmailMessages implements Schedulable{
    public ApproveEmailMessages(Datetime currentTime) {
        
    }
    
    public void execute(SchedulableContext schedularContext) {
        Database.executeBatch(new ApproveEmailMessagesBatch());
        /*
        System.abortJob(schedularContext.getTriggerId());
        Datetime sysTime = System.now();
        sysTime = sysTime.addHours(1);
        String chron_exp = ' ' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + 
            ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('Approve Records', chron_exp, new ApproveEmailMessages(System.now()));*/
    }
}