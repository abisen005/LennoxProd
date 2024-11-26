public class executiveAggregateHelperClassStateful {

    //variable declarations
    public integer year{get; set;}
    public integer preYear{get; set;}
    public integer preTwoYear{get; set;}
    public integer preThreeYear{get; set;}
    private List<User> amUsers{get;set;}

    public Set<String> salesAreas{get; set;}


    public decimal completedAccOpty{get; set;}
    public decimal progressAccOpty{get; set;}
    public decimal notStartedAccOpty{get; set;}
    public decimal cancelledAccOpty{get; set;}
    public decimal holdAccOpty{get; set;}

    public decimal completedAccOptyAdj{get; set;}
    public decimal progressAccOptyAdj{get; set;}
    public decimal notStartedAccOptyAdj{get; set;}
    public decimal cancelledAccOptyAdj{get; set;}
    public decimal holdAccOptyAdj{get; set;}

    public decimal completedRetOpty{get; set;}
    public decimal progressRetOpty{get; set;}
    public decimal notStartedRetOpty{get; set;}
    public decimal cancelledRetOpty{get; set;}

    public Date lastSalesHistoryUpdate{get; set;}

    public integer accOppProgCount{get; set;}
    public integer accountOppCompletedCount{get; set;}
    public integer accountOppNotStartedCount{get; set;}
    public integer accountOppCancelledCount{get; set;}
    public integer accountOppHoldCount{get; set;}

    public integer retOppProgCount{get; set;}
    public integer retOppCompletedCount{get; set;}
    public integer retOppNotStartedCount{get; set;}
    public integer retOppCancelledCount{get; set;}

    public integer actPlanProgCount{get; set;}
    public integer actPlanCompletedCount{get; set;}
    public integer actPlanCancelledCount{get; set;}
    public integer actPlanNotStartedCount{get; set;}

    //variable for YTD Sales Comparison
    public decimal ytdSales{get; set;}

    public List<wrapper> amDisplay{get; set;}
    
    
    public Boolean displayAccOpty{get; set;}
    public Boolean displayCompletedAccOpty{get; set;}
    public Boolean displayInProgressAccOpty{get; set;}
    public Boolean displayCancelledAccOpty{get; set;}
    public Boolean displayNotStartedAccOpty{get; set;}
    public Boolean displayHoldAccOpty{get; set;}
    
    public Boolean displayRetentionOppProgress{get; set;}
    public Boolean displayRetentionOppCompleted{get; set;}
    public Boolean displayRetentionOppNotStarted{get; set;}
    public Boolean displayRetentionOppCancelled{get; set;}
    
    public Boolean displayActionPlanProgress{get; set;}
    public Boolean displayActionPlanCompleted{get; set;}
    public Boolean displayActionPlanNotStarted{get; set;}
    public Boolean displayActionPlanCancelled{get; set;}
    
    public List<wrapper> accountOpportunities{get; set;}
    
    public List<wrapper> accountOppInProgress{get; set;}
    public List<wrapper> accountOppCompleted{get; set;}
    public List<wrapper> accountOppOnHold{get; set;}
    public List<wrapper> accountOppNotStarted{get; set;}
    public List<wrapper> accountOppCancelled{get; set;}
    
    public List<wrapper> accountRetInProgress{get; set;}
    public List<wrapper> accountRetCompleted{get; set;}
    public List<wrapper> accountRetNotStarted{get; set;}
    public List<wrapper> accountRetCancelled{get; set;}
    
    public List<wrapper> accPlanInProgress{get; set;}
    public List<wrapper> accPlanCompleted{get; set;}
    public List<wrapper> accPlanNotStarted{get; set;}
    public List<wrapper> accPlanCancelled{get; set;}

    public List<AggregateResult> aggResutsResAccountPlan = new List<AggregateResult>();
    
    public integer totalOppAmount {get; set;}
    


//constructor of the class.
//Here average value for Present and past years for various fields value to be displayed on the page is calculated using the aggregate
//query. The value of Present/Previous year, Dealer Id is captured from the url for further references.
public executiveAggregateHelperClassStateful(String pYear, Map<String, Account_Planning__c> aggResutsAccountPlan)
{   
    try
    {
        year = Integer.valueOf(pYear);
        preYear = year -1;
        preTwoYear = year - 2;
        preThreeYear = year - 3;

        System.debug('aggrAccountPlan:::::'+aggResutsAccountPlan);

        String querResAccPlan = 'SELECT sum(YTD_Sales__c) currentSale,sum(PY_YTD_Sales__c) previousSale, Dealer__r.Master_Resi_National_Account__r.Intiative__c FROM Account_Planning__c WHERE Dealer__r.Master_Resi_National_Account__r.Intiative__c = \'Res National Account\' and Account_Plan_Year__c =\''+string.valueOf(year)+'\' GROUP BY Dealer__r.Master_Resi_National_Account__r.Intiative__c';
        aggResutsResAccountPlan = database.query(querResAccPlan);
        System.debug('aggResutsResAccountPlan:::::'+aggResutsResAccountPlan);
        salesAreas = new Set<String>();

        //calculate the average of all the Account Plans associated with the Dealer for present/previous years
        if(aggResutsAccountPlan.size() > 0)
        {
            amDisplay = new List<wrapper>();


            ytdSales = 0;

            //Used to show subtotals - decimal variables
            progressAccOpty = 0;
            completedAccOpty = 0;
            notStartedAccOpty = 0;
            cancelledAccOpty = 0;
            holdAccOpty = 0;
            progressAccOptyAdj = 0;
            completedAccOptyAdj = 0;
            notStartedAccOptyAdj = 0;
            cancelledAccOptyAdj = 0;
            holdAccOptyAdj = 0;
            holdAccOpty = 0;
            completedRetOpty = 0;
            progressRetOpty = 0;
            notStartedRetOpty = 0;
            cancelledRetOpty = 0;

            //Used to dislpay count of records - integer variables
            accOppProgCount = 0;
            accountOppCompletedCount = 0;
            accountOppNotStartedCount = 0;
            accountOppCancelledCount = 0;
            accountOppHoldCount = 0;
            retOppProgCount = 0;
            retOppCompletedCount = 0;
            retOppNotStartedCount = 0;
            retOppCancelledCount = 0;
            actPlanProgCount = 0;
            actPlanCompletedCount = 0;
            actPlanCancelledCount = 0;
            actPlanNotStartedCount = 0;

            salesAreas = aggResutsAccountPlan.keySet();

            if(Test.isRunningTest())
                amUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive FROM User WHERE SAP_Sales_District__c IN: salesAreas];
            else 
                amUsers = [Select Id, FirstName, LastName, ProfileId, Profile.Name, SAP_Sales_District__c, IsActive FROM User WHERE SAP_Sales_District__c IN: salesAreas AND Profile.Name LIKE '%AM%' AND isActive = true];
            System.debug('::amUsers:: '+amUsers);

            Map<String,String> areaToUserIDMap = new Map<String,String>();
            Map<String,String> areaToUserNameMap = new Map<String,String>(); 
            if(amUsers != null)
            {
                for(User a: amUsers)
                {
                    areaToUserIDMap.put(a.SAP_Sales_District__c,a.Id);
                    areaToUserNameMap.put(a.SAP_Sales_District__c,a.FirstName+' '+a.LastName);
                }
            }
            
            wrapper houseAccounts = new wrapper();
            houseAccounts.userName = 'House Accounts';
            houseAccounts.userId = null;
            houseAccounts.userArea = null;
            houseAccounts.areaThisYearSales = 0;
            houseAccounts.areaLastYearSales = 0;
            
            System.debug('::areaToUserIDMap::'+areaToUserIDMap);
            System.debug('::areaToUserNameMap::'+areaToUserNameMap);

            for(String salesDistrict: salesAreas)
            {
                System.debug('::areaResult::'+salesDistrict);
                
                wrapper amRow;
                if(salesDistrict != null && areaToUserIDMap.keySet().contains(salesDistrict))
                {
                    amRow = new wrapper();
                    amRow.userArea = String.valueOf(salesDistrict);
                    amRow.userName = areaToUserNameMap.get(salesDistrict);
                    amRow.userId = areaToUserIDMap.get(salesDistrict);
                    amRow.areaThisYearSales = 0;
                    amRow.areaLastYearSales = 0;
                }
                else
                {
                    amRow = houseAccounts;
                    if(salesDistrict != null)
                            amRow.userArea = String.valueOf(salesDistrict);
                }

                amRow.areaThisYearSales += (aggResutsAccountPlan.get(salesDistrict)?.YTD_Sales__c == null ? 0 : aggResutsAccountPlan.get(salesDistrict).YTD_Sales__c);
                amRow.areaLastYearSales += (aggResutsAccountPlan.get(salesDistrict)?.PY_YTD_Sales__c == null ? 0 : aggResutsAccountPlan.get(salesDistrict).PY_YTD_Sales__c);
                                    
                
                if(amRow.userName != 'House Accounts'){
                    if(amDisplay == null || amDisplay.size() == 0){
                        amDisplay.add(amRow);
                    } else {
                        for(Integer i = 0; i < amDisplay.size(); i++) {
                            if((amRow.areaThisYearSales - amRow.areaLastYearSales) > (amDisplay[i].areaThisYearSales - amDisplay[i].areaLastYearSales)){
                                amDisplay.add(i,amRow);
                                i = amDisplay.size();
                            } else if((i+1) == amDisplay.size()){
                                    amDisplay.add(amRow); 
                                    i = amDisplay.size();
                            }
                        }
                    }
                } else {
                    houseAccounts = amRow;
                }
                    
                if(lastSalesHistoryUpdate == null && aggResutsAccountPlan.get(salesDistrict)?.Last_Sales_History_Update__c != null)
                    lastSalesHistoryUpdate = date.valueOf(aggResutsAccountPlan.get(salesDistrict)?.Last_Sales_History_Update__c);
                else if(aggResutsAccountPlan.get(salesDistrict)?.Last_Sales_History_Update__c != null && lastSalesHistoryUpdate < date.valueOf(aggResutsAccountPlan.get(salesDistrict)?.Last_Sales_History_Update__c))
                        lastSalesHistoryUpdate = date.valueOf(aggResutsAccountPlan.get(salesDistrict)?.Last_Sales_History_Update__c);

                System.debug('lastSalesHistoryUpdate:::::'+lastSalesHistoryUpdate);
            }
            amDisplay.add(houseAccounts);
        }
        else
        {
            ExecutiveSummaryUtils.CreateErrorTask('Could not retrieve any information for Executive Summary Batch.');
        }
    }
    catch(Exception e)
    {
        System.debug(e.getMessage());
        System.debug('Line Number: '+e.getLineNumber());
        ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
    }

            
  System.debug('amDisplay ='+amDisplay);
  
  try{
        
                SetAccountOpportunities();
                
                SetAccountRetentions();
                
                SetAccountPlans();
            }
            catch(Exception e)
            {
                System.debug(e.getMessage());
                System.debug('Line Number: '+e.getLineNumber());
                ExecutiveSummaryUtils.CreateErrorTask(e.getMessage());
            }
}
    
