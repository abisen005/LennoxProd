public class VendavoAgreementsSync {

    /*******************************************************************************************************
* @description Get unsynced agreements from vendavo api, create salesforce deals, update those
*              agreements with the salesforce id and VVersionNumber so the sync happens automatically
*              in the future.
* @return void
* @example
* VendavoAgreementsSync.syncAgreements()
*/
    public static List<Vendavo__Deal__c> syncAgreements(Integer pageNumber) {
        Vendavo_API_Credentials__c vendavoSettings = Vendavo_API_Credentials__c.getInstance();
        Integer perPage = vendavoSettings.Agreement_Callout__c != NULL ? Integer.valueOf(vendavoSettings.Agreement_Callout__c) : 500;
        List<Vendavo__Deal__c> newDeals = new List<Vendavo__Deal__c>();
        Map<String, List<AgreementsWrapperClasses.Data>> customerNumberToAgreementsMap = new Map<String, List<AgreementsWrapperClasses.Data>>(); // customerNumber => agreementData List
        AgreementsWrapperClasses result = AgreementsWrapperClasses.parse(VendavoUtils.getAgreements(VendavoUtils.getAuthToken(), perPage, pageNumber));
        
        for(Integer i = 0; i < result.data.size(); i++) {
            String customerNumber = result.data[i].VCustomerSalesData.VCustomer.VName;
            if(customerNumberToAgreementsMap.get(customerNumber) == null) {
                customerNumberToAgreementsMap.put(customerNumber, new List<AgreementsWrapperClasses.Data>());
            }
            // Agreements where VIsLatestRevision is false can not be updated;  don't add them to new Deals list.
            if(result.data[i].VIsLatestRevision) {
                // only add deals created in the last X days
                Integer cutoffDays = vendavoSettings.Created_Date_Cutoff__c != null ? Integer.valueOf(vendavoSettings.Created_Date_Cutoff__c) : 30;
                if(isCreatedAfterCutoff(result.data[i].created, cutoffDays)) {
                    System.debug('im being added');
                    customerNumberToAgreementsMap.get(customerNumber).add(result.data[i]);
                }
            }
        }

        System.debug('how big is it?' + customerNumberToAgreementsMap.size());
        if(!customerNumberToAgreementsMap.isEmpty()) {
            newDeals = createNewSalesforceDeals(customerNumberToAgreementsMap);
        }

        if(!newDeals.isEmpty()) {
            return newDeals;
        } else {
            return null;
        }

    }

    /*
     * created - expecting this format '09/09/2015 03:03:29 -0500'
     * 
     */    
    private static Boolean isCreatedAfterCutoff(String created, Integer numDays) {
        try {
            List<String> dateValues = created.substringBefore(' ').split('/'); // MM, DD, YYYY
            Date createdDate = Date.newInstance(Integer.valueOf(dateValues[2]), Integer.valueOf(dateValues[0]), Integer.valueOf(dateValues[1]));
            return createdDate.daysBetween(System.today()) <= numDays;
        } catch(Exception e) {
            return true;
        }

    }


    



    /*******************************************************************************************************
* @description Create salesforce deals from Vendavo Agreements
* @param customerNumberToAgreementsMap Map of customer numbers and agreements from API result
* @return List<Vendavo__Deal__c>
* @example
* newDeals = createNewSalesforceDeals(customerNumberToAgreementsMap);
*/
    public static List<Vendavo__Deal__c> createNewSalesforceDeals(Map<String, List<AgreementsWrapperClasses.Data>> customerNumberToAgreementsMap) {

        List<Vendavo__Deal__c> newDeals = new List<Vendavo__Deal__c>();
        for(Account a : [SELECT Id, Customer_Number_with_leading_zeros__c, OwnerId
                         FROM Account
                         WHERE Customer_Number_with_leading_zeros__c IN : customerNumberToAgreementsMap.keySet() AND Owner.VendavoUID__c != NULL AND Owner.Vendavo__VendavoID__c != NULL] ) {
            for(AgreementsWrapperClasses.Data agreement : customerNumberToAgreementsMap.get(a.Customer_Number_with_leading_zeros__c)) {
                if(agreement.VState.VName == 'approved') { //only sync unsynced, approved deals
                    Vendavo__Deal__c newDeal = new Vendavo__Deal__c(
                        Name = agreement.VID.substringBeforeLast('-'),
                        Vendavo__VNumber__c = agreement.VID.substringBeforeLast('-'),
                        Vendavo__VID__c = agreement.VID,
                        Vendavo__Channel_Label__c = agreement.VCustomerSalesData.VSalesArea.VChannel.VLabel,
                        Vendavo__ChannelID__c = agreement.VCustomerSalesData.VSalesArea.VChannel.VName, //id in result doesn't look the same as existing deals,
                        Vendavo__CustomerID__c = agreement.VCustomerSalesData.VCustomer.VName,
                        Vendavo__DealType__c = agreement.type,
                        Vendavo__Division_Label__c = agreement.VCustomerSalesData.VSalesArea.VDivision.VLabel,
                        Vendavo__DivisionID__c = agreement.VCustomerSalesData.VSalesArea.VDivision.VName, //id in result doesn't look the same as existing deals,
                        Vendavo__EndCustomer__c = agreement.VCustomerSalesData.displayName,
                        Vendavo__LastSynced__c = System.Now(),
                        Vendavo__ParentId__c = a.Id,
                        Vendavo__SalesOrg_Label__c = agreement.VCustomerSalesData.VSalesArea.VSalesOrg.VName,
                        Vendavo__SalesOrgID__c = agreement.VCustomerSalesData.VSalesArea.VSalesOrg.VName,
                        Vendavo__VSoldTo__c = a.Id,
                        OwnerId = a.OwnerId,
                        Vendavo__VVersionNumber__c = String.valueOf(agreement.VVersionNumber),
                        VendavoId__c = agreement.id,
                        Vendavo__StartDate__c = VendavoUtils.getDateVal(agreement.VValidity.fromDate),
                        Vendavo__EndDate__c = VendavoUtils.getDateVal(agreement.VValidity.to),
                        Vendavo__DealScore__c = agreement.VScore,
                        Vendavo__Description__c = agreement.Description,
                        Vendavo__Status__c = agreement.VState.VName,
                        Vendavo__TotalPocketPrice__c = agreement.VWaterfall.VPocketPrice.Amount,
                        CDQ_Type__c = agreement.CDQType.VName,
                        CDQ_Revenue__c = agreement.CDQRevenue.Amount,
                        Impact__c = agreement.Impact.Amount,
                        Workflow_Owner__c = agreement.VWorkflowOwner.VName,
                        Sales_Office__c = agreement.SalesOffice.VName,
                        Sales_Group__c = agreement.SalesGroup.VName,
                        Market_Segment__c = agreement.MarketSegment == null ? null : agreement.MarketSegment.VName,
                        ProjectNumber__c = agreement.ProjectNumber,
                        Vendavo__TotalRevenue__c = agreement.SupportedPrice.Amount,
                        Vendavo__Variable_Pocket_Margin__c = agreement.VWaterfall.VariablePocketMargin.Amount
                    );
                    system.debug(agreement);
                    newDeals.add(newDeal);
                }
            }
        }
        try {

            /*for(Integer i = 0; i < newDeals.size(); i++) {
                if(newDeals[i].Vendavo__VID__c.length() > 13) {
                    newDeals.remove(i);
                }
            }*/
            Database.UpsertResult[] upsertResult = Database.upsert(newDeals, Vendavo__Deal__c.Fields.Vendavo__VNumber__c, false);
            System.debug('Upsert Result: ' + upsertResult);
            return newDeals;
        } catch(DmlException e) {
            //what do we do if it didn't work?
            System.debug('nds: ' + newDeals.size());
            system.debug('dml error: ' + e.getMessage());
            return null;
        }

    }

}