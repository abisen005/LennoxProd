global class VendavoAgreementsScheduler implements Schedulable {
    
    global static void execute(SchedulableContext SC) {
        Integer pageNumber = 1;
        Integer numberOfPages = 1;
        Boolean isFirstBatch = true;
		VendavoAgreementSyncBatchable vb = new VendavoAgreementSyncBatchable(pageNumber, numberOfPages, isFirstBatch);
        Database.executeBatch(vb);
        
    }
    
    
}