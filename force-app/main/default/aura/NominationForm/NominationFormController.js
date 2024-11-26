/**
 * @description       : 
 * @author            : Amit Aher
 * @group             : 
 * @last modified on  : 13-12-2021 / 08-15-2023 / 08-30-2023
 * @last modified by  : Amit Aher /Abilash @Ventas
 **/
({
    doInit: function(component, event, helper) {
        helper.getRecordTypeId(component, event, helper);
        /*   var urlValue = helper.getAllUrlParams(component, event, window.location.href);
            console.log('urlValue',urlValue);
            if(urlValue && urlValue.state != null){
                component.set("v.state", urlValue.state); 
            }*/
    },
    bigImg: function(component, event, helper) {},
    aboutusFieldChange: function(component, event, helper) {
        var subjectValue = component.find("aboutus").get("v.value").split(";");
        if (subjectValue.includes("Other")) {
            component.set("v.showOther", true);
        } else {
            component.set("v.showOther", false);
        }
    },
    getAccountDetailsJS: function(component, event, helper) {
        let accountNumber = component.find("DealerNumber").get("v.value");
        let accountName = component.find("DealerName").get("v.value");
        component.set("v.isSpinner", true);
      /*  if (accountNumber || accountName) {
           let params = {
                "dealerNumber": accountNumber,
                "dealerName": accountName
            };
            helper.callApexAction(component, "getAccountDetailsApex", params)
                .then(result => {
                    if (result.isSuccess) {
                        let data = result.data;
                        component.set("v.dealerName", data.Name);
                        component.set("v.DealerNumber", data.SAP_Customer_Number__c);
                    } else {
                        component.set("v.dealerName", accountName);
                        component.set("v.DealerNumber", accountNumber);
                    }
                    component.set("v.isSpinner", false);
                });
        } else {
            component.set("v.dealerName", "");
            component.set("v.isSpinner", false);
            return;
        }*/
         component.set("v.dealerName", accountName);
                        component.set("v.DealerNumber", accountNumber);
    },
    onchange: function(component, event, helper) {
        let hasAgree = component.find("hasAgree").get("v.value");
        console.log('hasAgree value', hasAgree);
        let submitButton = component.find("submit");
    },
    handleOnSubmit: function(component, event, helper) {
        event.preventDefault();
        var fields = JSON.parse(JSON.stringify(event.getParam("fields")));
        var a = component.get('c.handleOnSuccess');
        $A.enqueueAction(a);
    },
    onNextClick: function(component, event, helper) {

        //console.log("### onNextClick Start ###");
        
        try{
            event.preventDefault();
            
            var selectedNomineeOwnHome = component.find("nomineeOwnHome").get("v.value");
            var selectedHomeManufactured = component.find("mobOrManufact").get("v.value");
            var selectedHomeDuctwork = component.find("completeDuctwork").get("v.value");
            
            var story = component.find("story");
                    // console.log('!!VIKING_1'+ selectedNomineeOwnHome+ selectedHomeManufactured+ selectedHomeDuctwork);
            // console.log('!!VIKING_1'+ story);
            
            component.set("v.attemptedSubmit", true);
            component.set("v.thanksdiv", false);
            component.set("v.isSpinner", true);
            
            
            if (((component.find("completeDuctwork").get("v.value") == "Yes" && component.find("mobOrManufact").get("v.value") == "No" &&
                            component.find("nomineeOwnHome").get("v.value") == "Yes") ||
                        (component.find("completeDuctwork").get("v.value") == "Unknown" && component.find("mobOrManufact").get("v.value") == "Unknown" &&
                            component.find("nomineeOwnHome").get("v.value") == "Unknown") ||
                        (component.find("completeDuctwork").get("v.value") == "Unknown" && component.find("mobOrManufact").get("v.value") == "No" &&
                            component.find("nomineeOwnHome").get("v.value") == "Unknown") ||
                        (component.find("completeDuctwork").get("v.value") == "Yes" && component.find("mobOrManufact").get("v.value") == "No" &&
                            component.find("nomineeOwnHome").get("v.value") == "Unknown") ||
                        (component.find("completeDuctwork").get("v.value") == "Unknown" && component.find("mobOrManufact").get("v.value") == "No" &&
                            component.find("nomineeOwnHome").get("v.value") == "Yes") ||
                        (component.find("completeDuctwork").get("v.value") == "Yes" && component.find("mobOrManufact").get("v.value") == "Unknown" &&
                            component.find("nomineeOwnHome").get("v.value") == "Yes") || 
                (component.find("completeDuctwork").get("v.value") == "Unknown" && component.find("mobOrManufact").get("v.value") == "Unknown" &&
                            component.find("nomineeOwnHome").get("v.value") == "Yes")
                    
                )
                && component.find("story") 
                && ( (Array.isArray(component.find("story")) && !component.find("story")[0].get("v.value")) || !component.find("story").get("v.value")) ) {
            // console.log('!!ABI CHECK');
                component.set("v.isSpinner", false);
                helper.customErrorToast(component, event, helper);
                var field = component.find("story");
                $A.util.addClass(field, 'slds-has-error');
                scrollTo(top, 0, 0);
            } else {
                //console.log('!!VIKING_2');
                var fields = ['Nominator_Name__c', 'Nominee_Address__c', 'Nominator_Email__c', 'Relationship_to_nominee__c', 'Nominee_Name__c',
                    'Best_Classification_of_Nominee__c',
                    'Does_nominee_own_home__c', 'Mobile_or_Manufactured_Home__c', 'Complete_ductwork_system_in_place__c', 'Nominee_Story__c',
                    'Nominee_Phone_Number__c', 'Nominator_Phone_Number__c',
                ];
                var error = false; //Set the initial value if the address value is blank.
                var error1 = true;
                var Reqfields = component.get("v.Reqfields");
                //var Reqfields = component.find("required");
                Reqfields.push(component.find("nominatorName"));
                Reqfields.push(component.find("nominatorPhone"));
                Reqfields.push(component.find("nominatorEmail"));
                Reqfields.push(component.find("nominatorRelation"));
                Reqfields.push(component.find("nomineeName"));
                Reqfields.push(component.find("classifyNominee"));
                Reqfields.push(component.find("nomineeOwnHome"));
                Reqfields.push(component.find("mobOrManufact"));
                Reqfields.push(component.find("completeDuctwork"));
                //Reqfields.push(component.find("story"));
                Reqfields.push(component.find("nomineePhone"));
                Reqfields.push(component.find("hasReceivedPermisssion"));
                Reqfields.push(component.find("hasAgree"));
                Reqfields.push(component.find("hasAgreeNominator"));
                var errorMessage = 'Please Review The Form and Complete All Required Fields.';
                //console.log('Reqfields :', Reqfields);
                Reqfields.forEach(function(field) {
                    if (field.get("v.value") == null || field.get("v.value") == "") {
                        $A.util.addClass(field, 'slds-has-error');
                        error = true;
                        error1 = false;
                        component.set("v.isSpinner", false);
                        helper.customErrorToast(component, event, helper);
                        scrollTo(top, 0, 0);
                    } else if (component.get("v.errorMessage") != '') {
                        //console.log('inside error', component.get("v.errorMessage"));
                        error = true;
                        error1 = false;
                        component.set("v.isSpinner", false);
                        helper.customErrorToast(component, event, helper);
                        scrollTo(top, 0, 0);
                    } else if (component.get("v.errorMessagePhoneMask") != '') {
                        //console.log('inside error', component.get("v.errorMessagePhoneMask"));
                        error = true;
                        error1 = false;
                        component.set("v.isSpinner", false);
                        helper.customErrorToast(component, event, helper);
                        scrollTo(top, 0, 0);
                    } else if ($A.util.hasClass(field, "slds-has-error")) {
                        //console.log('Req field 2:', field);
                        $A.util.removeClass(field, 'slds-has-error');
                        error = false;
                    }
                });
                var placeDetails = component.get("v.nomineeplaceDetails");
                var placeDetails = component.get("v.nomineeplaceDetails").length;
                let FTLProgramForm = {
                    Nominator_Name__c: '',
                    Nominator_Phone_Number__c: ''
                };
                //= component.get("v.FTLProgramForm");
                var nomName = component.find("nominatorName").get("v.value");
                FTLProgramForm.Nominator_Name__c = nomName;
                //FTLProgramForm.Nominator_Phone_Number__c =component.find("nominatorPhone").get("v.value");
                //FTLProgramForm.Nominator_Email__c =component.find("nominatorEmail").get("v.value");
                //FTLProgramForm.Relationship_to_nominee__c =component.find("nominatorRelation").get("v.value");
                /*FTLProgramForm.Nominee_Name__c =component.find("nomineeName").get("v.value");
            FTLProgramForm.Nominee_Phone_Number__c =component.find("nomineePhone").get("v.value");
            FTLProgramForm.Nominee_Email__c =component.find("NomineeEmsil").get("v.value");
            FTLProgramForm.Best_Classification_of_Nominee__c =component.find("classifyNominee").get("v.value");
            FTLProgramForm.Does_nominee_own_home__c =component.find("nomineeOwnHome").get("v.value");
            FTLProgramForm.Mobile_or_Manufactured_Home__c =component.find("mobOrManufact").get("v.value");
            FTLProgramForm.Complete_ductwork_system_in_place__c =component.find("completeDuctwork").get("v.value");
            FTLProgramForm.How_did_you_hear_about_us__c =component.find("aboutus").get("v.value");
            FTLProgramForm.How_did_you_hear_about_us_Other__c =component.find("other").get("v.value");
            FTLProgramForm.Dealer_Number__c =component.find("delarnumber").get("v.value");
            FTLProgramForm.Dealer_Name__c =component.find("delarname").get("v.value");
            FTLProgramForm.Nominator_Received_Permission__c =component.find("hasReceivedPermisssion").get("v.value");
            FTLProgramForm.Nomination_Form_Terms__c =component.find("hasAgree").get("v.value");*/
                if (error || placeDetails == 0) {
                    //console.log('placeDetails error:');
                    //window.scrollTo(0,0);
                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth'
                    });
                    component.set("v.isSpinner", false);
                    helper.customErrorToast(component, event, helper);
                    scrollTo(top, 0, 0);
                    // helper.displayToast("Error!", errorMessage, "error");
                } else {
                    //console.log('Error 2 :', error);
                    if (error == false) {
                        //console.log('fields :', fields);
                        helper.adddressFieldMapping(component, event, helper, fields);
                        var isApproved = true;
                        let msg = 'Thank you for your submission.\n\n' +
                            'We apologize as your nomination is not able to be considered for the following reason(s): \n'
                        //Does_nominee_own_home__c
                        //console.log("### Step 1 ###");
                        if (component.find("nomineeOwnHome").get("v.value") == 'No') {
                            isApproved = false;
                            msg += '\n • ' + $A.get("$Label.c.FTL_Nomination_Form_Rental");
                            component.set("v.condition1", true);
                        }
                        //Mobile_or_Manufactured_Home__c
                        //console.log("### Step 2 ###");
                        if (component.find("mobOrManufact").get("v.value") == 'Yes') {
                            isApproved = false;
                            msg += '\n • ' + $A.get("$Label.c.FTL_Nomination_Form_Declined");
                            component.set("v.condition2", true);
                        }
                        //Complete_ductwork_system_in_place__c
                        //console.log("### Step 3 ###");
                        if (component.find("completeDuctwork").get("v.value") == 'No') {
                            isApproved = false;
                            msg += '\n • ' + $A.get("$Label.c.FTL_Nomination_Form_Ductwork");
                            component.set("v.condition3", true);
                        }
                        msg += '\n\nIf one of these reasons does not apply to your nominee, please re-submit the form.';
                        //console.log("### Step 4 ###");
                        if (isApproved) {
                            msg = $A.get("$Label.c.FTL_Nomination_Form_Approved");
                            component.set("v.thanksdiv", false);
                            component.set("v.approvedCondition1", true);
                            window.scrollTo({
                                top: 0,
                                behavior: 'smooth'
                            });
                            component.set("v.isSubmit", true);
                            scrollTo(top, 0, 0);
                        }
                        //console.log("### Step 5 ###");
                        //alert(isApproved);
                        msg += '\n\n Thank you,' +
                            '\n Feel The Love Team' +
                            '\n Follow us on Facebook';
                        let hasAgree = component.find("hasAgree").get("v.value");
                        let hasReceivedPermisssion = component.find("hasReceivedPermisssion").get("v.value");
                        let hasAgreeNominator = component.find("hasAgreeNominator").get("v.value");
                        //console.log("### Step 6 ###");
                        if (!hasAgree || !hasReceivedPermisssion || !hasAgreeNominator) {
                            component.set("v.isSpinner", false);
                            helper.customErrorToast(component, event, helper);
                            window.scrollTo({
                                top: 0,
                                behavior: 'smooth'
                            });
                            //console.log("### Step 6.1 ###");
                            return;
                        } else if (error1 == false) {
                            helper.customErrorToast(component, event, helper);
                            //console.log("### Step 6.2 ###");
                            return;
                        } else {
                            //console.log('msg: ', msg);
                            //console.log('msg1: ', msg);
                            //component.set("v.showToast1", true);
                            //console.log("### Step 6.3 ###");
                            if (msg.trim().length > 0 && isApproved == false) {
                                component.set("v.showToast1", true);
                                //helper.customErrorToast(component,event,helper);
                                window.scrollTo({
                                    top: 0,
                                    behavior: 'smooth'
                                });
                                //console.log("### Step 6.3.1 ###");
                            } else if (msg.trim().length > 0 && isApproved == true) {
                                component.set("v.approvedCondition1", true);
                                window.scrollTo({
                                    top: 0,
                                    behavior: 'smooth'
                                });
                                //console.log("### Step 6.3.2 ###");
                            }
                            //console.log("### Step 6.4 ###");
                            if (fields.Mobile_or_Manufactured_Home__c == 'Yes' ||
                                (fields.Does_nominee_own_home__c == 'No' ||
                                    fields.Complete_ductwork_system_in_place__c == 'No')) {
                                fields["Status__c"] = "Declined";
                                fields["Reason_for_Declining__c"] = "Home Not Suitable";
                                //console.log("### Step 6.4.1 ###");
                            } else {
                                msg = $A.get("$Label.c.FTL_Nomination_Form_Approved");
                                //console.log("### Step 6.4.2 ###");
                            }
                            console.log('error msg is there:', component.get("v.errorMessage"));
                        }
                    }
                }
            }
        } catch (e) {
            console.log(e);
        }
        //console.log("### onNextClick End ###");
    },
    onSubmitClick: function(component, event, helper) {
        if (story != null && story != '' && story != undefined) {
            component.set("v.showToast3", false);
            component.set("v.approvedCondition1", true);
            //console.log('submittedRecordId', component.get("v.submittedRecordId"));
            var action = component.get("c.updateNominationStory");
            action.setParams({
                "nominationRecordId": component.get("v.submittedRecordId"),
                "nominationStory": story
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    component.set('v.isSubmit', false);
                } else if (state === "ERROR") {
                    var errors = action2.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            cmp.set("v.message", errors[0].message);
                        }
                    }
                } else {
                    console.log('There was a problem : ' + response.getError());
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.showToast3", true);
        }
    },
    onSuccess: function(component, event, helper) {
        //console.log("onSuccess Start: ");
        var payload = event.getParams().response;
        //console.log("payload: ", payload);
        var responseJSON = event.getParams();
        //console.log("responseJSON: ", responseJSON);
        var submittedRecordId = payload.id;
        //console.log("submittedRecordId: ", submittedRecordId);
        component.set("v.submittedRecordId", submittedRecordId);
    },
    closeToast: function(component, event, helper) {
        component.set("v.showToast", false);
        component.set("v.showToast3", false);
    },
    closeToast1: function(component, event, helper) {
        component.set("v.showToast1", false);
        var a = component.get('c.handleOnSuccess');
        $A.enqueueAction(a);
    },
    closeToast2: function(component, event, helper) {
        component.set("v.approvedCondition1", false);
        var a = component.get('c.handleOnSuccess');
        $A.enqueueAction(a);
    },
    showError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Error',
            message: 'This is an error message',
            duration: ' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    handleOnSuccess: function(component, event, helper) {
        component.set("v.approvedCondition1", false);
        component.set("v.isSpinner", false);
        component.set("v.thanksdiv", true);
    },
    handleOnError: function(component, event, helper) {
        console.log('HandleOnError...');
    },
    share: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log(id_str);
        if (id_str == "facebook") {
            window.open(
                "https://www.facebook.com/login.php?skip_api_login=1&api_key=966242223397117&signed_next=1&next=https%3A%2F%2Fwww.facebook.com%2Fsharer.php%3Ft%3DHelp%2BLennox%2Bsupport%2Bthose%2Bin%2Bneed%2521%26u%3Dhttps%253A%252F%252Fwww.feelthelove.com&cancel_url=https%3A%2F%2Fwww.facebook.com%2Fdialog%2Fclose_window%2F%3Fapp_id%3D966242223397117%26connect%3D0%23_%3D_&display=popup&locale=en_GB"
                );
        } else if (id_str == "twitter") {
            window.open("https://twitter.com/intent/tweet?text=Help%20Lennox%20support%20those%20in%20need!&url=https%3A%2F%2Fwww.feelthelove.com");
        } else if (id_str == "email") {
            var body =
                'I just nominated someone for Lennox Feel The Love™ program! Feel The Love gives back to people who serve their communities by providing them with a new home comfort system. Do you know of someone in need of a helping hand? Nominate them today at https://www.feelthelove.com!';
            var link = 'mailto:?subject=Id like to share a link with you' +
                '&body=' + body;
            window.location.href = link;
            //  window.open("https://twitter.com/intent/tweet?text=Help%20Lennox%20support%20those%20in%20need!&url=https%3A%2F%2Fwww.feelthelove.com");
        } else if (id_str == "in") {
            window.open(
                "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww.linkedin.com%2FshareArticle%3Ftitle%3DHelp%2520Lennox%2520support%2520those%2520in%2520need%21%26url%3Dhttps%253A%252F%252Fwww.feelthelove.com"
                );
        }
    },
    phoneMask: function phoneMask(component, event, helper) {
        var nominatorPhoneValidity = component.find("nominatorPhone").get("v.validity");
        //console.log('nominatorPhone : ' + nominatorPhoneValidity);
        var phonevalue = component.find("nominatorPhone").get("v.value");
        //console.log('Phonevalue==', phonevalue);
        var numbersOnly = phonevalue.replace(/\D/g, '');
        //console.log('PhonevalueSize==', numbersOnly.length);
        var inputCmp = component.find("nominatorPhone");
        if (numbersOnly.length < 11) {
            if ((/[a-zA-Z]/.test(phonevalue)) && phonevalue != '') {
                component.set("v.errorMessage", "You have entered an invalid format of Phone number.");
                $A.util.removeClass(component.find("nominatorPhone"), 'slds-has-error');
            } else if (numbersOnly.length < 10 && phonevalue != '') {
                component.set("v.errorMessage", "Phone number Should be 10 digits.");
                $A.util.removeClass(component.find("nominatorPhone"), 'slds-has-error');
            } else {
                component.set("v.errorMessage", "");
                $A.util.removeClass(component.find("nominatorPhone"), 'slds-has-error');
            }
            if (/^\d+$/.test(component.find("nominatorPhone").get("v.value"))) {
                var cleaned = ('' + component.find("nominatorPhone").get("v.value")).replace(/\D/g, '').substring(0, 10);
                //console.log('cleaned', cleaned);
                var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                //console.log('match ', match);
                if (match) {
                    //return '(' + match[1] + ') ' + match[2] + '-' + match[3]
                    component.set("v.nominatorPhone", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
                }
                component.set("v.nominatorPhone", component.find("nominatorPhone").get("v.value"));
                $A.util.removeClass(component.find("nominatorPhone"), 'slds-has-error');
                // var phoneNo = component.find("nominatorPhone").get("v.value");
            }
        } else {
            $A.util.addClass(component.find("nominatorPhone"), 'slds-has-error');
            component.set("v.errorMessage", "Phone number cannot exceed 10 digits.");
        }
    },
    nomineePhoneMask: function nomineePhoneMask(component, event, helper) {
        //console.log('phoneNo 4444 ', component.find("nomineePhone").get("v.value"));
        var phonevalue1 = component.find("nomineePhone").get("v.value");
        //console.log('Phonevalue==', phonevalue1);
        var numbersOnly1 = phonevalue1.replace(/\D/g, '');
        //console.log('PhonevalueSize==', numbersOnly1.length);
        var inputCmp = component.find("nomineePhone");
        if (numbersOnly1.length < 11) {
            if ((/[a-zA-Z]/.test(phonevalue1)) && phonevalue1 != '') {
                component.set("v.errorMessagePhoneMask", "You have entered an invalid format of Phone number.");
                $A.util.removeClass(component.find("nomineePhone"), 'slds-has-error');
            } else if (numbersOnly1.length < 10 && phonevalue1 != '') {
                component.set("v.errorMessagePhoneMask", "Phone number Should be 10 digits.");
                $A.util.removeClass(component.find("nomineePhone"), 'slds-has-error');
            } else {
                component.set("v.errorMessagePhoneMask", "");
                $A.util.removeClass(component.find("nomineePhone"), 'slds-has-error');
            }
            if (/^\d+$/.test(component.find("nomineePhone").get("v.value"))) {
                var cleaned = ('' + component.find("nomineePhone").get("v.value")).replace(/\D/g, '').substring(0, 10);
                //console.log('cleaned', cleaned);
                var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
                //console.log('match ', match);
                if (match) {
                    //return '(' + match[1] + ') ' + match[2] + '-' + match[3]
                    component.set("v.nomineePhone", '(' + match[1] + ') ' + match[2] + '-' + match[3]);
                }
                component.set("v.nomineePhone", component.find("nomineePhone").get("v.value"));
            } else {
                //component.set("v.nomineePhone", '');
                //$A.util.addClass(component.find("nomineePhone"), 'slds-has-error'); 
            }
        } else {
            $A.util.addClass(component.find("nomineePhone"), 'slds-has-error');
            component.set("v.errorMessagePhoneMask", "Phone number cannot exceed 10 digits.");
        }
    },
    onClickOpenProgramTerms : function(component, event, helper) {
        //var urlval = component.get("v.cards")[index].imgUrl__c;
        var profUrl = $A.get('$Resource.FTL_Terms');
        window.open(profUrl);
        component.set("v.isProgramCheckboxDisabled", false);
        
    },
    onClickOpenNominatorTerms : function(component, event, helper) {
        //var urlval = component.get("v.cards")[index].imgUrl__c;
        var profUrl = $A.get('$Resource.FTL_Nominator_Release');
        window.open(profUrl);
        component.set("v.isNominatorCheckboxDisabled", false);
        
    },    
    handleQualifyChange: function(component, event, helper) {
        component.set("v.FTLisQualified", false);
       var selectedNomineeOwnHome = component.find("nomineeOwnHome").get("v.value");
        var selectedHomeManufactured = component.find("mobOrManufact").get("v.value");
        var selectedHomeDuctwork = component.find("completeDuctwork").get("v.value");
       // console.log('!!!DRAGON'+ selectedNomineeOwnHome+ selectedHomeManufactured+ selectedHomeDuctwork);
        if (
            
            (selectedNomineeOwnHome  == 'Yes'   && selectedHomeDuctwork =='Yes' && selectedHomeManufactured == 'No') ||
            (selectedNomineeOwnHome  == 'Unknown' &&  selectedHomeDuctwork =='Unknown' && selectedHomeManufactured == 'No')||
            (selectedNomineeOwnHome == 'Unknown' && selectedHomeDuctwork == 'Unknown' && selectedHomeManufactured == 'Unknown') ||
            (selectedNomineeOwnHome == 'Unknown' && selectedHomeDuctwork == 'Yes' && selectedHomeManufactured == 'No')||
            (selectedNomineeOwnHome == 'Yes' && selectedHomeDuctwork == 'Unknown' && selectedHomeManufactured == 'No')||
            (selectedNomineeOwnHome == 'Yes' && selectedHomeDuctwork == 'Yes' && selectedHomeManufactured == 'Unknown') ||
              (selectedNomineeOwnHome == 'Yes' && selectedHomeDuctwork == 'Unknown' && selectedHomeManufactured == 'Unknown')
            
        
        ){

            component.set("v.FTLisQualified", true);
        } else {

            component.set("v.FTLisQualified", false);
        }
    },
})