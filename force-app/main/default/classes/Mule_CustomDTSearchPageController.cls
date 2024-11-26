public class Mule_CustomDTSearchPageController {
    public String tableData {get; set;}
    public String tableData2 {get; set;}
     
    public List<String> columns {get; set;}
    public List<String> columns1 {get; set;}
     public Map <String,String> headingMap{get;set;}
    /*public ObjectWrapper objWrap {get;set;}
public Map<String, String> tempColumnsLabel {get; set;}*/
    public List<Map<String, String>> data {get; set;}
    public List<Map<String, String>> data2 {get; set;}
    public List<Map<String, String>> accName {get; set;}
    public String type {get; set;}
    public string orderNumber {get; set;}
     public string serialNumber {get; set;}
    public String accountName {get; set;}
    public String customerNumber {get; set;}
    
    public Mule_CustomDTSearchPageController() {
          String displayText = (String) Cache.Org.get('local.MulesoftExternalData.displayText');
        String displayText2 = (String) Cache.Org.get('local.MulesoftExternalData2.displayText');
        
        System.debug('displayText :: '+displayText);
        System.debug('displayText2 :: '+displayText2);
        tableData = displayText;
        tableData2 = displayText2;
         headingMap = new Map<String,String>();
        //objWrap = new ObjectWrapper();
       type=ApexPages.currentPage().getParameters().get('Type');
        
        accountName = ApexPages.currentPage().getParameters().get('accName');
        system.debug('!!!1'+accountName);
    
           //Equipment
        if(type == 'Equipment'){
            tableData = tableData.replaceAll('Model_Number', 'Model Number');
            tableData = tableData.replaceAll('SAP_Material_Description', 'SAP Material Description');
            tableData = tableData.replaceAll('Installation_Date', 'Installation Date');
            tableData = tableData.replaceAll('Purchasing_Account', 'Purchasing Account');     
        }
        
        if(type == 'Learning'){
            tableData = tableData.replaceAll('USER_FULL_NAME', 'Name');
            tableData = tableData.replaceAll('USER_POSITION_DESCR', 'Position');
            tableData = tableData.replaceAll('TRAINING_TITLE', 'Class Title');
            tableData = tableData.replaceAll('TRANSCRIPT_STATUS', 'Status'); 
            tableData = tableData.replaceAll('REGISTRATION_DT', 'Registration Date');
            tableData = tableData.replaceAll('USER_STATUS', 'Completion Date');
            tableData = tableData.replaceAll('TRAINING_HOURS', 'Training Hours');
            tableData = tableData.replaceAll('TRAINING_TYPE', 'Training Type'); 
            tableData = tableData.replaceAll('PROVIDER_NAME', 'Provider Name'); 
            
        }          
      
        try {
            data = (List<Map<String, String>>)JSON.deserialize(tableData, List<Map<String, String>>.class);
             data2 = (List<Map<String, String>>)JSON.deserialize(tableData2, List<Map<String, String>>.class);
            for(Map<String, String> response : data){
                for(String str : response.keySet()){
                    
                    String tempString = response.get(str);
                    if(tempString == null || String.isBlank(tempString) || String.isEmpty(tempString)){
                        response.put(str, 'N/A');
                    } 
                }
            }
            
            for (Map<String, String> response : data){
                             system.debug('!!!!abiiii1' + response.get('AccountName'));
            system.debug('!!!!abiiii2' + response.get('Serial_Number'));
                 }
            
            system.debug('!!!!abiiii1' + data2[0].get('CustomerNumber'));
            system.debug('!!!!abiiii2' +data2[0].get('AccountName'));
             //system.debug('!!!!abiiii' + data.get('AccountName'));
            //system.debug('!!!!abiiii' + data.get('CustomerNumber'));
             //Map<String, Object> m2 = (Map<String, Object>) data.get('Order_Number__c');
            orderNumber = data[0].get('Order Number');
	        serialNumber = data[0].get('Serial_Number');
customerNumber = data2[0].get('CustomerNumber') != null ? data2[0].get('CustomerNumber') : 'NA' ;
    accountName = data2[0].get('AccountName') != null ? data2[0].get('AccountName') : 'NA' ;
            for(Map<String, String>  mp : data){
                for(String str : mp.keySet()){
                     String tempString = mp.get(str);
                    if(str == 'Training Hours' && tempString != 'N/A'  ){
                        Decimal hrs = Decimal.valueOf(mp.get(str)).setScale(2);
                        mp.put(str, String.valueOf(hrs));
                    }
                     else if(str.contains('Registration Date') && tempString != 'N/A'){
						String dateFormat = mp.get(str).substringBefore('T');
                        Datetime dt = Datetime.newInstance(
                                                    Integer.valueOf(dateFormat.substringBefore('-')), 
                                                    Integer.valueOf(dateFormat.substringBetween('-','-')), 
                                                    Integer.valueOf(dateFormat.substringAfterLast('-'))
                        							);
                        String myDatetimeStr = dt.format('MM/d/yyyy');
                        mp.put(str, String.valueOf(myDatetimeStr)); 
                    }
                     else if (str.contains('Completion Date') && tempString != 'N/A'){
						String dateFormat = mp.get(str).substringBefore('T');
                        Datetime dt = Datetime.newInstance(
                                                    Integer.valueOf(dateFormat.substringBefore('-')), 
                                                    Integer.valueOf(dateFormat.substringBetween('-','-')), 
                                                    Integer.valueOf(dateFormat.substringAfterLast('-'))
                        							);
                        String myDatetimeStr = dt.format('MM/d/yyyy');
                        mp.put(str, String.valueOf(myDatetimeStr)); 
                    }
                }
            }
                         
            accName = type == 'Equipment' ? (List<Map<String, String>>)JSON.deserialize(accountName, List<Map<String, String>>.class) : null;
             if(accName!= null && accName.size() > 0 && accName[0].containsKey('CustomerNumber') && accName[0].containsKey('AccountName')){
                 headingMap.put(accName[0].get('CustomerNumber') , accName[0].get('AccountName'));
             }  
            
             accName = type == 'Learning' ? (List<Map<String, String>>)JSON.deserialize(accountName, List<Map<String, String>>.class) : null;
             if(accName!= null && accName.size() > 0 && accName[0].containsKey('CustomerNumber') && accName[0].containsKey('AccountName')){
                 headingMap.put(accName[0].get('CustomerNumber') , accName[0].get('AccountName'));
             }  
            
            
            data2 = type == 'Items' ? (List<Map<String, String>>)JSON.deserialize(tableData2, List<Map<String, String>>.class) : null;
           // system.debug('data2'+data);
        } catch (Exception e) {
            // SyntaxError: Unexpected end of JSON input
            system.debug(e.getLineNumber());
            system.debug(e.getCause());
            system.debug(e.getTypeName());
            System.debug('An exception occurred: ' + e.getMessage());
        }
        
        
        system.debug('!!!1'+type);
        columns = new List<String>();
         columns1 = new List<String>();
        if(type == 'Order'){
            system.debug('!!!OrderColums'+type);
            
            List<MulesoftSearchFlowColumns__mdt > col1 = [Select  Id,
                                                                 FieldName__c ,
                                                                 Type__c ,
                                                                 Label__c,
                                                                 RecordType__c ,
                                                                 Sort_Order__c,
                                                                 DeveloperName,
                                                                 Add_Column_to_VF__c   
                                                         From MulesoftSearchFlowColumns__mdt 
                                                         where RecordType__c = 'Order'  AND Add_Column_to_VF__c = true  order by Sort_Order__c ];
            
            for(MulesoftSearchFlowColumns__mdt mdt : col1){
                if(mdt.RecordType__c == 'Order') columns.add(mdt.Label__c); 
            }
        }
        else if(type == 'OrderHeaders'){
   
            columns.add('Order Document Date');
            columns.add('PO Number');
            columns.add('Total Value');
            columns.add('Freight Charge');
            columns.add('Delivery Status');
    
        }
        else if(type == 'Warranty'){
            system.debug('!!!WarrantyColums'+type);
            
             List<MulesoftSearchFlowColumns__mdt > col1 = [Select  Id,
                                                                 FieldName__c ,
                                                                 Type__c ,
                                                                 Label__c,
                                                                 RecordType__c ,
                                                                 Sort_Order__c,
                                                                 DeveloperName,
                                                                 Add_Column_to_VF__c   
                                                         From MulesoftSearchFlowColumns__mdt 
                                                         where RecordType__c = 'Warranty'  AND Add_Column_to_VF__c = true  order by Sort_Order__c ];
            
            for(MulesoftSearchFlowColumns__mdt mdt : col1){
                if(mdt.RecordType__c == 'Warranty') columns.add(mdt.Label__c); 
            }
        }     
        else if (type == 'Items'){
            system.debug('!!!ItemColums'+type);
            
            List<MulesoftSearchFlowColumns__mdt > col = [Select  Id,
                                                                 FieldName__c ,
                                                                 Type__c ,
                                                                 Label__c,
                                                                 RecordType__c ,
                                                                 Sort_Order__c,
                                                                 DeveloperName,
                                                                 Add_Column_to_VF__c   
                                                         From MulesoftSearchFlowColumns__mdt 
                                                         where RecordType__c In ('OrderSearchItems','OrderSearchHeaders')  AND Add_Column_to_VF__c = true  order by Sort_Order__c ];
            
            for(MulesoftSearchFlowColumns__mdt mdt : col){
                if(mdt.RecordType__c == 'OrderSearchItems') columns.add(mdt.Label__c);
                if(mdt.RecordType__c == 'OrderSearchHeaders') columns1.add(mdt.Label__c);
            }
        } 
        else if (type == 'Equipment'){
            system.debug('!!!ItemColums'+type);
            List<MulesoftSearchFlowColumns__mdt > col = [Select  Id,
                                                                 FieldName__c ,
                                                                 Type__c ,
                                                                 Label__c,
                                                                 RecordType__c ,
                                                                 Sort_Order__c,
                                                                 DeveloperName,
                                                                 Add_Column_to_VF__c   
                                                         From MulesoftSearchFlowColumns__mdt 
                                                         where RecordType__c = 'Equipment'  AND Add_Column_to_VF__c = true  order by Sort_Order__c];
            
            for(MulesoftSearchFlowColumns__mdt mdt : col){
                if(mdt.RecordType__c == 'Equipment') columns.add(mdt.Label__c);
            
            }
        }
             else if (type == 'Learning'){
            system.debug('!!!LearningColumns'+type);
            
             List<MulesoftSearchFlowColumns__mdt > col1 = [Select  Id,
                                                                 FieldName__c ,
                                                                 Type__c ,
                                                                 Label__c,
                                                                 RecordType__c ,
                                                                 Sort_Order__c,
                                                                 DeveloperName,
                                                                 Add_Column_to_VF__c   
                                                         From MulesoftSearchFlowColumns__mdt 
                                                         where RecordType__c = 'LearningSearchFlow'  AND Add_Column_to_VF__c = true  order by Sort_Order__c ];
            
            for(MulesoftSearchFlowColumns__mdt mdt : col1){
                if(mdt.RecordType__c == 'LearningSearchFlow') columns.add(mdt.Label__c); 
            }
        }
    }
}