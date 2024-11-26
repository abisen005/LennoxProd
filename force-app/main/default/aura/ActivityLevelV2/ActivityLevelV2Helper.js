({
    handleServerActionError: function(cmp, helper, actionName, error) {
        console.log(actionName, error);
        
        var modalAlert = $A.get('e.c:ModalAlert'),
            errorMsg;
        if(error[0])
            if(error[0].pageErrors)
                if(error[0].pageErrors[0])
                    errorMsg = error[0].pageErrors[0].message;

        modalAlert.setParams({ 
            alertType: 'error',
            alertMessage: errorMsg || 'There was a problem creating the Event.'
        });

        cmp.set('v.isLoading', false);
        modalAlert.fire();
    },

    handleGetLatestMeeting: function(cmp, helper, response) {
        var now = new Date(),
            eventDate,
            numberDays;

        if(response) {
            console.log('inALV2', response);
            eventDate = new Date(response.StartDateTime);
            numberDays = Math.round((now-eventDate)/(1000*60*60*24));
            numberDays = numberDays < 0 ? numberDays * -1 : numberDays;  //always be a positive value
            cmp.set('v.event', response);
            cmp.set('v.numberDays', numberDays);

            if(+now > +eventDate) { //the event is in the past
                cmp.set('v.title', 'Days Since Last Meeting');
                cmp.set('v.hasMeeting', false);
                cmp.set('v.status', numberDays < 8 ? 'success' : numberDays < 15 ? 'warning' : 'error');
            } else {
                cmp.set('v.title', 'Days Until Next Meeting');
                cmp.set('v.hasMeeting', true);
                cmp.set('v.status', 'success');
            }
        } else {
            cmp.set('v.title', 'Days Since Last Meeting');
            cmp.set('v.hasMeeting', false);
            cmp.set('v.numberDays', null);
            cmp.set('v.status', 'error');
        }

        cmp.set('v.isLoading', false);
    },

    handleGetNewEvent: function(cmp, helper, response) {
        var newEvent = response;
        newEvent.Event_Type__c = 'Pre Call Planner';
        newEvent.DurationInMinutes = 60;
        cmp.set('v.newEvent', newEvent);
    },

    openPreCallPlanner: function(cmp, eventId) {

        var url = '/apex/TMPreCallPlanner?id=' + eventId,
            urlEvent = $A.get('e.force:navigateToURL');

        if(urlEvent) {
            urlEvent.setParams({'url': url});
            urlEvent.fire();
        } else {
            console.log(document.getElementById('planNextMeetingLink'));
            document.getElementById('planNextMeetingLink').click();
        }
    },

    handleNewEvent: function(cmp, helper, response) {
        var event = response;
        cmp.set('v.event', event);
        helper.openPreCallPlanner(cmp, event.Id);
    },

    toggleModal: function(cmp) {
        var isOpen = cmp.get('v.isModalOpen');
        cmp.set('v.isModalOpen', !isOpen);
    },

    /**
     * Validate fields in new event form; Add/remove errors
     * @param  {object}  cmp
     * @return  {boolean}  true if all are valid, false if not
     */
    validateFields: function(cmp) {
        var fieldsToValidate = ['subject', 'startDateTime', 'duration'],
            allValid = true,
            inputCmp,
            inputVal;

        for(var i = 0; i < fieldsToValidate.length; i++) {
            inputCmp =  cmp.find(fieldsToValidate[i]);
            inputVal = inputCmp.get('v.value');
            //if component has required class, length of value must be greater than 0

            if($A.util.hasClass(inputCmp, 'required')) {
                if($A.util.isUndefined(inputVal)) {
                    inputCmp.set('v.errors', [{message: 'This field is required.'}]);
                    allValid = false;
                } else if(inputVal.length === 0) {
                    inputCmp.set('v.errors', [{message: 'This field is required.'}]);
                    allValid = false;
                } else {
                    inputCmp.set('v.errors', null);
                }
            }

            if($A.util.hasClass(inputCmp, 'required-date')) {
                if(inputVal) {
                    /*if($A.util.isFiniteNumber(Date.parse(inputVal))) {
                        inputCmp.set('v.errors', null);
                    } else {
                        inputCmp.set('v.errors', [{message: 'Invalid date.'}]);
                        allValid = false;
                    }*/
                }
            }
        }

        return allValid;
    },
    
    handleGetEventFieldDetails: function(cmp, helper, response) {
        var eventFields = response; 
        console.log('eventFieldssss::::', eventFields);
        
        if(eventFields){
            var eventTopics = eventFields["Event_Topic__c"];
            var eventTypes = eventFields["Event_Type__c"];
            cmp.set('v.eventTypeOptions', eventTypes);
            cmp.set('v.eventTopicOptions', eventTopics);            
        }
    },
})