({
    /*
     * @purpose : This method will call initially and get the lennox favorite records 
     */ 
    doInit: function(cmp, event, helper) {
        //server action
        var action = cmp.get("c.getFavoritesLink");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serverResponse = response.getReturnValue();
                var keyLinks = [];
                var reports = [];
                var content = [];
                var customLinks = [];
                var errorString;
                
                for( var singlekey in serverResponse){
                    if(singlekey == 'Key Links'){
                        //sort records as per sequence
                        keyLinks = helper.sorting(serverResponse[singlekey]);
                    }else if(singlekey == 'Reports/Dashboards'){
                        //sort records as per sequence
                        reports = helper.sorting(serverResponse[singlekey]);
                    }else if(singlekey == 'Content'){
                        //sort records as per sequence
                        content = helper.sorting(serverResponse[singlekey]);
                    }else if(singlekey == 'Custom Links'){
                        //sort records as per sequence
                        customLinks = helper.sorting(serverResponse[singlekey]);
                    }
                } 
                
                cmp.set("v.keyLinks", keyLinks);
                cmp.set("v.reports", reports);
                cmp.set("v.content", content);
                cmp.set("v.customLinks", customLinks);
                console.log(reports);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        var errorString = 'Lennox Favorites could not load caused: ' + errors[0].message+ ' Contact your Admin.';
                        helper.showToast(cmp, 'error', errorString, 'Error');
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * @purpose : This method will handler the prview of file
     */ 
    handlePreviewFile: function(cmp, event, helper) {
        //var category = cmp.get("v.category");
        //var documentId = category.documentId;
        //console.log("document id" + documentId);
        //var buttonId = cmp.find("contentButton").get("v.buttonTitle");
        var docId = event.currentTarget.id;
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [docId]
        });
    },
    
    /*
     * @purpose : This method will open the lightning view model
     */ 
    openModal: function(cmp, event, helper) {
        var category = parseInt(event.currentTarget.getAttribute('data-category'));
        var contents = cmp.get("v.content");
        console.log(contents[category]);
        cmp.set("v.contentRecord",contents[category]);
        cmp.set("v.isOpen", true);
    },

	 /*
     * @purpose : This method will close the lightning view model
     */     
    closeModal: function(cmp, event, helper) {
        cmp.set("v.isOpen", false);
    }
})