global class storeRollupSummaryAggregateBatchPY_Sch implements Schedulable{
    Date todayDate = Date.today();
    String pYear = String.valueOf(todayDate.addYears(-1).year());
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new storeRollupSummaryAggregateBatch(pYear));
    }
}