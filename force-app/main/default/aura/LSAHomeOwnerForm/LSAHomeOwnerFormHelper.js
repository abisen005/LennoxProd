({
  callApexAction: function (cmp, apexAction, params) {
    //set promise as server call is async call.
    var p = new Promise(
      $A.getCallback(function (resolve, reject) {
        //set action
        var action = cmp.get("c." + apexAction + "");
        action.setParams(params);
        action.setCallback(this, function (callbackResult) {
          if (callbackResult.getState() === "SUCCESS") {
            resolve(callbackResult.getReturnValue());
          }
          if (callbackResult.getState() === "ERROR") {
            reject(callbackResult.getError());
          }
        });
        $A.enqueueAction(action);
      })
    );
    return p;
  },
  setJobAddressFieldLennoxForm: function (component, consumerForm, helper) {
    let placeDetails = component.get("v.placeDetails");
    if (placeDetails && placeDetails.length > 0) {
      var streetdAddress = "";
      for (var i = 0; i < placeDetails.length; i++) {
        if (placeDetails[i].label == "street_number") {
          streetdAddress = placeDetails[i].value + " ";
        } else if (placeDetails[i].label == "route") {
          streetdAddress = streetdAddress + placeDetails[i].value;
        } else if (placeDetails[i].label == "locality") {
          consumerForm.Site_City__c = placeDetails[i].value;
          //  streetdAddress = streetdAddress + placeDetails[i].value;
        } else if (placeDetails[i].label == "administrative_area_level_2") {
          //lennoxForm.JobCity__c = placeDetails[i].value;
        } else if (placeDetails[i].label == "administrative_area_level_1") {
          consumerForm.Site_State__c = placeDetails[i].value;
        } else if (placeDetails[i].label == "postal_code") {
          consumerForm.Site_Postal_Code__c = placeDetails[i].value;
        }
      }
      consumerForm.Site_Street_Address__c = streetdAddress;
    }
    return consumerForm;
  },
  initializeConsumerForm: function (cmp, helper) {
    var ConsumerForm = {
      Job_First_Name__c: "",
      Job_Last_Name__c: "",
      Unit_Type__c: null,
      Unit_Model_Number__c: "",
      DateUnitInstalled__c: null,
      Unit_Serial_Number__c: "",
      Site_City__c: "",
      Site_State__c: "",
      Site_Street_Address__c: "",
      Site_Postal_Code__c: "",
      Lennox_LSA_Program__c: "",
      Submitter_Email__c: "",
      Date_of_field_action__c: null,
      //Browser__c : this.getBrowser(cmp)
    };
    return ConsumerForm;
  },
  // Javascript function used to get all the parameters of a HTTP URL.
  getAllUrlParams: function (component, event, url) {
    var queryString = url ? url.split("?")[1] : window.location.search.slice(1);
    var obj = {};
    console.log("queryString", queryString);
    if (queryString) {
      queryString = queryString.split("#")[0];
      var arr = queryString.split("&");
      for (var i = 0; i < arr.length; i++) {
        var a = arr[i].split("=");
        var paramNum = undefined;
        var paramName = a[0].replace(/\[\d*\]/, function (v) {
          paramNum = v.slice(1, -1);
          return "";
        });
        var paramValue = typeof a[1] === "undefined" ? true : a[1];
        if (obj[paramName]) {
          if (typeof obj[paramName] === "string") {
            obj[paramName] = [obj[paramName]];
          }
          if (typeof paramNum === "undefined") {
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
  displayToast1: function (title, message, type) {
    console.log("checktoast");
    let toastEvent = $A.get("e.force:showToast");
    if (toastEvent) {
      toastEvent.setParams({
        title: title,
        message: message,
        type: type,
        mode: "dismissible",
      });
      toastEvent.fire();
    } else {
      // alert(message);
    }
  },
  showSpinner: function (component) {
    component.set("v.isSpinner", true);
  },
  hideSpinner: function (component) {
    component.set("v.isSpinner", false);
  },
  displayToast: function (title, message, type) {
    let toastEvent = $A.get("e.force:showToast");
    if (toastEvent) {
      toastEvent.setParams({
        title: title,
        message: message,
        type: type,
        mode: "dismissible",
      });
      toastEvent.fire();
    } else {
      // alert(message);
    }
  },
  displayToast: function (title, message, type) {
    let toastEvent = $A.get("e.force:showToast");
    if (toastEvent) {
      toastEvent.setParams({
        title: title,
        message: message,
        type: type,
        mode: "dismissible",
      });
      toastEvent.fire();
    } else {
      // alert(message);
    }
  },
});