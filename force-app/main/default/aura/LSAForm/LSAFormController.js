({
    onchange : function(component, event, helper) {

        let hasAgree = component.find("hasAgree").get("v.value");
        let submitButton = component.find("submit");
        let submitNewButton = component.find("submitNew");

        if (hasAgree) {

            submitButton.set('v.disabled',false);
            submitNewButton.set('v.disabled',false);
        } else {

            submitButton.set('v.disabled',true);
            submitNewButton.set('v.disabled',true);
        }
    },

    doInit : function(component, event, helper) {

        console.log('spinner',component.get('v.isSpinner'));
        var LennoxForm = helper.initializeLennoxForm(component, helper);
        component.set("v.LennoxForm", LennoxForm);
        var LSAProgramName;
        var urlValue = helper.getAllUrlParams(component, event, window.location.href);

        if (urlValue && urlValue.name != null) {

           LSAProgramName = urlValue.name;
        }else{
            component.set("v.hasActiveLSAProgram", false);
        }

        if (LSAProgramName) {

            helper.callApexAction(component, 'getLSAProgramRecord', {"strLSAProgramName": LSAProgramName})
                .then(function (result) {
                if (result.isSuccess && result.data ) {

                    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                    console.log('!!! today',today);
                    console.log('!!! result.data.Program_Expiration_Date__c',result.data.Program_Expiration_Date__c);
                    console.log('!!! result: ' + result.data.Program_Expiration_Date__c >= today);
                    if(result.data.Program_Expiration_Date__c >= today){
                        component.set("v.hasActiveLSAProgram", true);
                    } else {
                        component.set("v.hasActiveLSAProgram", false);
                        component.set("v.programExpired", true);
                    }
                    component.set("v.LSAProgram", result.data);
                    component.set("v.isSpinner", false);
                } else {

                    component.set("v.hasActiveLSAProgram", false);
                    console.log('v.hasActiveLSAProgram',component.get('v.hasActiveLSAProgram'));
                    helper.displayToast("Error!", result.msg, "error");
                    component.set("v.isSpinner", false);
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

        } else {

            helper.displayToast("Error!", "Invalid Program.", "error");
            helper.hideSpinner(component);
        }
    },

    setDefaults : function(component, event, helper) {

    },

    handleOnSubmit : function(component, event, helper) {
       console.log('on submit === handleOnSubmit');
        helper.showSpinner(component);
        event.preventDefault(); // Prevent default submit
        console.log('on submit ='+JSON.stringify(event.getParam("fields")));
        var fields = JSON.parse(JSON.stringify(event.getParam("fields")));
        console.log('on submit === ',fields);
        if (fields) {
             console.log('on submit === Inside ',fields);
            let placeDetails = component.get("v.placeDetails");

            if (placeDetails && placeDetails.length > 0) {

                var streetdAddress = '';

                for (var i = 0; i < placeDetails.length; i++) {

                    if (placeDetails[i].label == 'street_number') {

                        streetdAddress = placeDetails[i].value + ', ';
                    } else if(placeDetails[i].label == 'route') {

                        streetdAddress = streetdAddress + placeDetails[i].value + ', ';
                    } else if(placeDetails[i].label == 'locality') {

                        streetdAddress = streetdAddress + placeDetails[i].value;
                    } else if(placeDetails[i].label == 'administrative_area_level_2') {

                        fields["JobCity__c"] = placeDetails[i].value;
                    } else if(placeDetails[i].label == 'administrative_area_level_1') {

                        fields["JobState__c"] = placeDetails[i].value;
                    } else if(placeDetails[i].label == 'postal_code') {

                        fields["JobPostalCode__c"] = placeDetails[i].value;
                    }
                }

                fields["JobStreetAddress__c"] = streetdAddress;
            }

            let IndoorUnitSerialNumber = component.find("IndoorUnitSerialNumber").get("v.value");
            fields["IndoorUnitSerialNumber__c"] = IndoorUnitSerialNumber;

             console.log('Before submit '+fields);
            component.find('LSAForm').submit(fields);
        }

        //component.find('createLennoxForm').submit(fields);
    },

    handleOnSuccess : function(component, event, helper) {
        console.log('on submit === handleOnSuccess');

        helper.showSpinner(component);
        var LSAProgram = JSON.parse(JSON.stringify(component.get("v.LSAProgram")));
        var lennoxForm = JSON.parse(JSON.stringify(component.get("v.LennoxForm")));
        let pressedButtunType = event.getSource().get("v.name")
        var formFields = component.find("formFieldToValidate");
        var allValid;
        console.log('formFields.length + ',formFields.length);
        if (formFields.length!=undefined) {
           console.log('Inside If');
            // Iterating all the fields
             allValid = formFields.reduce(function (validSoFar, inputCmp) {

                inputCmp.showHelpMessageIfInvalid();

                var name = inputCmp.get('v.name');

                if (name == 'SerialNumber' || name == 'FirstName' || name == 'LastName' || name == 'DateOfFieldAction' || name == 'SubmitterEmail') {

                    var value = inputCmp.get('v.value');

                    if (value == undefined || value.trim() == '') {

                        inputCmp.focus();

                        inputCmp.set('v.validity', {valid:false, badInput :true});
                    }
                }

                // return whether all fields are valid or not
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);

             console.log('allValid ' ,allValid);
        }
        /*Validate location field*/

        console.log('SerchKey On Submit',component.get('v.searchKey'));
        const placeDetails = component.get('v.placeDetails');

        if (placeDetails && placeDetails.length > 0) {
            component.set('v.validAdd', true);
        }else{
            component.set('v.validAdd', false);
        }
        /**/
      allValid = allValid && component.get('v.validAdd');

        if (allValid) {
            console.log('InSide All valid');
            if (lennoxForm) {
                lennoxForm = helper.setJobAddressFieldLennoxForm(component, lennoxForm, helper);
                lennoxForm.Lennox_LSA_Program__c = LSAProgram.Id;

                let params = {
                    "lennoxForm": lennoxForm,
                    "lSAProgram" : component.get("v.LSAProgram")
                };

                helper.callApexAction(component, 'createLennoxFormRecord', params).then(function (result) {

                    if (result.isSuccess) {

                        if (pressedButtunType == 'Submit') {

                            component.set("v.isSuccess", true);
                            helper.hideSpinner(component);
                        } else {

                            component.set("v.showCustomToast", true);
                            component.set("v.searchKey", '');
                            component.set("v.reloadForm", false);
                            let lennoxFormRecord = helper.prePopulateLennoxForm(component, result.data, helper);
                            component.set("v.LennoxForm", lennoxFormRecord);
                            component.set("v.reloadForm", true);
                            helper.hideSpinner(component);
                            component.set("v.searchSerialNumber", "");
                            component.set("v.searchErrorMessage", "");
                            component.set("v.serialNumberNotFound", true);
                        }
                    } else {

                        helper.displayToast("Error!", result.msg, "error");
                        helper.hideSpinner(component);
                    }
                });
            }
        } else {

            helper.hideSpinner(component);
        }
    },

    toggleInstructions: function(cmp, evt, h) {

        if (cmp.get('v.showInstructions')) {

            cmp.set('v.showInstructions', false);
        } else {

            cmp.set('v.showInstructions', true);
        }
    },

    handleInstrChange: function(cmp, evt, h) {

        // Move instructions button with side panel
        if (cmp.get('v.showInstructions')) {

            $A.util.addClass(cmp.find('sidePanelBtn'), 'button-sidebar_open');
        } else {

            $A.util.removeClass(cmp.find('sidePanelBtn'), 'button-sidebar_open');
        }
    },

    getError : function(cmp, evt, h) {

        var error = evt.getParam("error");
        // main error message
        // top level error messages
        error.data.output.errors.forEach(function(msg) {
            console.log(msg.errorCode);
            console.log(msg.message);
        });
    },

    closeCustomToast: function(cmp, evt, h) {

        cmp.set("v.showCustomToast", false);
    },

    handleBlur: function (component, event) {

        //console.log("### handleBlur");
        //let name = inputCmp.get('v.name');
        //console.log("### name: ", name);

        let lennoxForm = JSON.parse(JSON.stringify(component.get("v.LennoxForm")));

        if (name == 'SerialNumbers') {

            if (lennoxForm.IndoorUnitSerialNumber__c == undefined
                || lennoxForm.IndoorUnitSerialNumber__c.trim() == '') {

                lennoxForm.IndoorUnitSerialNumber__c = '';
            } else {

            }
        }

        if (name == 'FirstName') {

            if (lennoxForm.JobFirstName__c.trim() === undefined) {

                lennoxForm.JobFirstName__c = "";
            }
        }

        component.set("v.LennoxForm", lennoxForm);
    },

    getAccountDetailsJS: function(component, event, helper) {

        component.set("v.isSpinner", true);

        let accountNumber = component.get("v.LennoxForm.DealerNumber__c");

        if (accountNumber) {

            let params = {
                "dealerNumber": accountNumber
            };
            console.log("params: ", params);
            helper.callApexAction(component, "getAccountDetailsApex", params)
                .then(result => {

                if (result.isSuccess) {

                    let data = result.data;

                    component.set("v.LennoxForm.DealerName__c", data.Name);
                } else {
                    component.set("v.LennoxForm.DealerNumber__c", '');
                    helper.displayToast("Error!", result.msg, "error");
                }

                component.set("v.isSpinner", false);
            });
        } else {

            component.set("v.LennoxForm.DealerName__c", "");
            component.set("v.isSpinner", false);
            return;
        }
    },

    checkSerialNumber : function(component, event, helper){

        component.set("v.isSpinner", true);
        let serialNumber = component.get("v.LennoxForm.IndoorUnitSerialNumber__c");
        let programId = component.get("v.LSAProgram.Id");
        if(serialNumber){
            //console.log("### Check Serial Number");
            let params = {
                "serialNumber" : serialNumber,
                "programId" : programId
            };          
            helper.callApexAction(component, "checkSerialNumberApex", params)
            .then(result => {
                //console.log("result: ", result);
                //console.log("result.isSuccess: ", result.isSuccess);
                //console.log("result.data: ", result.data);
                //console.log("result.msg: ", result.msg);
                let formFields = component.find("formFieldToValidate");
                for(let inputCmp of formFields){
                    if(inputCmp.get('v.name') == 'SerialNumber'){
                        if (result.isSuccess && !result.data) {
                            console.log("inputCmp.name: ", inputCmp.get('v.name'));
                            inputCmp.setCustomValidity(result.msg);
                        } else {
                            inputCmp.setCustomValidity("");
                        }
                        inputCmp.reportValidity();
                    }
                }
                component.set("v.isSpinner", false);
            });
        } else {
            component.set("v.isSpinner", false);
        }
    },

    searchSerialNumber : function(component, event, helper){

        let serialNumber = component.get("v.searchSerialNumber");
        let programId = component.get("v.LSAProgram.Id");
        let params = {
            "serialNumber" : serialNumber,
            "programId" : programId
        };          
        helper.callApexAction(component, "searchSerialNumberApex", params)
        .then(result => {
            //console.log("result: ", result);
            console.log("result.isSuccess: ", result.isSuccess);
            console.log("result.data: ", result.data);
            console.log("result.msg: ", result.msg);
            if(result.isSuccess){
                if(result.data == null){
                    component.set("v.searchErrorMessage", result.msg);
                } else {
                    component.set("v.LennoxForm.Unit_Type__c", result.data.Equipment_Data__r.type__c);
                    component.set("v.LennoxForm.IndoorUnitSerialNumber__c", result.data.Serial_Number__c);
                    component.set("v.LennoxForm.IndoorUnitModelNumber__c", result.data.Model_Number__c);
                    component.set("v.LennoxForm.DateUnitInstalled__c", result.data.Equipment_Data__r.Installation_Date__c);
                    component.set("v.searchErrorMessage", "");
                    component.set("v.serialNumberNotFound", false);
                }
            } else {
                helper.displayToast("Error!", result.msg, "error");
            }
        });        
    }
})