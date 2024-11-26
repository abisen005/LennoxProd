({
    handleInit: function(cmp, event, helper) {
        var action = cmp.get('c.getUserMode');
        action.setCallback(this, function(response) {
            helper.handleGetUserMode(cmp, helper, response);
        });
        $A.enqueueAction(action);
        cmp.set('v.isSf1', typeof $A.get('e.force:navigateToObjectHome') !== 'undefined');
    },
    handleNavChange: function(cmp, event, helper) {
        var auraId = event.getSource().getLocalId(),
            navTitle = event.getSource().getElement().innerText,
            currentYear = new Date().getFullYear(),
            settings = cmp.get('v.consoleSetting'),
            salesGoalReport = settings.Sales_Goals_Report_Id__c ? settings.Sales_Goals_Report_Id__c : '',
            iframeSrc = {
                rollupReport: '/apex/' + settings.Roll_Up_Report_Page_Name__c + '?year=' + currentYear,
                salesGoals: '/apex/OasisSalesSalesGoals?showOasisSales=false',
                oasisSales:'/apex/OasisSalesSalesGoals?showSalesGoals=false&salesGoalReport=' + salesGoalReport
            };
        cmp.set('v.iframeTitle', navTitle.trim());
        cmp.set('v.isLoading', true);
        window.setTimeout(
            $A.getCallback(function() {
                if (cmp.isValid()) {
                    cmp.set('v.isLoading', false);
                }
            }), 1000
        );
        if(auraId) {
            cmp.set('v.showIframe', true);
            cmp.set('v.showMainConsole', false);
            cmp.set('v.iframeSrc', iframeSrc[auraId]);
        }
    },
    handleViewCalendarPress: function(cmp, event, helper) {
        var evt = $A.get("e.force:navigateToObjectHome");
        evt.setParams({
        	"scope": "Event"
    	});
        evt.fire();
    },
    handleViewTasksPress: function(cmp, event, helper) {
        var evt = $A.get("e.force:navigateToObjectHome");
        evt.setParams({
        	"scope": "Task"
    	});
        evt.fire();
    },
    handleSearchDealersPress: function(cmp, event, helper) {
        cmp.set('v.showSearchDealers', true);
        cmp.set('v.showMainConsole', false);
    },
    handleUpdateForecastsPress: function(cmp, event, helper) {
        var userMode = cmp.get('v.userMode'),
            navEvent,
            settings = cmp.get('v.consoleSetting');
        if(userMode === 'Territory' || userMode === 'District') {
            navEvent = $A.get('e.force:navigateToList')
            navEvent.setParams({
                listViewId: settings.Update_Forecast_List_View_Id__c,
                scope: 'Account'
            });
            navEvent.fire();
        } else {
            navEvent = $A.get('e.force:navigateToSObject');
            navEvent.setParams({
                recordId: settings.Forecast_Report_Id__c
            });
            navEvent.fire();
        }
    },
    handleTerritoryRollupPress: function(cmp, event, helper) {
        var currentYear = new Date().getFullYear(),
            rollupUrl = '/apex/' + cmp.get('v.consoleSetting').Roll_Up_Report_Page_Name__c + '?year=' + currentYear;
        helper.navigateTo(cmp, rollupUrl);
    },
    handleLaunchMapPress: function(cmp, event, helper) {
        helper.navigateTo(cmp, '/apex/ProspectToolSF1');
    },
    handleScanBusinessCardPress: function(cmp, event, helper) {
        helper.navigateTo(cmp, '/apex/BusinessCardScanner');
    },
    handleUseReportsPress: function(cmp, event, helper) {
        var action = cmp.get('c.getReports'),
            userMode = cmp.get('v.userMode'),
            reportsFolder = cmp.get('v.consoleSetting').Report_Folder_Name__c;
        action.setParams({
            folderName: reportsFolder
        });
        action.setCallback(this, function(response) {
            helper.handleGetReports(cmp, response);
        });
        cmp.set('v.isLoading', true);
        cmp.set('v.showMainConsole', false);
        $A.enqueueAction(action);
    },
    handleCloseReportsPress: function(cmp, event, helper) {
        cmp.set('v.showReports', false);
        cmp.set('v.showMainConsole', true);
    },
    handleCloseSearchDealersPress: function(cmp, event, helper) {
        cmp.set('v.showSearchDealers', false);
        cmp.set('v.showMainConsole', true);
    },
    handleViewDashboardsPress: function(cmp, event, helper) {
        var action = cmp.get('c.getDashboards'),
            userMode = cmp.get('v.userMode'),
            dashboardsFolder = cmp.get('v.consoleSetting').Dashboard_Folder_Name__c;
        action.setParams({
            folderName: dashboardsFolder
        });
        action.setCallback(this, function(response) {
            helper.handleGetDashboards(cmp, response);
        });
        cmp.set('v.isLoading', true);
        cmp.set('v.showMainConsole', false);
        $A.enqueueAction(action);
    },
    handleCloseDashboardsPress: function(cmp, event, helper) {
        cmp.set('v.showDashboards', false);
        cmp.set('v.showMainConsole', true);
    },
    handleCloseIframePress: function(cmp, event, helper) {
        cmp.set('v.showIframe', false);
        cmp.set('v.iframeSrc', '');
        cmp.set('v.showMainConsole', true);
    },
    handleNavigateToRecordPress: function(cmp, event, helper) {
        var recordId = event.getSource().get('v.param'),
            evt = $A.get('e.force:navigateToSObject');
        evt.setParams({"recordId": recordId});
        evt.fire();
    }
})