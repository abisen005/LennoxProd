public class FTL_ProgramTaskController {
    @AuraEnabled
    public static List<FTL_Task__mdt> getFTLTasks(){
        List<FTL_Task__mdt> ftlTasks = new List<FTL_Task__mdt>();
        Date currentDate = System.today();
        try{
            ftlTasks = [SELECT Start_Date__c,End_Date__c,Subject__c,Program_End_Date__c,Comments__c 
                        FROM FTL_Task__mdt];
        }catch(Exception ex){
            System.debug('Error ::'+ex.getMessage());
        }
        
        return ftlTasks;
    }
}