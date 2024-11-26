/**
 * @description       : Apex Controller (Aura Component-CustomeDatatable for Warranty and Order Search)
 * @author            : Ventas Consulting
 * @group             : 
 * @last modified on  : 03-01-2023
 * @last modified by  : Ventas Consulting
**/
public class CustomDTController {
    
    @AuraEnabled 
    public static void storeJSONIntoTempCache( String jsonString1,String jsonString2 ) {         
        system.debug('jsonString1::' + jsonString1);    
        storeJSONContentIntoCache(jsonString1,jsonString2);
    }
    
    public static void storeJSONContentIntoCache( String jsonStr,String jsonStr2 ) {
        
        Cache.Org.put('local.MulesoftExternalData.displayText', jsonStr, 3600);  
        Cache.Org.put('local.MulesoftExternalData2.displayText', jsonStr2, 3600);       
    }
    
    @AuraEnabled
    public static List<ReturnWrapper> returnDefaultColumns(String table){
        
        List<MulesoftSearchFlowColumns__mdt > col = [Select FieldName__c ,Type__c ,Label__c,toLabel(RecordType__c) , Sort_Order__c  From MulesoftSearchFlowColumns__mdt where toLabel(RecordType__c) = : table AND  Add_Column_to_VF__c  = true order by Sort_Order__c desc ];
        system.debug('col --'+col);
        
        List<ReturnWrapper> wrpList = new List<ReturnWrapper>();
        for(MulesoftSearchFlowColumns__mdt  currentVar : col){
            wrpList.add(new ReturnWrapper(currentVar.Label__c , currentVar.FieldName__c , currentVar.Type__c , currentVar.Sort_Order__c));
        }
        
        return wrpList != null && wrpList.Size() > 0 ? wrpList : new List<ReturnWrapper>();
    }
    
    public class ReturnWrapper{
        @AuraEnabled public String Label {get;set;}
        @AuraEnabled public String FieldName {get;set;}
        @AuraEnabled public String Type {get;set;}
        @AuraEnabled public Decimal sortOrder {get;set;}
        
        public ReturnWrapper(String Label , String FieldName ,String Type , Decimal sortOrder ){
            this.Label      = Label;
            this.FieldName  = FieldName;
            this.Type       = Type;
            this.sortOrder      = sortOrder;
        }
    }
}