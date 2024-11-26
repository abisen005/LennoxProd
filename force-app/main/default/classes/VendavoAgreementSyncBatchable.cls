global class VendavoAgreementSyncBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private integer pageNumber {get;set;}
    private integer numberOfPages {get;set;}
    private Boolean isFirstBatch {get;set;}
    
    public VendavoAgreementSyncBatchable(Integer pageNumber, Integer numberOfPages, Boolean isFirstBatch) {
        this.pageNumber = pageNumber;
        this.numberOfPages = numberOfPages;
        this.isFirstBatch = isFirstBatch;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name FROM Account LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {

        VendavoAgreementsSync.syncAgreements(pageNumber);
    }   
    
    global void finish(Database.BatchableContext BC) {
        Integer nextPage = pageNumber + 1;
        if(isFirstBatch) {
            Vendavo_API_Credentials__c vendavoSettings = Vendavo_API_Credentials__c.getInstance();
            Integer perPage = vendavoSettings.Agreement_Callout__c != NULL ? Integer.valueOf(vendavoSettings.Agreement_Callout__c) : 500;
            String json = VendavoUtils.getAgreements(VendavoUtils.getAuthToken(), perPage, 1);
            AgreementsWrapperClasses result = AgreementsWrapperClasses.parse(json);
            numberOfPages = Integer.valueOf((result.paging.totalCount / result.paging.perPage).round(System.RoundingMode.UP));
        }
        System.debug('nextPage <= numberOfPages');
        System.debug(nextPage <= numberOfPages);
        if(nextPage <= numberOfPages) {
            VendavoAgreementSyncBatchable vb = new VendavoAgreementSyncBatchable(nextPage, numberOfPages, false);
            Database.executeBatch(vb);
        }
    }
    
}