public without sharing class FTL_NominationCounter {
    public class Nominations {
        public Nominations() {
            Items = new List<Nomination>();
            Total = 0;
        }

        @AuraEnabled
        public List<Nomination> Items {get;set;}

        @AuraEnabled
        public integer Total {get;set;}
    }

    public class Nomination {
        public Nomination(string s, integer t) {
            StateProvince = s;
            Total = t;
        }
        
        @AuraEnabled
        public string StateProvince {get;set;}
        @AuraEnabled
        public integer Total {get;set;}
    }

    @AuraEnabled
    public static Nominations getAggregateData() {
        Nominations r = new Nominations();

        AggregateResult[] results = [
            SELECT
                Nominee_State__c,
                COUNT(ID)
            FROM FTL_Program_Form__c
            WHERE
                RecordType.DeveloperName='Nomination_Form'
                AND Archived__c = false 
                AND CreatedDate = THIS_YEAR
            GROUP BY Nominee_State__c
            ORDER BY Nominee_State__c
        ];

        for(AggregateResult ar : results) {
            string state = (string) ar.get('Nominee_State__c');
            if (string.isBlank(state)) { state = 'Undefined'; }
            integer count = (integer) ar.get('expr0');

            r.Items.add(new Nomination(state, count));
            r.Total += count;
        }


        r.Items.add(new Nomination('Total Number of Nomination Forms', r.Total));

        return r;
    }
}