@isTest
public class FTL_ProgramTaskControllerTest {

   	@isTest
    public static void test(){
        List<FTL_Task__mdt> ftlTaskList = FTL_ProgramTaskController.getFTLTasks();
        System.assertNotEquals(null, ftlTaskList);
    }
}