public List<ExecutiveRollUpChild__c> getAccountOpportunityRecords (String pMasterId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accountOppInProgress != null)
    {
        for(wrapper acc: accountOppInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numInProgressOpp;
            newRecord.AdjustedValue__c = acc.oppInProgressAdjValue;
            newRecord.ExpectedValue__c = acc.oppInProgressExpValue;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppNotStarted != null)
    {    
        for(wrapper acc: accountOppNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numNotStartedOpp;
            newRecord.AdjustedValue__c = acc.oppNotStartedAdjValue;
            newRecord.ExpectedValue__c = acc.oppNotStartedExpValue;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppOnHold != null)
    {
        for(wrapper acc: accountOppOnHold)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numOnHoldOpp;
            newRecord.AdjustedValue__c = acc.oppOnHoldAdjValue;
            newRecord.ExpectedValue__c = acc.oppOnHoldExpValue;
            newRecord.Status__c = 'On Hold';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
   	if(accountOppCompleted != null)
    {
        for(wrapper acc: accountOppCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numCompletedOpp;
            newRecord.AdjustedValue__c = acc.oppCompletedAdjValue;
            newRecord.ExpectedValue__c = acc.oppCompletedExpValue;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountOppCancelled != null)
    {
        for(wrapper acc: accountOppCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfAccOpp__c = acc.numCancelledOpp;
            newRecord.AdjustedValue__c = acc.oppCancelledAdjValue;
            newRecord.ExpectedValue__c = acc.oppCancelledExpValue;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'Opportunity';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    return childRecords;
}
    
public List<ExecutiveRollUpChild__c> getRetentionOpportunityRecords (String pMasterId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accountRetInProgress != null)
    {
        for(wrapper acc: accountRetInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numInProgressRet;
            newRecord.PotentialCRIPoints__c = acc.retInProgressCRIPoints;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetNotStarted != null)
    {
        for(wrapper acc: accountRetNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numNotStartedRet;
            newRecord.PotentialCRIPoints__c = acc.retNotStartedCRIPoints;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetCompleted != null)
    {
        for(wrapper acc: accountRetCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numCompletedRet;
            newRecord.PotentialCRIPoints__c = acc.retCompletedCRIPoints;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accountRetCancelled != null)
    {
        for(wrapper acc: accountRetCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfRetOpp__c = acc.numCancelledRet;
            newRecord.PotentialCRIPoints__c = acc.retCancelledCRIPoints;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'Retention';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    return childRecords;
}
    
public List<ExecutiveRollUpChild__c> getActionPlanRecords (String pMasterId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    if(accPlanInProgress != null)
    {
        for(wrapper acc: accPlanInProgress)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numInProgressAccPlan;
            newRecord.Status__c = 'In Progress';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanNotStarted != null)
    {
        for(wrapper acc: accPlanNotStarted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numNotStartedAccPlan;
            newRecord.Status__c = 'Not Started';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanCompleted != null)
    {
        for(wrapper acc: accPlanCompleted)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numCompletedAccPlan;
            newRecord.Status__c = 'Completed';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    if(accPlanCancelled != null)
    {
        for(wrapper acc: accPlanCancelled)
        {
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
            }
            newRecord.NumberOfActionPlans__c = acc.numCancelledAccPlan;
            newRecord.Status__c = 'Cancelled';
            newRecord.Type__c = 'ActionPlan';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
    
    return childRecords;
}
    
public List<ExecutiveRollUpChild__c> getRegionRecords (String pMasterId)
{
    List<ExecutiveRollUpChild__c> childRecords = new List<ExecutiveRollUpChild__c>();
    integer priority = 0;
    if(amDisplay != null)
    {
        for(wrapper acc: amDisplay)
        {
            priority = priority +1;
            ExecutiveRollUpChild__c newRecord = new ExecutiveRollUpChild__c();
            newRecord.ExecutiveRollUpMain__c = pMasterId;
            if(acc.userId == null)
            {
                newRecord.Region__c = 'Non Residential Accounts';
                newrecord.NonResidentialAccounts__c = true;
                newrecord.NonResidentialAccounts__c = true;
                newrecord.Priority__c = priority +100;
            }
            else
            {
                newRecord.Region__c = acc.userArea + ' - ' + acc.userName;
                newRecord.NonResidentialAccounts__c = false;
                newrecord.Priority__c = priority;
            }
            newRecord.CY_YTDSales__c = acc.areaThisYearSales;
            newRecord.PY_YTDSales__c = acc.areaLastYearSales;
            newRecord.Type__c = 'Region';
            newRecord.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u='+acc.userId;
            childRecords.add(newRecord);
        }
    }
  /*  if(!aggResutsResAccountPlan.isEmpty()){
        priority = priority ;
        System.debug('inside aggResutsResAccountPlan '+aggResutsResAccountPlan);
        for(aggregateResult result : aggResutsResAccountPlan){
            priority = priority +1;
            ExecutiveRollUpChild__c executeChild = new ExecutiveRollUpChild__c();
            executeChild.ExecutiveRollUpMain__c = pMasterId;
            executeChild.CY_YTDSales__c = result.get('currentSale') == null ? 0 : (Decimal)result.get('currentSale');
            executeChild.PY_YTDSales__c = result.get('previousSale') == null ? 0 : (Decimal)result.get('previousSale');
            executeChild.Region__c = 'Residential National Accounts';
            executeChild.ResNationalAccounts__c = true;
            executeChild.Type__c = 'Region';
            executeChild.URLText__c = '/apex/areaManagerAggregateVF?year='+year+'&u=';
            executeChild.Priority__c = priority;
            childRecords.add(executeChild);
        }
    }*/
    return childRecords;
} 

public void SetAccountOpportunities()
    {
        List<AggregateResult> aggResultsAccountOpportunities = [SELECT 
                                                COUNT(Id) numOpp, 
                                                SUM(Adjusted_Value__c) adjValue,
                                                SUM(Expected_Value__c) expValue, 
                                                Opportunity_Status__c status,
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c area
                                           FROM Account_Opportunty__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               (Opportunity_Status__c = 'In Progress' OR Opportunity_Status__c = 'Completed' OR Opportunity_Status__c = 'Not Started' OR Opportunity_Status__c = 'Cancelled' OR Opportunity_Status__c = 'On Hold') 
                                           GROUP BY Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c 
                                           ];
                                                               
            System.debug('aggResultsAccountOpportunities :::::'+aggResultsAccountOpportunities );
            totalOppAmount  = 0;
            if(aggResultsAccountOpportunities != null && aggResultsAccountOpportunities.size() > 0)
            {
                accountOpportunities = new List<wrapper>();
                accountOppInProgress = new List<wrapper>();
                accountOppCompleted = new List<wrapper>();
                accountOppNotStarted = new List<wrapper>();
                accountOppCancelled = new List<wrapper>();
                accountOppOnHold = new List<wrapper>();
                
                displayAccOpty = true;
                for(aggregateResult ag: aggResultsAccountOpportunities)
                {
                    totalOppAmount +=  ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue')); 
                    for(wrapper ow: amDisplay)
                    {
                        if(ow.userArea == (String)ag.get('area'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppInProgressAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppInProgressExpValue = ag.get('expValue') == null ? 0 : Integer.valueOF((Decimal)ag.get('expValue'));
                               displayInProgressAccOpty = true;
                               progressAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               progressAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accOppProgCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               // Sorting by Exp Value Descending
                               if(accountOppInProgress == null || accountOppInProgress.size() == 0)
                                   accountOppInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppInProgress.size(); i++)
                                   {
                                       if(ow.oppInProgressAdjValue >= accountOppInProgress[i].oppInProgressAdjValue)
                                       {
                                           accountOppInProgress.add(i,ow);
                                           i = accountOppInProgress.size();
                                       }
                                       else
                                           if((i+1) == accountOppInProgress.size())
                                           {
                                              accountOppInProgress.add(ow); 
                                              i = accountOppInProgress.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCompletedAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCompletedExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCompletedAccOpty = true;
                               completedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               completedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCompletedCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppCompleted == null || accountOppCompleted.size() == 0)
                                   accountOppCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppCompleted.size(); i++)
                                   {
                                       if(ow.oppCompletedAdjValue >= accountOppCompleted[i].oppCompletedAdjValue )
                                       {
                                           accountOppCompleted.add(i,ow);
                                               i = accountOppCompleted.size();
                                       }
                                       else
                                           if((i+1) == accountOppCompleted.size())
                                           {
                                              accountOppCompleted.add(ow);
                                              i = accountOppCompleted.size();
                                           } 
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppNotStartedAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppNotStartedExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayNotStartedAccOpty = true;
                               notStartedAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               notStartedAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppNotStartedCount +=  ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppNotStarted == null || accountOppNotStarted.size() == 0)
                                   accountOppNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppNotStarted.size(); i++)
                                   {
                                       if(ow.oppNotStartedAdjValue >= accountOppNotStarted[i].oppNotStartedAdjValue )
                                       {
                                           accountOppNotStarted.add(i,ow);
                                           i = accountOppNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accountOppNotStarted.size())
                                           {
                                              accountOppNotStarted.add(ow); 
                                              i = accountOppNotStarted.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppCancelledAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppCancelledExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayCancelledAccOpty = true;
                               cancelledAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               cancelledAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppCancelledCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppCancelled == null || accountOppCancelled.size() == 0)
                                   accountOppCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppCancelled.size(); i++)
                                   {
                                       if(ow.oppCancelledAdjValue>= accountOppCancelled[i].oppCancelledAdjValue)
                                       {
                                           accountOppCancelled.add(i,ow);
                                           i = accountOppCancelled.size();
                                       }
                                       else
                                           if((i+1) == accountOppCancelled.size())
                                           {
                                              accountOppCancelled.add(ow); 
                                              i = accountOppCancelled.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'On Hold')
                           {
                               ow.numOnHoldOpp = ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               ow.oppOnHoldAdjValue = ag.get('adjValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('adjValue'));
                               ow.oppOnHoldExpValue = ag.get('expValue') == null ? 0 : Integer.valueOf((Decimal)ag.get('expValue'));
                               displayHoldAccOpty = true;
                               holdAccOpty += ag.get('expValue') == null ? 0 : (Decimal)ag.get('expValue');
                               holdAccOptyAdj += ag.get('adjValue') == null ? 0 : (Decimal)ag.get('adjValue');
                               accountOppHoldCount += ag.get('numOpp') == null ? 0 : (Integer)ag.get('numOpp');
                               
                               if(accountOppOnHold == null || accountOppOnHold.size() == 0)
                                   accountOppOnHold.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountOppOnHold.size(); i++)
                                   {
                                       if(ow.oppOnHoldAdjValue >= accountOppOnHold[i].oppOnHoldAdjValue)
                                       {
                                           accountOppOnHold.add(i,ow);
                                           i = accountOppOnHold.size();
                                       }
                                       else
                                           if((i+1) == accountOppOnHold.size())
                                           {
                                              accountOppOnHold.add(ow); 
                                              i = accountOppOnHold.size();
                                           }
                                   }
                               }
                           }
                        }
                    }
                }
            }
            else
                displayAccOpty = false;
    }

public void SetAccountRetentions()
    {
        List<AggregateResult> aggResultsAccountRetentions = [SELECT 
                                                COUNT(Id) numRet, 
                                                SUM(Potential_CRI_Points__c) criPoints, 
                                                Retention_Opportunity_Status__c status,
                                                Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c area
                                           FROM Retention_Opportunity__c 
                                           WHERE
                                               Dealer_Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               (Retention_Opportunity_Status__c = 'In Progress' OR Retention_Opportunity_Status__c = 'Completed' OR Retention_Opportunity_Status__c = 'Not Started' OR Retention_Opportunity_Status__c = 'Cancelled') 
                                           GROUP BY Retention_Opportunity_Status__c, Dealer_Account_Plan__r.Dealer__r.SAP_Sales_District__c 
                                           ];
                                                               
            System.debug('aggResultsAccountRetentions :::::'+aggResultsAccountRetentions );
            if(aggResultsAccountRetentions != null && aggResultsAccountRetentions.size() > 0)
            {
                accountRetInProgress = new List<wrapper>();
                accountRetCompleted = new List<wrapper>();
                accountRetNotStarted = new List<wrapper>();
                accountRetCancelled = new List<wrapper>();
                
                for(aggregateResult ag: aggResultsAccountRetentions)
                {
                    for(wrapper ow: amDisplay)
                    {
                        if(ow.userArea == (String)ag.get('area'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retInProgressCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppProgress = true;
                               progressRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppProgCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetInProgress == null || accountRetInProgress.size() == 0)
                                   accountRetInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetInProgress.size(); i++)
                                   {
                                       if(ow.retInProgressCRIPoints >= accountRetInProgress[i].retInProgressCRIPoints)
                                       {
                                           accountRetInProgress.add(i,ow);
                                           i = accountRetInProgress.size();
                                       }
                                       else
                                           if((i+1) == accountRetInProgress.size())
                                           {
                                              accountRetInProgress.add(ow);
                                              i = accountRetInProgress.size();
                                           }     
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCompletedCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCompleted = true;
                               completedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCompletedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetCompleted == null || accountRetCompleted.size() == 0)
                                   accountRetCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetCompleted.size(); i++)
                                   {
                                       if(ow.retCompletedCRIPoints>= accountRetCompleted[i].retCompletedCRIPoints)
                                       {
                                           accountRetCompleted.add(i,ow);
                                           i = accountRetCompleted.size();
                                       }
                                       else
                                           if((i+1) == accountRetCompleted.size())
                                           {
                                              accountRetCompleted.add(ow); 
                                              i = accountRetCompleted.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retNotStartedCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppNotStarted = true;
                               notStartedRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppNotStartedCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetNotStarted == null || accountRetNotStarted.size() == 0)
                                   accountRetNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetNotStarted.size(); i++)
                                   {
                                       if(ow.retNotStartedCRIPoints >= accountRetNotStarted[i].retNotStartedCRIPoints)
                                       {
                                           accountRetNotStarted.add(i,ow);
                                           i = accountRetNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accountRetNotStarted.size())
                                           {
                                              accountRetNotStarted.add(ow); 
                                              i = accountRetNotStarted.size();
                                           }
                                   }
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledRet = ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               ow.retCancelledCRIPoints = ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               displayRetentionOppCancelled = true;
                               cancelledRetOpty += ag.get('criPoints') == null ? 0 : Integer.valueOf((Decimal)ag.get('criPoints'));
                               retOppCancelledCount += ag.get('numRet') == null ? 0 : (Integer)ag.get('numRet');
                               
                               if(accountRetCancelled == null || accountRetCancelled.size() == 0)
                                   accountRetCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accountRetCancelled.size(); i++)
                                   {
                                       if(ow.retCancelledCRIPoints >= accountRetCancelled[i].retCancelledCRIPoints )
                                       {
                                           accountRetCancelled.add(i,ow);
                                           i = accountRetCancelled.size();
                                       }
                                       else
                                           if((i+1) == accountRetCancelled.size())
                                           {
                                              accountRetCancelled.add(ow);
                                              i = accountRetCancelled.size();
                                           } 
                                   }
                               }
                           }
                        }
                    }
                }
            }
        }
    
    public void SetAccountPlans(){

        List<AggregateResult> aggResultsAccountPlans = [SELECT 
                                                COUNT(Id) numAP, 
                                                Action_Status__c status,
                                                Account_Plan__r.Dealer__r.SAP_Sales_District__c area
                                           FROM Action_Plan__c 
                                           WHERE
                                               Account_Plan__r.Account_Plan_Year__c =: string.valueOf(year) AND
                                               (Action_Status__c = 'In Progress' OR Action_Status__c = 'Completed' OR Action_Status__c = 'Not Started' OR Action_Status__c = 'Cancelled') 
                                           GROUP BY Action_Status__c, Account_Plan__r.Dealer__r.SAP_Sales_District__c
                                           ];
                                                               
            System.debug('aggResultsAccountPlans :::::'+aggResultsAccountPlans );
            if(aggResultsAccountPlans != null && aggResultsAccountPlans.size() > 0)
            {
                accPlanInProgress = new List<wrapper>();
                accPlanCompleted = new List<wrapper>();
                accPlanNotStarted = new List<wrapper>();
                accPlanCancelled = new List<wrapper>();
                
                for(aggregateResult ag: aggResultsAccountPlans )
                {
                    for(wrapper ow: amDisplay)
                    {
                        if(ow.userArea == (String)ag.get('area'))
                        {
                           if((String)ag.get('status') == 'In Progress')
                           {
                               ow.numInProgressAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanProgress = true;
                               actPlanProgCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanInProgress == null || accPlanInProgress.size() == 0)
                                   accPlanInProgress.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanInProgress.size(); i++)
                                   {
                                       if(ow.numInProgressAccPlan >= accPlanInProgress[i].numInProgressAccPlan)
                                       {
                                           accPlanInProgress.add(i,ow);
                                           i = accPlanInProgress.size();
                                       }
                                       else
                                           if((i+1) == accPlanInProgress.size())
                                           {
                                              accPlanInProgress.add(ow); 
                                              i = accPlanInProgress.size();
                                           }
                                   }
                               
                               }
                               
                           }
                           if((String)ag.get('status') == 'Completed')
                           {
                               ow.numCompletedAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCompleted = true;
                               actPlanCompletedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanCompleted == null || accPlanCompleted.size() == 0)
                                   accPlanCompleted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanCompleted.size(); i++)
                                   {
                                       if(ow.numCompletedAccPlan >= accPlanCompleted[i].numCompletedAccPlan)
                                       {
                                           accPlanCompleted.add(i,ow);
                                           i = accPlanCompleted.size();
                                       }
                                       else
                                           if((i+1) == accPlanCompleted.size())
                                           {
                                              accPlanCompleted.add(ow); 
                                              i = accPlanCompleted.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Not Started')
                           {
                               ow.numNotStartedAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanNotStarted = true;
                               actPlanNotStartedCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanNotStarted == null || accPlanNotStarted.size() == 0)
                                   accPlanNotStarted.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanNotStarted.size(); i++)
                                   {
                                       if(ow.numNotStartedAccPlan >= accPlanNotStarted[i].numNotStartedAccPlan)
                                       {
                                           accPlanNotStarted.add(i,ow);
                                           i = accPlanNotStarted.size();
                                       }
                                       else
                                           if((i+1) == accPlanNotStarted.size())
                                           {
                                              accPlanNotStarted.add(ow); 
                                              i = accPlanNotStarted.size();
                                           }
                                   }
                               
                               }
                           }
                           if((String)ag.get('status') == 'Cancelled')
                           {
                               ow.numCancelledAccPlan = ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               displayActionPlanCancelled = true;
                               actPlanCancelledCount += ag.get('numAP') == null ? 0 : (Integer)ag.get('numAP');
                               
                               if(accPlanCancelled == null || accPlanCancelled.size() == 0)
                                   accPlanCancelled.add(ow);
                               else
                               {
                                   for(Integer i = 0; i < accPlanCancelled.size(); i++)
                                   {
                                       if(ow.numCancelledAccPlan >= accPlanCancelled[i].numCancelledAccPlan )
                                       {
                                           accPlanCancelled.add(i,ow);
                                           i = accPlanCancelled.size();
                                       }
                                       else
                                           if((i+1) == accPlanCancelled.size())
                                           {
                                              accPlanCancelled.add(ow); 
                                              i = accPlanCancelled.size();
                                           }
                                   }
                               
                               }
                           }
                        }
                    }
                }
            }

    }

//Wrapper Class
public class wrapper
{
    public string userId{get;set;}
    public string userName{get;set;}
    public string userArea{get;set;}
    public decimal areaThisYearSales{get;set;}
    public decimal areaLastYearSales{get;set;}
    public decimal areaTotalThisYearSales{get; set;}
    public decimal areaTotalLastYearSales{get; set;}
    public integer change {get {
    return Integer.valueOf(areaThisYearSales - areaLastYearSales);
    } set;}
        
            // Account Opportunity Variables
            public integer numCompletedOpp{get; set;}
            public integer oppCompletedAdjValue {get; set;}
            public integer oppCompletedExpValue {get; set;}
            public integer numInProgressOpp{get; set;}
            public integer oppInProgressAdjValue {get; set;}
            public integer oppInProgressExpValue {get; set;}
            public integer numNotStartedOpp{get; set;}
            public integer oppNotStartedAdjValue {get; set;}
            public integer oppNotStartedExpValue {get; set;}
            public integer numCancelledOpp{get; set;}
            public integer oppCancelledAdjValue {get; set;}
            public integer oppCancelledExpValue {get; set;}
            public integer numOnHoldOpp{get; set;}
            public integer oppOnHoldAdjValue {get; set;}
            public integer oppOnHoldExpValue {get; set;}
            
            // Account Retention Variables
            public integer numCompletedRet{get; set;}
            public integer retCompletedCRIPoints {get; set;}
            public integer numInProgressRet{get; set;}
            public integer retInProgressCRIPoints {get; set;}
            public integer numNotStartedRet{get; set;}
            public integer retNotStartedCRIPoints {get; set;}
            public integer numCancelledRet{get; set;}
            public integer retCancelledCRIPoints {get; set;}
            public integer numOnHoldRet{get; set;}
            public integer retOnHoldCRIPoints {get; set;}
            
            // Account Plan Variables
            public integer numCompletedAccPlan{get; set;}
            public integer numInProgressAccPlan{get; set;}
            public integer numNotStartedAccPlan{get; set;}
            public integer numCancelledAccPlan{get; set;}
            
            public string accPlanId{get; set;}
            public string accPlanName{get;set;}
            public string retOptyId {get; set;}
            public string retOptyNum{get;set;}
            public string retOptyType{get;set;}
            public string retOpty{get;set;}
            public integer potenCRIPts{get;set;}

}
}