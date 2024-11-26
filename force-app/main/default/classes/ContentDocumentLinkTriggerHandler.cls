public class ContentDocumentLinkTriggerHandler {
    public static void beforeInsert(List<ContentDocumentLink> cdls) {
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdls) {
            contentDocumentIds.add(cdl.ContentDocumentId);
        }
        Map<Id,ContentDocument> contentDocuments = new Map<Id,ContentDocument>([
            SELECT Id, Title 
            FROM ContentDocument 
            WHERE Id IN :contentDocumentIds 
                AND (Title LIKE 'DealerAgreement%' OR Title LIKE 'Dealer Participation Agreement%')
        ]);
        for (ContentDocumentLink cdl2 : cdls) {
            if (contentDocuments.get(cdl2.ContentDocumentId) != null) {
                cdl2.Visibility = 'AllUsers';
            }
        }
    }
}