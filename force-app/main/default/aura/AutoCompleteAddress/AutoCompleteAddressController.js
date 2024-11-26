({
    keyPressController: function (component, event, helper) {
        // Only by selecting an address from the options that a valid address will be set
        component.set('v.placeDetails', null);
        var searchKey = component.get("v.searchKey");

        helper.openListbox(component, searchKey);
        helper.displayOptionsLocation(component, searchKey);
    },

    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        console.log(selectedItem);
        var selectedValue = event.currentTarget.dataset.value;
        console.log(selectedValue);

        component.set("v.selectedOption", selectedItem);

        var searchLookup = component.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');

        component.set("v.searchKey", selectedItem);

        if(selectedValue){
            var action = component.get("c.getPlaceDetail");
            action.setParams({
                "placeId": selectedValue
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state ', state);
                if (state === "SUCCESS") {
                    var result = JSON.parse(response.getReturnValue());
                    console.log('result ', result);
                    var addressComponents = result.result.address_components;
                    var placeDetails = [];
                    if (addressComponents.length > 0) {
                        for (var i = 0; i < addressComponents.length; i++) {
                            var obj = {};
                            if(addressComponents[i].types[0] == 'administrative_area_level_2' ||
                               addressComponents[i].types[0] == 'administrative_area_level_1' ||
                               addressComponents[i].types[0] == 'country'){

                                obj.label = addressComponents[i].types[0],
                                obj.value = addressComponents[i].short_name
                            }
                            else{
                                obj.label = addressComponents[i].types[0],
                                obj.value = addressComponents[i].long_name
                            }
                            placeDetails.push(obj);
                        }

                        console.log('placeDetails ', placeDetails);
                        component.set("v.placeDetails", placeDetails);
                    }
                }
            });
            $A.enqueueAction(action);
        }

    },

    clear: function (component, event, helper) {
        helper.clearComponentConfig(component);
    } ,

    handleValueChange: function (component, event, helper) {
        console.log('%%%%% Address Comp Validity value changes ======= ',component.get('v.validAdd'));
        var formField = component.find("addlocation");
        const placeDetails = component.get('v.placeDetails');

        if (placeDetails && placeDetails.length > 0) {
            formField.setCustomValidity('');
            // formField.set("v.errors", null);
            // $A.util.removeClass(formField, 'slds-has-error');
        }else{
            formField.setCustomValidity('Type-in and select an address from the dropdown options.');
            // formField.set("v.errors", [{message:"Complete this field."}]);
            // $A.util.addClass(formField, 'slds-has-error');
        }

        formField.reportValidity();
        //num.set("v.errors", null);
    }
})