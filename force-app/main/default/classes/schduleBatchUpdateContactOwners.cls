global class schduleBatchUpdateContactOwners implements Schedulable {

   global void execute(SchedulableContext ctx) {
      UpdateContactOwners p = new UpdateContactOwners();
        database.executeBatch(p);
   }   
}