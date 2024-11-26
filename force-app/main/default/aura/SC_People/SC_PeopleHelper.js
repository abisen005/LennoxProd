({
    requestCoachingInfo: function requestCoachingInfo() {
        var evt = $A.get('e.c:SC_CoachingInfoRequest');
        evt.setParams({
            "isRefresh" : true,
        });
        evt.fire();
    },
    setTabs : function setTabs(cmp, e, h){
        var coachingInfo = cmp.get("v.coachingInfo");
        var coachingRole = coachingInfo.name;
        var tabs = [];
        //console.log('coachingInfo.name',coachingInfo.name);
        if(coachingInfo.name == 'Executive'){
            cmp.set('v.showSearchBar','true');
            tabs = ["Regional Director", "RBM-BDM", "District Manager", "Area Sales Manager", "Territory Manager"];
        }else if(coachingInfo.name == 'Regional Director'){
            cmp.set('v.showSearchBar','true');
            tabs = ["RBM-BDM", "District Manager", "Area Sales Manager", "Territory Manager"];
        }else if(coachingInfo.name == 'RBM-BDM'){  
            cmp.set('v.showSearchBar','true');
            tabs = ["District Manager", "Area Sales Manager", "Territory Manager"];
        }
        console.log('In set tabs setTabs ',tabs);
        cmp.set('v.tabs',tabs);
        cmp.set('v.SelectedTab',tabs[0]);
        h.toggleTabCmp(cmp, e, h,tabs[0]);
    },
    
    toggleTabCmp : function toggleTabCmp(cmp, e, h,tabId){
        console.log('toggleTabCmp', tabId);
        var coacheeList = [];
        var coachingInfo = cmp.get("v.coachingInfo"); 
        var coachees = coachingInfo.coachees;
        //console.log('coachees',coachees);
        coachees.forEach(function (coa) { 
            
            if(tabId == 'RBM-BDM'){
                if(coa.Profile.Name.includes("Res Sales BDM") || coa.Profile.Name.includes("Res Sales RBM")){
                    coacheeList.push(coa);
                }
            }else if(coa.Title == tabId){
                coacheeList.push(coa);
            }
            
        });
        // console.log('coacheeList',coacheeList);
        cmp.set('v.isLoading',false);
        if(tabId == null){
            cmp.set('v.Coachee', coachingInfo.coachees);
            cmp.set('v.SelectedTabCoachee', coachingInfo.coachees);
        }else{
            // sort by name
            coacheeList.sort(function(a, b) {
                var nameA = a.FirstName.toUpperCase(); // ignore upper and lowercase
                var nameB = b.FirstName.toUpperCase(); // ignore upper and lowercase
                if (nameA < nameB) {
                    return -1;
                }
                if (nameA > nameB) {
                    return 1;
                }
                
                // names must be equal
                return 0;
            });
            
            
            cmp.set('v.Coachee', coacheeList);
            cmp.set('v.SelectedTabCoachee', coacheeList);
        }
    },
    getCoacheeTeam  : function toggleTabCmp(cmp, e, h, UserName, UserId){
        cmp.set('v.UserName', UserName);
        var action = cmp.get('c.getCoacheeTeam');
        action.setParams({ UserName: UserName,
                          UserId : UserId});
        action.setCallback(this, getCoacheeTeamCallback);
        $A.enqueueAction(action);
        
        function getCoacheeTeamCallback(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('SUCCESS');
                var team = response.getReturnValue();
                console.log('team',team);
                var tet = [];
                var RegionalDirector = [];
                var RBMBDM = [];
                var DistrictManager = [];
                var AreaSalesManager = [];
                var TerritoryManager = [];
                
                team.forEach(function (coa) { 
                    if(coa.Title.includes("Regional Director")){
                        RegionalDirector.push(coa);
                    }else if(coa.Profile.Name.includes("Res Sales BDM") || coa.Profile.Name.includes("Res Sales RBM")){
                        RBMBDM.push(coa);
                    }else if(coa.Title.includes("District Manager")){
                        DistrictManager.push(coa);
                    }else if(coa.Title.includes("Area Sales Manager")){
                        AreaSalesManager.push(coa);
                    }else if(coa.Title.includes("Territory Manager") || coa.Title.includes("TM")){
                        TerritoryManager.push(coa);
                    }
                });
                cmp.set('v.RegionalDirector', RegionalDirector);
                cmp.set('v.RBMBDM', RBMBDM);
                cmp.set('v.DistrictManager', DistrictManager);
                cmp.set('v.AreaSalesManager', AreaSalesManager);
                cmp.set('v.TerritoryManager', TerritoryManager);
                
                cmp.set('v.Coachee', tet);
                
            }else{
                console.log('fail');
            }
        }
    }
});