({
    handleInit: function(cmp, event, helper) {
        console.log(cmp.get('v.accountId'));
        console.log(cmp.get('v.recordId'));
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
                    accountId: cmp.get('v.accountId')
                },
                callback: helper.handleGetEventFieldDetails
            },
            currentProfile = {
                "callback": function(component, helper, responseData) {

                    if (responseData.isSuccess) {

                        let data = responseData.data;
                        let profileForTmdmArray = data.profileForTmdmList;
                        let currentProfile = data.currentProfile;

                        let isProfilePermitted = profileForTmdmArray.some(profile => {
                            
                            return profile.Profile_Name__c === currentProfile;
                        });

                        if (isProfilePermitted) {

                            component.set("v.permittedProfile", false);
                        } else {

                            component.set("v.permittedProfile", true);
                        }
                    } else {

                        helper.showToast("Error!", "Unable to fetch Profile data. Please try again.", "error");
                    }
                },
                "name": "getProfileData"
            };
        helper.invokeServerAction(cmp, helper, latestMeetingMethodOptions);
        helper.invokeServerAction(cmp, helper, newEvtMethodOptions);
        helper.invokeServerAction(cmp, helper, fetchEventFieldDetails);
        
        helper.invokeServerAction(cmp, helper, currentProfile);
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
                var newEvent = cmp.get('v.newEvent');
                
                newEvent.whatId = cmp.get('v.accountId');
                newEvent.Event_Topic__c = cmp.get('v.EventTopic');
                newEvent.Event_Type__c = cmp.get('v.EventType');
                console.log('newEvent--',newEvent);
                
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