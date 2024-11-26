public class SignatureAnalyticsAppsControllerSales {

    public Signature_Analytics_App__mdt [] sap {get;set;}
    
    public SignatureAnalyticsAppsControllerSales (){
    
        sap = [SELECT label, DeveloperName, Description__c, Icon__c, URL__c, Sort_Order__c, Sales__c
               FROM Signature_Analytics_App__mdt 
               WHERE Published__c = True AND Sales__c = True
               ORDER BY Sort_Order__c];
        
    }
 
}