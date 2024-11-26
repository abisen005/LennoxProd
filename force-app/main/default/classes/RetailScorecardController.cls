public class RetailScorecardController {

    public String level {get;set;} // dealer, territory, district, region, executive
    public String id {get;set;} // if dealer: account id, territory: territory id, district: district id, region: region id, exec: null
    private String retailType {get; set;}
    public Retail_Scorecard_Targets__c targets {get;set;}
    public String yearVal {get;set;}
    public String period {get;set;}
    public Decimal curAvgSalesStoreTarget {get;set;} //ytd target
    public Decimal curPeriodSalesTarget {get;set;}

    public retailTypeDetails retailInfo {get;set;}
    public retailWrappers.retailSummaryData districtSummaryData {get;set;}

    public Map<String, retailWrappers.retailSummaryData> groupSummaryMap {get;set;}
    public Map<String, Map<String, Map<String, Map<String, List<String>>>>> internalAlignmentMap {get;set;}
    public Map<String, Map<String, List<String>>> externalAlignmentMap {get;set;}
    public Map<String, String> dealerStoreValuesMap {get;set;} //is this needed after adding the set below?
    public Set<String> storeDistricts {get;set;}

    public Account dealer {get;set;}
    //public String lastUpdated {get;set;}
    public String splitBarChartString {get;set;}
    public List<Retail_Sales_Tracker__c> storeData {get;set;}
    public retailWrappers.retailSummaryData storeSummaryData {get;set;}
    public retailWrappers.retailSummaryData periodStoreSummaryData {get;set;} //costco only

    public Boolean noDealerData {get;set;}
    public String sSplitBarChartString;


    // Dealer info not available yet
    // pass the retail region value + the retail district value; will return the wrapper object

    public RetailScorecardController() {
        level = ApexPages.currentPage().getParameters().get('level');
        id = ApexPages.currentPage().getParameters().get('id');
        retailType = ApexPages.currentPage().getParameters().get('type');
        String salesOrg = [SELECT SAP_Sales_Org__c FROM Account WHERE Id = :id LIMIT 1].SAP_Sales_Org__c;
        retailInfo = new retailTypeDetails(retailType, salesOrg);
        String retailerType = retailInfo.label.substringBeforeLast('-');
        targets = Retail_Scorecard_Targets__c.getValues(retailInfo.Label);
        noDealerData = false;
        System.debug(targets);
        period = currentPeriod();
        yearVal = currentYear();
        getSummaryData();
        System.debug('!groupSummaryMap.isEmpty() ' + !groupSummaryMap.isEmpty());
        if(!groupSummaryMap.isEmpty()) {
            if(level == 'dealer') {
                dealer = [SELECT Id, SAP_Customer_Number__c, Name, SAP_Sales_Office_Desc__c, SAP_Sales_Office__c, SAP_Sales_Group__c, OwnerId,
                          SAP_Sales_District__c, Costco_Escalation_to_Lead_Ratio__c, Costco_Mix_Index__c,
                          (SELECT Store_District__c, Store_Region_Name__c FROM Retail_Sales_Tracker__r WHERE Retailer__c = :retailerType LIMIT 1)
                          FROM Account
                          WHERE Id = :id
                          LIMIT 1];
            }
            getStoreData();
            getSplitBarChartData();
            //getCostcoSelfGenLeadData();
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This dealer has no retail data.'));
        }
    }

    public String getLastUpdated() {
        String retailerType = retailInfo.label.substringBeforeLast('-');
        System.debug('getLastUpdated: ' + retailerType );
        Retail_Sales_Tracker__c rst =  [SELECT Last_Updated__c FROM Retail_Sales_Tracker__c WHERE Retailer__c = :retailerType AND Last_Updated__c != NULL ORDER BY Last_Updated__c DESC LIMIT 1];
        System.debug(rst);
        if(rst != null) {
            return rst.Last_Updated__c.format();
        } else {
            return null;
        }
    }

    public String getPeriodInfo() {
        //Retailer REgion Name will equal CN if the == true
        //TODO; Store_Region_Name__c == CN if Canada; != CN if not
        String region = retailInfo.label.substringAfterLast('-'); //CN or other value
        String retailerType = retailInfo.label.substringBeforeLast('-');
        Id dealerId = dealer.Id;
        Retail_Sales_Tracker__c rst = [SELECT Period__c
                                       FROM Retail_Sales_Tracker__c
                                       WHERE Retailer__c = :retailerType AND Period__c LIKE '%period%' AND Dealer__c = :dealerId
                                       LIMIT 1];
        if(rst != null) {
            return rst.Period__c;
        } else {
            return null;
        }
    }

    String currentYear() {
        String retailerType = retailInfo.label.substringBeforeLast('-');
        AggregateResult year = [SELECT Year__c y
                                FROM Retail_Sales_Tracker__c
                                WHERE Retailer__c = :retailerType AND Year__c != NULL
                                GROUP BY Year__c
                                ORDER BY Year__c DESC
                                LIMIT 1];
        return (String)year.get('y');
    }

    String currentPeriod() {
        String retailerType = retailInfo.label.substringBeforeLast('-');
        AggregateResult period = [SELECT Sales_Curve_Period__c p
                                  FROM Retail_Sales_Tracker__c
                                  WHERE Retailer__c = :retailerType AND Sales_Curve_Period__c != NULL
                                  GROUP BY Sales_Curve_Period__c
                                  ORDER BY Sales_Curve_Period__c DESC
                                  LIMIT 1];
        return (String)period.get('p');
    }

    Decimal periodTarget(String period) {
        //determine target for period by subtracting prior periods percentage value
        //from current period percentage value and multiplying the result
        //by the annual stores goal.
        //If period value is 1, subtract by 13 value (if 13 is not null); if 13 is null, subtract by 12 value
        //If the result is negative (i.e. 5 - 95), use the current period value
        Integer priorPeriodInteger;
        String priorPeriodString;
        String priorPeriodTargetFieldName;
        String currentPeriodTargetFieldName;
        Decimal priorPeriodTargetPercentage;
        Decimal currentPeriodTargetPercentage;
        Decimal periodTargetPercentage;

        try {
            priorPeriodInteger = Integer.valueOf(period) - 1;
            System.debug('priorPeriodInteger');
            System.debug(priorPeriodInteger);
            if(priorPeriodInteger == 0) {
                if(targets.X13_YTD_Sales_Store_Target__c != NULL) {
                    priorPeriodString = '13';
                } else if(targets.X12_YTD_Sales_Store_Target__c != NULL) {
                    priorPeriodString = '12';
                } else {
                    String errorMsg = 'There is a problem with the Retail Scorecard Targets custom setting for this retail type.  Please check that the target values are correctly entered.';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, errorMsg));
                    return null;
                }
            } else {
                priorPeriodString = String.valueOf(priorPeriodInteger);
            }
            priorPeriodTargetFieldName = 'X' + priorPeriodString + '_YTD_Sales_Store_Target__c';
            currentPeriodTargetFieldName = 'X' + period + '_YTD_Sales_Store_Target__c';
            priorPeriodTargetPercentage = (Decimal)targets.get(priorPeriodTargetFieldName);
            currentPeriodTargetPercentage = (Decimal)targets.get(currentPeriodTargetFieldName);
            periodTargetPercentage = currentPeriodTargetPercentage - priorPeriodTargetPercentage < 0 ? currentPeriodTargetPercentage : currentPeriodTargetPercentage - priorPeriodTargetPercentage;
            return (targets.Average_Sales_Store_Target__c * periodTargetPercentage) / 100;
        } catch(TypeException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
            return null;
        }

    }

    public void getSummaryData() {

        System.debug('getSummaryData');

        groupSummaryMap = new Map<String, retailWrappers.retailSummaryData>();
        internalAlignmentMap = new Map<String, Map<String, Map<String, Map<String, List<String>>>>>();
        externalAlignmentMap = new Map<String, Map<String, List<String>>>();
        dealerStoreValuesMap = new Map<String, String>();
        String retailerType = retailInfo.label.substringBeforeLast('-');
        //get current average sales per store target
        String targetFieldName = 'X' + period + '_YTD_Sales_Store_Target__c';
        System.debug('targetFieldName: ' + targetFieldName);
        System.debug('targets: ' + targets);
        Decimal curTargetPercentage = targets != null ? (Decimal)targets.get(targetFieldName) : 0;
        System.debug('curTargetPercentage: ' + curTargetPercentage);
        curAvgSalesStoreTarget = (targets.Average_Sales_Store_Target__c * curTargetPercentage) / 100;
        curPeriodSalesTarget = periodTarget(period);

        for(Retail_Sales_Tracker__c rst : [SELECT Store_Name__c, Id, Store_Number__c, Year__c, Period__c, Total_Leads__c, YTD_Leads__c, YTD_In_Homes__c, Lead_to_Proposal_Spill_Rate__c,
        YTD_Proposals__c, Lead_to_Proposal_Rate__c, YTD_Proposals_Closed__c, Proposal_Close_Rate__c, YTD_Sales__c, PY_YTD_Sales__c, Self_Generated_Leads__c, Installs__c,
        YTD_Change__c, YTD_Change_per__c, Dealer__r.SAP_Sales_District__c, Dealer__r.SAP_Sales_Office__c, Dealer__r.SAP_Sales_Group__c, Annual_Store_Goal__c, Store_District__c, Store_Region_Name__c
        FROM Retail_Sales_Tracker__c WHERE Retailer__c = :retailerType AND Year__c = :yearVal]){

            if(internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c) == null) //Internal Region
            internalAlignmentMap.put(rst.Dealer__r.SAP_Sales_District__c, new Map<String, Map<String, Map<String, List<String>>>>());

            if(internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c) == null) //Internal District
            internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).put(rst.Dealer__r.SAP_Sales_Office__c, new Map<String, Map<String, List<String>>>());

            if(internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c).get(rst.Dealer__r.SAP_Sales_Group__c) == null) //Internal Territory
            internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c).put(rst.Dealer__r.SAP_Sales_Group__c, new Map<String, List<String>>());

            if(internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c).get(rst.Dealer__r.SAP_Sales_Group__c).get(rst.Dealer__c) == null) //Internal Dealer
            internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c).get(rst.Dealer__r.SAP_Sales_Group__c).put(rst.Dealer__c, new List<String>());

            if(externalAlignmentMap.get(rst.Store_Region_Name__c) == null) //External Region
            externalAlignmentMap.put(rst.Store_Region_Name__c, new Map<String, List<String>>());

            if(externalAlignmentMap.get(rst.Store_Region_Name__c).get(rst.Store_District__c) == null) //External District
            externalAlignmentMap.get(rst.Store_Region_Name__c).put(rst.Store_District__c, new List<String>());

            if(!rst.Period__c.contains('Period')){
                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c) == null) //Internal Region Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c) == null) //Internal District Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c) == null) //Internal Territory Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c) == null) //Internal Dealer Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Store_Region_Name__c) == null) // External Region Summary
                    groupSummaryMap.put(rst.Store_Region_Name__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Store_Region_Name__c + rst.Store_District__c) == null) //External District Summary
                    groupSummaryMap.put(rst.Store_Region_Name__c + rst.Store_District__c, new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));
            }

            if(rst.Period__c.contains('Period')){
                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + 'P') == null) //Internal Region Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + 'P') == null) //Internal District Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + 'P') == null) //Internal Territory Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c + 'P') == null) //Internal Dealer Summary
                    groupSummaryMap.put(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Store_Region_Name__c + 'P') == null) // External Region Summary
                    groupSummaryMap.put(rst.Store_Region_Name__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));

                if(groupSummaryMap.get(rst.Store_Region_Name__c + rst.Store_District__c + 'P') == null) //External District Summary
                    groupSummaryMap.put(rst.Store_Region_Name__c + rst.Store_District__c + 'P', new retailWrappers.retailSummaryData(0, 0, 0, 0, 0, 0, 0, 0, 0, curAvgSalesStoreTarget, false, null));
            }

            internalAlignmentMap.get(rst.Dealer__r.SAP_Sales_District__c).get(rst.Dealer__r.SAP_Sales_Office__c).get(rst.Dealer__r.SAP_Sales_Group__c).get(rst.Dealer__c).add(rst.Store_Number__c);
            externalAlignmentMap.get(rst.Store_Region_Name__c).get(rst.Store_District__c).add(rst.Store_Number__c);

            if(!rst.Period__c.contains('Period')){
                System.debug('setting non period data: ' + rst.YTD_In_Homes__c);
                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c,
                rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c,
                rst.YTD_In_Homes__c, rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c,
                rst.YTD_In_Homes__c, rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                System.debug(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c);
                System.debug(groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c));

                groupSummaryMap.get(rst.Store_Region_Name__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Store_Region_Name__c + rst.Store_District__c).addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);
            }

            if(rst.Period__c.contains('Period')){

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c,
                rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c,
                rst.YTD_In_Homes__c, rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Dealer__r.SAP_Sales_District__c + rst.Dealer__r.SAP_Sales_Office__c + rst.Dealer__r.SAP_Sales_Group__c + rst.Dealer__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c,
                rst.YTD_In_Homes__c, rst.YTD_Proposals__c, rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Store_Region_Name__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);

                groupSummaryMap.get(rst.Store_Region_Name__c + rst.Store_District__c + 'P').addVals(rst.Total_Leads__c, rst.YTD_Leads__c, rst.YTD_In_Homes__c, rst.YTD_Proposals__c,
                rst.YTD_Proposals_Closed__c, rst.YTD_Sales__c, rst.PY_YTD_Sales__c, rst.Annual_Store_Goal__c, rst.Self_Generated_Leads__c, rst.Installs__c);
            }

            if(dealerStoreValuesMap.get(rst.Dealer__c) == null)
            dealerStoreValuesMap.put(rst.Dealer__c, rst.Store_Region_Name__c + ':' + rst.Store_District__c);
            System.debug('end loop');
        }
        for(String s : groupSummaryMap.keyset()){
            groupSummaryMap.get(s).calcRatios();
            System.debug('s: ' + groupSummaryMap.get(s));
        }
        System.debug('@@@ Made it to the end of getSummaryData!');
    }

    public void getStoreData() {
        if(retailType == 'lowes') {
            storeData = [SELECT Id, Store_Name__c, Store_Number__c, Store_District__c, Year__c, Period__c, YTD_Leads__c, YTD_Proposals__c,
                                Lead_to_Proposal_Spill_Rate__c, YTD_Proposals_Closed__c, Proposal_Close_Rate__c, YTD_Sales__c, PY_YTD_Sales__c, YTD_Change__c,
                                YTD_Change_per__c, Annual_Store_Goal__c, to_Annual_Store_Goal__c, YTD_In_Homes__c,  Lead_to_IH_Spill_Rate__c
                         FROM Retail_Sales_Tracker__c
                         WHERE Retailer__c = :retailInfo.label AND Year__c = :yearVal AND Dealer__c = :dealer.Id
                         ORDER BY YTD_Change__c DESC];
            storeDistricts = new Set<String>();
            for(Retail_Sales_Tracker__c rts : storeData) {
                storeDistricts.add(rts.Store_District__c);
            }
            storeSummaryData = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id);
            if(storeData.size() > 0)
                storeSummaryData.setPerformanceRating(storeData.size());
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'This dealer has no sales data.'));
                noDealerData = true;
                System.debug('@@@ No dealer data was hit');
            }
        } else if(retailType.contains('costco')) {
            Integer storeCount = [SELECT COUNT() FROM Retail_Sales_Tracker__c WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal AND Period__c LIKE '%YTD%'];
            storeSummaryData = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id);
            periodStoreSummaryData = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id + 'P');
            if(storeCount > 0) {
                storeSummaryData.setPerformanceRating(storeCount);
            }
        }
    }

    public Map<String, List<Retail_Sales_Tracker__c>> getCostcoStoreData() {
        Map<String, List<Retail_Sales_Tracker__c>> storeData = new  Map<String, List<Retail_Sales_Tracker__c>>();
        System.debug('getCCStoreDate. yearVal: ' + yearVal);
        Retail_Sales_Tracker__c[] rst = [SELECT Name, Id, Store_Number__c, Total_Leads__c, YTD_Leads__c, Self_Generated_Leads__c, Self_Generated_Leads_Percent__c, Installs__c, Lead_to_Install_Percent__c, YTD_Sales__c,
                                         PY_YTD_Sales__c, YTD_Change__c, YTD_Change_per__c, Annual_Store_Goal__c, to_Annual_Store_Goal__c, Period__c
                                         FROM Retail_Sales_Tracker__c
                                         WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal
                                         ORDER BY YTD_Change__c DESC];
        for(Integer i = 0; i < rst.size(); i++) {
            if(storeData.get(rst[i].Period__c) == null) {
                storeData.put(rst[i].Period__c, new List<Retail_Sales_Tracker__c>());
            }
            storeData.get(rst[i].Period__c).add(rst[i]);
        }
        List<String> periods = new List<String>();
        periods.addAll(storeData.keySet());
        for(Integer x = 0; x < periods.size(); x++) {
            for(Integer i = 0; i < storeData.get(periods[x]).size(); i++) {
                if(storeData.get(periods[x])[i].Name.contains('Business Center')) {
                    Retail_Sales_Tracker__c bcStore = storeData.get(periods[x]).remove(i);
                    storeData.get(periods[x]).add(bcStore);
                }
            }
        }
        for(Integer x = 0; x < periods.size(); x++) {
            for(Integer i = 0; i < storeData.get(periods[x]).size(); i++) {
                if(storeData.get(periods[x])[i].Store_Number__c == '847') {
                    Retail_Sales_Tracker__c onlineStore = storeData.get(periods[x]).remove(i);
                    storeData.get(periods[x]).add(onlineStore);
                }
            }
        }
        return storeData;
    }

    public List<retailWrappers.retailChartValue> getProposalCloseRates() {
        List<retailWrappers.retailChartValue> result = new List<retailWrappers.retailChartValue>();
        if(level == 'dealer') {
            if(retailType == 'lowes') {
                String stReg = dealerStoreValuesMap.get(dealer.Id).split(':')[0];
                retailWrappers.retailSummaryData rsd;

                rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id);
                result.add(new retailWrappers.retailChartValue(dealer.Name, rsd.proposalCloseRatio));

                 //Iterate through
                /*if(!storeDistricts.isEmpty()) {
                    for(String district : storeDistricts) {
                        rsd = groupSummaryMap.get(stReg + district);
                        result.add(new retailWrappers.retailChartValue(retailInfo.label + ' District ' + district , rsd.proposalCloseRatio));
                    }
                }*/


                rsd = groupSummaryMap.get(stReg);
                result.add(new retailWrappers.retailChartValue(retailInfo.label + ' Region ' + stReg, rsd.proposalCloseRatio));

                rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c);
                result.add(new retailWrappers.retailChartValue('Lennox ' + dealer.SAP_Sales_District__c, rsd.proposalCloseRatio));
            }
        }
        return result;
    }

    public void getSplitBarChartData(){
        retailWrappers.retailSummaryData rsd;
        if(retailType == 'lowes') {
            splitBarChartString = '{data: [';
            if(level == 'dealer'){
                rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id);
                System.debug('dealerrsd: ' + rsd);
                splitBarChartString += '{label: \'' + dealer.Name.replace('\'', '\\\'') + '\', '
                    + 'rate: ' +  (rsd.inHomeSpillRatio != null ? rsd.inHomeSpillRatio / 100 : 0) + '},{'
                    + 'rate: ' + (rsd.inHomeConversionRatio != null ? rsd.inHomeConversionRatio / 100 : 0) + '}, ';
                String stReg = dealerStoreValuesMap.get(dealer.Id).split(':')[0];

                //Iterate through
               /* if(!storeDistricts.isEmpty()) {
                    for(String district : storeDistricts) {
                        rsd = groupSummaryMap.get(stReg + district);
                        splitBarChartString += '{label: \'' + retailInfo.label.replace('\'', '\\\'') + ' District ' + district + '\', ' + 'rate: ' +  (rsd.ldProposalSpillRatio / 100) + '},{' + 'rate: ' + (rsd.ldProposalRatio / 100) + '}, ';
                    }
                }*/
        System.debug('rsd debugging: ' + rsd);
                rsd = groupSummaryMap.get(stReg);
                System.debug('rsd debugging: ' + rsd);
                if(rsd != null) {
                    splitBarChartString += '{label: \'' + retailInfo.label.replace('\'', '\\\'') + ' Region ' + stReg + '\', '
                        + 'rate: ' +  (rsd.inHomeSpillRatio != null ? rsd.inHomeSpillRatio / 100 : 0) + '},{'
                        + 'rate: ' + (rsd.inHomeConversionRatio != null ? rsd.inHomeConversionRatio / 100 : 0) + '}, ';
                }
                rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c);
                if(rsd != null) {
                    splitBarChartString += '{label: \'Lennox ' + dealer.SAP_Sales_District__c.replace('\'', '\\\'') + '\', '
                        + 'rate: ' +  (rsd.inHomeSpillRatio != null ? rsd.inHomeSpillRatio / 100 : 0) + '},{'
                        + 'rate: ' + (rsd.inHomeConversionRatio != null ? rsd.inHomeConversionRatio / 100 : 0) + '}, ';
                }
            }

            splitBarChartString += '], targets: [' + (targets.Lead_to_In_home_Spill_Rate_Target__c / 100) + ', ' + (targets.Lead_to_In_Home_Conversion_Rate_Target__c / 100) + '], labels: [\'Spill Rate\', \'Conversion Rate\']}';
        }
    }


    public Map<String, List<Decimal>> getCostcoSelfGenLeadData() {
        Map<String, List<Decimal>> leadData = new Map<String, List<Decimal>>();
        String retailerType = 'Costco';
        String currentYear =  currentYear();
        Decimal totalYTDDealerLeads = 0;
        Decimal totalYTDDealerSelfGenLeads = 0;
        Decimal totalYTDLeads = 0;
        Decimal totalYTDSelfGenLeads = 0;
        Decimal totalPeriodDealerLeads = 0;
        Decimal totalPeriodDealerSelfGenLeads = 0;
        Decimal totalPeriodLeads = 0;
        Decimal totalPeriodSelfGenLeads = 0;
        String costcoRegion = '';
        for(Retail_Sales_Tracker__c rst :[SELECT Store_Region_Name__c FROM Retail_Sales_Tracker__c WHERE Dealer__c =: dealer.Id AND Retailer__c = :retailerType LIMIT 1]) {
            System.debug('@@@d' + rst.Store_Region_Name__c);
            costcoRegion = rst.Store_Region_Name__c;
        }
        //same query as getSummaryData but we're explicitly excluding online store (847)
        for(Retail_Sales_Tracker__c rst : [SELECT Id, Total_Leads__c, Self_Generated_Leads__c, Installs__c, Period__c, Dealer__r.Id, Store_Region_Name__c
                                           FROM Retail_Sales_Tracker__c
                                           WHERE Store_Region_Name__c = :costcoRegion AND Retailer__c = :retailerType AND Year__c = :currentYear AND Store_Number__c != '847']){
                                               Decimal totalLeads = rst.Total_Leads__c != NULL ? rst.Total_Leads__c : 0;
                                               Decimal totalSelfGenLeads = rst.Self_Generated_Leads__c != NULL ? rst.Self_Generated_Leads__c : 0;
                                               if(rst.Period__c.contains('Period')) {
                                                   if(rst.Dealer__r.Id == dealer.Id) {
                                                       totalPeriodDealerLeads += totalLeads;
                                                       totalPeriodDealerSelfGenLeads += totalSelfGenLeads;
                                                   }
                                                   totalPeriodLeads += totalLeads;
                                                   totalPeriodSelfGenLeads += totalSelfGenLeads;
                                               } else {
                                                   if(rst.Dealer__r.Id == dealer.Id) {
                                                       totalYTDDealerLeads += totalLeads;
                                                       totalYTDDealerSelfGenLeads += totalSelfGenLeads;
                                                   }
                                                   totalYTDLeads += totalLeads;
                                                   totalYTDSelfGenLeads += totalSelfGenLeads;
                                               }
                                            }
        Decimal periodDealerSelfGenLeadRatio = totalPeriodDealerLeads > 0 ? (totalPeriodDealerSelfGenLeads / totalPeriodDealerLeads) * 100 : 0;
        Decimal ytdDealerSelfGenLeadRatio = totalYTDDealerLeads > 0 ? (totalYTDDealerSelfGenLeads / totalYTDDealerLeads) * 100 : 0;
        Decimal periodSelfGenLeadRatio = totalPeriodLeads > 0 ? (totalPeriodSelfGenLeads / totalPeriodLeads) * 100 : 0;
        Decimal ytdSelfGenLeadRatio = totalYTDLeads > 0 ? (totalYTDSelfGenLeads / totalYTDLeads) * 100 : 0;
        leadData.put(dealer.Name, new List<Decimal>{periodDealerSelfGenLeadRatio, ytdDealerSelfGenLeadRatio});
        leadData.put('Costco Region - ' + costcoRegion, new List<Decimal>{periodSelfGenLeadRatio, ytdSelfGenLeadRatio});

        return leadData;
    }

    public List<Decimal> getCostcoLeadInstallRateData() {
        System.debug('getCostcoSelfGenLeadData');
        List<Decimal> leadData = new List<Decimal>();
        retailWrappers.retailSummaryData rsd;
        if(!noDealerData){
            if(retailType.contains('costco')) {
                if(level == 'dealer') {

                    //dealer level summary data
                    rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id + 'P');
                    if(rsd == null)
                        return null;
                    leadData.add(rsd.leadToInstallRatio);
                    rsd = groupSummaryMap.get(dealer.SAP_Sales_District__c + dealer.SAP_Sales_Office__c + dealer.SAP_Sales_Group__c + dealer.Id);
                    if(rsd == null)
                        return null;
                    leadData.add(rsd.leadToInstallRatio);

                    String storeRegion = dealerStoreValuesMap.get(dealer.Id).split(':')[0];
                    if(storeRegion != NULL && storeRegion != '') {
                        rsd = groupSummaryMap.get(storeRegion + 'P');
                        if(rsd == null)
                            return null;
                        leadData.add(rsd.leadToInstallRatio);
                        rsd = groupSummaryMap.get(storeRegion);
                        if(rsd == null)
                            return null;
                        leadData.add(rsd.leadToInstallRatio);
                    }

                }
            }
        }
        return leadData;
    }

    public List<summarySalesData> getCostcoSalesData() {
        List<summarySalesData> salesData = new List<summarySalesData>();
        String targetFieldName = 'X' + Date.today().month().format() + '_YTD_Sales_Store_Target__c';
        Decimal curTargetPercentage = (Decimal)targets.get(targetFieldName);
        Decimal curAvgSalesStoreTarget = (targets.Average_Sales_Store_Target__c * curTargetPercentage) / 100;
        Decimal curAvgProposalsStoreTarget = (targets.Average_Proposals_Closed_Store__c * curTargetPercentage) / 100;
        if(level == 'dealer') {
            for(Retail_Sales_Tracker__c rst :[SELECT Id, YTD_Sales__c,  PY_YTD_Sales__c, YTD_Proposals_Closed__c, YTD_Change__c
                                            FROM Retail_Sales_Tracker__c
                                            WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal AND Period__c LIKE '%period%']) {
                                            System.debug(rst);
                                            }
            AggregateResult[] retailData = [SELECT COUNT(Id)cnt, AVG(YTD_Sales__c)avg, SUM(YTD_Sales__c)sum, SUM(PY_YTD_Sales__c)pySUm, AVG(YTD_Proposals_Closed__c)avgClosed, SUM(YTD_Change__c)ytdChange
                                            FROM Retail_Sales_Tracker__c
                                            WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal AND Period__c LIKE '%period%'];
            System.debug('period retailData: ' + retailData);
            Boolean hasOnlineStore = ![SELECT Id FROM Retail_Sales_Tracker__c WHERE Dealer__c = :dealer.Id AND Store_Number__c = '847' LIMIT 1].isEmpty();
            Boolean hasBusinessCenter = ![SELECT Id FROM Retail_Sales_Tracker__c WHERE Dealer__c = :dealer.Id AND Name LIKE '%Business Center%' LIMIT 1].isEmpty();
            Decimal ytdChangePercentage = (Decimal)retailData[0].get('pySum') != 0 ? (Decimal)retailData[0].get('ytdChange') / (Decimal)retailData[0].get('pySum') : 0;
            //Add period data
            summarySalesData periodSalesData = new summarySalesData();
            periodSalesData.previousYtdSales = (Decimal)retailData[0].get('pySUm');
            periodSalesData.numStores = hasOnlineStore ? (Integer)retailData[0].get('cnt') - 1 : (Integer)retailData[0].get('cnt');
            periodSalesData.numStores = hasBusinessCenter ? periodSalesData.numStores - 1 : periodSalesData.numStores;
            periodSalesData.avgYtdSales = periodSalesData.numStores != 0 ? (Decimal)retailData[0].get('sum') / periodSalesData.numStores : 0;
            periodSalesData.avgMinTargetSales = curAvgSalesStoreTarget;
            periodSalesData.avgPercentToTargetSales = curAvgSalesStoreTarget != 0 ? (Decimal)retailData[0].get('avg') / curAvgSalesStoreTarget : 0;
            periodSalesData.ytdClosed = (Decimal)retailData[0].get('avgClosed');
            periodSalesData.minTargetClosed = curAvgProposalsStoreTarget;
            periodSalesData.percentToTargetClosed = curAvgProposalsStoreTarget != 0 ? (Decimal)retailData[0].get('avgClosed') / curAvgProposalsStoreTarget : 0;
            periodSalesData.ytdSales = (Decimal)retailData[0].get('sum');
            periodSalesData.minTargetSales = curAvgSalesStoreTarget * periodSalesData.numStores;
            periodSalesData.percentToTargetSales = (curAvgSalesStoreTarget * periodSalesData.numStores) != 0 ? (Decimal)retailData[0].get('sum') / (curAvgSalesStoreTarget * (Integer)retailData[0].get('cnt')) : 0;
            periodSalesData.ytdChangeSales = (Decimal)retailData[0].get('ytdChange');
            periodSalesData.ytdChangePercentage = ytdChangePercentage;
            periodSalesData.performanceRating = ytdChangePercentage > 0 && (Decimal)retailData[0].get('avg') >= curAvgSalesStoreTarget ? 'success' : ytdChangePercentage <= 0 && (Decimal)retailData[0].get('avg') < curAvgSalesStoreTarget ? 'danger' : 'warning';
            salesData.add(periodSalesData);

            retailData = [SELECT COUNT(Id)cnt, AVG(YTD_Sales__c)avg, SUM(YTD_Sales__c)sum, SUM(PY_YTD_Sales__c)pySUm, AVG(YTD_Proposals_Closed__c)avgClosed, SUM(YTD_Change__c)ytdChange
                          FROM Retail_Sales_Tracker__c
                          WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal AND Period__c LIKE '%YTD%'];
            for(Retail_Sales_Tracker__c rst :[SELECT Id, YTD_Sales__c,  PY_YTD_Sales__c, YTD_Proposals_Closed__c, YTD_Change__c
                                            FROM Retail_Sales_Tracker__c
                                            WHERE Dealer__c = :dealer.Id AND Retailer__c = 'Costco' AND Year__c = :yearVal AND Period__c LIKE '%YTD%']) {
                                            System.debug(rst);
                                            }
            System.debug('ytd retailData: ' + retailData);
            ytdChangePercentage = (Decimal)retailData[0].get('pySum') != 0 ? (Decimal)retailData[0].get('ytdChange') / (Decimal)retailData[0].get('pySum') : 0;
            //Add period data
            summarySalesData ytdSalesData = new summarySalesData();
            ytdSalesData.previousYtdSales = (Decimal)retailData[0].get('pySUm');
            ytdSalesData.numStores = periodSalesData.numStores;
            ytdSalesData.avgYtdSales = ytdSalesData.numStores != 0 ? (Decimal)retailData[0].get('sum') / ytdSalesData.numStores : 0;
            ytdSalesData.avgMinTargetSales = curAvgSalesStoreTarget;
            ytdSalesData.avgPercentToTargetSales = curAvgSalesStoreTarget != 0 ? (Decimal)retailData[0].get('avg') / curAvgSalesStoreTarget : 0;
            ytdSalesData.ytdClosed = (Decimal)retailData[0].get('avgClosed');
            ytdSalesData.minTargetClosed = curAvgProposalsStoreTarget;
            ytdSalesData.percentToTargetClosed = curAvgProposalsStoreTarget != 0 ? (Decimal)retailData[0].get('avgClosed') / curAvgProposalsStoreTarget : 0;
            ytdSalesData.ytdSales = (Decimal)retailData[0].get('sum');
            ytdSalesData.minTargetSales = curAvgSalesStoreTarget * ytdSalesData.numStores;
            ytdSalesData.percentToTargetSales = (curAvgSalesStoreTarget * ytdSalesData.numStores) != 0 ? (Decimal)retailData[0].get('sum') / (curAvgSalesStoreTarget * (Integer)retailData[0].get('cnt')) : 0;
            ytdSalesData.ytdChangeSales = (Decimal)retailData[0].get('ytdChange');
            ytdSalesData.ytdChangePercentage = ytdChangePercentage;
            ytdSalesData.performanceRating = ytdChangePercentage > 0 && (Decimal)retailData[0].get('avg') >= curAvgSalesStoreTarget ? 'success' : ytdChangePercentage <= 0 && (Decimal)retailData[0].get('avg') < curAvgSalesStoreTarget ? 'danger' : 'warning';
            salesData.add(ytdSalesData);
        }
        return salesData;
    }


    //use this method
    /*public Decimal getYTDTarget() {
        Decimal ytdTarget = targets.Average_Sales_Store_Target__c * (targets.);
        return 0;
    }*/

    public class retailTypeDetails {
        public String type {get; set;}
        public String img {get;set;}
        public String label {get;set;}
        public Boolean fyFlag {get;set;} //indicates if the year should be incremented for custom FY

        private Map<String, String> typeImageMap = new Map<String, String>{'lowes' => 'LowesLogo150',
                                                                           'homeDepot' => 'hdlogo',
                                                                           'costco' => 'costcoLogo',
                                                                           'costco-us' => 'costcoLogo',
                                                                           'costco-ca' => 'costcoLogo'};
        private Map<String, String> typeLabelMap = new Map<String, String>{'lowes' => 'Lowe\'s',
                                                                           'homeDepot'=> 'Home Depot',
                                                                           'costco'=> 'Costco',
                                                                           'costco-us'=> 'Costco-US',
                                                                           'costco-ca'=> 'Costco-CA'};
        public RetailTypeDetails(String retailtype, String salesOrg) {
            type = retailtype;
            if(type == 'costco') {
                if(salesOrg == 'LXUS') {
                    type = 'costco-us';
                } else if(salesOrg == 'LXCA') {
                    type = 'costco-ca';
                }
            }
            img = typeImageMap.get(type);
            label = typeLabelMap.get(type);
            fyFlag = false;
            try{
                for(Retail_Scorecard_Targets__c cs : [SELECT Fiscal_Year_Start_Month__c from Retail_Scorecard_Targets__c WHERE Name = :label]){
                    System.debug('@@@ Custom Setting: ' + cs);
                    if(cs.Fiscal_Year_Start_Month__c!= null && cs.Fiscal_Year_Start_Month__c <= Integer.valueOf(System.today().month())) {
                        fyFlag = true;
                    }
                }
            }catch(Exception ex){
                System.debug('@@@ There was an exception in retail type details: ' + ex + ' Line: ' + ex.getLineNumber());
            }
        }
    }

    public class summarySalesData {
        public Integer numStores {get;set;}
        public Decimal avgYtdSales {get;set;}
        public Decimal avgMinTargetSales {get;set;}
        public Decimal avgPercentToTargetSales {get;set;}
        public Decimal ytdClosed {get;set;}
        public Decimal minTargetClosed {get;set;}
        public Decimal percentToTargetClosed {get;set;}
        public Decimal ytdSales {get;set;}
        public Decimal previousYtdSales {get;set;}
        public Decimal minTargetSales {get;set;}
        public Decimal percentToTargetSales {get;set;}
        public Decimal ytdChangeSales {get;set;}
        public Decimal ytdChangePercentage {get;set;}
        public String performanceRating {get;set;} //success, warning, danger
        public SummarySalesData(){}
    }

}