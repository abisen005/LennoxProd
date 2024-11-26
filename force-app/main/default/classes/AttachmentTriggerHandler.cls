/**
* @ Purpose      : Handler for AttachmentTrigger to copy the attachment from DocuSign_Status object to its parent Account object           
* @ CreatedDate  : 16-04-2019
**/
public class AttachmentTriggerHandler {
    
	//Method to copy the attachment from DocuSign_Status object to its parent Account(Company) object
	
    public static void copyFileToAccount(List<Attachment> attachments) {
        if(attachments!= NULL) {
			Map<Id,Id> docuSignIdtoComapnyIdMap = new Map<Id,Id>();
            List<Attachment> cloneAttachments = new List<Attachment>();			
			Set<Id> parentIds = new Set<Id>();
			for(Attachment attachment:attachments) {
				if(attachment.ParentId!=Null)
					parentIds.add(attachment.ParentId);									
			}
				
						
			for(dsfs__DocuSign_Status__c docuSignStatus:[SELECT Id, dsfs__Company__c
														 FROM dsfs__DocuSign_Status__c
														 WHERE Id In :parentIds]){
                if(docuSignStatus.dsfs__Company__c != NULL) {
                	docuSignIdtoComapnyIdMap.put(docuSignStatus.Id,docuSignStatus.dsfs__Company__c);                                                 
                }                                                             				
			}
					
			Attachment clonedAttachment;          
            for(Attachment attachment:attachments){                   
                    if(docuSignIdtoComapnyIdMap.containsKey(attachment.ParentId)){						
                        //Cloning the Attachment and linking it to the parent object(Account) of docuSignStatus
						
        				clonedAttachment = attachment.clone(false,true,false,false);
	        			clonedAttachment.ParentId = docuSignIdtoComapnyIdMap.get(attachment.ParentId);
    					cloneAttachments.add(clonedAttachment); 
                    }
    			}  
            INSERT(cloneAttachments); 
       }                      
   }
}