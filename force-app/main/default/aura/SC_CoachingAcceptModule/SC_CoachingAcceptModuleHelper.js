({
    getCoachingSession: function getCoachingSession(cmp) {
        var sessionId = cmp.get('v.recordId'),
            action = cmp.get('c.getCoachingSession');
        cmp.set('v.isLoading', true);
        action.setParams({ sessionId: sessionId });
        action.setCallback(this, getCoachingSessionCallback);
        $A.enqueueAction(action);
        
        function getCoachingSessionCallback(response) {
            var state = response.getState();
            cmp.set('v.isLoading', false);
            if (state === 'SUCCESS') {
                var session = response.getReturnValue();
                cmp.set('v.session', session);
                
                var userId = $A.get( "$SObjectType.CurrentUser.Id" );
                console.log('userId ::: ',userId);
                console.log('session ::: ',session);
                console.log('session ::: ',session.Coaching_Session_URL__c);
                console.log('session ::: ',session.Coaching_Session_URL__c.slice(0,-15));
                
                cmp.set("v.BaseUrl", session.Coaching_Session_URL__c.slice(0,-15))
                
                var isCoach = userId == session.Owner.Id ? true : false; 
                
                cmp.set("v.isCoach", isCoach);
                
                if(session.Is_Rescheduled_by_Cochee__c && isCoach ){
                    var rescheduledInviteModal = cmp.find('rescheduledInviteModal');
                    rescheduledInviteModal.toggleIsOpen();
                }
                
                this.getRelationId(cmp);
                
            } else {
                var errorEvent = $A.get('e.force:showToast'),
                    errors = response.getError(),
                    errorMsg = 'There was an unknown error getting the Coaching Session';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                }
                if (errorEvent) {
                    errorEvent.setParams({
                        title: 'Error',
                        message: errorMsg,
                        type: 'error'
                    });
                    errorEvent.fire();
                } else {
                    alert(errorMsg);
                }
            }
        }
    },
    
    getRelationId: function getRelationId(cmp) {
        var session = cmp.get('v.session');
        var eventArray = session.Events__r;
        console.log('eventArray ::; ', eventArray);
        
        var action = cmp.get('c.getEventRelationId');
        cmp.set('v.isLoading', true);
        action.setParams({ eventList: session.Events__r });
        action.setCallback(this, getEventRelationIdCallback);
        $A.enqueueAction(action);
        
        function getEventRelationIdCallback(response) {
            var state = response.getState();
            cmp.set('v.isLoading', false);
            
            if (state === 'SUCCESS') {
                
                console.log('Succeasss --- ');
                var eventRelation = response.getReturnValue();
                console.log('eventid', eventRelation);
                cmp.set('v.relation', eventRelation);
                
                if(eventRelation != undefined && eventRelation.Status != undefined){
                    
                    console.log('eventRelation.Status ', eventRelation.Status);
                    var userId = $A.get( "$SObjectType.CurrentUser.Id" );
                    console.log('userId ', userId);
                    
                    if(eventRelation.Status == 'New' && userId == eventRelation.RelationId && session.Is_Rescheduled_by_Cochee__c == false){
                         console.log('eventRelation.Status IMMMMMMM ');
                        console.log('eventRelation rELATIONiD ', eventRelation.RelationId);
                        var acceptInviteModal = cmp.find('acceptInviteModal');
                        acceptInviteModal.toggleIsOpen();
                    }
                    
                }
                
                
            }else{
                
                console.log('Fail --- ');
                
                var errorEvent = $A.get('e.force:showToast'),
                    errors = response.getError(),
                    errorMsg = 'There was an unknown error getting the Coaching Session';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                }
                if (errorEvent) {
                    errorEvent.setParams({
                        title: 'Error',
                        message: errorMsg,
                        type: 'error'
                    });
                    errorEvent.fire();
                } else {
                    alert(errorMsg);
                }
            }
            
        }
        
    },
    
    respondToInvite: function respondToInvite(cmp, isAccepted) {
        console.log('in Respond to invte === ');
        var action = cmp.get('c.respondToInvite'),
            relationId = cmp.get('v.relation.Id'),
            sessionId = cmp.get('v.recordId'),
            acceptInviteModal = cmp.find('acceptInviteModal');
        console.log('relationId',relationId);
        console.log('sessionId',sessionId);
        action.setParams({ isAccepted: isAccepted, relationId: relationId, sessionId: sessionId});
        $A.enqueueAction(action);
        console.log('Action Completed');
        acceptInviteModal.toggleIsOpen();
    },
    
    validateRescheduleForm: function validateRescheduleForm(cmp) {
        var dateInputCmp = cmp.find('sessionDate'),
            durationInputCmp = cmp.find('sessionDuration');
        return this.hasValue(dateInputCmp) && this.hasValue(durationInputCmp);
    },
    
    hasValue: function hasValue(inputCmp) {
        var inputCmpVal = inputCmp.get('v.value');
        if (typeof inputCmpVal === 'number') inputCmpVal = inputCmpVal.toString();
        if (!inputCmpVal || !inputCmpVal.length) {
            inputCmp.set('v.errors', [{ message: 'This field is required' }]);
            return false;
        } else {
            inputCmp.set('v.errors', null);
            return true;
        }
    },
    
    updateSessionDate: function updateSessionDate(cmp) {
        var action = cmp.get('c.updateCoachingSession'),
            oldStartDate = cmp.get('v.session.Start_Date__c'),
            oldDuration = cmp.get('v.session.Duration__c'),
            newStartDate = cmp.get('v.sessionStartDate'),
            newDuration = cmp.get('v.sessionDuration');
        
        if(oldStartDate == newStartDate && oldDuration == newDuration){
            alert('Please select different date or time than previous one');
            return;
        }
        
        if(!cmp.get("v.isCoach")){
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', true);            
        }else{
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', false);
        }
        cmp.set('v.session.Start_Date__c', newStartDate);
        cmp.set('v.session.Duration__c', newDuration);
        
        
        action.setParams({ session: cmp.get('v.session'), IsReschedule : true });
        action.setCallback(this, updateCoachingSessionCallback);
        $A.enqueueAction(action);
        var _this = this;
        function updateCoachingSessionCallback(response) {
            var state = response.getState();
            if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
                var rescheduleModalCmp = cmp.find('rescheduleModal');
                rescheduleModalCmp.toggleIsOpen();
                
            } else {
                var errorEvent = $A.get('e.force:showToast'),
                    errors = response.getError(),
                    errorResponse = response.getReturnValue(),
                    errorMsg = 'There was an unknown error updating the Note';
                cmp.set('v.session.Start_Date__c', oldStartDate);
                cmp.set('v.session.Duration__c', oldDuration);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                }
                if (errorResponse) errorMsg = errorResponse.message;
                if (errorEvent) {
                    errorEvent.setParams({
                        title: 'Error',
                        message: errorMsg,
                        type: 'error'
                    });
                    errorEvent.fire();
                } else {
                    alert(errorMsg);
                }
            }
        }
    },
    
    updateSession: function updateSession(cmp) {
        var action = cmp.get('c.updateCoachingSession');
        
        if(!cmp.get("v.isCoach")){
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', true);
        }else{
            cmp.set('v.session.Is_Rescheduled_by_Cochee__c', false);
        }
        
        console.log('session'+ cmp.get('v.session'));
        action.setParams({ session: cmp.get('v.session'), IsReschedule : false });
        action.setCallback(this, updateCoachingSessionCallback);
        $A.enqueueAction(action);
        var _this = this;
        function updateCoachingSessionCallback(response) {
            var state = response.getState();
            if (cmp.isValid() && state === 'SUCCESS' && !response.getReturnValue().isError) {
                console.log('state'+ state);
                _this.updateAttendeeStatus(cmp, 'Rescheduled and Accepted by Coach', true);
            } else {
                var errorEvent = $A.get('e.force:showToast'),
                    errors = response.getError(),
                    errorResponse = response.getReturnValue(),
                    errorMsg = 'There was an unknown error updating the Note';
                cmp.set('v.session.Start_Date__c', oldStartDate);
                cmp.set('v.session.Duration__c', oldDuration);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                }
                if (errorResponse) errorMsg = errorResponse.message;
                if (errorEvent) {
                    errorEvent.setParams({
                        title: 'Error',
                        message: errorMsg,
                        type: 'error'
                    });
                    errorEvent.fire();
                } else {
                    alert(errorMsg);
                }
            }
        }
    },
    
    updateAttendeeStatus: function updateAttendeeStatus(cmp, status, isUpdateAll) {
        console.log('Reschedule and accepted by coach');
        if( status == 'Rescheduled and Accepted by Coach'){
            var action = cmp.get('c.updateAttendeeStatus'),
                sessionId = cmp.get('v.session.Id');
            var userId = cmp.get('v.session.ownerId');
            action.setParams({ status: status, sessionId: sessionId, userId:userId, isUpdateAll:isUpdateAll });
            $A.enqueueAction(action);
            console.log('In Callback');
            window.location.replace(cmp.get("v.BaseUrl")+"lightning/n/Coaching_Console_VF");
             
        }
    },
    
})