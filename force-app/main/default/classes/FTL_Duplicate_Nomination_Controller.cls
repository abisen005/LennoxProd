public without sharing class FTL_Duplicate_Nomination_Controller {
    public FTL_Program_Form__c record { get; set; }
    public List<FTL_Program_Form__c> dupFormLst {get;set;}
    public FTL_Program_Form__c form { get; set; }
    
    public FTL_Duplicate_Nomination_Controller(ApexPages.StandardController stdController){
        record = (FTL_Program_Form__c) stdController.getRecord();
        form = [
            SELECT
                Id,
            	Name,
            	Nominee_Name__c,
                Nominee_Zip_Code__c,
                Nominee_State__c,
                Nominee_Country__c,
                Nominee_City__c,
                Nominee_Street_Address__c,
                Assigned_Dealer__c,
            	Multiple_Submissions__c
            FROM FTL_Program_Form__c
            WHERE Id = :record.Id
        ];
        /*dupFormLst = [SELECT Id,Nominee_Name__c,Nominee_City__c, Nominee_Address__c,Assigned_Dealer__c,Assigned_Dealer__r.Name,Status__c,CreatedDate
                      FROM FTL_Program_Form__c 
                      WHERE Id !=: form.Id 
                      AND Nominee_Name__c =: form.Nominee_Name__c 
                      AND Nominee_City__c =: form.Nominee_City__c 
                      AND Archived__c = false
                     ];*/
        dupFormLst = findNominees(form);
    }
    
    public void updateMultipleSubmissions(){
        if(!dupFormLst.isEmpty()){
            form.Multiple_Submissions__c = true;
            update form;
        }
    }

    public static List<String> blacklistedWords = new List<String> {
        'and',
        'of',
        '+',
        '&',
        'Mrs.',
        'Miss'
    };
    
    public List<FTL_Program_Form__c> findNominees(FTL_Program_Form__c potentialRecord)
    {
        if (String.isBlank(potentialRecord.Nominee_Name__c)) return null;
        /*List<FTL_Program_Form__c> candidates = [SELECT Id FROM FTL_Program_Form__c WHERE Name = :potentialRecord.Nominee_Name__c];
        if (!candidates.isEmpty()) return candidates;*/
        
        List<String> partialMatches = new List<String>();
        String field1 = potentialRecord.Nominee_Name__c.replaceAll('[0-9]', ' ');
        String field2 = field1.toLowerCase();
        for (String fragment : field2.split(' '))
        {

            if (!blacklistedWords.contains(fragment) && fragment.length() > 2) {
                partialMatches.add('%' + fragment + '%');
            }
        }
        System.debug('partialMatches ::'+partialMatches);
        return [SELECT Id, Name, Nominee_Name__c,Nominee_City__c, Nominee_Address__c,Assigned_Dealer__c,Assigned_Dealer__r.Name,Status__c,CreatedDate 
                FROM FTL_Program_Form__c 
                WHERE Nominee_Name__c LIKE : partialMatches AND Nominee_City__c =: potentialRecord.Nominee_City__c AND Archived__c = false AND Id !=: potentialRecord.Id];
    }
}