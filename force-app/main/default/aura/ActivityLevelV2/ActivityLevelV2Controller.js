({
    handleInit: function(cmp, event, helper) {
        console.log('In It');
        setTimeout(function(){
            var latestMeetingMethodOptions = {
                name: 'getLatestMeeting',
                params: {
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetLatestMeeting
            },
                newEvtMethodOptions = {
                    name: 'getNewEvent',
                    params: {
                        accountId: cmp.get('v.accountId')
                    },
                    callback: helper.handleGetNewEvent
                },
                fetchEventFieldDetails = {
                    name: 'getpicklistValues',
                    params: {
                        accountId: cmp.get('v.recordId')
                    },
                    callback: helper.handleGetEventFieldDetails
                };
            //getEventTypeList
            //console.log('before helper method');
            helper.invokeServerAction(cmp, helper, latestMeetingMethodOptions);
            helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
            helper.invokeServerAction(cmp, helper, fetchEventFieldDetails); 
        });
        
    },
    
    handleHasMeetingPress: function(cmp, event, helper) {
        var eventId = cmp.get('v.event').Id;
        helper.openPreCallPlanner(cmp, eventId);
    },
    
    handleHasNoMeetingPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
    },
    
    handleSavePress: function(cmp, event, helper) {
        
        
        var sdt = cmp.get('v.newEvent.StartDateTime');
        
        if(sdt =='' || sdt == null || sdt == 'undefined'){
            cmp.set("v.showEMOne","true");
        }
        
        var sub = cmp.get('v.newEvent.Subject');
        
        if(sub =='' || sub == null || sub == 'undefined'){
            cmp.set("v.showEMTwo","true");
        }
        
        if(sdt !='' && sdt != null && sdt != 'undefined' && sub !='' && sub != null && sub != 'undefined'){
            
            if(helper.validateFields(cmp)) {
                
                /*var newEvent = cmp.get('v.newEvent'),
                eventType = cmp.find("eventType").elements[0],
                eventTopicOptions = cmp.find('eventTopic').elements[0].children,
                selectedTopicOptions = '';*/
                
                var newEvent = cmp.get('v.newEvent');
                var eventType = document.getElementById("eventTypeId2").value;
                /*eventTopicOptions = cmp.find('eventTopic').elements[0].children,
                selectedTopicOptions = '';
            console.log('testing1');
            for(var i = 0; i < eventTopicOptions.length; i++) {
                if(eventTopicOptions[i].selected) {
                    selectedTopicOptions += eventTopicOptions[i].value + ';';
                }
            }
            selectedTopicOptions = selectedTopicOptions.slice(0, -1);*/
                
                var eventTopicOptions = document.getElementById("eventTopicId").options,
                    selectedTopicOptions = '';
                
                for(var i = 0; i < eventTopicOptions.length; i++) {
                    if(eventTopicOptions[i].selected) {
                        selectedTopicOptions += eventTopicOptions[i].value + ';';
                    }
                }
                
                selectedTopicOptions = selectedTopicOptions.slice(0, -1);
                //newEvent.whatId = cmp.get('v.recordId');
                newEvent.whatId = cmp.get('v.accountIdV2');
                newEvent.Event_Topic__c = selectedTopicOptions;
                //newEvent.Event_Topic__c = selectedTopicOptions;
                newEvent.Event_Type__c = eventType;
                
                cmp.set('v.newEvent', newEvent);
                cmp.set('v.isLoading', true);
                
                var methodOptions = {
                    name: 'newEvent',
                    params: {
                        evt: JSON.stringify(cmp.get('v.newEvent'))
                    },
                    callback: helper.handleNewEvent
                };
                
                helper.invokeServerAction(cmp, helper, methodOptions);
            } else {
                console.log('Errors detected!');
            }
        }
    },
    
    handleCloseModalPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
    },
    
    changeOne: function(cmp, event, helper) {
        cmp.set("v.showEMOne","false");
    },
    
    changeTwo: function(cmp, event, helper) {
        cmp.set("v.showEMTwo","false");
    }
})