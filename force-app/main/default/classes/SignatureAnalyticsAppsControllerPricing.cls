public class SignatureAnalyticsAppsControllerPricing {

    public Signature_Analytics_App__mdt [] sap {get;set;}
    
    public SignatureAnalyticsAppsControllerPricing(){
    
        sap = [SELECT label, DeveloperName, Description__c, Marketing__c,Icon__c, URL__c, Sort_Order__c
               FROM Signature_Analytics_App__mdt 
               WHERE Published__c = True AND Pricing__c = true
               ORDER BY Sort_Order__c];
        
    }
 
}