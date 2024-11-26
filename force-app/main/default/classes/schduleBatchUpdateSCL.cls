global class schduleBatchUpdateSCL implements Schedulable {

   global void execute(SchedulableContext ctx) {
      UpdateSCLClose p = new UpdateSCLClose();
        database.executeBatch(p);
   }   
}