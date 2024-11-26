({
   callApexAction: function(component, apexAction, params) {
    return new Promise($A.getCallback(function(resolve, reject) {
        var action = component.get("c." + apexAction);
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Apex call successful");
                console.log("Response:", response.getReturnValue());
                resolve(response.getReturnValue());
            } else if (state === "ERROR") {
                console.error("Apex call failed");
                console.error("Error:", response.getError());
                reject(response.getError());
            }
        });
        $A.enqueueAction(action);
    }));
},
    
    getBrowser: function (component) {

        var browserType = navigator.sayswho= (function(){
            var ua= navigator.userAgent, tem,
                M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
            if(/trident/i.test(M[1])){
                tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
                return 'IE '+(tem[1] || '');
            }
            if(M[1]=== 'Chrome'){
                tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
                if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
            }
            M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
            if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
            return M.join(' ');
        })();
        return browserType;
    },

    initializeLennoxForm : function(component, helper){
        
        var LennoxForm = {
            DealerNumber__c : '',
            DealerName__c : '',
            DealerContactSubmitter__c : '',
            JobFirstName__c : '',
            JobLastName__c : '',
            Unit_Type__c : null,
            IndoorUnitModelNumber__c : '',
            DateUnitInstalled__c : null,
            IndoorUnitSerialNumber__c : '',
            JobCity__c : '',
            JobState__c : '',
            JobPostalCode__c : '',
            JobStreetAddress__c : '',
            Lennox_LSA_Program__c : '',
            Submitter_Email__c : '',
            Date_of_field_action__c : null,
            Browser__c : this.getBrowser(component)
        }

        return LennoxForm;
    },
    
    prePopulateLennoxForm : function(component, lennoxForm, helper){
        
        var LennoxForm = {
            DealerNumber__c : lennoxForm.DealerNumber__c,
            DealerName__c : lennoxForm.DealerName__c,
            DealerContactSubmitter__c : lennoxForm.DealerContactSubmitter__c,
            JobFirstName__c : '',
            JobLastName__c : '',
            Unit_Type__c : null,
            IndoorUnitModelNumber__c : '',
            DateUnitInstalled__c : null,
            IndoorUnitSerialNumber__c : '',
            JobCity__c : '',
            JobState__c : '',
            JobPostalCode__c : '',
            JobStreetAddress__c : '',
            Lennox_LSA_Program__c : '',
            Submitter_Email__c : lennoxForm.Submitter_Email__c,
            Date_of_field_action__c : null,
            Browser__c : this.getBrowser(component)
        }

        return LennoxForm;
    },
    
    setJobAddressFieldLennoxForm : function(component, lennoxForm, helper) {

        let placeDetails = component.get("v.placeDetails");
        
        if (placeDetails 
            && placeDetails.length > 0) {

            var streetdAddress = '';

            for (var i = 0; i < placeDetails.length; i++) {
                
                if (placeDetails[i].label == 'street_number') {

                    streetdAddress = placeDetails[i].value + ' ';
                } else if (placeDetails[i].label == 'route') {

                    streetdAddress = streetdAddress + placeDetails[i].value ;
                } else if(placeDetails[i].label == 'locality') {
                   lennoxForm.JobCity__c = placeDetails[i].value;
                  //  streetdAddress = streetdAddress + placeDetails[i].value;
                } else if(placeDetails[i].label == 'administrative_area_level_2') {

                    //lennoxForm.JobCity__c = placeDetails[i].value;
                } else if(placeDetails[i].label == 'administrative_area_level_1') {

                    lennoxForm.JobState__c = placeDetails[i].value;
                } else if(placeDetails[i].label == 'postal_code') {

                    lennoxForm.JobPostalCode__c = placeDetails[i].value;
                }
            }
            
            lennoxForm.JobStreetAddress__c = streetdAddress;
        }
        
        return lennoxForm;
    },
    
    showSpinner: function (component) {

        component.set("v.isSpinner", true);
    },
    
    hideSpinner: function (component) {

        component.set("v.isSpinner", false);
    },

    displayToast : function(title, message, type) {

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
    
           // alert(message);
        }
    },
    
    // Javascript function used to get all the parameters of a HTTP URL.
   getAllUrlParams: function(component, event, url) {

       var queryString = url 
        ? url.split('?')[1] 
        : window.location.search.slice(1);

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

                var paramValue = typeof(a[1]) === 'undefined' 
                    ? true 
                    : a[1];

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
})