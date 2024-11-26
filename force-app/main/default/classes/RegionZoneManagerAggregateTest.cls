@isTest
public class RegionZoneManagerAggregateTest {
    @isTest
    static void testController() {

        String year = '2023';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name LIKE '%LPP SM%' LIMIT 1];
        User sfUser = new User(Alias = 'standt', Email='lennoxDMAgg@lennoxDMAgg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='lennoxDMAgg@lennoxDMAgg.com',
                              LPP_Store__c = 'C489');
        sfUser.UserRoleId = r.Id;
        sfUser.SAP_Sales_Office__c = 'C489';
        sfUser.SAP_Sales_Group__c = 'C1';
        INSERT sfUser;

        system.runAS(sfUser){        

            ExecutiveRollUpMain__c mainRecord = new ExecutiveRollUpMain__c();
            mainRecord.Region__c = 'LPP North Region';
            mainRecord.Zone__c = 'Canada';
            mainRecord.Store__c = 'C489';
            mainRecord.CY_YTDSales__c = 100;
            mainRecord.PY_YTDSales__c = 100;
            mainRecord.PY_SalesHistory__c = 100;
            mainRecord.P2Y_SalesHistory__c = 100;
            mainRecord.P3Y_SalesHistory__c = 100;
            mainRecord.CY_SalesForecast__c = 100;
            mainRecord.CY_YTDResEquipment__c = 100;
            mainRecord.CY_YTDCommercial__c = 100;
            mainRecord.CY_YTDPartsAndSupplies__c = 100;
            mainRecord.CY_YTDDLSC__c = 100;
            mainRecord.CY_YTDElite__c = 100;
            mainRecord.CY_YTDMerit__c = 100;
            mainRecord.CY_YTDAireFlo__c = 100;
            mainRecord.CY_YTDOther__c = 100;
            mainRecord.PY_YTDDLSC__c = 100;
            mainRecord.PY_YTDElite__c = 100;
            mainRecord.PY_YTDMerit__c = 100;
            mainRecord.PY_YTDAireFlo__c = 100;
            mainRecord.PY_YTDOther__c = 100;
            mainRecord.Type__c= 'Store Summary Sales';
            mainRecord.Year__c= year;
            mainRecord.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord;          

            ExecutiveRollUpMain__c mainRecord2 = new ExecutiveRollUpMain__c();
            mainRecord2.Region__c = 'LPP North Region';
            mainRecord2.Zone__c = 'Canada';
            mainRecord2.Store__c = 'C489';
            mainRecord2.KPI_OppScorecards__c = 11;
            mainRecord2.KPI_Contacts__c = 11;
            mainRecord2.KPI_PhoneCalls__c = 11;
            mainRecord2.Type__c= 'Store Summary KPI';
            mainRecord2.Year__c= year;
            mainRecord2.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord2; 

            ExecutiveRollUpMain__c mainRecord3 = new ExecutiveRollUpMain__c();
            mainRecord3.Region__c = 'LPP North Region';
            mainRecord3.Zone__c = 'Canada';
            //mainRecord3.Store__c = 'C489';
            mainRecord3.CY_YTDSales__c = 100;
            mainRecord3.PY_YTDSales__c = 100;
            mainRecord3.PY_SalesHistory__c = 100;
            mainRecord3.P2Y_SalesHistory__c = 100;
            mainRecord3.P3Y_SalesHistory__c = 100;
            mainRecord3.CY_SalesForecast__c = 100;
            mainRecord3.CY_YTDResEquipment__c = 100;
            mainRecord3.CY_YTDCommercial__c = 100;
            mainRecord3.CY_YTDPartsAndSupplies__c = 100;
            mainRecord3.CY_YTDDLSC__c = 100;
            mainRecord3.CY_YTDElite__c = 100;
            mainRecord3.CY_YTDMerit__c = 100;
            mainRecord3.CY_YTDAireFlo__c = 100;
            mainRecord3.CY_YTDOther__c = 100;
            mainRecord3.PY_YTDDLSC__c = 100;
            mainRecord3.PY_YTDElite__c = 100;
            mainRecord3.PY_YTDMerit__c = 100;
            mainRecord3.PY_YTDAireFlo__c = 100;
            mainRecord3.PY_YTDOther__c = 100;
            mainRecord3.Type__c= 'Store Summary Sales';
            mainRecord3.Year__c= year;
            mainRecord3.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord3;          

            ExecutiveRollUpMain__c mainRecord4 = new ExecutiveRollUpMain__c();
            mainRecord4.Region__c = 'LPP North Region';
            mainRecord4.Zone__c = 'Canada';
            //mainRecord4.Store__c = 'C489';
            mainRecord4.KPI_OppScorecards__c = 11;
            mainRecord4.KPI_Contacts__c = 11;
            mainRecord4.KPI_PhoneCalls__c = 11;
            mainRecord4.Type__c= 'Store Summary KPI';
            mainRecord4.Year__c= year;
            mainRecord4.Last_Sales_History_Update__c = System.today();
            INSERT mainRecord4;             

            ApexPages.currentPage().getParameters().put('year', year);
            ApexPages.currentPage().getParameters().put('u', sfUser.Id);
            ApexPages.currentPage().getParameters().put('region', 'LPP North Region');
            RegionZoneManagerAggregate controller = new RegionZoneManagerAggregate();
            //controller.getyearSelected(); 
            //controller.setyearSelected(year);
            //Pagereference pr1 =controller.cancel();
            //Pagereference pr =controller.navigateToReport();
            //List<SelectOption> report = controller.getReportYear();
            PageReference page;
        }
    }
}