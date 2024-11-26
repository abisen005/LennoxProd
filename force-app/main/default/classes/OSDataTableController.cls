/**
* @description       : Warranty and Order Search
* @author            : Ventas Consulting
* @group             : 
* @last modified on  : 03-01-2023
* @last modified by  : Ventas Consulting
**/
public class OSDataTableController {
    public String tableData {get; set;}
    public String tableData2 {get; set;}
    public String accountName {get; set;}
    public Map <String,String> headingMap{get;set;}
    public List<String> columns {get; set;}
    public List<String> columns1 {get; set;}
    public List<Map<String, String>> data {get; set;}
    public List<Map<String, String>> data2 {get; set;}
    public List<Map<String, String>> accName {get; set;} 
    public String type {get; set;}    
    public string orderNumber {get; set;}
    public string warrantyNumber {get; set;}
    public string accNumber {get; set;}
    public string sfAccountName {get; set;}
    public string sfCustomerNumber {get; set;}
    
    
    public OSDataTableController() {
        String displayText1 = (String) Cache.Org.get('local.MulesoftExternalData.displayText');
        String displayText2 = (String) Cache.Org.get('local.MulesoftExternalData2.displayText');
        displayText2 = displayText2.replace('&' , 'and');
        
        System.debug('displayText :: '+displayText1);
        System.debug('displayText :: '+displayText2);
        
        headingMap = new Map<String,String>();
        
        
        tableData = displayText1; 
        tableData2 = displayText2;
        system.debug('tableData1-->'+tableData);   
        system.debug('tableData2-->'+tableData2);
        
        //objWrap = new ObjectWrapper();
        type=ApexPages.currentPage().getParameters().get('Type');
        accountName = ApexPages.currentPage().getParameters().get('accName');
        system.debug('!!!1'+accountName);
        
        
        system.debug(ApexPages.currentPage());
        system.debug('!!!1'+type);
        
        //Order Colums:
        tableData = tableData.replaceAll('Order_Number__c', 'Order Number');
        tableData = tableData.replaceAll('Overall_Order_status__c', 'Order Status');
        tableData = tableData.replaceAll('Delivery_status__c', 'Delivery Status');
        tableData = tableData.replaceAll('Order_Document_Date__c', 'Order Document Date');
        tableData = tableData.replaceAll('PO_Number__c', 'PO Number'); 
        tableData = tableData.replaceAll('Total_Value_Net_Value__c', 'Total Value');
        tableData = tableData.replaceAll('Order_Currency__c', 'Currency');
        
        //Order Headers
        system.debug('type---'+type);
        if(type == 'Items'){
            tableData2 = tableData2.replaceAll('Order_Document_Create_Date__c', 'Order Document Date');
            tableData2 = tableData2.replaceAll('Purchase_Order_No__c', 'PO Number');
            tableData2 = tableData2.replaceAll('Total_Value__c', 'Total Value');
            tableData2 = tableData2.replaceAll('Freight_charge__c', 'Freight Charge'); 
            tableData2 = tableData2.replaceAll('Delivery_status__c', 'Delivery Status');
            tableData2 = tableData2.replaceAll('Overall_Order_status__c', 'Order Status');
            tableData2 = tableData2.replaceAll('Order_Number__c', 'Order Number');
        }
        
        //Warranty Columns:
        tableData = tableData.replaceAll('SAP_Order Number', 'SAP OrderNumber');
        tableData = tableData.replaceAll('Warranty_Claim__c', 'Warranty Claim');
        tableData = tableData.replaceAll('Line_Item__c', 'LineItem');
        tableData = tableData.replaceAll('Warranty_Creation_Date__c', 'Created Date');
        tableData = tableData.replaceAll('Account__c', 'Account');
        tableData = tableData.replaceAll('Component_Failed_Date__c', 'Failed Date');
        tableData = tableData.replaceAll('Decline_Code_Description__c', 'Decline Description');
        tableData = tableData.replaceAll('Failed_Part_Description__c', 'Failed Description');
        tableData = tableData.replaceAll('Installation_Date__c', 'Installation Date');
        tableData = tableData.replaceAll('Failure_Reason_Description__c', 'Failure Reason');
        tableData = tableData.replaceAll('Model_Description__c', 'Model Description');
        tableData = tableData.replaceAll('PO_Number__c', 'PO Number');
        tableData = tableData.replaceAll('Replacement_Part__c', 'Replacement Part');
        
        tableData = tableData.replaceAll('Serial_Number__c', 'Serial No');
        tableData = tableData.replaceAll('TEMPORARYHASHTAG', '#');
        
        
        //Items
        tableData = tableData.replaceAll('Item_Number__c', 'Item No');
        tableData = tableData.replaceAll('Material_Number__c', 'Material No');
        tableData = tableData.replaceAll('Material_Description__c', 'Material Description');
        tableData = tableData.replaceAll('Quantity__c', 'Quantity');
        tableData = tableData.replaceAll('Sales_Price_per_Item__c', 'Sales Price per Item');
        tableData = tableData.replaceAll('Shipment_Date__c', 'Shipment Date');
        tableData = tableData.replaceAll('Shipment_Number__c', 'Shipment No');
        tableData = tableData.replaceAll('Delivery_Number__c', 'Delivery No');
        
        try {
            data = (List<Map<String, String>>)JSON.deserialize(tableData, List<Map<String, String>>.class);
            system.debug('!!!!data[0]' + data[0]);
            orderNumber = data[0].get('Order Number');
            warrantyNumber = data[0].get('Warranty Claim');
            
            /* for(Map<String, String> rec: data){
if (rec != null && rec.size() > 0 && rec.containsKey('Total Value')){
//value = rec.get('Total Value');
//Decimal scaledDecimal = rec.get('Total Value').setScale(2);
String strFormattedCurrency = '$' + string.valueOf(rec.get('Total Value'));
rec.get('Total Value') = strFormattedCurrency ;
}
}*/
            accName = type == 'Warranty' ? (List<Map<String, String>>)JSON.deserialize(accountName, List<Map<String, String>>.class) : null;
            if(accName!= null && accName.size() > 0 && accName[0].containsKey('CustomerNumber') && accName[0].containsKey('AccountName')){
                headingMap.put(accName[0].get('CustomerNumber') , accName[0].get('AccountName'));
            }
            
            data2 = type == 'Items' ? (List<Map<String, String>>)JSON.deserialize(tableData2, List<Map<String, String>>.class) : null;
            system.debug('!!!sdfsdfdsfdsf--'+data2[0].containsKey('CustomerNumber'));
            if(data2!= null && data2.size() > 0 && data2[0].containsKey('CustomerNumber') && data2[0].containsKey('AccountName')){
                headingMap.put(data2[0].get('CustomerNumber') , data2[0].get('AccountName'));
            }   
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
        if(type == 'OrderHeaders'){  
            columns.add('Order Document Date');
            columns.add('PO Number');
            columns.add('Total Value');
            columns.add('Freight Charge');
            columns.add('Delivery Status');   
        }
        if(type == 'Warranty'){
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
        if (type == 'Items'){
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
    }
    
    /*Code Used to remove Leading zeroes
     * public static String drop_leading_zeros(String passedValue) {
String return_string = null; //return string for passing back
if (passedValue != null) { //if the passed value is not null
return_string=passedValue;
if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with a 0 and the length is greater than 1
boolean keepChecking = true; //create a boolean variable
while (keepChecking) { //if boolean is true
if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with 0 and there is more than 1 character
return_string = return_string.substring(1); //drop the first character
} else { //either the string doesn't begin with 0 or the length is less than or equal to 1
keepChecking = false; //stop the loop
}
}
if (return_string == '0') { //if the resulting string is now a single '0'
return_string ='0'; //set the string to null
}
} else { //otherwise the value passed was not valid
return_string = passedValue; //set the string to null
}
}
return String.valueof(return_string); //pass back a value
        }*/
    
}