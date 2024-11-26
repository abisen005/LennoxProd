({
    doInit: function (cmp, event, helper) {
        //var LennoxForm = helper.initializeConsumerForm(cmp, helper);
        //cmp.set("v.LennoxForm", LennoxForm);
        var LSAProgramName;
        var urlValue = helper.getAllUrlParams(cmp, event, window.location.href);
        //console.log("urlValue", urlValue);
        if (urlValue && urlValue.name != null) {
            LSAProgramName = urlValue.name;
            //LSAProgramName ='30KManifoldProgram';
            //console.log("LSAProgramName1", LSAProgramName);
        } else {
            cmp.set("v.hasActiveLSAProgram", false);
        }
        if (LSAProgramName) {
            helper
            .callApexAction(cmp, "getLSAProgramRecord", {
                strLSAProgramName: LSAProgramName,
            })
            .then(function (result) {
                if (result.isSuccess && result.data) {
                    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"); 
                    
                    console.log('today',today); 
                    console.log('result.data.Consumer_Program_Expiration_Date__c',result.data.Consumer_Program_Expiration_Date__c); 
                    console.log('ProgramExpirationDate >= Today',result.data.Consumer_Program_Expiration_Date__c >= today);                   
                    if(result.data.Consumer_Program_Expiration_Date__c >= today){
                        cmp.set("v.hasActiveLSAProgram", true);
                    } else {
                        cmp.set("v.hasActiveLSAProgram", false);
                    }
                    cmp.set("v.LSAProgram", result.data);
                    cmp.set("v.isSpinner", false);
                } else {
                    cmp.set("v.hasActiveLSAProgram", false);
                    console.log(
                        "v.hasActiveLSAProgram",
                        cmp.get("v.hasActiveLSAProgram")
                    );
                    //helper.displayToast("Error!", result.msg, "error");
                    cmp.set("v.isSpinner", false);
                }
            });
            cmp.set("v.isSpinner", false);
            var ConsumerForm = helper.initializeConsumerForm(cmp, helper);
            cmp.set("v.ConsumerForm", ConsumerForm);
        }
    },
    onchange: function (cmp, event, helper) {
        let hasAgree = cmp.find("hasAgree").get("v.value");
        let submitButton = cmp.find("submit");
        //let submitNewButton = component.find("submitNew");
        if (hasAgree) {
            submitButton.set("v.disabled", false);
            //submitNewButton.set('v.disabled',false);
        } else {
            submitButton.set("v.disabled", true);
            //submitNewButton.set('v.disabled',true);
        }
    },
    onChangeSerialSearch: function (cmp, event) {
        let serialNumber = cmp.find("serialNumber").get("v.validity");
        let button = cmp.find("serialSearchId");
        if (serialNumber.valid) {
            //Action to be taken
            button.set("v.disabled", false);
        } else {
            button.set("v.disabled", true);
        }
    },
    handleOnSearch: function (cmp, event, helper) {
        let serialNumber = cmp.find("serialNumber").get("v.value");
        cmp.set("v.firstScreenSerialNumber", serialNumber);
        cmp.set("v.isSpinner", false);
        cmp.set("v.showToast1", false);
        cmp.set("v.showToast2", false);
        helper
        .callApexAction(cmp, "LSAserialNumberCheck", {
            unitSerialNumber: serialNumber,
        })
        .then((result) => {
            //console.log("data", result.msg);
            if (result.isSuccess && result.data) {
            //console.log("Success", result.isSuccess);
            let data = result.data;
            //console.log("data", result.data.Id);
            cmp.set("v.ConsumerForm", result.data);
            cmp.set("v.recordId", result.data.Id);
            cmp.set("v.siteLocationId", result.data.Site_Location__c);
            
            //alert ('Success');
            cmp.set("v.hasActiveConsumerProgram", false);
            cmp.set("v.consumerProgramForm", true);
            cmp.set("v.recordId", result.data.Id);
        } else if (result.msg == "Submitted") {
            //console.log("Error", result.msg);
            //alert ('Submitted');
            cmp.set("v.showToast2", true);
            cmp.set("v.formAlreadyExist", true);
            //helper.displayToast("Error!", 'result.msg', "error");
            //var a = cmp.get('c.displayToast');
            //$A.enqueueAction(a);
            scrollTo(top, 0, 0);
        } else {            
            console.log("Error", result.msg);
            cmp.set("v.showToast1", true);
        }
        cmp.set("v.isSpinner", false);
    });
},
 //Consumer Form Submission
 handleOnSubmit: function (cmp, event, helper) {
    event.preventDefault(); // Prevent the default form submission
    
    
    var fields = JSON.parse(JSON.stringify(event.getParam("fields")));
    console.log("Before submit " + fields);
    cmp.find("ConsumerForm").submit(fields);
    //console.log("on submit === handleOnSubmit");
},
    validateEmail: function (component, event, helper) {
        // Find the email input component
        var emailInput = component.find("storeSubmitterEmail");
        var isValid = emailInput.get("v.validity").valid;
        if (isValid) {
            // Email is valid
            console.log("Valid email:", emailInput.get("v.value"));
            // Perform further actions if needed
        } else {
            // Invalid email
            console.log("Invalid email:", emailInput.get("v.value"));
            // Display an error message or handle the invalid case
        }
    },
        handleOnSuccess: function (component, event, helper) {
            
            console.log("on submit === handleOnSuccess");
            
            helper.showSpinner(component);
            //var LSAProgram = JSON.parse(JSON.stringify(component.get("v.LSAProgram")));
            var consumerForm = JSON.parse(
                JSON.stringify(component.get("v.ConsumerForm"))
            );
            
            var submitterEmail = component.get("v.inputValue");
            
            let pressedButtonType = event.getSource().get("v.name");
            var formFields = component.find("formFieldToValidate");
            
            var allValid;
            console.log("formFields.length + ", formFields.length);
            if (formFields.length != undefined) {
                console.log("Inside If");
                // Iterating all the fields
                allValid = formFields.reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    var name = inputCmp.get("v.name");
                    component.set("v.showToast2", false);
                    if ( name == "SerialNumber"){
                        
                        var submissionScreenSerialNumber = inputCmp.get("v.value");
                        //console.log("submissionScreenSerialNumber ", submissionScreenSerialNumber);
                        //console.log("firstScreenSerialNumber ", component.get("v.firstScreenSerialNumber") );
                        var firstScreenSerialNumber = component.get("v.firstScreenSerialNumber")
                        if ( firstScreenSerialNumber.toUpperCase() == submissionScreenSerialNumber.toUpperCase()) {
                            component.set("v.showToast2", true);

                            component.set("v.submissionScreenSameSerialNumber", true);  
                            component.set("v.validAdd", false);
                            allValid = false;
                            return;
                        }
                        console.log('innnnn');
                        
                    }
                    
                    if (
                        name == "SerialNumber" ||
                        name == "FirstName" ||
                        name == "LastName" ||
                        name == "DateOfFieldAction" ||
                        name == "SubmitterEmail"
                    ) {
                        var value = inputCmp.get("v.value");
                        if (value == undefined || value.trim() == "") {
                            inputCmp.focus();
                            inputCmp.set("v.validity", {
                                valid: false,
                                badInput: true,
                            });
                        }
                        
                    }
                    // return whether all fields are valid or not
                    return validSoFar && inputCmp.get("v.validity").valid;
                }, true);
                console.log("allValid123 ", allValid);
            }
            /*Validate location field*/
            console.log("SerchKey On Submit", component.get("v.searchKey"));
            const placeDetails = component.get("v.placeDetails");
            if (placeDetails && placeDetails.length > 0) {
                component.set("v.validAdd", true);
            } else {
                component.set("v.validAdd", true);
            }
            allValid = allValid && component.get("v.validAdd");
            if (allValid) {
                console.log("InSide All valid");
                if (consumerForm) {
                    consumerForm = helper.setJobAddressFieldLennoxForm(
                        component,
                        consumerForm,
                        helper
                    );
                    // consumerForm.Lennox_LSA_Program__c = LSAProgram.Id;
                    let params = {
                        consumerForm: consumerForm,
                        lSAProgram: "null",
                        submitterEmail: submitterEmail,
                        siteLocationId: component.get("v.siteLocationId"),
                    };
                    helper
                    .callApexAction(
                        component,
                        "UpdateLennoxConsumerFormRecord",
                        params
                    )
                    .then(function (result) {
                        if (result.isSuccess) {
                            helper.showSpinner(component);
                            //console.log('check1',result.msg);
                            if (pressedButtonType == "Submit") {
                                component.set("v.isSuccess", true);
                                helper.hideSpinner(component);
                                
                            } else if (result.msg == "Submitted") {
                                let submitButton = component.find("submit");
                                submitButton.set("v.disabled", true);
                                console.log("!!ElseIFblock");
                                component.set("v.showToast2", true);
                                // component.set("v.formAlreadyExist", true);
                            }
                        } else {
                            
                        }
                    });
                }
            } else {
                helper.hideSpinner(component);
            }
        },
            dupSerialScreenCloseToast: function (component, event, helper) {
                component.set("v.showToast2", false);
                
            },
                
                closeToast: function (component, event, helper) {
                    component.set("v.showToast1", false);
                    component.set("v.showToast2", false);
                    component.set("v.consumerProgramForm", false);
                    component.set("v.hasActiveConsumerProgram", true);
                },
                    showSpinner: function (component, event, helper) {
                        // display spinner when aura:waiting (server waiting)
                        component.set("v.toggleSpinner", true);
                    },
                        hideSpinner: function (component, event, helper) {
                            // hide when aura:downwaiting
                            component.set("v.toggleSpinner", false);
                        },
                            handleClickVerbiageURL: function (cmp, event, helper) {
                                cmp.set("v.url", $A.get("$Label.c.LSA_Homeowner_Verbiage"));
                            },
});