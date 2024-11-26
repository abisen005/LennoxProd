public class ExecutiveSummaryUtils {
    
    public static void CreateErrorTask(String errorMessage)
    {
        AggregateReportsSettings__c reportSettings = AggregateReportsSettings__c.getOrgDefaults(); 
        if(reportSettings != null && reportSettings.Task_User_Id__c != null)
        {
            Task theTask = new Task();
            theTask.OwnerId = reportSettings.Task_User_Id__c;
            theTask.Subject = 'Error While Running Batch Process for Summary Reports';
            theTask.Priority = 'High';
            theTask.Status = 'Not Started';
            theTask.Description = errorMessage;
            insert theTask;
        }
    }
}