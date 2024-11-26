({
    
	setStatus: function(cmp, helper, val) {
        var status;
        switch(val) {
            case 'A':
                status = 'success';
                break;
            case 'B':
                status = 'success';
                break;
            case 'C':
                status = 'warning';
                break;
            default:
                status = 'error';
        }
        cmp.set('v.status', status);
	},
    
    handleGetNewEvent: function(cmp, helper, response) {
        var newEvent = response;
        newEvent.Event_Type__c = 'Phone Call - Outbound';
        newEvent.Event_Topic__c = 'Credit';
        newEvent.DurationInMinutes = 60;
        cmp.set('v.newEvent', newEvent);
    },
    
    handleNewEvent: function(cmp, helper, response) {
        cmp.set('v.isLoading', false);
        cmp.set('v.eventCreated', true);
    },
    
    /**
     * Validate fields in new event form; Add/remove errors
     * @param	{object}	cmp
     * @return	{boolean}	true if all are valid, false if not
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
                    if($A.util.isFiniteNumber(Date.parse(inputVal))) {
                        inputCmp.set('v.errors', null);
                    } else {
                        inputCmp.set('v.errors', [{message: 'Invalid date.'}]);
                        allValid = false;
                    }
                }
            }
        }
        return allValid;
    }
})