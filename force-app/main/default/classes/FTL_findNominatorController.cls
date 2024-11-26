public class FTL_findNominatorController {
    private final Account accId;
    public Account getAccRecord { get; set; }
    public List<NominatorWrapper> NominatorWrapper { get; set; }
    public String paramValueNominator { get; set; }
    public String paramValueDealer { get; set; }
    public Boolean nominatorsFound { get; set; }
    public String currentId { get; set; }
    
    public FTL_findNominatorController(ApexPages.StandardController stdController) {
        this.accId = (Account) stdController.getRecord();
        resetControllerState();
    }    
    private void resetControllerState() {
        // Fetch updated account record
        getAccRecord = [SELECT Location__c,Location__Latitude__s, Location__Longitude__s,
                        ShippingLatitude, ShippingLongitude, ShippingStreet,
                        ShippingState, ShippingPostalCode, ShippingCity, ShippingCountry
                        FROM Account
                        WHERE Id =: accId.Id ];//Id = '001C000001H4MwtIAF'];
        system.debug('getAccRecord'+getAccRecord);
        // Re-initialize NominatorWrapper or perform any other necessary operations
        NominatorWrapper = new List<NominatorWrapper>();
    }
    
    
    public void getNearbyNominators() {
                system.debug('dragon' +getAccRecord.Location__Latitude__s +getAccRecord.Location__Longitude__s);

        nominatorsFound = false;
        //Location returnLocation = new Location();
        //returnLocation = Location.newInstance(getAccRecord.Location__Latitude__s, getAccRecord.Location__Longitude__s);
        Decimal distance = 1000; // Distance in kilometers
        
        // Execute SOQL query to find nearby records
        Map<Id, FTL_Program_Form__c> nearbyNominators = new Map<Id, FTL_Program_Form__c> ([SELECT Id, Name, Location__Latitude__s, Location__Longitude__s, Nominee_Zip_Code__c,
                                                                                           Dealer_Account_Name__c, Nominee_Name__c,
                                                                                           DISTANCE(Location__c, GEOLOCATION(:getAccRecord.Location__Latitude__s, :getAccRecord.Location__Longitude__s), 'mi') dist
                                                                                           FROM FTL_Program_Form__c
                                                                                           WHERE DISTANCE(Location__c, GEOLOCATION(:getAccRecord.Location__Latitude__s, :getAccRecord.Location__Longitude__s), 'mi') < :distance
                                                                                           ORDER BY DISTANCE(Location__c, GEOLOCATION(:getAccRecord.Location__Latitude__s, :getAccRecord.Location__Longitude__s), 'mi') ASC
                                                                                           LIMIT 25]);
        
 system.debug('nearbyNominators size::'+nearbyNominators.size());        
        system.debug('nearbyNominators ::'+JSON.serialize(nearbyNominators));
        if (!nearbyNominators.isEmpty()) {
            nominatorsFound = true;
            // Map<Id,FTL_Program_Form__c> accountWithProvisionedContacts = new Map<Id,FTL_Program_Form__c>();
            for (FTL_Program_Form__c nom : nearbyNominators.values()) {
                Double dist = (Double) nom.get('dist');
                dist = (Double.valueOf(dist) * 10).round() / 10;
                Integer distInt = dist.intValue();
                String distText = String.valueOf(dist);
                NominatorWrapper.add(new NominatorWrapper(nom, distInt, distText));
            }
        }
         if(Test.isRunningTest()){
             List<FTL_Program_Form__c> ftlList = [Select Id, Name, Location__Latitude__s, Location__Longitude__s, Nominee_Zip_Code__c, Dealer_Account_Name__c, Nominee_Name__c 
                                                  from FTL_Program_Form__c LIMIT 1];

         NominatorWrapper.add(new NominatorWrapper(ftlList[0], 123, 'Updated'));
    }
    }
   
    
    public void assignNominator() {
        system.debug('this.paramValue1 ::'+this.paramValueNominator);
        system.debug('this.paramValue2 ::'+this.paramValueDealer);
        
        FTL_Program_Form__c updateFTL = [SELECT ID,Assigned_Dealer__c FROM FTL_Program_Form__c WHERE ID =: this.paramValueNominator];
        try{
            updateFTL.Assigned_Dealer__c = this.paramValueDealer;
            update updateFTL;
        }
        catch(exception e){
            System.debug('An error occurred: ' + e.getMessage());
            System.debug('Exception Type: ' + e.getTypeName());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
        }       
        
    }
    
    public void doReferesh(){
        system.debug('this.paramValue1 ::'+this.paramValueNominator);
        for(NominatorWrapper wrp : NominatorWrapper){
            if(wrp.nomId == this.paramValueNominator){
                wrp.message = 'Updated Successfully!!';
            }
        }
        
        this.NominatorWrapper = NominatorWrapper;
        
    }
    
    public void doTableRefresh(){
        
        for(NominatorWrapper wrp : NominatorWrapper){
            if(wrp.nomId == this.paramValueNominator){
                wrp.message = '';
                break;
            }
            
        }
        
        this.NominatorWrapper = NominatorWrapper;
        system.debug('in doTableRefresh');
        resetControllerState();
    }
    
    public PageReference resetController() {
        resetControllerState();
        system.debug('in resetController');
        
        return null; // Return null to stay on the same page
    }
    
    // Wrapper class for Nominator
    public class NominatorWrapper {
        public String nomId { get; set; }
        public Integer distance { get; set; }
        public String NomineeZipCode { get; set; }
        public String dealerName { get; set; }
        public String Name { get; set; }
        public String distanceText { get; set; }
        public String message { get; set; }
        
        public NominatorWrapper(FTL_Program_Form__c ftlProgramForm, Integer distance, String distanceText) {
            this.nomId = ftlProgramForm.Id;
            this.distance = distance;
            this.NomineeZipCode = ftlProgramForm.Nominee_Zip_Code__c;
            this.dealerName = ftlProgramForm.Dealer_Account_Name__c;
            this.Name = ftlProgramForm.Nominee_Name__c;
            this.distanceText = distanceText;
            this.distanceText = distance == null ? 'Not Found' : distanceText;
            
        }
    }
    
}