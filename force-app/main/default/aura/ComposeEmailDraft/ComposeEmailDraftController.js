({
    doInit : function(component, event, helper) {
	    var fetchUserEmailAction = component.get("c.fetchDraftDetails"); 
        fetchUserEmailAction.setParams({
            'caseId' : component.get("v.recordId")
        });
        
        fetchUserEmailAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVal = response.getReturnValue();
                helper.initialize(component, responseVal);
            }
        });
        $A.enqueueAction(fetchUserEmailAction);
        
        //Call helper method to get all Templates
        helper.callApexAction(component, 'getEmailTemplates', {})
        .then(function (result) {
            if (result.isSuccess) {
                //console.log('Email Templates--- ',result.data);
                component.set('v.options', result.data);
                //helper.hideSpinner(component);
            }
            else {
                helper.showError(component, result.message);
                //helper.hideSpinner(component);
            }
        });
    },
    
    renderedEmailBody : function(component, event, helper) {
        var selectedTemplateId = component.find("TemplateId").get("v.value");
        //alert(selectedTemplateId); 
        
        if( selectedTemplateId != 'None'){
            helper.getEmailDefaultValues(component,event,helper);
        }
    },
    
	validateAndSaveEmail : function(component, event, helper) {
        helper.draftMail(component, event, helper);
    },
    
    closeModal : function(component, event, helper){
        window.location.assign('/customercare/'+component.get("v.recordId"));
    },
    
    // txtRecipients keyPress Events
    addSeparatorTo : function(component, event, helper) {
        helper.handleKeyPressEvents(component, event, 'to');
    },
    
    // txtRecipients keyup Events 
    addSeparatorToUp : function(component, event, helper) {    
        helper.handleKeyUpEvents(component, event, 'to');        
    },
    
    toggleCc : function(component, event, helper) {
        var ccElement = component.find("cc");
        ccElement.set("v.value", "");
        $A.util.toggleClass(ccElement, "toggle");
    },
    
    toggleBcc : function(component, event, helper) {        
        var bccElement = component.find("bcc");        
        bccElement.set("v.value", "");
        $A.util.toggleClass(bccElement, "toggle");		
    },
    
    // txtCc keyup Events 
    addSeparatorCcUp : function(component, event, helper) {
        helper.handleKeyUpEvents(component, event, 'cc');        
    },    
    // txtCc KeyPress Events
    addSeparatorCc : function(component, event, helper) {
        helper.handleKeyPressEvents(component, event, 'cc');
    },
    
    // txtBcc keyup Events 
    addSeparatorBccUp : function(component, event, helper) {
        helper.handleKeyUpEvents(component, event, 'bcc');        
    },   
    // txtBcc KeyPress Events
    addSeparatorBcc : function(component, event, helper) {
        helper.handleKeyPressEvents(component, event, 'bcc');
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected.';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        /*var fileName = 'No File Selected.';
        helper.showSpinner(component, event, helper);
        if (event.getSource().get("v.files").length > 0) {
            var files = event.getSource().get("v.files");//[0]['name'];
            fileName = '';
            for(var i=0; i< files.length; i++){
                fileName = fileName + '\n\r' + files[i]['name'];
            }            
            
            helper.createAttachments(component, helper, '').then(function(data) {
                
                component.set("v.mailAttachment", data);
                helper.hideSpinner(component, event, helper);
                //self.saveDraftMail(component, JSON.stringify(messageDetails), data, helper);                
            });
        }else{
            component.set("v.mailAttachment", '');
            helper.hideSpinner(component, event, helper);
        }
        component.set("v.fileName", fileName);*/
    },
    
    hideMessageDiv : function(component, event, helper) {
        var x = document.getElementsByClassName("messageDiv");
        x[0].style.display = "none";
    },
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log("Files uploaded : " + uploadedFiles);
        
    }
})