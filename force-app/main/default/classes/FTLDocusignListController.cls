/**
 * @File Name          : FTLDocusignListController.cls
 * @Description        : 
 * @Author             : Ken@VentasConsulting.com <Ken Dickinson>
 * @Group              : 
 * @Last Modified By   : Ken@VentasConsulting.com <Ken Dickinson>
 * @Last Modified On   : 2/27/2020, 1:47:02 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/27/2020   Ken@VentasConsulting.com <Ken Dickinson>     Initial Version
**/
public without sharing class FTLDocusignListController {
    public class DocumentInformation {
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String documentId { get; set; }
        
        public DocumentInformation(ContentDocumentLink cdl) {
            this.title = cdl.ContentDocument.Title;
            this.documentId = cdl.ContentDocument.Id;
        }
    }
    
    /**
    * @description Gets the Account Id associated with the current user (only works with commmunity users)
    and gets all files associated with that account that begin with 'DealerAgreement' wrapped 
    in a custom class - used by ftlDocusignList aura component in FTL community
    * @author Ken@VentasConsulting.com <Ken Dickinson> | 2/27/2020 
    * @return List<DocumentInformation> 
    **/
    @AuraEnabled
    public static List<DocumentInformation> getDocusignDocuments(){
        String titleMatcher = 'Dealer%Agreement%';
        Id userId = UserInfo.getUserId();
        
        // get the current user's associated account
        Id accountId = [SELECT Id, AccountId FROM User WHERE Id = :userId LIMIT 1].AccountId;
     
        List<ContentDocumentLink> cdls = getContentDocumentLinks(accountId, titleMatcher);
        // return the content as a list of custom objects specific to this component
        return getDocumentInformation(cdls);
    }
    
    private static List<ContentDocumentLink> getContentDocumentLinks(Id accountId, String titleMatcher) {
        List<ContentDocumentLink> cdls = 
            [SELECT Id, ContentDocument.Title, ContentDocument.Id 
                 FROM ContentDocumentLink 
                 WHERE LinkedEntityId = :accountId
                    AND ContentDocument.Title LIKE :titleMatcher
        ];
        return cdls;
    }
    
    private static List<DocumentInformation> getDocumentInformation(List<ContentDocumentLink> cdls) {
        List<DocumentInformation> ddis = new List<DocumentInformation>();
        for (ContentDocumentLink cdl : cdls) {
            ddis.add(new DocumentInformation(cdl));
        }
        return ddis;
    }
}