/*
    Documentation:

    SELECT Id, formulaFullAddress__c
    FROM Home_Owners__c
    WHERE Site_Type__c = 'Residential' //do not use recordType as that was recently introduced and old records may not have that defined
    AND formulaFullAddress__c IN :addressList
    ORDER BY CreatedDate DESC //to ensure most recent match

    Home_Owners__c.formulaFullAddress__c:
        MailingAddress__c+'|'+MailingCity__c+'|'+MailingState__c+'|'+MailingPostal__c+'|'+TEXT(Country__c)+'|'+Phone__c+'|'+Email__c+'|'+FTL_Contact__c

    Calculate Key for Form f:
        f.Nominee_Street_Address__c+'|'+f.Nominee_City__c+'|'+f.Nominee_State__c+'|'+f.Nominee_Zip_Code__c+'|'+f.Nominee_Country__c+'|'+f.Nominee_Phone_Number__c+'|'+f.Nominee_Email__c+'|'+f.Nominee_Name__c

    Form => Site
    -------------
    'Nominee_Street_Address__c' => 'MailingAddress__c'
    'Nominee_City__c' => 'MailingCity__c'
    'Nominee_State__c' => 'MailingState__c'
    'Nominee_Zip_Code__c' => 'MailingPostal__c'
    'Nominee_Country__c' => 'Country__c'
    'Nominee_Phone_Number__c' => 'Phone__c'
    'Nominee_Email__c' => 'Email__c'
    'Nominee_Name__c' => 'FTL_Contact__c'
*/
public class FTL_Program_Form_UpdateSiteLocationBatch implements Database.Batchable<sObject>, Database.Stateful {
    private static final String[] KEYGEN_FIELDS = new String[] {
        'Nominee_Street_Address__c',
        'Nominee_City__c',
        'Nominee_State__c',
        'Nominee_Zip_Code__c',
        'Nominee_Country__c',
        'Nominee_Phone_Number__c',
        'Nominee_Email__c',
        'Nominee_Name__c'
    };

    private final Set<Id> programFormIdSet;
    public Map<String,FTL_Program_Form__c> fullAddressToFormMap = new Map<String,FTL_Program_Form__c>();
    public Set<String> missingFullAddressSet;
    public Map<String,Home_Owners__c> fullAddressToSiteMap = new Map<String,Home_Owners__c>();

    private static final String SITE_TYPE = 'Residential';

    public FTL_Program_Form_UpdateSiteLocationBatch(Set<Id> programFormIdSet) {
        this.programFormIdSet = programFormIdSet;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        for (FTL_Program_Form__c form : [SELECT Nominee_Street_Address__c, Nominee_City__c, Nominee_State__c,
                                        Nominee_Zip_Code__c, Nominee_Country__c, Nominee_Phone_Number__c,
                                        Nominee_Email__c, Nominee_Name__c
                                        FROM FTL_Program_Form__c WHERE Id IN :programFormIdSet]) {

            fullAddressToFormMap.put(keygenForm(form), form);
        }
        missingFullAddressSet = fullAddressToFormMap.keySet();

        return Database.getQueryLocator(
            'SELECT formulaFullAddress__c, CreatedDate ' +
            'FROM Home_Owners__c ' +
            'WHERE Site_Type__c = \'Residential\' ' +
            'AND formulaFullAddress__c IN :missingFullAddressSet'
        );
    }

    public void execute(Database.BatchableContext BC, SObject[] batch) {
        for (Home_Owners__c site : (Home_Owners__c[]) batch) {
            if (fullAddressToFormMap.containsKey(site.formulaFullAddress__c)) {
                if (fullAddressToSiteMap.containsKey(site.formulaFullAddress__c)) {
                    Home_Owners__c existingSite = fullAddressToSiteMap.get(site.formulaFullAddress__c);

                    // Keep most recent record
                    if (site.CreatedDate > existingSite.CreatedDate) {
                        fullAddressToSiteMap.put(site.formulaFullAddress__c, site);
                    }

                } else {
                    missingFullAddressSet.remove(site.formulaFullAddress__c);
                    fullAddressToSiteMap.put(site.formulaFullAddress__c, site);
                }
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Only used for new records, not matching
        Id recordTypeId =
            Schema.SObjectType.Home_Owners__c.getRecordTypeInfosByDeveloperName().get('Feel_The_Love').getRecordTypeId();
        Home_Owners__c[] newSites = new Home_Owners__c[] {};

        // Update the map of sites to include any new sites...
        // add new sites to the 'newSites' list for easy inserts...
        for (String missingFullAddress : missingFullAddressSet) {
            FTL_Program_Form__c form = fullAddressToFormMap.get(missingFullAddress);

            Home_Owners__c newSite = new Home_Owners__c(
                RecordTypeId=recordTypeId,
                Site_Type__c=SITE_TYPE,
                MailingAddress__c=form.Nominee_Street_Address__c,
                MailingCity__c=form.Nominee_City__c,
                MailingState__c=form.Nominee_State__c,
                MailingPostal__c=form.Nominee_Zip_Code__c,
                Country__c=form.Nominee_Country__c,
                Phone__c=form.Nominee_Phone_Number__c,
                Email__c=form.Nominee_Email__c,
                FTL_Contact__c=form.Nominee_Name__c,

                // Other
                Name=form.Nominee_Street_Address__c,
                FirstName__c=form.Nominee_Name__c);

            fullAddressToSiteMap.put(missingFullAddress, newSite);
            newSites.add(newSite);
        }

        insert newSites;    // Ids will be loaded for these sites, and are referenced by the sites Map

        // Sync the forms if the site keys exist
        for (String fullAddress : fullAddressToFormMap.keySet()) {
            fullAddressToFormMap.get(fullAddress).Site_Location__c = fullAddressToSiteMap.get(fullAddress).Id;
        }

        update fullAddressToFormMap.values();
    }

    private String keygenForm(FTL_Program_Form__c form) {
        String[] fieldValueList = new String[] {};

        for (String fieldName : FTL_Program_Form_UpdateSiteLocationBatch.KEYGEN_FIELDS) {
            if (String.isBlank((String) form.get(fieldName))) {
                fieldValueList.add('');
            } else {
                fieldValueList.add((String) form.get(fieldName));
            }
        }

        return String.join(fieldValueList, '|');
    }
}