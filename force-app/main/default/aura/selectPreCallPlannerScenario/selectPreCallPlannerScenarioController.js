({
    
    onclick: function(component,event,helper){
        console.log(event.currentTarget.getAttribute('data-id'));        
        component.set("v.selectedScenario",event.currentTarget.getAttribute('data-id'));
        component.set("v.showScenarioTabs",false);
        component.set("v.showScenarioRecords",true);
        component.set("v.isShowPreviousButton",true);  
        component.set("v.isShowNextButton",true);
        component.set("v.isShowFooter",true);   
        
        var scenariosRecordArray = component.get('v.scenariosRecordArray');
        var selectedTab = event.currentTarget.getAttribute('data-id');
        var scenariosList = [];
        var index;
        var optionDefaultValue;
        
        for (index = 0; index < scenariosRecordArray.length; index++) {
            if( scenariosRecordArray[index].tabName == selectedTab ){
                var count;
                var scenerioRecords = scenariosRecordArray[index].scenerioRecords;
                
                for( count = 0; count < scenerioRecords.length; count++){
                    if(count == 0){
                        optionDefaultValue = scenerioRecords[count].Id;
                    }
                    // Remove 'Customer Improvement' and 'Customer Growth' text from beggining of Scenario record name. 
                    
                    var str = scenerioRecords[count].Name;
                    
                    var scenarioName = str.replace('Customer Improvement: ', '');
                    scenarioName = scenarioName.replace('Customer Improvement-', '');
                    scenarioName = scenarioName.replace('Customer Growth: ', '');
                    scenariosList.push({'label': scenarioName + ' - ' + scenerioRecords[count].Description__c, 'value': scenerioRecords[count].Id});
                }                
            } 
        }
        
        component.set("v.optionDefaultValue",optionDefaultValue);
        component.set("v.options",scenariosList);        
    },
    
    handlePreviousClick: function(component,event,helper){        
        component.set("v.selectedScenario","");
        component.set("v.showScenarioTabs",true);
        component.set("v.showScenarioRecords",false);
        component.set("v.isShowPreviousButton",false);  
        component.set("v.isShowNextButton",false); 
        component.set("v.isShowFooter",false);
    },    
    
    handleInit: function(cmp, evt, h) {
        console.log( 'handleInit ');
        //h.getPrecallPlannerScenarios(cmp);
        h.getPrecallPlannerScenario(cmp);
    },
    
    handleScenarioChange: function(cmp, evt, h) {
        /*  var value = ''
        value = evt.target.value;
        
        console.log('In handleScenarioChange',value);
        cmp.set("v.selectedTemplateId", value);
        */
        
        var changeValue = evt.getParam("value");
        cmp.set("v.selectedTemplateId", changeValue);        
    },
    
    handlePrimaryObjectiveChange: function(cmp, evt, h) {
        cmp.set('v.selectedPrimaryObjectiveId', evt.target.value);
    },
    
    handleSecondaryObjectiveChange: function(cmp, evt, h) {
        cmp.set('v.selectedSecondaryObjectiveId', evt.target.value);
    },
    
    handleBackClick: function(cmp, evt, h) {
        cmp.set("v.isShowPreviousButton",true);
        var state = cmp.get('v.state');
        h.setState(cmp, h.backStateMap(state));
    },
    
    handleNextClick: function(cmp, evt, h) {
       // cmp.set("v.isShowPreviousButton",false);
        var state = cmp.get('v.state');
        console.log('state ', state);
        if(state === 'SELECT_TEMPLATE') {
            //h.updateTemplateNameOnEvent(cmp);
            if(!h.setAttributes(cmp)) return; // if it returns false, exit and don't set the state
        }
        console.log('state after on click set attr : ',cmp.get('v.state'));
        h.setState(cmp, h.nextStateMap(state));
    },
    
    handleFinishClick: function(cmp, evt, h) {
        h.addPreCallPlannerTemplate(cmp);
    },
    
    handleCancelClick: function(cmp, evt, h) {
        h.updateHasBeenPrompted(cmp);
    }
    
})