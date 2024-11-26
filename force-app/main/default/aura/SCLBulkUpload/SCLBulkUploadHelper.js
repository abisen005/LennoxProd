({
    upload: function(recId, component, file, base64Data, callback) {
        
        console.log('Check2',recId+ ''+file +''+base64Data);

        var action = component.get("c.uploadFile");
        console.log('type123: ' + file.type);
        action.setParams({
            recordId: recId,
            filename: file.name,
            base64Data: base64Data,
            contentType: file.type
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message123: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    
    uploadRecs: function(component, fn, recs, callback) {
        console.log('Uploading records...');
        var action = component.get("c.saveRecords");
        action.setParams({
            filename: fn,
            records: recs
        });

        action.setCallback(this,
            function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    callback(a.getReturnValue());
                }
            });

        $A.enqueueAction(action);
    },

    show: function (cmp, evt) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hide:function (cmp, evt) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
})