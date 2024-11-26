({
  handleInit: function(cmp, event, helper) {
        console.log('In It');
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
            getEventTypeOptions = {
                name: 'getpicklistValues',
                params: {},
                callback: helper.handleGetEventTopic
            };
        //getEventTypeList
        console.log('before helper method');
        helper.invokeServerAction(cmp, helper, getEventTypeOptions);
    helper.invokeServerAction(cmp, helper, latestMeetingMethodOptions);
        helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
  },
    handleHasMeetingPress: function(cmp, event, helper) {
        var eventId = cmp.get('v.event').Id;
        helper.openPreCallPlanner(cmp, eventId);
    },
    handleHasNoMeetingPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
    },
    handleSavePress: function(cmp, event, helper) {
        if(helper.validateFields(cmp)) {
            console.log('testing ', cmp.get('v.newEvent'));
            console.log('eventType ', cmp.find('eventType').get("v.value"));
            
            var newEvent = cmp.get('v.newEvent');
                //eventType = cmp.find('eventType').elements[0],
                /*eventTopicOptions = cmp.find('eventTopic').elements[0].children,
                selectedTopicOptions = '';
            console.log('testing1');
            for(var i = 0; i < eventTopicOptions.length; i++) {
                if(eventTopicOptions[i].selected) {
                    selectedTopicOptions += eventTopicOptions[i].value + ';';
                }
            }
            selectedTopicOptions = selectedTopicOptions.slice(0, -1);*/
            newEvent.whatId = cmp.get('v.accountId');
            //newEvent.Event_Topic__c = selectedTopicOptions;
            //newEvent.Event_Type__c = cmp.find('eventType').get("v.value");
            newEvent.RecordTypeId = '012C0000000QW0R';
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
            console.log('there are errors');
        }
    },
    handleCloseModalPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
    }
})