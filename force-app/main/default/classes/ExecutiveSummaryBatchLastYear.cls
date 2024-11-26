global  class ExecutiveSummaryBatchLastYear implements Database.Batchable<String>, Database.Stateful{
    
    ExecutiveRollUpMain__c thisYearRollUp = new ExecutiveRollUpMain__c();
    Map<String, ExecutiveRollUpChild__c> mapChildRegions = new Map<String, ExecutiveRollUpChild__c>();
    Map<String, ExecutiveRollUpChild__c> mapAccountOpportunity = new Map<String, ExecutiveRollUpChild__c>();
    Map<String, ExecutiveRollUpChild__c> mapRetentionOpportunity = new Map<String, ExecutiveRollUpChild__c>();
    Map<String, ExecutiveRollUpChild__c> mapActionPlan = new Map<String, ExecutiveRollUpChild__c>();
    
    public List<String> start(Database.BatchableContext ctx ) {
        
        Date todayDate = Date.today();
        String thisYear = String.valueOf(todayDate.year());
        String pYear = String.valueOf(todayDate.addYears(-1).year());
        List<String> districtList = new List<String>();
        
        // Delete previous year records
        AreaManagerAggregateBatchHelper.deletExecutiveRollUpMainRecords(pYear, 'Executive');  
        
        // Initialize Stateful variable
        thisYearRollUp.Year__c = pYear;
        thisYearRollUp.PY_SalesHistory__c = 0;
        thisYearRollUp.P2Y_SalesHistory__c = 0;
        thisYearRollUp.P3Y_SalesHistory__c = 0;
        thisYearRollUp.CY_SalesForecast__c = 0;
        thisYearRollUp.CY_YTDSales__c = 0;
        thisYearRollUp.PY_YTDSales__c = 0;
        thisYearRollUp.CY_YTDDLSC__c = 0;
        thisYearRollUp.PY_YTDDLSC__c = 0;
        thisYearRollUp.CY_YTDMerit__c = 0;
        thisYearRollUp.PY_YTDMerit__c = 0;
        thisYearRollUp.CY_YTDElite__c = 0;
        thisYearRollUp.PY_YTDElite__c = 0;
        thisYearRollUp.CY_YTDAireFlo__c = 0;
        thisYearRollUp.PY_YTDAireFlo__c = 0;
        thisYearRollUp.CY_YTDOther__c = 0;
        thisYearRollUp.PY_YTDOther__c = 0;
        thisYearRollUp.CY_YTDCommercial__c = 0;
        thisYearRollUp.CY_YTDPartsAndSupplies__c = 0;
        thisYearRollUp.CY_YTDResEquipment__c = 0;
        thisYearRollUp.Type__c = 'Executive'; 
        insert thisYearRollUp;      
        
        for(AggregateResult a : [SELECT Dealer__r.SAP_Sales_District__c district FROM Account_Planning__c WHERE Account_Plan_Year__c = :pYear GROUP BY Dealer__r.SAP_Sales_District__c]){
            String district = (String)a.get('district');
            districtList.add(district);
        }
        return districtList;
        //String query = 'SELECT Dealer__r.SAP_Sales_District__c district FROM Account_Planning__c WHERE Account_Plan_Year__c = \'' + pYear + '\' GROUP BY Dealer__r.SAP_Sales_District__c';
        //return Database.getQueryLocator(query);
        
        /*
String query = 'Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive '+
'FROM User LIMIT 1';

return Database.getQueryLocator(query);
*/
    }
    
    public void execute(Database.BatchableContext ctx, List<String> scope) {
        Date todayDate = Date.today();
        String thisYear = String.valueOf(todayDate.year());
        String pYear = String.valueOf(todayDate.addYears(-1).year());
        
        // Create This Year Executive Report
        for(String district : scope){
            try{
                
                system.debug('##### district: ' + district);
                //String district = (String)a.get('district');
                executiveAggregateHelperClass Helper1 = new executiveAggregateHelperClass(pYear, district);
                
                ExecutiveRollUpMain__c thisYearDistrictRollUp = Helper1.getMainRecord();       
                // Aggregate the district record into main reacord
                thisYearRollUp.PY_SalesHistory__c += thisYearDistrictRollUp.PY_SalesHistory__c;
                thisYearRollUp.P2Y_SalesHistory__c += thisYearDistrictRollUp.P2Y_SalesHistory__c;
                thisYearRollUp.P3Y_SalesHistory__c += thisYearDistrictRollUp.P3Y_SalesHistory__c;
                thisYearRollUp.CY_SalesForecast__c += thisYearDistrictRollUp.CY_SalesForecast__c;
                thisYearRollUp.CY_YTDSales__c += thisYearDistrictRollUp.CY_YTDSales__c;
                thisYearRollUp.PY_YTDSales__c += thisYearDistrictRollUp.PY_YTDSales__c;
                thisYearRollUp.CY_YTDDLSC__c += thisYearDistrictRollUp.CY_YTDDLSC__c;
                thisYearRollUp.PY_YTDDLSC__c += thisYearDistrictRollUp.PY_YTDDLSC__c;
                thisYearRollUp.CY_YTDMerit__c += thisYearDistrictRollUp.CY_YTDMerit__c;
                thisYearRollUp.PY_YTDMerit__c += thisYearDistrictRollUp.PY_YTDMerit__c;
                thisYearRollUp.CY_YTDElite__c += thisYearDistrictRollUp.CY_YTDElite__c;
                thisYearRollUp.PY_YTDElite__c += thisYearDistrictRollUp.PY_YTDElite__c;
                thisYearRollUp.CY_YTDAireFlo__c += thisYearDistrictRollUp.CY_YTDAireFlo__c;
                thisYearRollUp.PY_YTDAireFlo__c += thisYearDistrictRollUp.PY_YTDAireFlo__c;
                thisYearRollUp.CY_YTDOther__c += thisYearDistrictRollUp.CY_YTDOther__c;
                thisYearRollUp.PY_YTDOther__c += thisYearDistrictRollUp.PY_YTDOther__c;
                thisYearRollUp.CY_YTDCommercial__c += thisYearDistrictRollUp.CY_YTDCommercial__c;
                thisYearRollUp.CY_YTDPartsAndSupplies__c += thisYearDistrictRollUp.CY_YTDPartsAndSupplies__c;
                thisYearRollUp.CY_YTDResEquipment__c += thisYearDistrictRollUp.CY_YTDResEquipment__c;  
                
                for(ExecutiveRollUpChild__c c : Helper1.getRegionRecords(thisYearRollUp.Id)){
                    if(mapChildRegions.containsKey(c.Region__c)){
                        ExecutiveRollUpChild__c s = mapChildRegions.get(c.Region__c);
                        s.CY_YTDSales__c += c.CY_YTDSales__c;
                        s.PY_YTDSales__c += c.PY_YTDSales__c;
                    } else {
                        ExecutiveRollUpChild__c s = new ExecutiveRollUpChild__c();
                        s.ExecutiveRollUpMain__c = c.ExecutiveRollUpMain__c;
                        s.Region__c = c.Region__c;
                        s.NonResidentialAccounts__c = c.NonResidentialAccounts__c;
                        s.CY_YTDSales__c = c.CY_YTDSales__c;
                        s.PY_YTDSales__c = c.PY_YTDSales__c;
                        s.Type__c = c.Type__c;
                        s.URLText__c = c.URLText__c;
                        mapChildRegions.put(s.Region__c, s);
                    }
                }
                
                for(ExecutiveRollUpChild__c c : Helper1.getAccountOpportunityRecords(thisYearRollUp.Id)){
                    String mapKey = c.Region__c + ':' + c.Status__c;
                    if(mapAccountOpportunity.containsKey(mapKey)){
                        ExecutiveRollUpChild__c s = mapAccountOpportunity.get(mapKey);
                        s.NumberOfAccOpp__c += s.NumberOfAccOpp__c;
                        s.AdjustedValue__c += s.AdjustedValue__c;
                        s.ExpectedValue__c += c.ExpectedValue__c;
                    } else {
                        ExecutiveRollUpChild__c s = new ExecutiveRollUpChild__c();
                        s.ExecutiveRollUpMain__c = c.ExecutiveRollUpMain__c;
                        s.Region__c = c.Region__c;
                        s.NonResidentialAccounts__c = c.NonResidentialAccounts__c;
                        s.NumberOfAccOpp__c = c.NumberOfAccOpp__c;
                        s.AdjustedValue__c = c.AdjustedValue__c;
                        s.ExpectedValue__c = c.ExpectedValue__c;
                        s.Status__c = c.Status__c;
                        s.Type__c = c.Type__c;
                        s.URLText__c = c.URLText__c;
                        mapAccountOpportunity.put(mapKey, s);
                    }
                }
                
                for(ExecutiveRollUpChild__c c : Helper1.getRetentionOpportunityRecords(thisYearRollUp.Id)){
                    String mapKey = c.Region__c + ':' + c.Status__c;
                    if(mapRetentionOpportunity.containsKey(mapKey)){
                        ExecutiveRollUpChild__c s = mapRetentionOpportunity.get(mapKey);
                        s.NumberOfRetOpp__c += c.NumberOfRetOpp__c;
                        s.PotentialCRIPoints__c += c.PotentialCRIPoints__c;
                    } else {
                        ExecutiveRollUpChild__c s = new ExecutiveRollUpChild__c();
                        s.ExecutiveRollUpMain__c = c.ExecutiveRollUpMain__c;
                        s.Region__c = c.Region__c;
                        s.NonResidentialAccounts__c = c.NonResidentialAccounts__c;
                        s.NumberOfRetOpp__c = c.NumberOfRetOpp__c;
                        s.PotentialCRIPoints__c = c.PotentialCRIPoints__c;
                        s.Status__c = c.Status__c;
                        s.Type__c = c.Type__c;
                        s.URLText__c = c.URLText__c;
                        mapRetentionOpportunity.put(mapKey, s);
                    }
                }                
                
                for(ExecutiveRollUpChild__c c : Helper1.getActionPlanRecords(thisYearRollUp.Id)){
                    String mapKey = c.Region__c + ':' + c.Status__c;
                    if(mapActionPlan.containsKey(mapKey)){
                        ExecutiveRollUpChild__c s = mapActionPlan.get(mapKey);
                        s.NumberOfActionPlans__c += c.NumberOfActionPlans__c;
                    } else {
                        ExecutiveRollUpChild__c s = new ExecutiveRollUpChild__c();
                        s.ExecutiveRollUpMain__c = c.ExecutiveRollUpMain__c;
                        s.Region__c = c.Region__c;
                        s.NumberOfActionPlans__c = c.NumberOfActionPlans__c;
                        s.Status__c = c.Status__c;
                        s.Type__c = c.Type__c;
                        s.URLText__c = c.URLText__c;
                        mapActionPlan.put(mapKey, s);
                    }
                }   
                
                //insert thisYearRollUp;
                
                //List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
                //childRecords.addAll(Helper1.getAccountOpportunityRecords(thisYearRollUp.Id));
                //childRecords.addAll(Helper1.getRetentionOpportunityRecords(thisYearRollUp.Id));
                //childRecords.addAll(Helper1.getActionPlanRecords(thisYearRollUp.Id));
                //if(childRecords.size() > 0)
                //    insert childRecords;
                
            } catch (Exception e)
            {
                //System.debug('Exception e ::' + e.getLineNumber() + '  :: ' + e.getMessage());
                ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext ctx) {
        Date todayDate = Date.today();
        String thisYear = String.valueOf(todayDate.year());
        String pYear = String.valueOf(todayDate.addYears(-1).year());
        
        update thisYearRollUp;
        insert mapChildRegions.values();
        insert mapAccountOpportunity.values();
        insert mapRetentionOpportunity.values();
        insert mapActionPlan.values();
        
        //executiveAggregateHelperClass Helper2 = new executiveAggregateHelperClass();
        //List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
        //childRecords.addAll(Helper2.getAccountOpportunityRecords(thisYearRollUp.Id));
        //childRecords.addAll(Helper2.getRetentionOpportunityRecords(thisYearRollUp.Id));
        //childRecords.addAll(Helper2.getActionPlanRecords(thisYearRollUp.Id));
        //if(childRecords.size() > 0)
        //    insert childRecords;        
        Database.executeBatch(new AreaManagerAggregateBatch(pYear),1);
    }
}