global class schduleBatchUpdateContacts implements Schedulable {

   global void execute(SchedulableContext ctx) {
      UpdateContacts p = new UpdateContacts();
        database.executeBatch(p);
   }   
}