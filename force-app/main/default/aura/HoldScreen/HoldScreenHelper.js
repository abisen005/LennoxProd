({
    handleNavigate: function(cmp, event,helper) {
        
        cmp.set("v.displayLoader",false);
        var navigate = cmp.get("v.navigateFlow");
        if(navigate){
            navigate("NEXT");
        }
        
    },
    getCaseInfo : function(component, event, helper) {
        
        console.log('1111111111');
        var action = component.get("c.getCase");
        var recordId = component.get("v.recordId");
        var modelNo = component.get("v.modelNo");
        var message = component.get("v.message");
        
        action.setParams({"caseId": recordId});
        
        action.setCallback(this, function(response){
            var caseRec = response.getReturnValue(); 
            
            if(caseRec != null){
                
                if(caseRec.Model_Number__c != modelNo 
                   || caseRec.SAP_Error_Message__c != message){
                    console.log('Test');
                    // navigate to next screen 
                    if(this != null){
                        this.handleNavigate(component, event, helper); 
                    }
                    
                }else{
                    this.getCaseInfo(component, event, helper);
                }
            }else{
                component.set("v.errorMsg",'RecordId related Case record not found!');
                this.displayErrorMessage(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    displayErrorMessage : function(component, event, helper) {
        
        var toastEvent = $A.get("event.force:showToast");
        var message = component.get("v.errorMsg");
        
        toastEvent.setParams({
            title : 'Error',
            message: message,
            duration:' 5000',
            type: 'Error'
        });
        
        toastEvent.fire();        
        // navigate to next screen 
        if(this != null){
            helper.handleNavigate(component, event, helper);
        }
    }
})