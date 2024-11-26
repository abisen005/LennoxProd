/*
* @ Purpose      : Handler for Task Trigger              
* @ CreatedDate  : 09-04-2019
*/
public class Task_Trigger_Handler {
    
    public static void beforeUpdate(List<Task> currentTaskList){
        
        //get current profile of user
        User user = [SELECT Id, Profile.UserLicense.Name FROM User WHERE Id=: UserInfo.getUserId()];
        String userLicenseName = user.Profile.UserLicense.Name;
        

        //execute only if userProfile is community user
        if(userLicenseName.equalsIgnoreCase(Label.Community_User_Licence_Name)) {
        
            //List of Steps and number
            List<Task_Step__mdt> stepToNumberList = [SELECT MasterLabel, Step_number__c FROM Task_Step__mdt];
            
            //map of step number ot step name
            Map<Integer,String> stepNumbertoStapeName = new Map<Integer,String>();
            
            //map of step name to step number
            Map<String,Integer> stepNametoStapeNumber = new Map<String,Integer>();
            
            for(Task_Step__mdt step : stepToNumberList){
                stepNumbertoStapeName.put(Integer.valueof(step.Step_number__c), step.MasterLabel);
                stepNametoStapeNumber.put(step.MasterLabel,Integer.valueof(step.Step_number__c));
            }
            
            //set of currentTaskList related account id
            set<Id> accountIds = new set<Id>();
            for(Task task : currentTaskList){
                accountIds.add(task.accountID);
            }
        
            Map<Id,List<Task>> accountIdToTaskListMap = new Map<Id,List<Task>>();
            Map<Id,Task> taskToIdListMap = new Map<Id,Task>();
            
            for(Task task:[SELECT Id, subject, status, AccountId FROM Task WHERE AccountId IN :accountIds]){
                taskToIdListMap.put(task.Id,task);
                if(!accountIdToTaskListMap.containsKey(task.AccountId)){
                    
                    accountIdToTaskListMap.put(task.AccountId, new List<Task>());
                }
                    accountIdToTaskListMap.get(task.AccountId).add(task);
                
            }
            //current task prefix
			String stepPrefirx = String.getCommonPrefix(stepNumbertoStapeName.values());
            //length of step name
            Integer stepPrefirxLength = stepNumbertoStapeName.get(1).length();
            
            for(Task currentTask: currentTaskList){
                		
                if(currentTask.Subject.contains(stepPrefirx)){
                    //current task step name
                	String currentSubjectPrefix = currentTask.Subject.substring(currentTask.Subject.indexOf(stepPrefirx),stepPrefirxLength);
   					//previous task step name
                	String previousSubjectPrefix = stepNumbertoStapeName.get(stepNametoStapeNumber.get(currentSubjectPrefix)-1);
                        
                    if(previousSubjectPrefix!=null){
                        //get id of previous task
                        ID previousTaskId = getPreviousTaskId(accountIdToTaskListMap.get(currentTask.AccountId),previousSubjectPrefix);
                        if(previousTaskId!=null){
                            if(!taskToIdListMap.get(previousTaskId).status.equalsIgnoreCase('Completed')){
                            	currentTask.addError('Previous Task must be marked complete');
                            }
                        }
                        else
                            currentTask.addError('Previous Step, '+previousSubjectPrefix+' is not available');
                    }
                }     		
            }
        }     
    }
    
    //method to return id of previous step
    public static Id getPreviousTaskId(List<Task> taskToIdList,String previousTaskSubject){
        
        Id previousTaskId;
        for(Task previousTask:taskToIdList){
            
            if(previousTask.Subject.contains(previousTaskSubject)){
                previousTaskId = previousTask.Id;
            }
        }
        return previousTaskId;
    }
}