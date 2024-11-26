({
    showSuccess: function (component, msg) {
        this.showToastMessage(component, msg, "slds-theme_success");
    },
    
    showWarning: function (component, msg) {
        this.showToastMessage(component, msg, "slds-theme--warning");
    },
    
    showError: function (component, msg) {
        this.showToastMessage(component, msg, 'slds-theme_error');
    },
    
    showToastMessage: function (component, msg, type) {   
        component.set('v.toastMessage', msg );                         
        component.set('v.ShowMessageClass',  type);  
        var x = document.getElementsByClassName("messageDiv");
        x[0].style.display = "block";                        
        setTimeout(function(){
            if (x[0].style.display === "block" ) {
                x[0].style.display = "none";
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.childRecordId"),
                    "slideDevName": "Detail"
                });
                navEvt.fire();
            } 
        }, 2000);
        
        
    },
    
    // General Functions
    showSpinner: function (component, event, helper) {
        component.set("v.isSpinner", true);
    },
    
    hideSpinner: function (component, event, helper) {
        component.set("v.isSpinner", false);
    },
    
    openTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var caseRecordID = component.get("v.childRecordId");
        workspaceAPI.openTab({
            url: '#/sObject/'+caseRecordID+'/view',
            focus: true
        });
    },
    
    /*showSpinner: function (component,  helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },*/
    
	createCaseResourceRecord: function(component, event, helper){
          
        var self = this;        
		self.showSpinner(component, helper);
        
        var createCase = component.get("c.createCSChildCase");
        
        createCase.setParams({
            caseId: component.get("v.recordId")
        });
        // Define Response handler
        createCase.setCallback(this, function(auraResponse) {
            self.hideSpinner(component, helper);       
             
            var state = auraResponse.getState();
            if (state === "SUCCESS") {
                //response.getReturnValue()
                var response = auraResponse.getReturnValue();
                if(response === "") {
                	self.showError(component,'Failed to create case resource record');
                } else {
                    component.set("v.childRecordId", response);
                    //self.showSuccess(component,'Success! Case Resource record created successfully'); 
                    self.openTab(component, event, helper);
                }
                
            } else if (state === "ERROR") {
                self.hideSpinner(component);
                var errorMsg = ''; 
                var errors = auraResponse.getError();
                if (errors && errors[0] && errors[0].message) {
                    errorMsg = errors[0].message;
                } else {
                    errorMsg = "Unknown error. Please try again after some time.";
                }
                self.showError(component,errorMsg);
            }
        });
        
        // Send Action for async execution
        $A.enqueueAction(createCase);
    }
})