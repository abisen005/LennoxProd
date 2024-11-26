({
	handleInit: function(cmp, event, helper) {
        console.log( 'in init44' );
        cmp.set("v.isSpinner",true);
        var latestMeetingMethodOptions = {
                name: 'getLatestMeeting',
                params: {
                    accountId: cmp.get('v.recordId')
                },
                callback: helper.handleGetLatestMeeting
            },
            newEvtMethodOptions = {
                name: 'getNewEvent',
                params: {
                    accountId: cmp.get('v.recordId')
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
		helper.invokeServerAction(cmp, helper, latestMeetingMethodOptions);
        helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
        helper.invokeServerAction(cmp, helper, fetchEventFieldDetails);        
    },
    
    handleHasMeetingPress: function(cmp, event, helper) {
        var eventId = cmp.get('v.event').Id;
        helper.openPreCallPlanner(cmp, eventId);
    },

    handleHasNoMeetingPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
    },

    handleSavePress: function(cmp, event, helper) {
		var isvalid =  true; 
        
        var sdt = cmp.get('v.newEvent.StartDateTime');
        if(sdt =='' || sdt == null || sdt == 'undefined'){
            cmp.set("v.showEMOne","true");
            isvalid= false; 
        }
        var sub = cmp.get('v.newEvent.Subject');
        if(sub =='' || sub == null || sub == 'undefined'){
            cmp.set("v.showEMTwo","true");
            isvalid= false; 
        }
        console.log( 'isvalid ', isvalid );
        console.log( 'validateFields ', helper.validateFields(cmp) );
        //if(sdt !='' && sdt != null && sdt != 'undefined' && sub !='' && sub != null && sub != 'undefined'){
        if( isvalid ){
            
            console.log( 'isvalid: ', isvalid );
            if(helper.validateFields(cmp)) {
                cmp.set("v.isSpinner",true);
                var newEvent = cmp.get('v.newEvent'),
                    //eventType = cmp.find('eventType').elements[0],
                    eventType = document.getElementById("eventTypeId1").value,
                    //eventTopicOptions = cmp.find('eventTopic').elements[0].children,
                    eventTopicOptions = document.getElementById("eventTopicId1").options,
                    selectedTopicOptions = '';
                //console.log( 'eventTopicOptions: ', JSON.parse( JSON.stringify( eventTopicOptions ) ), 'len: ', document.getElementById("eventTopicId1").options.length );
                for(var i = 0; i < eventTopicOptions.length; i++) {
                    //console.log( 'eventTopicOption: ',eventTopicOptions[i], ' isSelected : ', eventTopicOptions[i].selected );
                    if(eventTopicOptions[i].selected) {
                        selectedTopicOptions += eventTopicOptions[i].value + ';';
                    }
                }
                //console.log( 'selectedTopicOptions111: ', selectedTopicOptions );
                selectedTopicOptions = selectedTopicOptions.slice(0, -1);
                    
                console.log( 'selectedTopicOptions: ', selectedTopicOptions );
                newEvent.whatId = cmp.get('v.recordId');
                newEvent.Event_Topic__c = selectedTopicOptions;
                newEvent.Event_Type__c = eventType;
                newEvent.Location = 'Phone call';
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
                //cmp.set("v.isSpinner",false);
            } else {
                console.log('there are errors');
            }
        }
    },

    handleCloseModalPress: function(cmp, event, helper) {
        helper.toggleModal(cmp);
        $A.get("e.force:closeQuickAction").fire(); 
    },

    changeOne: function(cmp, event, helper) {
        cmp.set("v.showEMOne","false");
    },

    changeTwo: function(cmp, event, helper) {
        cmp.set("v.showEMTwo","false");
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
})