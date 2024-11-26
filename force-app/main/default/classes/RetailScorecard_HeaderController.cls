public class RetailScorecard_HeaderController {
    
    public String headerLevel {get;set;}
    public String headerId {get;set;}
    public String headerRetailType {get;set;}

    public List<String> getScorecardData() {
        system.debug('invoked RetailScorecard_HeaderController');
        List<String> scorecardData = new List<String>();
        if(headerLevel == 'dealer') {
            Account a;
            try{
                a = [SELECT SAP_Customer_Number__c, Name, SAP_Sales_Office_Desc__c, SAP_Sales_Group__c, OwnerId, SAP_Sales_District__c, (SELECT Store_Division__c, Store_Region_Number__c, Store_Region_Name__c FROM Retail_Sales_Tracker__r LIMIT 1) FROM Account WHERE Id = :headerId LIMIT 1];
            }catch(Exception ex){
                System.debug('@@@ No dealer data inside RetailScorecard_Header Controller');
            }
            if(a != null) {
                scorecardData.add(a.SAP_Customer_Number__c + ' - ' + a.Name);
                scorecardData.add(a.SAP_Sales_Office_Desc__c + ' - ' + a.SAP_Sales_Group__c + ' - ' + [SELECT Name FROM User WHERE Id = :a.OwnerId LIMIT 1].Name);
                if(headerRetailType == 'lowes')
                    scorecardData.add(a.Retail_Sales_Tracker__r[0].Store_Division__c + ' Division - Region ' + a.Retail_Sales_Tracker__r[0].Store_Region_Number__c);
                if(headerRetailType == 'costco')
                    scorecardData.add('Costco Region ' + a.Retail_Sales_Tracker__r[0].Store_Region_Name__c);
            }
        }
        return scorecardData;
    }
    
}