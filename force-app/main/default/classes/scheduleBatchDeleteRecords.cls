global class scheduleBatchDeleteRecords implements Schedulable {

   global void execute(SchedulableContext ctx) {
      DeleteRecords p = new DeleteRecords();
        database.executeBatch(p);
   }   
}