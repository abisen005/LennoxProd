public with sharing class homeEquiploader
{
           public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};


    public Lennox_lsa__c l;
    
    List<equipment_data__c> equiptoupload;
    List<home_owners__c> hometoupload;
    
    public List<Equipment_data__c> objFromList{get;set;}
    public List<Case_Equip_Junction__c> objToList{get;set;}
  
    
    public List<home_owners__c> objFromList1{get;set;}
    public List<homeownerjunction__c> objToList1{get;set;}  
    
     

    public homeEquiploader (ApexPages.StandardController controller) {
        l = (lennox_lsa__c ) controller.getRecord(); 



  
}
    
    public Pagereference ReadFile()
    {
        

            
            
            nameFile =blobToString( contentFile,'ISO-8859-1');
            
            
            filelines = nameFile.split('\n');
            
            
            hometoupload = new List<home_owners__c>();
            equiptoupload = new List<equipment_data__c>();
            
 
         
            for (Integer i=1;i<filelines.size();i++)
               
            {       

            
                String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                

                
                
            //    home_owners__c homeref=new Home_owners__c(name= 'x',legacyid__c='SAP'+i);
             //   e.Home_Owner__c=homeref.id;
                
                home_owners__c h = new home_owners__c();
                h.firstname__c = inputvalues[0];
                h.name=inputvalues[2] +', ' + inputvalues[3] + ' '+ inputvalues[4];
                h.lastname__c = inputvalues[1];
                h.address__c = inputvalues[2];
                h.city__c = inputvalues[3];       
                h.state__c = inputvalues[4];
                h.dollar_amount__c = double.valueof(inputvalues[8]);
                h.postal_code__c = inputvalues[5];
                
          //      system.debug('HHHHHHH+e.home_owner__c');
                
                  hometoupload.add(h);
            
                
                upsert hometoupload;
                
                       Equipment_data__c  e= new Equipment_data__c ();
                                
                e.name=inputvalues[6] + ' - ' + inputvalues[7];
                e.Home_Owner__c=h.id;
                e.serial_number__c = inputvalues[7];       
                e.model_number__c = inputvalues[6];
                e.dollar_amount__c = double.valueof(inputvalues[8]);
               
                  equiptoupload.add(e);
                upsert equiptoupload;
            }

 
            List<home_owners__c> objFromList1=new List<home_owners__c>();
             List<homeownerjunction__c> objToList1=new List<homeownerjunction__c>();  
            
               
            for(home_owners__c objfrm1 : Hometoupload){
                
                if(!hometoupload.isEmpty()){
               homeownerjunction__c objTo1=new homeownerjunction__c();
              objto1.sitelocation__c=objfrm1.id;
               objto1.dollaramount__c=objfrm1.dollar_amount__c;
                objto1.Lennox_Lsa__c=l.id;
            
                objtolist1.add(objto1);
             
            }
            
            
            if(!objtoList1.isEmpty()){
                upsert objtoList1;
            }

            
            }
        

      
           List<equipment_data__c> objFromList=new List<equipment_data__c>();
            
           List<case_equip_junction__c> objToList=new List<case_equip_junction__c>();
               
            for(equipment_data__c objfrm : equiptoupload){
                
                if(!equiptoupload.isEmpty()){
               case_equip_junction__c objTo=new case_equip_junction__c();
              objto.equipment_data__c=objfrm.id;
                    objto.site_location__c=objfrm.home_owner__c;
                    objto.dollar_amount__c=objfrm.dollar_amount__c;    
                    objto.bypass__c=true;            
                objto.Lennox_Lsa__c=l.id;
            
                objtolist.add(objto);
             
            }
            
            
            if(!objtoList.isEmpty()){
                upsert objtoList;
            }

          
            }
        

        try{
  //   insert hometoupload;
   //       insert equiptoupload;
  //          upsert objtoList;
   //       upsert objtoList1;
             Integer i=0;
            System.debug('@@@@@filebody'+namefile);  
            
                PageReference pageRef = new PageReference('/'+ l.id);
    pageRef.getParameters().put('id',l.Id);
    pageRef.setRedirect(true);
    return pageRef;
          
    }
    catch (Exception ex)
    {
        ApexPages.addMessages(ex);
    }       
    
    return null;                  
    
    
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