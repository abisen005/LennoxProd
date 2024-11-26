({
    sameAsClick : function(component, event, helper) {
        console.log('sameAs...');
        var chk = component.find("chkSameAs");

        var svcName = component.find("servicingName");
        var svcPhone = component.find("servicingPhone");

        svcName.reset();
        svcPhone.reset();

        console.log(chk, svcName, svcPhone);
        console.log('values: ', chk.get("v.checked"), svcName.get("v.disabled"),svcPhone.get("v.disabled"));
        if (chk.get("v.checked")==true) {
            svcName.set("v.disabled", true);
            svcPhone.set("v.disabled", true);

            var inName = component.find("installingName");
            var inPhone = component.find("installingPhone");
            console.log(inName, inPhone);
            console.log('values: ', inName.get("v.value"),inPhone.get("v.value"));

            svcName.set("v.value", inName.get("v.value"));
            
            svcPhone.set("v.value", inPhone.get("v.value"));
            //component.set("v.servicingPhone", cmp.get("v.installingPhone"));
        }
        else {
            svcName.set("v.disabled", false);
            svcPhone.set("v.disabled", false);

            svcName.set("v.value", '');

            svcPhone.set("v.value", '');
            //component.set("v.servicingPhone", '');
        }
    },

    doInit : function(component, event, helper) {
        var url = window.location.href;
        if(url.includes("id")){
            var parts = url.split('id=');
            var caseId = parts[parts.length - 1];
            
            //Validate Case Id
            helper.callApexAction(component, 'getObjectName', {"caseId": caseId})
            .then(function (result) {
                if (result) {
                    component.set("v.isShowMainForm", true);
                    component.set("v.validId", false);                    
                }
                else {
                    component.set("v.validId", true);
                    component.set("v.isShowMainForm", false);
                }
            });
            
            //get recordTypeId
            helper.callApexAction(component, 'getRecordTypeId', {})
            .then(function (result) {
                if (result) {
                    console.log('result', result);     
                    component.set("v.recordTypeId", result);
                }
                else {
                    console.log('falser', result); 
                }
            });
        }       
    },
    
    setDefaults : function(component, event, helper) {
        //Get Site Location record 
        var url = window.location.href;
        var parts = url.split('id=');
        var caseId = parts[parts.length - 1];
        
        
        helper.callApexAction(component, 'getSiteLocationDetails', {"caseId": caseId})
        .then(function (result) {
            
            if (result.isSuccess) {
               
                
                if(result.lennoxFormSubmitted){
                    component.set("v.isShowMainForm", false);
                    var message = $A.get("$Label.c.ConsumerAffairs_FormSubmittedOnceMsg");
                    //message = message + "If you have any additional query please response to the same email to open a new case.";
                    component.set('v.Errormsg',message);
                    component.set('v.showToast',true);
                    window.scrollTo(0,0);
                }else{
                    
                    if(!component.get("v.isformSubmitted")){
                        console.log('component.find("First_Name__c")', result.data);
                        component.set("v.siteLocation", result.data);
                        var siteLocation = component.get("v.siteLocation");
                        component.find("Site_Location__c").set("v.value", siteLocation.Id);
                        component.find("First_Name__c").set("v.value", siteLocation.FirstName__c);
                        component.find("Last_Name__c").set("v.value", siteLocation.LastName__c);
                        
                        var state;
                        if(siteLocation.StateProvince__c){
                            state = siteLocation.StateProvince__c.trim();
                            //  component.find("Consumer_State__c").set("v.value", state);
                        }
                        
                        component.find("Home_Phone__c").set("v.value", siteLocation.Phone__c);
                        component.find("Business_Phone__c").set("v.value", siteLocation.Phone1__c);  
                    }
                }
            }
            else {
                console.log('result false--- ',result);
            }
        });
    },
    
    handleProductChange : function(component, event, helper) {
        var numberOfProducts = component.get("v.numberOfProducts");
        var installationList = component.get("v.installationList");
        
        installationList.length = 0;
        //alert(numberOfProducts);
        while(numberOfProducts > 0){
            installationList[numberOfProducts -1 ] = {};
            installationList[numberOfProducts -1 ].Installation_Type__c = '';
            installationList[numberOfProducts -1 ].Date_Installed__c = '';
            installationList[numberOfProducts -1 ].Serial_Number__c = '';
            installationList[numberOfProducts -1 ].Model_Number__c = '';
            numberOfProducts--;
        }
        component.set("v.installationList",installationList);
        
    },
    
    handleFilesChange: function(component, event, helper) {
        //var fileName = 'No File Selected.';
        helper.showSpinner(component); 
         
        if (event.getSource().get("v.files").length > 0) {
            var files = event.getSource().get("v.files");//[0]['name'];
            var fileName = component.get("v.fileName");
            for(var i=0; i< files.length; i++){
                fileName = fileName + '\n\r' + files[i]['name']+', '; 
            }            
            
            var fileInput = component.find("fileId").get("v.files");
            component.set("v.fileName", fileName);
            var attachments = component.get('v.attachements');
            var fileDetails = component.get('v.fileDetails');
            
            for(var index = 0 ; index<fileInput.length; index++){
                
                if (fileInput[index].size > 1500000) {
                    component.set('v.fileDetails',"");
                    component.set('v.fileName',"");
                    component.set('v.fileError',true);
                    //alert('file size too large');
                    component.set("v.isSpinner", false);
                    component.set("v.isShowUploadFileSpinner", false);
                    component.set("v.fileErrorMsg", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + fileInput[index].size); 
                    //fileName = 'Alert : File size cannot exceed ' + '1500000' + ' bytes.\n' + ' Selected file size: ' + fileInput[index].size; 
                   
                }else{
                    component.set('v.fileError',false);
                    var filed = { name: fileInput[index].name, type: fileInput[index].type};
                    console.log('filed == ',filed);
                    fileDetails.push(filed);

                    helper.createAttachments(component, helper, '', index, fileInput[index]).then(function(data) {
                        //component.set("v.mailAttachment", data);
                        attachments.push(data);
                        component.set("v.attachements", attachments);
                        helper.hideSpinner(component);                               
                    });
                }
            }
            
            component.set("v.fileDetails", fileDetails);
            /*if (fileInput[0].size > 1500000) {
                //alert('file size too large');
                component.set("v.isSpinner", false);
                component.set("v.isShowUploadFileSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + fileInput[0].size); 
                fileName = 'Alert : File size cannot exceed ' + '1500000' + ' bytes.\n' + ' Selected file size: ' + fileInput[0].size; 
            }else{
                helper.createAttachments(component, helper, '').then(function(data) {
                    component.set("v.mailAttachment", data);
                    helper.hideSpinner(component);                               
                });
            }*/
            
        }else{
            component.set("v.mailAttachment", '');
            helper.hideSpinner(component);
        }
        
    },
    
    handleOnSubmit : function(component, event, helper) {
        
        helper.showSpinner(component);
        event.preventDefault(); // Prevent default submit
        var lennoxFormSubmit = component.get("v.formSubmitted");
        console.log('lennoxFormSubmit', lennoxFormSubmit);
        
        var fields = JSON.parse(JSON.stringify(event.getParam("fields")));   
        
        let placeDetails = component.get("v.placeDetails");
        
        if (placeDetails && placeDetails.length > 0) {
            
            var streetdAddress = '';
            
            for (var i = 0; i < placeDetails.length; i++) {
                
                if (placeDetails[i].label == 'street_number') {
                    
                    streetdAddress = placeDetails[i].value + ', ';
                } else if(placeDetails[i].label == 'route') {
                    
                    fields["Consumer_Street_Address__c"] = streetdAddress + placeDetails[i].value + ', ';
                } else if(placeDetails[i].label == 'locality') {
                    
                    fields["Consumer_City__c"]  = placeDetails[i].value;
                } else if(placeDetails[i].label == 'administrative_area_level_2') {
                    
                    fields["Consumer_County__c"] = placeDetails[i].value;
                } else if(placeDetails[i].label == 'administrative_area_level_1') {
                    
                    fields["Consumer_State__c"] = placeDetails[i].value;
                } else if(placeDetails[i].label == 'postal_code') {
                    
                    fields["Consumer_Postal_Code__c"] = placeDetails[i].value;
                } else if(placeDetails[i].label == 'country') {
                    
                    fields["Consumer_Country__c"] = placeDetails[i].value;
                }
            }
            
            //fields["Consumer_Street_Address__c"] = streetdAddress;
        }
        
        var url = window.location.href;
        var parts = url.split('id=');
        var caseId = parts[parts.length - 1];
        fields["CaseId__c"] = caseId; // Get Id from URL
        fields["Summary_of_Concerns__c"] = component.get('v.summaryConcern');
        
        component.set('v.caseId',caseId); 
        //component.find('createLennoxForm').submit(fields); 
        
        var errorMessage = 'Please Review The Form and Complete All Required Fields.';
        var summaryerror = false;
        var producterror = false;
        var summary = component.find("Summary_of_Concerns__c");
        if(component.find("Summary_of_Concerns__c").get("v.value") == null || component.find("Summary_of_Concerns__c").get("v.value") == ""){
            $A.util.addClass(component.find("Summary_of_Concerns__c"), 'slds-has-error');  
            summaryerror = true;
        }else{
            $A.util.removeClass(component.find("Summary_of_Concerns__c"), 'slds-has-error'); 
            summaryerror = false;
        }
        console.log('====');
        console.log(component.find("productInstall").get("v.value"));
        if(component.find("productInstall").get("v.value") == null || component.find("productInstall").get("v.value") == ""){
            $A.util.addClass(component.find("productInstall"), 'slds-has-error');  
            producterror = true;
        }else{
            $A.util.removeClass(component.find("productInstall"), 'slds-has-error'); 
            producterror = false;
        }
        
        var error = false;
        if(component.get('v.fileError')){
            errorMessage = 'Please check the error with file.';
            error = true;
        }
        var reqerror = false;
        var reqfields = component.find("required");
        console.log(reqfields);
       // console.log(fields.length);
        
        if((component.find("productInstall").get("v.value") != null || component.find("productInstall").get("v.value") != "") && reqfields != undefined){
            if(component.find("productInstall").get("v.value") == "1" || component.find("productInstall").get("v.value") == 1){
                if((reqfields.get("v.value") != "Indoor" && reqfields.get("v.value") != "Outdoor" && reqfields.get("v.value") !="Accessories") || reqfields.get("v.value") == ""){
                    $A.util.addClass(reqfields, 'slds-has-error');  
                    reqerror = true;
                }else{
                    $A.util.removeClass(reqfields, 'slds-has-error'); 
                    reqerror = false;
                } 
                
            }else{
                
                reqfields.forEach(function (field) { 
                    if((field.get("v.value") != "Indoor" && field.get("v.value") != "Outdoor" && field.get("v.value") !="Accessories")|| field.get("v.value") == ""){
                        $A.util.addClass(field, 'slds-has-error');  
                        reqerror = true;
                    }else if($A.util.hasClass(field, "slds-has-error")){
                        $A.util.removeClass(field, 'slds-has-error'); 
                        reqerror = false;
                    }
                    
                });  
            }
            
        }
        
        if(summaryerror || producterror || error || reqerror){
            helper.hideSpinner(component);
            window.scrollTo(0,0);
            component.set('v.Errormsg',errorMessage);
            component.set('v.showToast',true);
        }else{
            //helper.hideSpinner(component);
            component.set('v.showToast',false);
            component.set("v.Likedisable",true);
            console.log('fields',fields);
            component.set("v.isformSubmitted",true);
            component.find('createLennoxForm').submit(fields); 
        }
    },
    
    handleOnSuccess : function(component, event, helper) {
        helper.showSpinner(component);
        
        var url = window.location.href;
        var parts = url.split('id=');
        var caseId = parts[parts.length - 1];
        
       // console.log('handleOnSuccess ');
        var lennoxFormRecord = event.getParam("response");
        //Update Installation's records
        var installationList = component.get("v.installationList");
        //var numberOfProducts = component.get("v.numberOfProducts");
        
        for(var index = 0 ; index<installationList.length; index++){
            installationList[index].Lennox_Form__c = lennoxFormRecord.id;
            
            if( !installationList[index].Date_Installed__c ){
                installationList[index].Date_Installed__c = null;
            }
        }
        //console.log('installationList ', installationList);
        
        var strSummeryOfConcern = component.get("v.summaryConcern");
        //console.log('strSummeryOfConcern-- ', strSummeryOfConcern);
        //Call apex method to insert Installation records
        
        helper.callApexAction(component, 'insertInstallationRecords', { "strInstallationList": JSON.stringify(installationList), "caseId": caseId , "strSummeryOfConcern": strSummeryOfConcern})
        .then(function (result) {
            //console.log('result insertInstallationRecords--- ', JSON.stringify(result));
            if (result.isSuccess) {
              //  console.log('result--- ',result.data);
            }
            else {
                alert('Error occured while inserting Installation records');
            }
        });
        
        var lennoxForm = component.get("v.lennoxFormList");
        
       // console.log('lennoxFormRecord.fields.First_Name__c--' + lennoxFormRecord.fields.First_Name__c.value);
       // console.log('lennoxFormRecord.fields--' + lennoxFormRecord.fields);
        
        lennoxForm[0] = {};
        lennoxForm[0].id =  lennoxFormRecord.id;
        lennoxForm[0].First_Name__c =  lennoxFormRecord.fields.First_Name__c.value;
        lennoxForm[0].Last_Name__c =  lennoxFormRecord.fields.Last_Name__c.value;
        lennoxForm[0].Consumer_Postal_Code__c =  lennoxFormRecord.fields.Consumer_Postal_Code__c.value;
        lennoxForm[0].Consumer_Street_Address__c =  lennoxFormRecord.fields.Consumer_Street_Address__c.value;
        lennoxForm[0].Consumer_City__c =  lennoxFormRecord.fields.Consumer_City__c.value;
        
        if(lennoxFormRecord.fields.Consumer_State__c.value){
            lennoxForm[0].Consumer_State__c =  lennoxFormRecord.fields.Consumer_State__c.value;
        }else{
            lennoxForm[0].Consumer_State__c = '';
        } 
        
        lennoxForm[0].Home_Phone__c =  lennoxFormRecord.fields.Home_Phone__c.value;
        lennoxForm[0].Business_Phone__c =  lennoxFormRecord.fields.Business_Phone__c.value;
        lennoxForm[0].Case__c =  component.get('v.caseId'); //lennoxFormRecord.fields.CaseId__c.value;
        
        component.set("v.lennoxFormList",lennoxForm);
        
        var lennoxFormList = component.get("v.lennoxFormList");
        
        // Update Site Location record 
        helper.callApexAction(component, 'updateSiteLocationRecord', {"strlennoxFormRecord": JSON.stringify(lennoxFormList), "strSummeryOfConcern": strSummeryOfConcern} )
        .then(function (result) {
            //console.log('result updateSiteLocationRecord--- ', JSON.stringify(result));
            if (result.isSuccess) {
                //console.log('result--- ',result.data);
            }
            else {
                alert('Error occured while updating Site Location record');
            }
        });
        //Insert Attachment
        var mailAttachment = component.get("v.mailAttachment");
        var attach = component.get("v.attachements");
        
        if( attach.length > 0 ){
            
            for(var index = 0 ; index<attach.length; index++){
                component.set("v.isShowUploadFileSpinner", true);
                var fileContents = attach[index];
                var base64 = 'base64,';
                var dataStart = fileContents.indexOf(base64) + base64.length;
                
                fileContents = fileContents.substring(dataStart);
                
                var fileInput = component.find("fileId").get("v.files");
                // get the first file using array index[0]  
                var file = fileInput[index];
                // call the uploadProcess method 
                helper.uploadProcess(component, file, fileContents, caseId, index);   
                component.set("v.isShowUploadFileSpinner", false);
            }
            
          /*  console.log('mailAttachment',mailAttachment);
            component.set("v.isShowUploadFileSpinner", true);
            var fileContents = mailAttachment;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            console.log('fileContents :::: ',fileContents);
            
            var fileInput = component.find("fileId").get("v.files");
            // get the first file using array index[0]  
            var file = fileInput[0];
            // call the uploadProcess method 
            helper.uploadProcess(component, file, fileContents, caseId);   
            component.set("v.isShowUploadFileSpinner", false);*/
        }
        component.set("v.isShowMainForm", false);
        component.set("v.isShowConfirmationPage", true);
        helper.hideSpinner(component);        
    },
    
    toggleInstructions: function(cmp, evt, h) {
        if(cmp.get('v.showInstructions')) {
            cmp.set('v.showInstructions', false);
        } else {
            cmp.set('v.showInstructions', true);
        }
    },
    
    handleInstrChange: function(cmp, evt, h) {
        // Move instructions button with side panel
        if(cmp.get('v.showInstructions')) {
            $A.util.addClass(cmp.find('sidePanelBtn'), 'button-sidebar_open');
            
        } else {
            $A.util.removeClass(cmp.find('sidePanelBtn'), 'button-sidebar_open');
        }
    },
    
    getError : function(cmp, event, h) {
        
        var message = '';
        var errorsArr  = event.getParams("error");
        
        if(errorsArr.detail != "" && errorsArr.detail != null && errorsArr.detail != undefined){
            message = errorsArr.detail;
        }
        else if(errorsArr.error != undefined &&  errorsArr.error.body != undefined && 
                errorsArr.error.body.output != undefined 
                && errorsArr.error.body.output.fieldErrors != undefined 
                && errorsArr.error.body.output.fieldErrors.OwnerId != undefined )
        {
            var errorlist = errorsArr.error.body.output.fieldErrors.OwnerId;
            //if(errorlist  != ""  && errorlist != null && errorlist != undefined)
            message = errorlist[0].message;
        }else if( errorsArr.output != undefined && errorsArr.output.fieldErrors != undefined 
                 &&  errorsArr.output.fieldErrors.Status != undefined && errorsArr.output.fieldErrors.Status.length > 0 
                ){
            message = errorsArr.output.fieldErrors.Status[0].message;
            
        }else if( errorsArr.output.fieldErrors != undefined ){
            var fieldErrors =JSON.parse(JSON.stringify( errorsArr.output.fieldErrors) );
            for(var field in fieldErrors ){
                if( fieldErrors[field] && fieldErrors[field][0] != null ){
                    message = errorsArr.output.fieldErrors[field][0].message;
                    break;
                }
            }
        }
        if(message == ''){
            message = "Some error occured, Please contact to system administrator.";
        }    
        cmp.set('v.Errormsg',message);
        cmp.set('v.showToast',true);
        window.scrollTo(0,0);
    },
    closeToast : function(cmp, event, h){
        cmp.set('v.showToast',false);
        cmp.set('v.isSpinner', false);
    },
    
    phoneMask: function phoneMask(component, event, helper) { 
        
        if(/^\d+$/.test(component.find("installingPhone").get("v.value"))){
            
            var cleaned = ('' + component.find("installingPhone").get("v.value")).replace(/\D/g, '').substring(0, 10);
            
            var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
            if (match) {
                component.set("v.installingPhone", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
            }
            component.set("v.installingPhone", component.find("installingPhone").get("v.value"));
            $A.util.removeClass(component.find("installingPhone"), 'slds-has-error');
            
        }else{
            component.set("v.installingPhone", '');
            $A.util.addClass(component.find("installingPhone"), 'slds-has-error'); 
        }
    },
    servicingPhoneMask: function servicingPhoneMask(component, event, helper) { 
        
        if(/^\d+$/.test(component.find("servicingPhone").get("v.value"))){
            var cleaned = ('' + component.find("servicingPhone").get("v.value")).replace(/\D/g, '').substring(0, 10);
            
            var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
            if (match) {
                //return '(' + match[1] + ') ' + match[2] + '-' + match[3]
                component.set("v.servicingPhone", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
            }
            component.set("v.servicingPhone", component.find("servicingPhone").get("v.value"));
            $A.util.removeClass(component.find("servicingPhone"), 'slds-has-error');
            // var phoneNo = component.find("nominatorPhone").get("v.value");
            
        }else{
            component.set("v.servicingPhone", '');
            $A.util.addClass(component.find("servicingPhone"), 'slds-has-error'); 
        }
    },
    
    homephoneMask: function homephoneMask(component, event, helper) { 
        
        if(/^\d+$/.test(component.find("Home_Phone__c").get("v.value"))){
            var cleaned = ('' + component.find("Home_Phone__c").get("v.value")).replace(/\D/g, '').substring(0, 10);
            
            var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
            if (match) {
                //return '(' + match[1] + ') ' + match[2] + '-' + match[3]
                component.set("v.Home_Phone__c", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
            }
            component.set("v.Home_Phone__c", component.find("Home_Phone__c").get("v.value"));
            $A.util.removeClass(component.find("Home_Phone__c"), 'slds-has-error');
            // var phoneNo = component.find("nominatorPhone").get("v.value");
            
        }else{
            component.set("v.Home_Phone__c", '');
            $A.util.addClass(component.find("Home_Phone__c"), 'slds-has-error'); 
        }
    },
    
    businessphoneMask: function businessphoneMask(component, event, helper) { 
        
        if(/^\d+$/.test(component.find("Business_Phone__c").get("v.value"))){
            var cleaned = ('' + component.find("Business_Phone__c").get("v.value")).replace(/\D/g, '').substring(0, 10);
            
            var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
            if (match) {
                //return '(' + match[1] + ') ' + match[2] + '-' + match[3]
                component.set("v.Business_Phone__c", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
            }
            component.set("v.Business_Phone__c", component.find("Business_Phone__c").get("v.value"));
            $A.util.removeClass(component.find("Business_Phone__c"), 'slds-has-error');
            // var phoneNo = component.find("nominatorPhone").get("v.value");
            
        }else{
            component.set("v.Business_Phone__c", '');
            $A.util.addClass(component.find("Business_Phone__c"), 'slds-has-error'); 
        }
    },
    UploadFinished : function UploadFinished(component, event, helper) {
        
        console.log('File upload finished ----- $$$$$');
        
    }
})