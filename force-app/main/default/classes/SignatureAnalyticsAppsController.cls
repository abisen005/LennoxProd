public class SignatureAnalyticsAppsController {

    public Signature_Analytics_App__mdt [] sap {get;set;}
    
    public SignatureAnalyticsAppsController (){
    
        sap = [SELECT label, DeveloperName, Description__c, Icon__c, URL__c, Sort_Order__c
               FROM Signature_Analytics_App__mdt 
               WHERE Published__c = True
               ORDER BY Sort_Order__c];
        
    }
 
}