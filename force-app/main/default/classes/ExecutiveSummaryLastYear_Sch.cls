global class ExecutiveSummaryLastYear_Sch implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        String year = String.valueOf(Date.today().year() - 1);
        //Database.executeBatch(new ExecutiveSummaryBatchLastYear(),1);
        Database.executeBatch(new ExecutiveSummaryBatchStateful(year),1);
    }
}