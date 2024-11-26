@isTest
public class CopyFileFromEventToAccountHandlerTest {
    @isTest
    public static void CopyFileFromEventToAccountHandlerTest(){
    
            Account a= new Account(

            name='xyz');
                      
        insert a;
      
        
       Event e = new event(
            type = 'CSS Event', 
           whatid=a.id,
           StartDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0),
           EndDateTime = datetime.newInstance(2014, 9, 15, 13, 30, 0));
        insert e;
        
        

       
            ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content Data'),
                IsMajorVersion = true);
        insert contentVersionInsert;
        

            ContentDocument documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        

                 
                   
                  
            ContentDocumentLink contentlink = new ContentDocumentLink(
            LinkedEntityId = a.Id,
            ShareType = 'V',
            ContentDocumentId = documents.Id);                

            insert contentlink;
          
           
    }
}