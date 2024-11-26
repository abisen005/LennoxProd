({
    
    getPrecallPlannerScenarios: function(cmp) {
        var action = cmp.get('c.getPrecallPlannerScenarios'),
            templateId = cmp.get('v.selectedTemplateId');
        console.log('templateId templateId : ', templateId);
        action.setCallback(this, getPrecallPlannerScenariosCallback);
        action.setParams({templateId: templateId});
        $A.enqueueAction(action);
        
        function getPrecallPlannerScenariosCallback(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnVal = response.getReturnValue();
                console.log('returnVal from old : ', returnVal);
                cmp.set('v.scenarios', returnVal);
                if(cmp.get('v.scenarios').length > 0){
                    cmp.set('v.selectedTemplateId', cmp.get('v.scenarios')[0].Id);
                }
                
                if(templateId.length > 0) {
                    var state = cmp.get('v.state');
                    console.log('get state: ', state);
                    if(!this.setAttributes(cmp)) return; // if it returns false, exit and don't set the state
                    console.log('set Attributes');
                    this.setState(cmp, this.nextStateMap(state));
                    console.log('set new state', this.nextStateMap(state));
                }
                
            } else if(state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        this._handleError(cmp, errors[0].message);
                    }
                } else {
                    this._handleError(cmp, 'Unknown error');
                }
            }
        }
    },
    
    getPrecallPlannerScenario : function(cmp){
        var action = cmp.get('c.getPrecallPlannerScenario'),
            templateId = cmp.get('v.selectedTemplateId');
        console.log('templateId @@ : ', templateId);
        action.setCallback(this, getPrecallPlannerScenariosCallback);
        action.setParams({templateId: templateId});
        $A.enqueueAction(action);
        
        function getPrecallPlannerScenariosCallback(response) {
            var state = response.getState();
            var ListOfScenarios = [];
            var scenariosArray = [];
            var scenario = '';
            
            if(state === 'SUCCESS') {
                var returnVal = response.getReturnValue();
                console.log( 'returnVal ', returnVal );
                var iconMap = {"Existing Customer Engagement / Growth": "custom:custom26",  
                               "Channel Focus (RNC / Retail)": "standard:customer_360",
                               "Customer Improvement": "custom:custom39",
                               "New Customer / Prospecting": "custom:custom101"}; 
                
                //cmp.set('v.scenariosMap', returnVal);
                if(!$A.util.isEmpty(returnVal) && !$A.util.isUndefinedOrNull(returnVal)){
                    Object.keys(returnVal).forEach(function(plannerScenerio){
                        console.log('scenarioRecords : ',returnVal[plannerScenerio]);
                        console.log('plannerScenerio : ',plannerScenerio);
                        if( plannerScenerio == undefined || plannerScenerio == 'null' ){
                            scenario = ''; 
                        }else{
                            scenario = plannerScenerio;
                        }
                       // scenario = ( !plannerScenerio ? '': plannerScenerio );
                        console.log('scenario : ',scenario);
                        var iconName = iconMap[plannerScenerio];
                        
                        if(iconName){
                            scenariosArray.push({tabName:plannerScenerio, scenerioRecords:returnVal[plannerScenerio], iconName:iconName});
                            Array.prototype.push.apply(ListOfScenarios, returnVal[plannerScenerio]);
                        }else{
                            scenariosArray.push({tabName:plannerScenerio, scenerioRecords:returnVal[plannerScenerio], iconName: "custom:custom39"});
                            Array.prototype.push.apply(ListOfScenarios, returnVal[plannerScenerio]);
                        }                        
                    });
                    console.log( 'scenariosArray-- ', scenariosArray );
                    
                    //Sorting
                    scenariosArray.sort(function(a, b){
                        var nameA=a.tabName.toLowerCase(), nameB=b.tabName.toLowerCase();
                        if (nameA < nameB) //sort string ascending
                            return 1 
                            if (nameA > nameB)
                                return -1
                                return 0 //default return value (no sorting)
                    })
                    console.log( 'Sorted scenariosArray-- ', scenariosArray );
                    if(scenariosArray.length == 1){                        
                        cmp.set('v.showScenarioRecords',true);
                        cmp.set('v.selectedScenario',scenario);    
                        cmp.set("v.isShowNextButton",true);
                        cmp.set("v.isShowFooter",true); 
                        console.log( 'scenariosArray ', scenariosArray );
                        var scenariosRecordArray = scenariosArray;
                        var scenariosList = [];
                        var index;
                        var optionDefaultValue;
                        
                        for (index = 0; index < scenariosRecordArray.length; index++) {
                            var count;
                            var scenerioRecords = scenariosRecordArray[index].scenerioRecords;
                            
                            for( count = 0; count < scenerioRecords.length; count++){
                                if(count == 0){
                                    optionDefaultValue = scenerioRecords[count].Id;
                                }
                                scenariosList.push({'label': scenerioRecords[count].Name + ' - ' + scenerioRecords[count].Description__c, 'value': scenerioRecords[count].Id});
                            }                
                        }                        
                        cmp.set("v.optionDefaultValue",optionDefaultValue);
                        cmp.set("v.options",scenariosList);   
                        
                        
                    }
                }
                
                cmp.set('v.scenariosRecordArray',scenariosArray);
                cmp.set('v.scenarios',ListOfScenarios);
                console.log('list of ListOfScenarios : ',ListOfScenarios);
                if(cmp.get('v.scenarios').length > 0){
                    cmp.set('v.selectedTemplateId', cmp.get('v.scenarios')[0].Id);
                }
                
                if(templateId.length > 0) {
                    //cmp.set('v.state','SELECT_TEMPLATE'); //SELECT_TEMPLATE is default template. It should not override the template set while including component in VF page
                    //if state is SELECT_OBJECTIVES on load in case of "Outbound Phone Call" template then 2nd step loaded so fetch questions and objectives
                    if( cmp.get('v.state') === 'SELECT_OBJECTIVES' ) { 
                		this.setAttributes( cmp );
                    }
                    console.log('templateId : ',templateId);
                    /*var state = cmp.get('v.state');
                    console.log('get state: ', state);
                    if(!this.setAttributes(cmp)) return; // if it returns false, exit and don't set the state
                    console.log('set Attributes');
                    cmp.set('v.state','SELECT_TEMPLATE');
                    //this.setState(cmp, this.nextStateMap(state));
                    //console.log('set new state', this.nextStateMap(state));*/
                }
                
            } else if(state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        this._handleError(cmp, errors[0].message);
                    }
                } else {
                    this._handleError(cmp, 'Unknown error');
                }
            }
        }
    }, 
    
    /*updateTemplateNameOnEvent : function(cmp) {
        console.log('In updateTemplateNameOnEvent ');
        let eventId;
        let preCallPlanner = cmp.get('v.preCallPlanner'); 
        if(preCallPlanner){
            eventId = preCallPlanner.Event_Id__c;
        }
        let TemplateId = cmp.get('v.selectedTemplateId');            
        let scenarios = cmp.get("v.scenarios");
        let templateName; 
        for(let index=0; index<scenarios.length; index++){
            if(scenarios[index].Id == TemplateId){
                templateName = scenarios[index].Name;
            }
        }
        console.log('templateName ', templateName);
        console.log('eventId ', eventId);
        if(eventId != null && templateName != null){
            console.log('in updateTemplateNameOnEvent action ');
            var action = cmp.get('c.updateEvent');
            action.setCallback(this, getupdateTemplateNameOnEventCallback);
            action.setParams({eventId: eventId, templateName:templateName});
            $A.enqueueAction(action);
            
            function getupdateTemplateNameOnEventCallback(response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                    var returnVal = response.getReturnValue();
                    console.log('returnVal: ', returnVal);
                    
                } else if(state === 'ERROR') {
                    var errors = response.getError();
                    if (errors) {
                        if(errors[0] && errors[0].message) {
                            this._handleError(cmp, errors[0].message);
                        }
                    } else {
                        this._handleError(cmp, 'Unknown error');
                    }
                }
            }
        }
        
    },*/
    
    setAttributes: function(cmp) {
        console.log('set Attrs');
        var selectedTemplate = this._getSelectedScenario(cmp);
        console.log('selectedTemplate: ', selectedTemplate);
        if(!this._setObjectives(cmp, selectedTemplate)) return false; // if it returns false, exit and don't set the state
        if(!this._setQuestions(cmp, selectedTemplate)) return false;
        return true;
    },
    
    updateHasBeenPrompted: function(cmp) {
        var preCallPlanner = cmp.get('v.preCallPlanner');
        preCallPlanner.hasBeenTemplatePrompted__c = true;
        this._upsertPreCallPlanner(cmp, preCallPlanner, false);
    },
    
    addPreCallPlannerTemplate: function(cmp) {
        
        console.log('addPreCallPlannerTemplate');
        var selectedScenario = this._getSelectedScenario(cmp),
            primaryObjective = this._getObjectiveValue(cmp, cmp.get('v.selectedPrimaryObjectiveId')),
            secondaryObjective = this._getObjectiveValue(cmp, cmp.get('v.selectedSecondaryObjectiveId')),
            situationQuestions = this._getQuestionsAsString(cmp.get('v.situationQuestions')),
            problemQuestions = this._getQuestionsAsString(cmp.get('v.problemQuestions')),
            implicationQuestions = this._getQuestionsAsString(cmp.get('v.implicationQuestions')),
            needPayoffQuestions = this._getQuestionsAsString(cmp.get('v.needPayoffQuestions')),
            defaultValuesObj = this._getDefaultPlannerValues(cmp, selectedScenario);
        
        console.log('create preCallPlanner obj: ', secondaryObjective);
        var preCallPlanner = this._mergeObjects(
            cmp.get('v.preCallPlanner'),
            defaultValuesObj,
            {
                sobjectType: 'PreCallPlanner__c',
                Pre_Call_Planner_Scenario__c: selectedScenario.Id,
                hasBeenTemplatePrompted__c: true,
                Primary_Objective__c: primaryObjective.Objective__c,
                Secondary_Objective__c: secondaryObjective.Objective__c,
                Objections_to_Primary_Objective__c: primaryObjective.Objection__c,
                Objections_to_Secondary_Objective__c: secondaryObjective.Objection__c,
                Response_to_Primary_Objections__c: primaryObjective.Our_Response__c,
                Response_to_Secondary_Objections__c: secondaryObjective.Our_Response__c,
                Situation_Questions__c: situationQuestions,
                Problem_Questions__c: problemQuestions,
                Implication_Questions__c: implicationQuestions,
                Need_Payoff_Questions__c: needPayoffQuestions
            }
        );
        console.log('preCallPlanner obj Pre_Call_Planner_Scenario__c: ', preCallPlanner.Pre_Call_Planner_Scenario__c);
        this._upsertPreCallPlanner(cmp, preCallPlanner, true);
        
    },
    
    _upsertPreCallPlanner: function(cmp, preCallPlanner, shouldRefresh) {
        console.log('_upsertPreCallPlanner');
        var action = cmp.get('c.upsertPreCallPlanner');
        if($A.util.isEmpty(preCallPlanner.Id)) delete preCallPlanner.Id;
        action.setParams({preCallPlanner: preCallPlanner});
        action.setCallback(this, upsertPreCallPlannerCallback);
        $A.enqueueAction(action);
        
        function upsertPreCallPlannerCallback(response) {
            console.log('_upsertPreCallPlanner callback');
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnVal = response.getReturnValue();
                console.log('returnVal: ', returnVal);
                cmp.set('v.isOpen', false);
                this._firePreCallPlannerEvent(cmp, shouldRefresh);
            } else if(state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        this._handleError(cmp, errors[0].message);
                    }
                } else {
                    this._handleError(cmp, 'Unknown error');
                }
            }
        }
    },
    
    setState: function(cmp, newState) {
        cmp.set('v.state', newState);
    },
    
    backStateMap: function(state) {
        var stateBackStateMap = {
            'SELECT_OBJECTIVES': 'SELECT_TEMPLATE',
            'SELECT_QUESTIONS': 'SELECT_OBJECTIVES'
        };
        return stateBackStateMap[state];
    },
    
    nextStateMap: function(state) {
        var stateNextStateMap = {
            'SELECT_TEMPLATE': 'SELECT_OBJECTIVES',
            'SELECT_OBJECTIVES': 'SELECT_QUESTIONS'
        };
        return stateNextStateMap[state];
    },
    
    _firePreCallPlannerEvent: function(cmp, shouldRefresh) {
        var appEvent = $A.get('e.c:selectPrecallPlannerScenarioEvent');
        appEvent.setParams({shouldRefresh: shouldRefresh});
        appEvent.fire();
    },
    
    _getObjectiveValue: function(cmp, id) {
        var objectives = cmp.get('v.objectives');
        return objectives.find(function(objective) {
            return objective.Id === id;
        }) || '';
    },
    
    _setObjectives: function(cmp, selectedTemplate) {
        if(selectedTemplate.Pre_Call_Planner_Scenario_Objectives__r) {
            cmp.set('v.objectives', selectedTemplate.Pre_Call_Planner_Scenario_Objectives__r);
            return true;
        } else {
            this._handleError(cmp, 'The selected template is missing objectives');
            return false;
        }
    },
    
    _getQuestionsAsString: function(questions) {
        var questionsAsString = questions.filter(function(question) {
            return question.selected;
        })
        .map(function(question) {
            return '<li>' + question.question + '</li>';
        }).join('\n');
        return '<ul>' + questionsAsString + '</ul>';
    },
    
    _setQuestions: function(cmp, selectedTemplate) {
        var typeListMap = {
            'Situation': 'v.situationQuestions',
            'Problem': 'v.problemQuestions',
            'Implication': 'v.implicationQuestions',
            'Need/Payoff': 'v.needPayoffQuestions'
        },
            typeCollectionMap = {
                'Situation': [],
                'Problem': [],
                'Implication': [],
                'Need/Payoff': []
            };
        
        function Question(id, question) {
            this.id = id;
            this.question = question;
            this.selected = false;
        }
        
        if(selectedTemplate.Pre_Call_Planner_Scenario_Questions__r) {
            selectedTemplate.Pre_Call_Planner_Scenario_Questions__r.forEach(function(question) {
                typeCollectionMap[question.Type__c].push(
                    new Question(question.Id, question.Question__c)
                );
            });
            for(var prop in typeCollectionMap) {
                console.log('set ', typeListMap[prop], ' to ', typeCollectionMap[prop]);
                cmp.set(typeListMap[prop], typeCollectionMap[prop]);
            }
            return true;
        } else {
            this._handleError(cmp, 'The selected template is missing questions');
            return false;
        }
    },
    
    _getSelectedScenario: function(cmp) {
        var scenarios = cmp.get('v.scenarios'),
            selectedTemplateId = cmp.get('v.selectedTemplateId'),
            selectedTemplate;
        if(selectedTemplateId.length > 0) {
            selectedTemplate = scenarios.find(function(scenario) {
                return scenario.Id === selectedTemplateId;
            });
        } else {
            selectedTemplate = scenarios[0];
        }
        return selectedTemplate;
    },
    
    _mergeObjects: function() {
        var resObj = {};
        for(var i=0; i < arguments.length; i += 1) {
            var obj = arguments[i],
                keys = Object.keys(obj);
            for(var j=0; j < keys.length; j += 1) {
                resObj[keys[j]] = obj[keys[j]];
            }
        }
        return resObj;
    },
    
    _getDefaultPlannerValues: function(cmp, selectedTemplate) {
        var defaultValues = selectedTemplate.Pre_Call_Planner_Scenario_Default_Values__r || [];
        return defaultValues.reduce(function(acc, currentVal) {
            acc[currentVal.Field__c] = currentVal.Value__c;
            return acc;
        }, {});
    },
    
    _handleError: function(cmp, errorMsg) {
        window.alert(errorMsg);
    }
})