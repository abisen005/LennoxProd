({
    doinit : function(component, event, helper) {
        //helper.getEmailAttachments(component,event);
        helper.showSpinner(component);
        //helper.getEmailDefaultValues(component,event,helper);
        document.addEventListener("click", (evt) => {
            const flyoutElement = document.getElementById("mailSelection");
            let targetElement = evt.target; // clicked element
            
            do {
                if (targetElement == flyoutElement) {
                // This is a click inside. Do nothing, just return.
                return;
        	}
            // Go up the DOM
            targetElement = targetElement.parentNode;
            } while (targetElement);
        
        	// This is a click outside.
        	component.set("v.isTo", "false");
        	component.set("v.isCC", "false");
        	component.set("v.isBCC", "false");        
        });
    
        //Call helper method to get all Templates
        helper.callApexAction(component, 'getEmailTemplates', {})
        .then(function (result) {
            if (result.isSuccess) {
                console.log('Email Templates--- ',result.data);
                component.set('v.options', result.data);
                //helper.hideSpinner(component);

                // component.set("v.isEnabled", result.isEnabled);

                // //If isEnabled is false (email has already been sent), throw a toast (if available) or an alert
                // if (!result.isEnabled) {
                //     var toastEvent = $A.get("e.force:showToast");
                //     console.log("isEnabled is false");
                //     if (toastEvent) {
                //         //toast is available, use that
                //         toastEvent.setParams({
                //             title:'Warning', 
                //             message: 'A Consumer Affairs form has already been sent. Should you need to send another, please create a new child case.', 
                //             type:'info',
                //             duration:10000
                //         });

                //         toastEvent.fire();
                //     } else {
                //         alert("A Consumer Affairs form has already been sent. Should you need to send another, please create a new child case.");
                //         window.history.back();
                //     }
                // }
            }
            else {
                helper.showToastMessage(component, 'Error', result.msg, 'error');
                //helper.hideSpinner(component);
            }
        });

		var recordId = component.get("v.recordId");		

		//Call helper method to get all Templates
        helper.callApexAction(component, 'getEmailAddress', {recordId})
        .then(function (result) {
            console.log('Returning from getEmailAddress');
            if (result.isSuccess) {
                console.log('Email--- ',result.data);
                component.find('txtRecipients').set('v.value', result.data);


                component.set("v.isEnabled", result.isEnabled);

                //If isEnabled is false (email has already been sent), throw a toast (if available) or an alert
                if (!result.isEnabled) {
                    var toastEvent = $A.get("e.force:showToast");
                    console.log("isEnabled is false");
                    if (toastEvent) {
                        //toast is available, use that
                        toastEvent.setParams({
                            title:'Warning', 
                            message: 'A Consumer Affairs form has already been sent. Should you need to send another, please create a new child case.', 
                            type:'info',
                            duration:10000
                        });

                        toastEvent.fire();
                    } else {
                        alert("A Consumer Affairs form has already been sent. Should you need to send another, please create a new child case.");
                        window.history.back();
                    }
                }
            }
            else {
                helper.showToastMessage(component, result.msg, 'Error', 'error');
            }
        });
                                                             
        helper.getEmailDefaultValues(component,event,helper);
                                                             
    	helper.hideSpinner(component);
    },
 
     renderedEmailBody : function(component, event, helper) {
         //var selectedTemplateId = component.find("TemplateId").get("v.value");
         //alert(selectedTemplateId); 
         
         if( selectedTemplateId != 'None'){
             helper.getEmailDefaultValues(component,event,helper);
         }
    },
    
    toggleCc : function(component, event, helper) {
        var ccElement = component.find("txtCc");
        ccElement.set("v.value", "");
        $A.util.toggleClass(ccElement, "toggle");
    },
    
    toggleBcc : function(component, event, helper) {        
        var bccElement = component.find("txtBcc");
        bccElement.set("v.value", "");
        $A.util.toggleClass(bccElement, "toggle");		
    },
    
    // txtRecipients keyup Events 
    addSeparatorToUp : function(component, event, helper) {       
        helper.handleKeyUpEvents(component, event, 'txtRecipients');        
    },
    // txtRecipients keyPress Events
    addSeparatorTo : function(component, event, helper) {
        component.set("v.isTo", "true");
        component.set("v.isCC", "false");
        component.set("v.isBCC", "false");
        helper.handleKeyPressEvents(component, event, 'txtRecipients');
    },
    
    // txtCc keyup Events 
    addSeparatorCcUp : function(component, event, helper) {
        helper.handleKeyUpEvents(component, event, 'txtCc');        
    },    
    // txtCc KeyPress Events
    addSeparatorCc : function(component, event, helper) {
        component.set("v.isCC", "true");
        component.set("v.isTo", "false");
        component.set("v.isBCC", "false");
        helper.handleKeyPressEvents(component, event, 'txtCc');
    },
    
    // txtBcc keyup Events 
    addSeparatorBccUp : function(component, event, helper) {
        helper.handleKeyUpEvents(component, event, 'txtBcc');        
    },   
    // txtBcc KeyPress Events
    addSeparatorBcc : function(component, event, helper) {
        component.set("v.isBCC", "true");
        component.set("v.isTo", "false");
        component.set("v.isCC", "false");
        helper.handleKeyPressEvents(component, event, 'txtBcc');
    },
    
    sendMail : function(component, event, helper) {
        helper.createMailContent(component);
    },
    
    closeModal : function(component, event, helper) {       
        //component.set("v.isOpen", false); 
        // Close the action panel 
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 

        if (dismissActionPanel) {
            dismissActionPanel.fire(); 
        } else {
            //If there's no dismissActionPanel event to fire, assume this is an external page and use history.back
            window.history.back();
        }
    },
    storeLookupValue: function(component, event, helper) {             
        component.set("v.isTo", "false");        
        console.log('txtRecipients');
        var finalStr =  helper.createContatToEmailMap(component, event, 'txtRecipients');
        
        component.find('txtRecipients').set('v.value', finalStr);
    },
    
    storeLookupValueCC: function(component, event, helper) {     
        component.set("v.isCC", "false");        
        var finalStr =  helper.createContatToEmailMap(component, event, 'txtCc');
        component.find('txtCc').set('v.value', finalStr);
    },
    
    storeLookupValueBCC: function(component, event, helper) {  
        
        component.set("v.isBCC", "false");        
        var finalStr =  helper.createContatToEmailMap(component, event, 'txtBcc');
        
        component.find('txtBcc').set('v.value', finalStr);
    },
    hideMessageDivCompose : function(component, event, helper) {
            var x = document.getElementsByClassName("messageDivCompose");
            x[0].style.display = "none";
        },
    outsideDiv: function(component, event, helper) {
        component.set("v.isTo", "false"); 
        component.set("v.isCC", "false"); 
        component.set("v.isBCC", "false"); 
    },
        
        handleUploadFinished : function (cmp, event){
            // Get the list of uploaded files
            var uploadedFiles = event.getParam("files");
            console.log("Files uploaded : " + uploadedFiles.length);
        },
            
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected.';
        helper.showSpinner(component);
        if (event.getSource().get("v.files").length > 0) {
            var files = event.getSource().get("v.files");//[0]['name'];
            fileName = '';
            for(var i=0; i< files.length; i++){
                fileName = fileName + '\n\r' + files[i]['name'];
            }            
            
            var fileInput = component.find("fileId").get("v.files");
            
            if (fileInput[0].size > 1500000) {
                //alert('file size too large');
                component.set("v.showLoadingSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + fileInput[0].size); 
                fileName = 'Alert : File size cannot exceed ' + '1500000' + ' bytes.\n' + ' Selected file size: ' + fileInput[0].size; 
            }
            else{
                helper.createAttachments(component, helper, '').then(function(data) {
                    
                    component.set("v.mailAttachment", data);
                    helper.hideSpinner(component);                                   
                });
            }
        }else{
            component.set("v.mailAttachment", '');
            helper.hideSpinner(component);
        }
        component.set("v.fileName", fileName);
        helper.hideSpinner(component);
    },        
       
})