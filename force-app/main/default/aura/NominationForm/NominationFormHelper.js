({
    // Javascript function used to get all the parameters of a HTTP URL.
    getAllUrlParams: function(component, event, url) {
        var queryString = url ?
            url.split('?')[1] :
        window.location.search.slice(1);
        var obj = {};
        if (queryString) {
            queryString = queryString.split('#')[0];
            var arr = queryString.split('&');
            for (var i = 0; i < arr.length; i++) {
                var a = arr[i].split('=');
                var paramNum = undefined;
                var paramName = a[0].replace(/\[\d*\]/, function(v) {
                    paramNum = v.slice(1, -1);
                    return '';
                });
                var paramValue = typeof(a[1]) === 'undefined' ?
                    true :
                a[1];
                if (obj[paramName]) {
                    if (typeof obj[paramName] === 'string') {
                        obj[paramName] = [obj[paramName]];
                    }
                    if (typeof paramNum === 'undefined') {
                        obj[paramName].push(paramValue);
                    } else {
                        obj[paramName][paramNum] = paramValue;
                    }
                } else {
                    obj[paramName] = paramValue;
                }
            }
        }
        return obj;
    },
    callApexAction: function(component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function(resolve, reject) {
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function(callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
                    resolve(callbackResult.getReturnValue());
                }
                if (callbackResult.getState() === 'ERROR') {
                    reject(callbackResult.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    },
    adddressFieldMapping: function(component, event, helper, fields) {
        console.log("### adddressFieldMapping Start ###");
        if (fields) {
            let nominatorplaceDetails = component.get("v.nominatorplaceDetails");
            if (nominatorplaceDetails && nominatorplaceDetails.length > 0) {
                var streetdAddress = '';
                for (var i = 0; i < nominatorplaceDetails.length; i++) {
                    if (nominatorplaceDetails[i].label == 'street_number') {
                        streetdAddress = nominatorplaceDetails[i].value + ', ';
                    } else if (nominatorplaceDetails[i].label == 'route') {
                        streetdAddress = streetdAddress + nominatorplaceDetails[i].value + ', ';
                    } else if (nominatorplaceDetails[i].label == 'locality') {
                        fields["Nominator_City__c"] = nominatorplaceDetails[i].value;
                    } else if (nominatorplaceDetails[i].label == 'administrative_area_level_3') {
                        fields["Nominator_City__c"] = nominatorplaceDetails[i].value;
                    } else if (nominatorplaceDetails[i].label == 'administrative_area_level_2') {
                        //fields["Nominator_City__c"] = nominatorplaceDetails[i].value;
                    } else if (nominatorplaceDetails[i].label == 'administrative_area_level_1') {
                        fields["Nominator_State__c"] = nominatorplaceDetails[i].value;
                    } else if (nominatorplaceDetails[i].label == 'postal_code') {
                        fields["Nominator_Zip_Code__c"] = nominatorplaceDetails[i].value;
                    }
                }
                //fields["Nominator_Address__c"] = streetdAddress;
            }
            let nomineeplaceDetails = component.get("v.nomineeplaceDetails");
            if (nomineeplaceDetails && nomineeplaceDetails.length > 0) {
                var streetdAddressNominee = '';
                for (var i = 0; i < nomineeplaceDetails.length; i++) {
                    //console.log('nomineeplaceDetails[i]', nomineeplaceDetails[i].label);
                    if (nomineeplaceDetails[i].label == 'street_number') {
                        streetdAddressNominee = nomineeplaceDetails[i].value + ', ';
                    } else if (nomineeplaceDetails[i].label == 'route') {
                        streetdAddressNominee = streetdAddressNominee + nomineeplaceDetails[i].value + ', ';
                    } else if (nomineeplaceDetails[i].label == 'locality') {
                        fields["Nominee_City__c"] = nomineeplaceDetails[i].value;
                    } else if (nomineeplaceDetails[i].label == 'administrative_area_level_3') {
                        fields["Nominee_City__c"] = nomineeplaceDetails[i].value;
                    } else if (nomineeplaceDetails[i].label == 'administrative_area_level_2') {
                        fields["Nominee_County__c"] = nomineeplaceDetails[i].value;
                    } else if (nomineeplaceDetails[i].label == 'administrative_area_level_1') {
                        fields["Nominee_State__c"] = nomineeplaceDetails[i].value;
                    } else if (nomineeplaceDetails[i].label == 'postal_code') {
                        fields["Nominee_Zip_Code__c"] = nomineeplaceDetails[i].value;
                    } else if (nomineeplaceDetails[i].label == 'country') {
                        fields["Nominee_Country__c"] = nomineeplaceDetails[i].value;
                    }
                }
                //console.log('Check1');
                fields["Nominee_Street_Address__c"] = streetdAddressNominee;
                fields["Nominee_Address__c"] = streetdAddressNominee;
                fields["RecordTypeId"] = component.get("v.recordTypeId");
                fields["OwnerId"] = component.get("v.queueId");
                fields["Nominator_Name__c"] = component.find("nominatorName").get("v.value");
                fields["Relationship_to_nominee__c"] = component.find("nominatorRelation").get("v.value");
                fields["Nominee_Name__c"] = component.find("nomineeName").get("v.value");
                fields["Best_Classification_of_Nominee__c"] = component.find("classifyNominee").get("v.value");
                fields["Does_nominee_own_home__c"] = component.find("nomineeOwnHome").get("v.value");
                fields["Mobile_or_Manufactured_Home__c"] = component.find("mobOrManufact").get("v.value");
                fields["Complete_ductwork_system_in_place__c"] = component.find("completeDuctwork").get("v.value");
                fields["Nominee_Phone_Number__c"] = component.find("nomineePhone").get("v.value");
                fields["Nominee_Email__c"] = component.find("NomineeEmail").get("v.value");
                fields["Nominator_Phone_Number__c"] = component.find("nominatorPhone").get("v.value");
                fields["Nominator_Email__c"] = component.find("nominatorEmail").get("v.value");
                
                //console.log('How_did_you_hear_about_us__c', component.find("aboutus").get("v.value"));
                fields["How_did_you_hear_about_us__c"] = component.find("aboutus").get("v.value");
                
                fields["Dealer_Number__c"] = component.find("DealerNumber").get("v.value");
                fields["Dealer_Name__c"] = component.find("DealerName").get("v.value");
                
                
                if ((component.find("completeDuctwork").get("v.value") == "Yes" && component.find("mobOrManufact").get("v.value") == "No" &&
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
                   ) {
                    fields["Nominee_Story__c"] = component.find("story").get("v.value");
                }
                
                if( component.find("aboutus").get("v.value") == 'Other')  {
                    
                    fields["How_did_you_hear_about_us_Other__c"] = component.find("other").get("v.value");
                }
            }
            component.find('recordEditForm').submit(fields);
        }
        console.log("### adddressFieldMapping End ###");
    },
    getRecordTypeId: function(component, event, helper) {
        var action = component.get("c.getNominationFormRecordType");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = JSON.parse(response.getReturnValue());
                console.log('res ', res.recordTypeId);
                console.log('res ', res.queueId);
                component.set("v.recordTypeId", res.recordTypeId);
                component.set("v.queueId", res.queueId);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    displayToast: function(title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible"
            });
            toastEvent.fire();
        } else {
            alert(message);
        }
    },
    customErrorToast: function(component, event, helper) {
        component.set("v.showToast", true);
        var duration = 5000; // Adjust as needed (e.g., 5000ms for 5 seconds)
        setTimeout($A.getCallback(function() {
            component.set("v.showToast", false);
        }), duration);
    }
})