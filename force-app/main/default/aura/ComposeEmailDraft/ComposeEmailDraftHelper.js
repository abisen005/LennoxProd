({
    MAX_FILE_SIZE: 1500000, 
    CHUNK_SIZE: 750000,

    draftMail :function (component, event, helper) { 
        var self = this;
        self.showSpinner(component, null, helper);
        var compulsoryFields = ['from','to'];
        var emailFields = ['from', 'to', 'cc', 'bcc'];
        var isValid = validateCompulsoryFields(component, compulsoryFields);
        console.log('Valid validateCompulsoryFields: ', isValid);
        if(isValid){
            isValid = validateEmailFields(component, emailFields);
        }else{
            self.hideSpinner(component, event, helper);
        }
        
        if(isValid){
            var messageDetails = new Email_Message__c(component); 
            var fileInput = component.find("fileId").get("v.files");
            var attachments = createAttachments(component, self);
            if(attachments){
                attachments.then(function(data) {
                    if(data){
                        messageDetails.Has_Attachment__c = true;
                    }else{
                        messageDetails.Has_Attachment__c = false;
                    }
                    var blobStr;
                    var contentType;
                    if(data){                
                        blobStr = data.split(',')[1];
                        contentType = data.split(',')[0];
                    }
                    self.saveDraftMail(component, JSON.stringify(messageDetails), data, contentType, helper);                
                }); 
            }else{
                if(!fileInput){
                    self.saveDraftMail(component, JSON.stringify(messageDetails), null, null, helper); 
                }else{
                    self.hideSpinner(component, null, helper);
                }
            }
                     
        }else{
            self.hideSpinner(component, null, helper);
        }
        // functions
         function validateCompulsoryFields(component, fields) {            
            var isValid = true; 
            
            fields.forEach(function(fieldName){   
                if($A.util.isEmpty(component.get("v."+fieldName))){
                    var cmpElement = component.find(fieldName);
                    $A.util.addClass(cmpElement, 'slds-has-error'); 
                    //cmpElement.set("v.errors", [{message: "Field can not be Blank"}]);
                    isValid = false;
                }
            });
            console.log('return isValidr', isValid);  
            return isValid;        
        }
        
        function validateEmailFields(component, fields) {
            //var emailRegex = /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([,](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/;
            var isValid = true; 
            fields.forEach(function(fieldName){
               if(!$A.util.isEmpty(component.get("v."+fieldName))){
                    var errorElement = component.find(fieldName);
                    if(checkAllValidEmails(component.get("v."+fieldName).split(","))){                                               
                            //errorElement.set("v.errors", [{message: ''}]);
                            $A.util.removeClass(errorElement, 'slds-has-error');                
                    }else{
                        isValid = false;
                        $A.util.addClass(errorElement, 'slds-has-error');
                        //errorElement.set("v.errors", [{message: "Please Enter a Valid Email Address"}]); 
                    }
                }                
            });
            return isValid;
        }
        
        function Email_Message__c(component){            
            this.Id =  component.get("v.MessageId");
            this.Mail_Body__c =  component.get("v.body");
            this.Subject__c =  component.get("v.subject");
            this.Case_Id__c =  component.get("v.recordId");
            this.BCC_Address__c =  component.get("v.bcc");
            this.CC_Address__c =  component.get("v.cc");
            this.FromAddress__c =  component.get("v.from");
            this.To__c =  component.get("v.to");
            this.Is_Rejected__c = false;
            this.Is_Approved__c = false;
            this.Email_Message_Status__c = 'Draft';    
        }
        
        function validateEmailValue(strEmail){ 
            if(strEmail.includes("@")){
                var pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$/;
                return pattern.test(strEmail.trim()); 
            }
        }
        
        function checkAllValidEmails(ipStrings){            
            var isValid = true;            
            for(var indx =0; indx<ipStrings.length; indx++){
                if(!validateEmailValue(ipStrings[indx])){
                    isValid = false;
                    break;
                }
            }
            return isValid;
        }  
        
        function createAttachments(component, helper, mailMessage){
            var fileInput = component.find("fileId").get("v.files");
            var self = helper;
            if(fileInput){
                if (fileInput[0].size > self.MAX_FILE_SIZE) {
                    component.set("v.showLoadingSpinner", false);
                    component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + fileInput[0].size);
                    return;
                }
                return getBase64(fileInput[0]);
            }
        }
        
        function getBase64(file) {
            var reader = new FileReader();
            
            return new Promise((resolve, reject) => {
                const reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = () => resolve(reader.result);
                reader.onerror = error => reject(error);
            });
        } 
    },
    
    saveDraftMail : function(component, recordDetails, attachementData, contentType, helper){
    	var createEmailMessageAction1 = component.get("c.saveDraftMailMessage"); 
        createEmailMessageAction1.setParams({'mailMessageJSON' : recordDetails,
                                             'attachmentBlob' : attachementData,
                                             'cType' : contentType,
                                             'fileName' : component.get("v.fileName")});
        createEmailMessageAction1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var response = response.getReturnValue();
                console.log(response);
                helper.hideSpinner(component, null, helper);
                helper.showSuccess(component, response.message);
                window.location.assign('/customercare/'+component.get("v.recordId"));
            }else{
                helper.hideSpinner(component, null, helper);
                helper.showError(component, 'Failed to save record');
            }
        });
        $A.enqueueAction(createEmailMessageAction1);	
    },
    
    initialize : function(component, responseVal){
        console.log(responseVal.data);
        if(Array.isArray(responseVal.data)){
            var data = responseVal.data;
            component.set("v.from", data[0].FromAddress__c);
            component.set("v.to", data[0].To__c);
            component.set("v.cc", data[0].CC_Address__c);
            component.set("v.bcc", data[0].BCC_Address__c);
            component.set("v.subject", data[0].Subject__c);
            component.set("v.body", data[0].Mail_Body__c);
            component.set("v.isDisable", !data[0].Is_Rejected__c);
            component.set("v.MessageId", data[0].Id);
            
            if(data[0].CC_Address__c){
                $A.util.toggleClass(component.find("cc"), "toggle");
            }
            if(data[0].BCC_Address__c){
                $A.util.toggleClass(component.find("bcc"), "toggle");
            }
        }
        else{
            component.set("v.from", 'consumeraffairs@lennoxind.com');
            
            if(responseVal.data){
                component.set("v.to", responseVal.data);
            }            
        }
    },    
    
    handleKeyPressEvents: function(component, event, inputVar) {
        if(event.keyCode === 13){    
            var CmpTo = component.find(inputVar);
            if(CmpTo){
                var textStr = CmpTo.get("v.value");
                var lastCommaIndex = textStr.lastIndexOf(",");   
                var lastSpaceIndex = textStr.lastIndexOf(" ");   
                
                if(textStr && lastCommaIndex != (textStr.length -2) 
                   && lastCommaIndex != (textStr.length -1)
                   && lastSpaceIndex != (textStr.length -1)){
                    textStr += ', ';
                    CmpTo.set("v.value", textStr);
                }
            }
        }
        if(event.keyCode === 44){
            event.preventDefault();                    
        } 
        if(event.keyCode === 32 ){
            var CmpTo = component.find(inputVar);
            if(CmpTo){
                var textStr = CmpTo.get("v.value"); 
                var lastSpaceIndex = textStr.lastIndexOf(" ");   
                
                if(textStr && lastSpaceIndex === (textStr.length -1)){
                    event.preventDefault();
                }
            }
        }
    },
    
    handleKeyUpEvents:function(component, event, inputVar) {  
        
        var currentText = component.find(inputVar);
        var currentTextValue = currentText.get("v.value");
        
        if(currentTextValue.includes(",")){
            
            var commaIndex = currentTextValue.lastIndexOf(",");
            currentTextValue = currentTextValue.substring(commaIndex+1);
            
            var spaceIndex = currentTextValue.lastIndexOf(" ");
            if(currentTextValue.includes(" ")){
                currentTextValue = currentTextValue.substring(spaceIndex+1);    
            }
        }else{
            var spaceIndex = currentTextValue.lastIndexOf(" ");
            if(currentTextValue.includes(" ")){
                currentTextValue = currentTextValue.substring(spaceIndex+1);    
            }
        }
        if(event.keyCode === 188){ 
            var CmpTo = component.find(inputVar);              
           
            if(CmpTo){                
                var textStr = CmpTo.get("v.value");                
                var lastCommaIndex = textStr.lastIndexOf(","); 
                var lastSpaceIndex = textStr.lastIndexOf(" ");                
                if(textStr && lastSpaceIndex != (textStr.length -1) 
                   && lastCommaIndex != (textStr.length -2)){
                    CmpTo.set("v.value", textStr += ', ');
                }else if(lastCommaIndex == (textStr.length -1)){
                    CmpTo.set("v.value", textStr.slice(0, -1));
                }               
            }
        }
    },
    
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
                    "recordId": component.get("v.recordId"),
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
    
    //generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            //console.log( 'params-' , params);
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
                    //onsole.log( 'callbackResult.getReturnValue---' , callbackResult.getReturnValue());
                    resolve(callbackResult.getReturnValue());
                }
                if (callbackResult.getState() === 'ERROR') {
                    //console.log('ERROR', callbackResult.getError());
                    reject(callbackResult.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    },
    
    getEmailDefaultValues : function(component, event, helper){
        var self = this;
        
        var selectedTemplateId = component.find("TemplateId").get("v.value");
        //alert(selectedTemplateId);
        
        var getEmailDefaultValues = component.get("c.getEmailDefaultValues");
        getEmailDefaultValues.setParams({
            recordId: component.get("v.recordId"),templateId: selectedTemplateId
        });
        self.showSpinner(component);
        // Define Response handler
        getEmailDefaultValues.setCallback(this, function(auraResponse) {
            self.hideSpinner(component);                
            var state = auraResponse.getState();
            if (state === "SUCCESS") {
                var response = auraResponse.getReturnValue();
                if (response.Success) {
                    var oppo = response.Data;
                    //console.log('oppo.to  ::' + oppo.to);
                    //component.set('v.to', oppo.to);
                    component.set('v.subject', oppo.subject);
                    component.set('v.body', oppo.body);
                    ///component.find('txtRecipients').set('v.value', oppo.to);*/
                } else {
                    //console.log('response :', response.Message);
                    self.showError(component, response.Message);
                }
            } else if (state === "ERROR") {
                self.hideSpinner(component);
                //console.log("ERROR",auraResponse.getError());
                var errorMsg = ''; var errors = auraResponse.getError();
                if (errors && errors[0] && errors[0].message) {
                    errorMsg = errors[0].message;
                } else {
                    errorMsg = "Unknown error. Please try again after some time.";
                }
                //self.showError(component, errorMsg);
            }            
        });
        // Send Action for async execution
        $A.enqueueAction(getEmailDefaultValues);    
    },
})