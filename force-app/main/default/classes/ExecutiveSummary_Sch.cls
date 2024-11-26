global class ExecutiveSummary_Sch implements Schedulable {   
    global void execute(SchedulableContext ctx)
    {
        Database.executeBatch(new ExecutiveSummaryBatchStateful(),1);
    }
}