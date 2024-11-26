public with sharing class FileUploader 
{

    public FileUploader(ApexPages.StandardController controller) {
        scl = (SupplyChain__c ) controller.getRecord(); 
    }

    public SupplyChain__c sclget{get;set;}
    public Attachment myAttachment {get;set;}
    
                           
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<SCSkus__c> accstoupload;
    public SupplyChain__c scl;
   
    public Pagereference ReadFile()
    {

        try{
                
            nameFile =blobToString( contentFile,'ISO-8859-1');
            
            filelines = nameFile.split('\n');
                
            myAttachment = new Attachment();

            accstoupload = new List<SCSkus__c>();
            for (Integer i=1;i<26;i++){
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                SCSkus__c a = new SCSkus__c();
                a.supplychain__c = scl.id;
                a.recordtypeid='012C0000000UrpNIAS';
                a.material__c = inputvalues[0];       
                a.quantity__c = double.valueOf(inputvalues[1]);
                a.storea__c ='N/A';
                a.Has_store_opened_in_last_12_months__c ='N/A';
                a.TypeofRequest__c='N/A';
                a.reasonforrequest__c='N/A';
                a.Material__c='N/A';
                a.ProductDivision__c='N/A';
                a.MaterialDescription__c='N/A';      
    
                accstoupload.add(a);
            }
          
            insert accstoupload;
            System.debug('@@@@@filebody'+namefile);  
            myAttachment = new Attachment();      
            Integer i=0;
            myAttachment.clear();
            myAttachment.Body=contentfile;
            myAttachment.Name='Product Shortage.csv';
            MyAttachment.ParentID=scl.id;
            insert myAttachment;
                    PageReference pageRef = new PageReference('/'+ scl.id);
            pageRef.getParameters().put('id',scl.Id);
            pageRef.setRedirect(true);
            return pageRef;

        } catch(Exception e){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Your file cannot be uploaded.  Please ensure your Product Shortage upload is in the correct format with no additional columns.  Column A is material numbers and Column B is quantity.  If your upload is in the correct format, ensure that it is under 25 rows. ');
                ApexPages.addMessage(errormsg);
        }       
       
        PageReference pageRef = new PageReference('/'+ scl.id);
        pageRef.getParameters().put('id',scl.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
       
       

 
       
    

    public PageReference returntorecord() {
        

                //return (new ApexPages.StandardController(visit)).view();
                PageReference pageRef = new PageReference('/'+ scl.id);
                pageRef.getParameters().put('id',scl.Id);
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
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         
}