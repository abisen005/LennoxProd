public without sharing class territoryManagerScorecardsLtngController {


    // Copy constructor code
    // make sure wrapList, mode and goalTableCaption are properties on the wrapper
    // return the wrapper

    @AuraEnabled
    public static ScorecardConfig getScorecardConfig() {
        //try {
            ScorecardConfig config = new ScorecardConfig();
            List<Oasis_Sales__c> oasisList = new List<Oasis_Sales__c>();
            Oasis_Sales__c oasis = new Oasis_Sales__c();
            List<goalWrapper> wrapList = new List<goalWrapper>();
            List<Profile> profileList = [Select Name, Id from Profile where Name like '%Res Sales DM%' OR Name like '%Res Sales TM%' OR Name like '%Res Sales AM%'  OR Name like '%Res Sales ASM%'];
            Set<String> dmIdSet = new Set<String>();
            Set<String> tmIdSet = new Set<String>();
            Set<String> rmIdSet = new Set<String>();
            // system.debug(profileList);
            for(Profile p : profileList)
            {
                if(p.Name.contains('Res Sales TM'))
                    tmIdSet.add(p.Id);
                else if(p.Name.contains('Res Sales DM') || p.Name.contains('Res Sales ASM'))
                    dmIdSet.add(p.Id);
                else if(p.Name.contains('Res Sales AM'))
                    rmIdSet.add(p.Id);
            }
            
            String goalTableCaption = '';
            Wrapper wrap = new Wrapper();
            String uid = UserInfo.getUserId();
            String pId = UserInfo.getProfileId();
            String mode = 'All';
            if(dmIdSet.contains(pId))
            {
                mode = 'DM';
                goalTableCaption = 'DM Sales Goals';
            }
            else if(tmIdSet.contains(pId))
            {
                mode = 'TM';
                goalTableCaption = 'TM Sales Goals';
            }
            else if(rmIdSet.contains(pId))
            {
                mode = 'RM';
                goalTableCaption = 'RM Sales Goals';
            }
            else
            {
                goalTableCaption = '';
            }
            System.debug('mode:::'+mode);
            if(mode=='TM')
            {
                String userSalesGroup = [Select SAP_Sales_Group__c from User where Id = :uid LIMIT 1].SAP_Sales_Group__c;
                system.debug('#### userSalesGroup: ' + userSalesGroup);
                if(userSalesGroup != null && userSalesGroup != '')
                    oasisList = [SELECT MTD_Plan_Sales__c, MTD_Actual_Sales__c, CALC_MTD_Sales_to_Plan__c, YTD_Plan_Sales__c, YTD_Actual_Sales__c, CALC_YTD_Sales_to_Plan__c, MTD_Plan_GP__c, MTD_Actual_GP__c, CALC_MTD_GP_to_Plan__c, YTD_Plan_GP__c, YTD_Actual_GP__c, CALC_YTD_GP_to_Plan__c, Sales_Group__c, Daily_Actual_Sales__c, Daily_Actual_GP__c, LastModifiedDate FROM Oasis_Sales__c where Sales_Group__c = :userSalesGroup LIMIT 1];

                if(oasisList.size() > 0)
                {
                    oasis = oasisList.get(0);
                    wrap.LastModifiedDate = Date.valueOf(oasis.LastModifiedDate).addDays(-1);
                    wrap.DailyActualSales = oasis.Daily_Actual_Sales__c;
                    wrap.MTDPlanSales = oasis.MTD_Plan_Sales__c;
                    wrap.MTDActualSales = oasis.MTD_Actual_Sales__c;
                    wrap.MTDActualToPlanSales = oasis.CALC_MTD_Sales_to_Plan__c;
                    wrap.YTDPlanSales = oasis.YTD_Plan_Sales__c;
                    wrap.YTDActualSales = oasis.YTD_Actual_Sales__c;
                    wrap.YTDActualToPlanSales = oasis.CALC_YTD_Sales_to_Plan__c;
                    wrap.DailyActualMargin = oasis.Daily_Actual_GP__c;
                    wrap.MTDPlanMargin = oasis.MTD_Plan_GP__c;
                    wrap.MTDActualMargin = oasis.MTD_Actual_GP__c;
                    wrap.MTDActualToPlanMargin = oasis.CALC_MTD_GP_to_Plan__c;
                    wrap.YTDPlanMargin = oasis.YTD_Plan_GP__c;
                    wrap.YTDActualMargin = oasis.YTD_Actual_GP__c;
                    wrap.YTDActualToPlanMargin = oasis.CALC_YTD_GP_to_Plan__c;

                    List<Metric_Parameter__c> metricParameterList = new List<Metric_Parameter__c>();
                    metricParameterList = [Select Name, Green_Start_Range__c, Green_End_Range__c, Red_Start_Range__c, Red_End_Range__c, Yellow_Start_Range__c, Yellow_End_Range__c, Metric_Unit__c from Metric_Parameter__c where Is_Active__c=true and Role__c='All Roles'];

                    for(Metric_Parameter__c p : metricParameterList)
                    {
                        if(p.Name=='Oasis Sales MTD to Quota')
                        {
                            //Set Color for MTDActualToPlanSales
                            if(wrap.MTDActualToPlanSales >= p.Red_Start_Range__c && wrap.MTDActualToPlanSales < p.Red_End_Range__c)
                                wrap.MTDColorSales = 'slds-theme_error'; //Red
                            else if(wrap.MTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanSales < p.Yellow_End_Range__c)
                                wrap.MTDColorSales = 'slds-theme_warning'; //Yellow
                            else if(wrap.MTDActualToPlanSales >= p.Green_Start_Range__c && wrap.MTDActualToPlanSales < p.Green_End_Range__c)
                                wrap.MTDColorSales = 'slds-theme_success'; //Green

                            //Set Color for YTDActualToPlanSales
                            if(wrap.YTDActualToPlanSales >= p.Red_Start_Range__c && wrap.YTDActualToPlanSales < p.Red_End_Range__c)
                                wrap.YTDColorSales = 'slds-theme_error'; //Red
                            else if(wrap.YTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanSales < p.Yellow_End_Range__c)
                                wrap.YTDColorSales = 'slds-theme_warning'; //Yellow
                            else if(wrap.YTDActualToPlanSales >= p.Green_Start_Range__c && wrap.YTDActualToPlanSales < p.Green_End_Range__c)
                                wrap.YTDColorSales = 'slds-theme_success'; //Green

                            //Set Color for MTDActualToPlanMargin
                            if(wrap.MTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.MTDActualToPlanMargin < p.Red_End_Range__c)
                                wrap.MTDColorMargin = 'slds-theme_error'; //Red
                            else if(wrap.MTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanMargin < p.Yellow_End_Range__c)
                                wrap.MTDColorMargin = 'slds-theme_warning'; //Yellow
                            else if(wrap.MTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.MTDActualToPlanMargin < p.Green_End_Range__c)
                                wrap.MTDColorMargin = 'slds-theme_success'; //Green

                            //Set Color for YTDActualToPlanMargin
                            if(wrap.YTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.YTDActualToPlanMargin < p.Red_End_Range__c)
                                wrap.YTDColorMargin = 'slds-theme_error'; //Red
                            else if(wrap.YTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanMargin < p.Yellow_End_Range__c)
                                wrap.YTDColorMargin = 'slds-theme_warning'; //Yellow
                            else if(wrap.YTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.YTDActualToPlanMargin < p.Green_End_Range__c)
                                wrap.YTDColorMargin = 'slds-theme_success'; //Green
                        }
                    }
                }
                else
                {
                    //wrap.LastModifiedDate = (Date)oasis.LastModifiedDate.addDays(-1);
                    wrap.DailyActualSales = 0;
                    wrap.MTDPlanSales = 0;
                    wrap.MTDActualSales = 0;
                    wrap.MTDActualToPlanSales = 0;
                    wrap.YTDPlanSales = 0;
                    wrap.YTDActualSales = 0;
                    wrap.YTDActualToPlanSales = 0;
                    wrap.DailyActualMargin = 0;
                    wrap.MTDPlanMargin = 0;
                    wrap.MTDActualMargin = 0;
                    wrap.MTDActualToPlanMargin = 0;
                    wrap.YTDPlanMargin = 0;
                    wrap.YTDActualMargin = 0;
                    wrap.YTDActualToPlanMargin = 0;
                }

                List<Performance_Metric__c> perfMetricList = new List<Performance_Metric__c>();
                perfMetricList = [Select Goal_Type__c, As_Of_Date__c, Performance_Percent1__c, Goal_Type__r.Metric_Unit__c, Goal_Type__r.Name, Performance_Number__c, Color__c, LastModifiedDate from Performance_Metric__c where Goal_Type__r.Is_Active__c = true AND TM_DM_Name__c = :uid AND Goal_Type__r.Role__c='Territory Manager' ORDER BY Goal_Type__r.External_Id__c];
                
                for(Performance_Metric__c pm : perfMetricList)
                {
                    goalWrapper g = new goalWrapper();
                    g.GoalName = pm.Goal_Type__r.Name;
                    if(pm.Goal_Type__r.Metric_Unit__c == 'Percentage')
                    {
                        g.displayStyle = 'percent';
                        g.displayType = 'percent';

                        if (pm.Performance_Percent1__c==null) { g.achievedScore = 0.00; }
                        else { g.achievedScore = pm.Performance_Percent1__c/100; }
                    }
                    else if(pm.Goal_Type__r.Metric_Unit__c == 'Number')
                    {
                        g.displayStyle = 'decimal';
                        g.displayType = 'decimal';
                        g.achievedScore = pm.Performance_Number__c;
                    }
                    else if(pm.Goal_Type__r.Metric_Unit__c == 'Dollars')
                    {
                        g.displayStyle = 'decimal';
                        g.displayType = 'currency';
                        g.achievedScore = pm.Performance_Number__c;
                    }
                                if(pm.Color__c == '#FFFF66') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_warning';
                                }
                                else if(pm.Color__c == '#FF0000') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_error';
                                }
                                else if(pm.Color__c == '#00FF00') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_success';
                                }
                    //g.modifiedDate = pm.LastModifiedDate.Date();
                    g.modifiedDate = pm.As_Of_Date__c;
                    wrapList.add(g);
                }
            }
            else if(mode=='DM')
            {
                String loggedInDistrictNo = [Select SAP_Sales_Office__c from User where Id = :uid LIMIT 1].SAP_Sales_Office__c;
                /*List<User> userList = [Select SAP_Sales_Group__c, SAP_Sales_Office__c from User where SAP_Sales_Office__c = :loggedInDistrictNo AND IsActive=true];
                Set<String> salesGroupSet = new Set<String>();

                for(User u : userList)
                {
                    salesGroupSet.add(u.SAP_Sales_Group__c);
                }*/

                List<Sales_Group_Master__c> sgmList = [Select Sales_Group__c, District_Number__c from Sales_Group_Master__c where District_Number__c = :loggedInDistrictNo AND Region__c in ('Northeast Region','Southeast Region','South Central Region','North Central Region','Home Warr/Prpty Mgmt','Res Sourced Products','West Region','Res National Accts')];

                Set<String> salesGroupSet = new Set<String>();

                for(Sales_Group_Master__c u : sgmList)
                {
                    if(u.Sales_Group__c != null && u.Sales_Group__c != '')
                        salesGroupSet.add(u.Sales_Group__c);
                }

                AggregateResult[] groupedResults = new AggregateResult[]{};
                if(salesGroupSet.size() > 0)
                    groupedResults = [SELECT MAX(LastModifiedDate), SUM(Daily_Actual_Sales__c), SUM(MTD_Plan_Sales__c), SUM(MTD_Actual_Sales__c), SUM(YTD_Plan_Sales__c), SUM(YTD_Actual_Sales__c), SUM(Daily_Actual_GP__c), SUM(MTD_Plan_GP__c), SUM(MTD_Actual_GP__c), SUM(YTD_Plan_GP__c), SUM(YTD_Actual_GP__c)  FROM Oasis_Sales__c where Sales_Group__c in :salesGroupSet];

                if(groupedResults.size() > 0)
                {
                    //wrap.LastModifiedDate = (Datetime)groupedResults[0].get('expr0');
                    wrap.LastModifiedDate = (groupedResults[0].get('expr0') == null ? null : Date.valueOf((Datetime)groupedResults[0].get('expr0')).addDays(-1));
                    wrap.DailyActualSales = (Decimal)groupedResults[0].get('expr1');
                    wrap.MTDPlanSales = (Decimal)groupedResults[0].get('expr2');
                    wrap.MTDActualSales = (Decimal)groupedResults[0].get('expr3');
                    if(wrap.MTDPlanSales > 0 && wrap.MTDActualSales != null)
                        wrap.MTDActualToPlanSales = (wrap.MTDActualSales/wrap.MTDPlanSales)*100;
                    else
                        wrap.MTDActualToPlanSales = 0;
                    wrap.YTDPlanSales = (Decimal)groupedResults[0].get('expr4');
                    wrap.YTDActualSales = (Decimal)groupedResults[0].get('expr5');
                    if(wrap.YTDPlanSales > 0 && wrap.YTDActualSales != null)
                        wrap.YTDActualToPlanSales = (wrap.YTDActualSales/wrap.YTDPlanSales)*100;
                    else
                        wrap.YTDActualToPlanSales = 0;
                    wrap.DailyActualMargin = (Decimal)groupedResults[0].get('expr6');
                    wrap.MTDPlanMargin = (Decimal)groupedResults[0].get('expr7');
                    wrap.MTDActualMargin = (Decimal)groupedResults[0].get('expr8');
                    if(wrap.MTDPlanMargin > 0 && wrap.MTDActualMargin != null)
                        wrap.MTDActualToPlanMargin = (wrap.MTDActualMargin/wrap.MTDPlanMargin)*100;
                    else
                        wrap.MTDActualToPlanMargin = 0;
                    wrap.YTDPlanMargin = (Decimal)groupedResults[0].get('expr9');
                    wrap.YTDActualMargin = (Decimal)groupedResults[0].get('expr10');
                    if(wrap.YTDPlanMargin > 0)
                        wrap.YTDActualToPlanMargin = (wrap.YTDActualMargin/wrap.YTDPlanMargin)*100;
                    else
                        wrap.YTDActualToPlanMargin = 0;
                }

                List<Metric_Parameter__c> metricParameterList = new List<Metric_Parameter__c>();
                metricParameterList = [Select Name, Green_Start_Range__c, Green_End_Range__c, Red_Start_Range__c, Red_End_Range__c, Yellow_Start_Range__c, Yellow_End_Range__c, Metric_Unit__c from Metric_Parameter__c where Is_Active__c=true and Role__c='All Roles'];

                for(Metric_Parameter__c p : metricParameterList)
                {
                    if(p.Name=='Oasis Sales MTD to Quota')
                    {                     
                        //Set Color for MTDActualToPlanSales
                        if(wrap.MTDActualToPlanSales >= p.Red_Start_Range__c && wrap.MTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanSales >= p.Green_Start_Range__c && wrap.MTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_success'; //Green

                        //Set Color for YTDActualToPlanSales
                        if(wrap.YTDActualToPlanSales >= p.Red_Start_Range__c && wrap.YTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanSales >= p.Green_Start_Range__c && wrap.YTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_success'; //Green

                        //Set Color for MTDActualToPlanMargin
                        if(wrap.MTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.MTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.MTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_success'; //Green

                        //Set Color for YTDActualToPlanMargin
                        if(wrap.YTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.YTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.YTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_success'; //Green
                    }
                }
                List<Performance_Metric__c> perfMetricList = new List<Performance_Metric__c>();
                perfMetricList = [Select Goal_Type__c, As_Of_Date__c, Performance_Percent1__c, Goal_Type__r.Metric_Unit__c, Goal_Type__r.Name, Performance_Number__c, Color__c, LastModifiedDate from Performance_Metric__c where Goal_Type__r.Is_Active__c = true AND TM_DM_Name__c = :uid AND Goal_Type__r.Role__c='District Manager' ORDER BY Goal_Type__r.External_Id__c];
                for(Performance_Metric__c pm : perfMetricList)
                {
                    goalWrapper g = new goalWrapper();
                    g.GoalName = pm.Goal_Type__r.Name;
                    if(pm.Goal_Type__r.Metric_Unit__c == 'Percentage')
                    {
                        g.displayStyle = 'percent';
                        g.displayType = 'percent';

                        if (pm.Performance_Percent1__c==null) { g.achievedScore = 0.00; }
                        else { g.achievedScore = pm.Performance_Percent1__c/100; }
                    }
                    else if(pm.Goal_Type__r.Metric_Unit__c == 'Number')
                    {
                        g.displayStyle = 'decimal';
                        g.displayType = 'decimal';
                        g.achievedScore = pm.Performance_Number__c;
                    }
                    else if(pm.Goal_Type__r.Metric_Unit__c == 'Dollars')
                    {
                        g.displayStyle = 'decimal';
                        g.displayType = 'currency';
                        g.achievedScore = pm.Performance_Number__c;
                    }
                                if(pm.Color__c == '#FFFF66') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_warning';
                                }
                                else if(pm.Color__c == '#FF0000') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_error';
                                }
                                else if(pm.Color__c == '#00FF00') {
                                    g.bgColor = pm.Color__c;
                                    g.bgColor = 'slds-theme_success';
                                }
                    //g.modifiedDate = pm.LastModifiedDate.Date();
                    g.modifiedDate = pm.As_Of_Date__c;
                    wrapList.add(g);
                }
            }
            ///////////////////////////////////////////////////////////////////////////////
            else if(mode=='RM')
            {
                String loggedInRegion = [Select SAP_Sales_District1__c from User where Id = :uid LIMIT 1].SAP_Sales_District1__c;
                
                /*List<User> userList = [Select SAP_Sales_Group__c, SAP_Sales_Office__c from User where SAP_Sales_Office__c = :loggedInDistrictNo AND IsActive=true];
                Set<String> salesGroupSet = new Set<String>();

                for(User u : userList)
                {
                    salesGroupSet.add(u.SAP_Sales_Group__c);
                }*/
                List<Sales_Group_Master__c> sgmList = new List<Sales_Group_Master__c>();

                if(loggedInRegion != null && loggedInRegion != '')
                    sgmList = [Select Sales_Group__c, Region__c from Sales_Group_Master__c where Region__c = :loggedInRegion AND Region__c in ('Northeast Region','Southeast Region','South Central Region','North Central Region','Home Warr/Prpty Mgmt','Res Sourced Products','West Region','Res National Accts')];
                Set<String> salesGroupSet = new Set<String>();

                for(Sales_Group_Master__c u : sgmList)
                {
                    if(u.Sales_Group__c != null && u.Sales_Group__c != '')
                        salesGroupSet.add(u.Sales_Group__c);
                }

                AggregateResult[] groupedResults = new AggregateResult[]{};
                if(salesGroupSet.size() > 0)
                    groupedResults = [SELECT MAX(LastModifiedDate), SUM(Daily_Actual_Sales__c), SUM(MTD_Plan_Sales__c), SUM(MTD_Actual_Sales__c), SUM(YTD_Plan_Sales__c), SUM(YTD_Actual_Sales__c), SUM(Daily_Actual_GP__c), SUM(MTD_Plan_GP__c), SUM(MTD_Actual_GP__c), SUM(YTD_Plan_GP__c), SUM(YTD_Actual_GP__c)  FROM Oasis_Sales__c where Sales_Group__c in :salesGroupSet];

                if(groupedResults.size() > 0)
                {
                    //wrap.LastModifiedDate = (Datetime)groupedResults[0].get('expr0');
                    wrap.LastModifiedDate = (groupedResults[0].get('expr0') == null ? null : Date.valueOf((Datetime)groupedResults[0].get('expr0')).addDays(-1));
                    wrap.DailyActualSales = (Decimal)groupedResults[0].get('expr1');
                    wrap.MTDPlanSales = (Decimal)groupedResults[0].get('expr2');
                    wrap.MTDActualSales = (Decimal)groupedResults[0].get('expr3');
                    if(wrap.MTDPlanSales > 0 && wrap.MTDActualSales != null)
                        wrap.MTDActualToPlanSales = (wrap.MTDActualSales/wrap.MTDPlanSales)*100;
                    else
                        wrap.MTDActualToPlanSales = 0;
                    wrap.YTDPlanSales = (Decimal)groupedResults[0].get('expr4');
                    wrap.YTDActualSales = (Decimal)groupedResults[0].get('expr5');
                    if(wrap.YTDPlanSales > 0 && wrap.YTDActualSales != null)
                        wrap.YTDActualToPlanSales = (wrap.YTDActualSales/wrap.YTDPlanSales)*100;
                    else
                        wrap.YTDActualToPlanSales = 0;
                    wrap.DailyActualMargin = (Decimal)groupedResults[0].get('expr6');
                    wrap.MTDPlanMargin = (Decimal)groupedResults[0].get('expr7');
                    wrap.MTDActualMargin = (Decimal)groupedResults[0].get('expr8');
                    if(wrap.MTDPlanMargin > 0 && wrap.MTDActualMargin != null)
                        wrap.MTDActualToPlanMargin = (wrap.MTDActualMargin/wrap.MTDPlanMargin)*100;
                    else
                        wrap.MTDActualToPlanMargin = 0;
                    wrap.YTDPlanMargin = (Decimal)groupedResults[0].get('expr9');
                    wrap.YTDActualMargin = (Decimal)groupedResults[0].get('expr10');
                    if(wrap.YTDPlanMargin > 0)
                        wrap.YTDActualToPlanMargin = (wrap.YTDActualMargin/wrap.YTDPlanMargin)*100;
                    else
                        wrap.YTDActualToPlanMargin = 0;
                }

                List<Metric_Parameter__c> metricParameterList = new List<Metric_Parameter__c>();
                metricParameterList = [Select Name, Green_Start_Range__c, Green_End_Range__c, Red_Start_Range__c, Red_End_Range__c, Yellow_Start_Range__c, Yellow_End_Range__c, Metric_Unit__c from Metric_Parameter__c where Is_Active__c=true and Role__c='All Roles'];

                for(Metric_Parameter__c p : metricParameterList)
                {
                    if(p.Name=='Oasis Sales MTD to Quota')
                    {
                        //Set Color for MTDActualToPlanSales
                        if(wrap.MTDActualToPlanSales >= p.Red_Start_Range__c && wrap.MTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanSales >= p.Green_Start_Range__c && wrap.MTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_success'; //Green

                        //Set Color for YTDActualToPlanSales
                        if(wrap.YTDActualToPlanSales >= p.Red_Start_Range__c && wrap.YTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanSales >= p.Green_Start_Range__c && wrap.YTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_success'; //Green

                        //Set Color for MTDActualToPlanMargin
                        if(wrap.MTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.MTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.MTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_success'; //Green

                        //Set Color for YTDActualToPlanMargin
                        if(wrap.YTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.YTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.YTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_success'; //Green
                    }
                }
            }
            ///////////////////////////////////////////////////////////////////////////////
            else if(mode=='All')
            {
                Set<String> sgIdSet = new Set<String>();
                List<Sales_Group_Master__c> sgmList = new List<Sales_Group_Master__c>();
                sgmList = [Select Sales_Group__c, Region__c from Sales_Group_Master__c where Region__c in ('Northeast Region','Southeast Region','South Central Region','North Central Region','Home Warr/Prpty Mgmt','Res Sourced Products','West Region','Res National Accts')];
                for(Sales_Group_Master__c sgm : sgmList) sgIdSet.add(sgm.Sales_Group__c);

                AggregateResult[] groupedResults = new AggregateResult[]{};
                if(sgIdSet.size() > 0)
                    groupedResults = [SELECT MAX(LastModifiedDate), SUM(Daily_Actual_Sales__c), SUM(MTD_Plan_Sales__c), SUM(MTD_Actual_Sales__c), SUM(YTD_Plan_Sales__c), SUM(YTD_Actual_Sales__c), SUM(Daily_Actual_GP__c), SUM(MTD_Plan_GP__c), SUM(MTD_Actual_GP__c), SUM(YTD_Plan_GP__c), SUM(YTD_Actual_GP__c) FROM Oasis_Sales__c where Sales_Group__c in :sgIdSet];

                if(groupedResults.size() > 0)
                {
                    //wrap.LastModifiedDate = (Datetime)groupedResults[0].get('expr0').addDays(-1);
                    wrap.LastModifiedDate = Date.valueOf((Datetime)groupedResults[0].get('expr0')).addDays(-1);
                    wrap.DailyActualSales = (Decimal)groupedResults[0].get('expr1');
                    wrap.MTDPlanSales = (Decimal)groupedResults[0].get('expr2');
                    wrap.MTDActualSales = (Decimal)groupedResults[0].get('expr3');
                    if(wrap.MTDPlanSales > 0 && wrap.MTDActualSales != null)
                        wrap.MTDActualToPlanSales = (wrap.MTDActualSales/wrap.MTDPlanSales)*100;
                    else
                        wrap.MTDActualToPlanSales = 0;
                    wrap.YTDPlanSales = (Decimal)groupedResults[0].get('expr4');
                    wrap.YTDActualSales = (Decimal)groupedResults[0].get('expr5');
                    System.debug('wrap.YTDPlanSales:::'+wrap.YTDPlanSales);
                    System.debug('wrap.YTDActualSales:::'+wrap.YTDActualSales);
                    if(wrap.YTDPlanSales > 0 && wrap.YTDActualSales != null)
                        wrap.YTDActualToPlanSales = (wrap.YTDActualSales/wrap.YTDPlanSales)*100;
                    else
                        wrap.YTDActualToPlanSales = 0;
                    wrap.DailyActualMargin = (Decimal)groupedResults[0].get('expr6');
                    wrap.MTDPlanMargin = (Decimal)groupedResults[0].get('expr7');
                    wrap.MTDActualMargin = (Decimal)groupedResults[0].get('expr8');
                    if(wrap.MTDPlanMargin > 0 && wrap.MTDActualMargin != null)
                        wrap.MTDActualToPlanMargin = (wrap.MTDActualMargin/wrap.MTDPlanMargin)*100;
                    else
                        wrap.MTDActualToPlanMargin = 0;
                    wrap.YTDPlanMargin = (Decimal)groupedResults[0].get('expr9');
                    wrap.YTDActualMargin = (Decimal)groupedResults[0].get('expr10');
                    if(wrap.YTDPlanMargin > 0 && wrap.YTDActualMargin != null)
                        wrap.YTDActualToPlanMargin = (wrap.YTDActualMargin/wrap.YTDPlanMargin)*100;
                    else
                        wrap.YTDActualToPlanMargin = 0;
                }
                List<Metric_Parameter__c> metricParameterList = new List<Metric_Parameter__c>();
                metricParameterList = [Select Name, Green_Start_Range__c, Green_End_Range__c, Red_Start_Range__c, Red_End_Range__c, Yellow_Start_Range__c, Yellow_End_Range__c, Metric_Unit__c from Metric_Parameter__c where Is_Active__c=true and Role__c='All Roles'];

                for(Metric_Parameter__c p : metricParameterList)
                {
                    if(p.Name=='Oasis Sales MTD to Quota')
                    {
                        //Set Color for MTDActualToPlanSales
                        if(wrap.MTDActualToPlanSales >= p.Red_Start_Range__c && wrap.MTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanSales >= p.Green_Start_Range__c && wrap.MTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.MTDColorSales = 'slds-theme_success'; //Green
                    }
                    else if(p.Name=='Oasis Sales YTD to Quota')
                    {
                        //Set Color for YTDActualToPlanSales
                        if(wrap.YTDActualToPlanSales >= p.Red_Start_Range__c && wrap.YTDActualToPlanSales < p.Red_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanSales >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanSales < p.Yellow_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanSales >= p.Green_Start_Range__c && wrap.YTDActualToPlanSales < p.Green_End_Range__c)
                            wrap.YTDColorSales = 'slds-theme_success'; //Green
                    }
                    else if(p.Name=='Oasis GP MTD to Quota')
                    {
                        //Set Color for MTDActualToPlanMargin
                        if(wrap.MTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.MTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.MTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.MTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.MTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.MTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.MTDColorMargin = 'slds-theme_success'; //Green
                    }
                    else if(p.Name=='Oasis GP YTD to Quota')
                    {
                        //Set Color for YTDActualToPlanMargin
                        if(wrap.YTDActualToPlanMargin >= p.Red_Start_Range__c && wrap.YTDActualToPlanMargin < p.Red_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_error'; //Red
                        else if(wrap.YTDActualToPlanMargin >= p.Yellow_Start_Range__c && wrap.YTDActualToPlanMargin < p.Yellow_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_warning'; //Yellow
                        else if(wrap.YTDActualToPlanMargin >= p.Green_Start_Range__c && wrap.YTDActualToPlanMargin < p.Green_End_Range__c)
                            wrap.YTDColorMargin = 'slds-theme_success'; //Green
                    }
                }
            }
            config.wrap = wrap;
            config.wrapList = wrapList;
            config.mode = mode;
            config.goalTableCaption = goalTableCaption;
            return config;
        //} catch(Exception e) {
        //    system.debug(e);
        //    throw new AuraHandledException(e.getMessage());
        //}
    }

    public class ScorecardConfig {
        @AuraEnabled public Wrapper wrap {get;set;}
        @AuraEnabled public List<goalWrapper> wrapList{get;set;}
        @AuraEnabled public String mode {get;set;}
        @AuraEnabled public String goalTableCaption{get;set;}

    }


    public class Wrapper {
        @AuraEnabled public Datetime LastModifiedDate{get;set;}
        @AuraEnabled public Decimal DailyActualSales{get;set;}
        @AuraEnabled public Decimal MTDPlanSales{get;set;}
        @AuraEnabled public Decimal MTDActualSales{get;set;}
        @AuraEnabled public Decimal MTDActualToPlanSales{get;set;}
        @AuraEnabled public Decimal YTDPlanSales{get;set;}
        @AuraEnabled public Decimal YTDActualSales{get;set;}
        @AuraEnabled public Decimal YTDActualToPlanSales{get;set;}
        @AuraEnabled public String MTDColorSales{get;set;}
        @AuraEnabled public String YTDColorSales{get;set;}
        @AuraEnabled public Decimal DailyActualMargin{get;set;}
        @AuraEnabled public Decimal MTDPlanMargin{get;set;}
        @AuraEnabled public Decimal MTDActualMargin{get;set;}
        @AuraEnabled public Decimal MTDActualToPlanMargin{get;set;}
        @AuraEnabled public Decimal YTDPlanMargin{get;set;}
        @AuraEnabled public Decimal YTDActualMargin{get;set;}
        @AuraEnabled public Decimal YTDActualToPlanMargin{get;set;}
        @AuraEnabled public String MTDColorMargin{get;set;}
        @AuraEnabled public String YTDColorMargin{get;set;}
    }

    public class goalWrapper {
        @AuraEnabled public String GoalName{get;set;}
        @AuraEnabled public Decimal achievedScore{get;set;}
        @AuraEnabled public Date modifiedDate{get;set;}
        @AuraEnabled public String displayStyle{get;set;} //percent or decimal
        @AuraEnabled public String displayType{get;set;} //percent or number or currency
        @AuraEnabled public String bgColor{get;set;}
    }


}