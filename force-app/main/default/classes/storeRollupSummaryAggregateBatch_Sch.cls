global class storeRollupSummaryAggregateBatch_Sch  implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        Database.executeBatch(new storeRollupSummaryAggregateBatch());
    }
}