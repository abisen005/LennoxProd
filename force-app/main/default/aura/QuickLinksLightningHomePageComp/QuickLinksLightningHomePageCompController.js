({
    //function to set current year and fatch all the data from apex
    init : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY");
        component.set('v.currentYear', today);
        
        helper.setUserInformationAndPermissionObject(component, event);
    },
    
    //function to close the model
    closemodal:function(component,event,helper){    
        component.set("v.OpenModel", false);
    },
    
    //function to open the model with differant attributes
    openmodal: function(component,event,helper) {
        var rollupSummaryType = event.target.getAttribute("data-attriVal");
        console.log("rollupSummaryType",rollupSummaryType);
        component.set("v.rollUpSummaryType", rollupSummaryType);
        component.set("v.OpenModel", true); 
    },
    
    //redirect to the page
    redirectToPage : function(component,event,helper){
        var rollUpType = event.target.getAttribute("data-attriVal");
        var year = event.target.getAttribute("data-year");
        console.log(rollUpType,year);
        
        var pagename;
        
        if(rollUpType.includes("Territory")){
            console.log(rollUpType, true , 'Territory');
            pagename = 'dealerAccountPlanAggregateVF';
        }else if(rollUpType.includes("District")){
            console.log(rollUpType, true , 'District');
            pagename = 'districtManagerAggregateVF';
        }else if(rollUpType.includes("Region")){
            console.log(rollUpType, true , 'Region');
            pagename = 'areaManagerAggregateVF';
        }else if(rollUpType.includes("Manager")){
            console.log(rollUpType, true , 'Store Manager');
            pagename = 'storeAccountPlanAggregateVF';
        }else if(rollUpType.includes("Zone")){
            console.log(rollUpType, true , 'Store Zone');
            pagename = 'zoneManagerAggregateVF';
        }else if(rollUpType.includes("Store Rollup")){
            console.log(rollUpType, true , 'Store Region');
            pagename = 'RegionZoneManagerAggregateVF';
        }else if(rollUpType.includes("Executive")){
            console.log(rollUpType, true , 'Store Executive');
            pagename = 'storeAggregateVF';
        }else {
            pagename = 'executiveAggregateVF';
        }
        
        console.log('pagename',pagename);
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var link = '/apex/'+pagename+'?year='+year+'&u='+userId;
        window.open(link);
    },
    
   gotoURL : function(component, event, helper) { 
       var tabName = event.target.getAttribute("data-attriVal");
        console.log(tabName); 
       var obj = component.get("v.TabPermission");
       var link;
       if(tabName == 'map'){
           link = obj.data.BaseURL+'/apex/ProspectTool';
           console.log(link);  
       }else if(tabName == 'view'){
           link = obj.data.BaseURL+'/04i';
           console.log(link); 
       }else if(tabName == 'cdq'){
           link = obj.data.BaseURL+ '/apex/VendavoLandingPageLightning';
            console.log(link); 
       }else if(tabName == 'MapsView'){
           link = obj.data.BaseURL+ '/lightning/n/maps__Maps';
            console.log(link); 
       }
       
       //window.open(link);
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": link
       });
       urlEvent.fire();
   },
  gotoEvent : function(component, event, helper) {
      window.open("/lightning/o/Event/home?0.source=alohaHeader");
  }
    
})