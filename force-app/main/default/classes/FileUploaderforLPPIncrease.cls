public with sharing class FileUploaderforLPPIncrease
{

 
public SupplyChain__c currentRecord{get; set;}
    public Attachment myAttachment {get;set;}
    String dec='0';
    String errorMessage;
          public Boolean status {get;set;}                  
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    public List<SCSkus__c> skustoupload{get;set;}
    
    public FileUploaderforLPPIncrease(ApexPages.StandardController controller) {

        
    currentRecord = (SupplyChain__c)controller.getRecord(); 
    }
 



    
   
   
    public Pagereference ReadFile()
    {
 
try{
                
                nameFile =blobToString( contentFile,'UTF-8');
                  
          
                filelines = nameFile.split('\n');
                
        myAttachment = new Attachment();

                skustoupload = new List<SCSkus__c>();
                for (Integer i=1;i<filelines.size();i++)
                {
                    String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                    
                        if (filelines.get(i).equals('')) {
                        filelines.remove(i);
                                i--;}
                    SCSkus__c a = new SCSkus__c();

                  a.supplychain__c = currentrecord.id;
                  a.name= inputvalues[4];
                   a.recordtypeid='012C0000000UrpLIAS';                  
                  a.storea__c =inputvalues[0];
                  a.Has_store_opened_in_last_12_months__c =inputvalues[1];
                  a.TypeofRequest__c=inputvalues[2];
            a.reasonforrequest__c=inputvalues[3];
                  a.Material__c=inputvalues[4];
                  a.ProductDivision__c=inputvalues[5];
                  a.MaterialDescription__c=inputvalues[6];                 
                  a.jan__c=(string.ISBLANK(inputvalues[7])) ? 0: Double.valueOf(inputvalues[7]);              
                  a.feb__c=(string.ISBLANK(inputvalues[8])) ? 0: Double.valueOf(inputvalues[8]);
                  a.march__c=(string.ISBLANK(inputvalues[9])) ? 0: Double.valueOf(inputvalues[9]);
                  a.apr__c=(string.ISBLANK(inputvalues[10])) ? 0: Double.valueOf(inputvalues[10]);
                  a.may__c=(string.ISBLANK(inputvalues[11])) ? 0: Double.valueOf(inputvalues[11]);
                  a.june__c=(string.ISBLANK(inputvalues[12])) ? 0: Double.valueOf(inputvalues[12]);
                  a.july__c=(string.ISBLANK(inputvalues[13])) ? 0: Double.valueOf(inputvalues[13]);
                  a.aug__c=(string.ISBLANK(inputvalues[14])) ? 0: Double.valueOf(inputvalues[14]);
                  a.sept__c=(string.ISBLANK(inputvalues[15])) ? 0: Double.valueOf(inputvalues[15]);
                  a.oct__c=(string.ISBLANK(inputvalues[16])) ? 0: Double.valueOf(inputvalues[16]);
                  a.nov__c=(string.ISBLANK(inputvalues[17])) ? 0: Double.valueOf(inputvalues[17]);
                  a.dec__c=(string.ISBLANK(inputvalues[18])) ? 0: Double.valueOf(inputvalues[18]);


        
                    skustoupload.add(a);
                    
      }
          
         }

catch(Exception e)
    {

ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please upload a valid CSV document');
        ApexPages.addMessage(myMsg); 
        status=true;
            }
            
            return null;
                 }
                 
      
                 
                               public List<SCSkus__c> getuploadedskus()
    {
        if (skustoupload!= NULL)
            if (skustoupload.size() > 0)
                return skustoupload;
            else
                return null;                    
        else
            return null;
    }   
    
    
        public Pagereference SaveFile()
             {    
            try{           
         insert skustoupload;
         status=true;

ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record(s) Created Successfully.Thank you!'));

         }

                  catch(Exception e){
ApexPages.addMessages(e);
               
         }            
                 return null;
               }  
                 
   

public PageReference save() {

             currentrecord.recordtypeid='012C0000000GcTQIA0';
       
           update currentrecord;
            System.debug('@@@@@filebody'+namefile);  
                myAttachment = new Attachment();      
                  Integer i=0;
       myAttachment.clear();
      myAttachment.Body=contentfile;
          myAttachment.Name='Forecast Request.csv';
          MyAttachment.ParentID=currentrecord.id;
        insert myAttachment;
  PageReference pageRef = new PageReference('/'+ currentrecord.id);
                pageRef.getParameters().put('id',currentrecord.Id);
                pageRef.setRedirect(true);
                return pageRef;
}



    public PageReference returntorecord() {
        

                //return (new ApexPages.StandardController(visit)).view();
                PageReference pageRef = new PageReference('/'+ currentrecord.id);
                pageRef.getParameters().put('id',currentrecord.Id);
                pageRef.setRedirect(true);
                return pageRef;
        }

    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'UTF-8');
    }         
}