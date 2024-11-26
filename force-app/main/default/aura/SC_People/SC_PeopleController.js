({
    handleInit: function handleInit(cmp, e, h) {
        console.log('Init in people');
        h.requestCoachingInfo();
    },
    handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
        var coachingInfo = e.getParam('coachingInfo');
        console.log('Pepoplevingof ',coachingInfo);
        if (coachingInfo == null) {
            window.setTimeout($A.getCallback(function () {
                h.requestCoachingInfo();
            }), 1000);
        } else {
            cmp.set('v.isLoading', false);
            cmp.set('v.coachingInfo', coachingInfo);
            
            var user =  cmp.get("v.UserName");
            console.log('user === ',user);
            // if(user==''){
            
            var coachingInfo = cmp.get("v.coachingInfo");
            
            // sort by name
            coachingInfo.coachees.sort(function(a, b) {
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
            
            if(cmp.get('v.test')){
                cmp.set('v.Coachee', coachingInfo.coachees);
                cmp.set('v.SelectedTabCoachee', coachingInfo.coachees);
                
                console.log('cmp.get() ', cmp.get('v.test'));
                
                h.setTabs(cmp, e, h);
                cmp.set('v.test',false);
                var coachingInfo = cmp.get("v.coachingInfo"); 
                console.log('Coaching Info ', coachingInfo);
                var coachees = coachingInfo.coachees; 
            }
        }
    },
    handleKeyUp : function handleKeyUp(cmp, e, h) {
        var serchkey = cmp.get('v.serchkey');
        console.log('serchkey.length',serchkey);
        var coachingInfo = cmp.get("v.coachingInfo");
        var coachee = coachingInfo.coachees;
        
        var filtereCoachee = [];
        console.log('serchkey.length',serchkey.length);
        if(serchkey.length == 0){
            cmp.set('v.Coachee', cmp.get('v.SelectedTabCoachee'));
        }
        
        if(serchkey.length){
            coachee.forEach(function (coa) {
                var fullname = coa.FirstName + ' ' + coa.LastName;
                if(coa.FirstName.toUpperCase().includes(serchkey.toUpperCase()) || coa.LastName.toUpperCase().includes(serchkey.toUpperCase())
                  || fullname.toUpperCase().includes(serchkey.toUpperCase())){
                    filtereCoachee.push(coa);
                }
            });
            cmp.set('v.Coachee', filtereCoachee);
        }
        
    },
    handleTabSelect: function handleTabSelect(cmp, evt, h) {
        cmp.set('v.isLoading',true);
        var tabCmp = evt.detail.selectedTab;
        var tabId = tabCmp.get('v.id');
        console.log('tabId',tabId);
        cmp.set('v.SelectedTab', tabId);
        h.toggleTabCmp(cmp, evt, h,tabId);
    },
    fireViewTeamEvent : function fireViewTeamEvent(cmp, evt, h) {
        var UserName = evt.getParam("UserName");
        var UserId = evt.getParam("UserId");
        h.getCoacheeTeam(cmp, evt, h, UserName, UserId);
    },
    
    backToList : function backToList(cmp, evt, h) {
        var coacheeList = [];
        cmp.set("v.RegionalDirector", coacheeList);
        cmp.set("v.RBMBDM", coacheeList);
        cmp.set("v.DistrictManager", coacheeList);
        cmp.set("v.AreaSalesManager", coacheeList);
        cmp.set("v.TerritoryManager", coacheeList);
        
        var tabId = cmp.get('v.SelectedTab');
        cmp.set('v.UserName','');
        console.log('tabId',tabId);
        h.toggleTabCmp(cmp, evt, h,tabId);
    }
});