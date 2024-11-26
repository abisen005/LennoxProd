/*
* @ Purpose      : Handler for AttachmentTrigger to copy the attachment from DocuSign_Status object to its parent Account object 
* @ CreatedDate  : 13-04-2019
*/
public class CopyFileToAccountHandler {
    
    public static void copyFileToAccount(List<ContentDocumentLink> contentDocumentLinks) {
        if(contentDocumentLinks!= NULL) {
            List<ContentDocumentLink> clonedContentDocumentLinks = new List<ContentDocumentLink>();			
			Set<Id> linkedEntityIds = new Set<Id>();
            Map<Id,Id> docuSignIdtoComapnyIdMap = new Map<Id,Id>();
			for(ContentDocumentLink contentDocumentLink:contentDocumentLinks) {
					linkedEntityIds.add(contentDocumentLink.LinkedEntityId);
			}
			
			for(dsfs__DocuSign_Status__c docuSignStatus:[SELECT Id, dsfs__Company__c
														 FROM dsfs__DocuSign_Status__c
														 WHERE Id In :linkedEntityIds]){
				docuSignIdtoComapnyIdMap.put(docuSignStatus.Id,docuSignStatus.dsfs__Company__c);
			}
					
			ContentDocumentLink clonedContentDocumentLink;          
            for(ContentDocumentLink contentDocumentLink:contentDocumentLinks){                   
                    if(docuSignIdtoComapnyIdMap.containsKey(contentDocumentLink.LinkedEntityId)){						
                        //Cloning the ContentDocumentLink and linking it to the parent object(Account) of docuSignStatus
						
						clonedContentDocumentLink = contentDocumentLink.clone(false,true,false,false);
	        			clonedContentDocumentLink.LinkedEntityId = docuSignIdtoComapnyIdMap.get(contentDocumentLink.LinkedEntityId);
    					clonedContentDocumentLinks.add(clonedContentDocumentLink);
                    }
    			}  
				            
          insert(clonedContentDocumentLinks);             

        }
    }
}