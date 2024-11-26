global class scheduleBatchArchiveCSTasks implements Schedulable {

   global void execute(SchedulableContext ctx) {
      ArchiveCSTasks p = new ArchiveCSTasks();
        database.executeBatch(p);
   }   
}