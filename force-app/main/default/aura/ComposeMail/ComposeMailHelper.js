({
    MAX_FILE_SIZE: 1500000, 
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
        
        var currTxtStr = currentTextValue;
        var getContactAction = component.get("c.getContact");
        getContactAction.setParams({
            contactName: currTxtStr
        }); 
        
        getContactAction.setCallback(this, function(auraResponse) {             
            var state = auraResponse.getState();
            if (state === "SUCCESS") {
                var response = auraResponse.getReturnValue();
                
                var contactList = [];
                if(response.Success){
                    
                    response.Data.forEach(function(contactData) {
                        contactList.push(contactData);  
                    });
                }
                component.set("v.contactListData", contactList);    
               
            } else if (state === "ERROR") {
            	console.log('Inside Error....');       
            }
        });
        
        // Send Action for async execution
        $A.enqueueAction(getContactAction);
        
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
    
    getEmailDefaultValues : function(component, event, helper){
        var self = this;
        
       // var selectedTemplateId = component.find("TemplateId").get("v.value");
        //alert(selectedTemplateId);
        
        var getEmailDefaultValues = component.get("c.getEmailDefaultValues");
        getEmailDefaultValues.setParams({
            recordId: component.get("v.recordId")
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
                    component.find('txtSub').set('v.value', oppo.subject);
                    component.find('txtBody').set('v.value', oppo.body);
                    component.find('txtRecipients').set('v.value', oppo.to);
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
        
    showToastMessage: function (component, msg, type) { 
        if(!msg){
           msg = 'Unexpected Error has been occured, Please contact administrator.'; 
        }
        component.set('v.toastMessageCompose', msg );                         
        component.set('v.ShowMessageClassCompose',  type);  
        
        var x = document.getElementsByClassName("messageDivCompose");
        x[0].style.display = "block";  /*                      
        setTimeout(function(){
            if (x[0].style.display === "block" ) {
                x[0].style.display = "none";
            } 
        }, 3000);*/
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
    createMailContent : function(component){
        var mailContent = function(component){
            // rcpt
            var rcpt = component.find("txtRecipients");
            var rcptVal = rcpt.get("v.value");            
            this.mRecipients = rcptVal.split(",");
            
            // Cc
            var cc = component.find("txtCc");
            var ccVal = cc.get("v.value");
            this.mCcs = ccVal.split(",");
            
            // Bcc
            var bcc = component.find("txtBcc");
            var bccVal = bcc.get("v.value");
            this.mBccs = bccVal.split(",");
            
           var sub = component.find("txtSub");
            this.mSubject = sub.get("v.value");
            // mail body
            this.mBody = component.get("v.mailBody");
            this.mAttachment = component.get("v.mailAttachment");
            this.contentType = component.get("v.mailAttachment");
            this.fileName = component.get("v.fileName");
        }
        var mailContent = new mailContent(component);        
               
        var recptValid = true;
        var ccValid = true;
        var bccValid = true;
        if(mailContent.mRecipients) {
           
            mailContent.mRecipients = removerEmptyStrs(mailContent.mRecipients);            
            recptValid = checkAllValidEmails(mailContent.mRecipients);
            
            var finalVal = [];
            if(component.get("v.selectedContactIdList") && component.get("v.selectedEmailList")){
                finalVal = component.get("v.selectedContactIdList").concat(component.get("v.selectedEmailList"));
                component.set("v.selectedContactIdList",[]);
                component.set("v.selectedEmailList",[]);    
            }
            mailContent.mRecipients = finalVal;
        }         
        if(mailContent.mCcs) {
            
            mailContent.mCcs = removerEmptyStrs(mailContent.mCcs);;            
            ccValid = checkAllValidEmails(mailContent.mCcs); 
            
            var finalVal = [];
            if(component.get("v.selectedContactIdList") && component.get("v.selectedEmailList")){
                finalVal = component.get("v.selectedContactIdList").concat(component.get("v.selectedEmailList"));
                component.set("v.selectedContactIdList",[]);
                component.set("v.selectedEmailList",[]);  
            }           
            mailContent.mCcs = finalVal;            
        }  
        if(mailContent.mBccs) {
            
            mailContent.mBccs = removerEmptyStrs(mailContent.mBccs);
            bccValid = checkAllValidEmails(mailContent.mBccs);
            
            var finalVal = [];
            if(component.get("v.selectedContactIdList") && component.get("v.selectedEmailList")){
                finalVal = component.get("v.selectedContactIdList").concat(component.get("v.selectedEmailList"));                
                component.set("v.selectedContactIdList",[]);
                component.set("v.selectedEmailList",[]);    
            }
            mailContent.mBccs = finalVal;     
        }  
       if(mailContent){
           if(mailContent.mAttachment){                
               mailContent.mAttachment = mailContent.mAttachment.split(',')[1];
               mailContent.contentType = mailContent.contentType.split(',')[0];
           }
           
           console.log('mailContent.contentType :', mailContent.contentType);
           console.log('mailContent.mAttachment :', mailContent.mAttachment);
       if(mailContent.mRecipients && mailContent.mRecipients.length > 0){
                var isValidCC = true;
               	
                if(mailContent.mRecipients.length > 0 && mailContent.mRecipients.length < 101){
                    if((mailContent.mCcs && mailContent.mCcs.length > 25) 
                       || (mailContent.mBccs && mailContent.mBccs.length > 25)){
                        isValidCC = false;
                        this.showError(component,"You can not enter more than 25 cc/bcc mails.")
                    }
                    if(recptValid && ccValid && bccValid){
                        if(isValidCC ){
                         
                            var maiContentJson = JSON.stringify(mailContent);
                            component.set("v.mailContent", maiContentJson);
                            this.sendMail(component, event, maiContentJson);                  
                        }
                    }else{
                        this.showToast(component, 'Error', 'Please enter valid mail address(es).', 'error');
                    }                                     
                }else{
                    if(mailContent.mRecipients.length === 0){
                        this.showToast(component, 'Error', 'Please enter the at least one recipient mail address.', 'error');
                    }
                    else{
                        this.showToast(component, 'Error', 'You can not send mail to more than 100 user recipients.', 'error');
                    }
                }
            }else{
               this.showToast(component, 'Error', 'Please enter the recipient mail address.', 'error');
            }            
        }
        
        function validateEmailValue(strEmail){ 
            
            var contactId = component.get("v.contactNameToIdList"); // importatnt
            
            if(strEmail.includes("@")){

                var pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$/;                
                var selectedEmail = [];
                selectedEmail = component.get("v.selectedEmailList");
                selectedEmail.push(strEmail);
                
                return pattern.test(strEmail); 
            }else{
                
                var selectedId = [];
                selectedId = component.get("v.selectedContactIdList");
                var emailVal = contactId[strEmail]; 
                if(emailVal){
                	selectedId.push(emailVal);
                    return true; 
                }else{
                    var pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$/;                    
                    return pattern.test(strEmail); 
                }
            }
        }
        
        function checkAllValidEmails(ipStrings){
            
            var isValid = true;            
            for(var indx =0; indx<ipStrings.length; indx++){
                if(ipStrings[indx].indexOf('<') != -1&& ipStrings[indx].indexOf('>') != -1 ){
                    var str = ipStrings[indx].substr(ipStrings[indx].indexOf('<') +1, ipStrings[indx].indexOf('>') -1);
                    str = str.replace('>', '');
                    ipStrings[indx] = str;
                }
                if(!validateEmailValue(ipStrings[indx])){
                    isValid = false;
                    break;
                }
            }
            return isValid;
        }
        
        function removerEmptyStrs(ipStrings){
            var opStrings = [];
            for(var index =0; index<ipStrings.length; index++){
                
                if(ipStrings[index] && ipStrings[index] != "" && ipStrings[index] != " "){
					opStrings.push(ipStrings[index].trim().replace(/\s/g,''));                    
                }
            }
            
            return opStrings;
        }
    },

    sendMail: function(component, event, mailContent) {
        var self = this;
        var getEmailDefaultValues = component.get("c.sendMails");
        var recordId = component.get("v.recordId");
        

        getEmailDefaultValues.setParams({
            mailContentJson: mailContent,
            caseId: recordId
        });
        
        self.showSpinner(component);
        // Define Response handler
        getEmailDefaultValues.setCallback(this, function(auraResponse) {
            self.hideSpinner(component);                
            var state = auraResponse.getState();
           
            //alert('state - '+state);
            if (state === "SUCCESS") {
                var response = auraResponse.getReturnValue();

                if (response.Success) {
                    var oppo = response.Data;
                    //console.log(oppo);
                    var toastEvent = $A.get("e.force:showToast");
                    if (!toastEvent) {
                        window.history.back();
                        return;
                    }
                    self.showToast(component, 'Success', 'Email has been sent successfully.', 'success');
                    self.showSuccess(component, response.Message);
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire(); 
                } else {
                    console.log('response :', response.Message);
                    var toastEvent = $A.get("e.force:showToast");

                    if (!toastEvent) {
                        return;
                    }
                    
                    self.showError(component, response.Message);
                }
            } else if (state === "ERROR") {
                self.hideSpinner(component);
                console.log("ERROR",auraResponse.getError());
                var errorMsg = ''; var errors = auraResponse.getError();
                if (errors && errors[0] && errors[0].message) {
                    errorMsg = errors[0].message;
                } else {
                    errorMsg = "Unknown error. Please try again after some time.";
                }
                self.showError(component, errorMsg);
            }            
        });
        // Send Action for async execution
        $A.enqueueAction(getEmailDefaultValues);
    }
    ,
    // General Functions
    showSpinner: function (component, event, helper) {
        component.set("v.isSpinner", true);
    },
    
    hideSpinner: function (component, event, helper) {
        component.set("v.isSpinner", false);
    },
	
    createContatToEmailMap:function(component, event, inputVar){
        
        component.set("v.contactListData", []); 
        
        var id_str = event.target.id; 
        var name_str = document.getElementById(id_str).innerHTML;
       	
        var contactToEmail = [];       
        contactToEmail = component.get("v.contactNameToIdList");       
        contactToEmail[name_str.trim().replace(/\s/g,'')] = id_str;     
        
        var rcpt_Name = component.find(inputVar);
        var rcptVal = rcpt_Name.get("v.value");        
        var lastCommaIndex = rcptVal.lastIndexOf(",");  
        var finalSubString = rcptVal.substr(0, lastCommaIndex + 1);  
        
        if(finalSubString == ''){
            name_str = name_str + ', ';
        }else{
            name_str = ' ' + name_str + ', ';
        } 
        name_str = name_str.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&');
        return finalSubString.concat(name_str);
    },    
    
    createAttachments : function(component, helper, mailMessage){
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
    //generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            console.log( 'params-' , params);
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                console.log("Returning from " + apexAction);
                if (callbackResult.getState() === 'SUCCESS') {
                    console.log( 'callbackResult.getReturnValue---' , callbackResult.getReturnValue());
                    resolve(callbackResult.getReturnValue());
                }
                if (callbackResult.getState() === 'ERROR') {
                    console.log('ERROR', callbackResult.getError());
                    reject(callbackResult.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    },
    
    showToast : function(component, title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type" : type
        });
        toastEvent.fire();
    }
})