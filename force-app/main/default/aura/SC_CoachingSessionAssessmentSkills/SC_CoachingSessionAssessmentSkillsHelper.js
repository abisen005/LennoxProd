({
    component :null,	
    loadInitialData : function() {
        
        var coachingSessionId = this.component.get("v.CoachingSessionId");
        
        if(coachingSessionId){
            this.component.set("v.Spinner", true);
            var param = {
                coachingSessionId : coachingSessionId
            };
            console.log(' getAssessmentSkillsForSession param',param);        
            
            this.callServer("getAssessmentSkillsForSession", param, false, function(response) {             
                if(!response.isSuccess) {
                    this.showErrorToast(response.error);
                    this.component.set("v.Spinner", false); 
                    return;
                } 
                var resultMap = response.data;
                console.log('Response Contents from server',resultMap);        
                this.component.set("v.listSC_Assessment_Skill", resultMap.listSC_Assessment_Skill);
                this.component.set("v.Spinner", false);
            });
        }
	},
    
    saveSkillData : function() {
        
        this.component.set("v.Spinner", true);
        
        var listSC_Assessment_Skill =  this.component.get("v.listSC_Assessment_Skill");        
        var coachingSessionId = this.component.get("v.CoachingSessionId");
        
        var param = {
            listSC_Assessment_Skill : listSC_Assessment_Skill,
            coachingSessionId: coachingSessionId
        };
        this.callServer("updateSkillsForSession", param, false, function(response) {             
            if(!response.isSuccess) {
                alert(response.error);
                this.component.set("v.Spinner", false); 
                return;
            } 
            var resultMap = response.data;
            //console.log('updateSkillsForSession : Response Contents from server',resultMap);        
            this.loadInitialData();
            this.component.set("v.Spinner", false);
        });
	},
    
    callServer : function(apexMethod, params, cacheable, callback) {        
        var method = "c." + apexMethod;
		var action = this.component.get(method);
        
        if(params) {
            action.setParams(params);
        }
        
        if(cacheable) {
            action.setStorable();
        }
        action.setCallback(this, function(response) {
            var state = response.getState();  
            
            if(state === "SUCCESS") {
                callback.call(this, response.getReturnValue())
            } else if(state === "ERROR") {
                this.handleActionFailedState( response.getError());
                this.component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
	},    
    
    handleActionFailedState : function(errors) {
        var errorTxt;
        console.log('errors',errors);
        if(errors) {
            var errorMsgs = [];
            for(var index in errors) {
                errorMsgs.push(errors[index].message);
            }            
            errorTxt = errorMsgs.join('<br/>');
        } else {
            errorTxt = 'Something went wrong!';
        }
        console.log('\n errorTxt:', errorTxt);
        alert(errorTxt);
    }
})