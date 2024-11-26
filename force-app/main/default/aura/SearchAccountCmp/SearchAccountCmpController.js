({
	doInit : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
		var fields = [
        { label: 'Name', value: 'Name' },
        { label: 'Shipping Street', value: 'ShippingStreet' },
        { label: 'Shipping City', value: 'ShippingCity' },
        { label: 'Shipping State', value: 'ShippingState' },
        { label: 'Shipping Postal', value: 'ShippingPostalCode' },
        { label: 'Phone', value: 'Phone' }];
        
        component.set('v.fields', fields); 
        component.set("v.isShowAccTable", false);
        console.log('showOtherPicklist ', component.get("v.showOtherPicklist"));
        helper.hideSpinner(component, event, helper);
	},
    
    openRecordDetailPage : function(component, event, helper) {
        var recordId = event.target.id;
        window.open('/' + recordId,'_blank');
    },
    
    onChangeOfSelectedValue1: function (component, event, helper) {
        //component.set("v.showOtherPicklist", false);
        var selectevalue = component.get("v.selectedValue1");
        var index = component.get("v.index");
        console.log('selectevalue ', selectevalue);
        component.set("v.inputValue1", '');
        component.set("v.accountList", []);
        
        if(selectevalue != null && selectevalue != 'None')//&& selectevalue != 'SAP_Customer_Number__c'
         {
            console.log('in if');
            component.set("v.selectedValue2", 'None');
            component.set("v.inputValue2", '');
            component.set("v.showOtherPicklist", false);
            
        }
    	else{
            console.log('in else');
            component.set("v.showOtherPicklist", true);
            component.set("v.selectedValue2", null);
            component.set("v.inputValue2", null);
            component.set("v.inputValue1", '');
            
        }
        
        if(index > 0){
            
            helper.removeSelectList(component, 1, index);
            // console.log('index',component.get("v.index"));
        }
    },
    
    onChangeOfSelectedValue2: function (component, event, helper) {
        component.set("v.isShowAccTable", false);
        var selectevalue2 = component.get("v.selectedValue2");
        var selectevalue1 = component.get("v.selectedValue1");
        var index = component.get("v.index");
        console.log('selectevalue ', selectevalue2);
        component.set("v.inputValue2", '');
        component.set("v.accountList", []);
        
        if(selectevalue2 == 'None'){
            if(index > 0){
                helper.removeSelectList(component, 1, index);
                // console.log('index',component.get("v.index"));
            }
        }else{
            if(index == 0){
                            
                            let remainedOptionList = helper.getRemainOptionList(component);
                
                            console.log('remainedOptionList ', remainedOptionList);
                
                            helper.createSelectList(component, event, helper, remainedOptionList);
                        } 
                        else{
                            
                            if(index => 1) {
                                
                                helper.removeSelectList(component, 2, index);
                                var selectHTML = "<select>" ;
                                selectHTML += "<option class=uiInputSelectOption value='" + 'None' + "'>" + 'None' + "</option>";
                                selectHTML += "</select>";
                                //newDiv.innerHTML = selectHTML;
                                document.getElementById(1).innerHTML = selectHTML;
                                let remainedOptionList = helper.getRemainOptionList(component);
                                helper.addSelectOption(component, 1, remainedOptionList);
                                document.getElementById('input'+1).value = '';
                                //console.log('elemennt ',document.getElementById('input'+1).value);
                            }
                          
                        }
        }
    },
    
    addSelectList : function (component, event, helper) {
        component.set("v.isShowAccTable", false);
        component.set("v.accountList", []);
        var eventId = parseInt(event.target.id) ;
        console.log('eventId',eventId);
        //console.log('eventIdval',eventId+1);
        var selectListVal = document.getElementById(eventId).value ;
        document.getElementById('input'+eventId).value = '';
        //console.log('selectListVal',selectListVal);
        var indexVal = component.get("v.index");
        var tempIndex =  indexVal ;
        var eventId1 = eventId+1 ;
        var eventId2 = eventId+2 ;
        if(selectListVal != 'None'){
            
            if(eventId == indexVal){
                
                let remainedOptionList = helper.getRemainOptionList(component);
                
                if(remainedOptionList.length > 0){
                    
                    helper.createSelectList(component, event, helper, remainedOptionList);
                }
                
            }
            
            if(eventId2 <= indexVal){
                console.log('In eventId2 block');
                //console.log('in if');
                helper.removeSelectList(component, eventId2, indexVal);
            }   
            
            if(eventId < indexVal){
                console.log('In eventId block');
                var selectHTML = "<select>" ;
                selectHTML += "<option class=uiInputSelectOption value='" + 'None' + "'>" + 'None' + "</option>";
                selectHTML += "</select>";
                //newDiv.innerHTML = selectHTML;
                document.getElementById(eventId1).innerHTML = selectHTML;
                let remainedOptionList = helper.getRemainOptionList(component);
                helper.addSelectOption(component, eventId1, remainedOptionList);
                document.getElementById('input'+eventId1).value = '';
                //document.getElementById(eventId1).innerHTML = '';
            }
        }
        else{
            
            helper.removeSelectList(component, eventId1, indexVal);
        }
        
    },
    
    searchAccount : function (component, event, helper) {
        helper.showSpinner(component, event, helper);
        component.set("v.accountList", []);
        var selectevalue1 = component.get("v.selectedValue1");
        var selectevalue2 = component.get("v.selectedValue2");
        var inputValue1 = component.get("v.inputValue1");
        var inputValue2 = component.get("v.inputValue2");
        
        var formFields = component.find("formFieldToValidate");
        console.log('formFields ', formFields.length);
        
        var allValid;
        
        if(formFields.length!=undefined) {
            // Iterating all the fields
             allValid = formFields.reduce(function (validSoFar, inputCmp) {
                
                inputCmp.showHelpMessageIfInvalid();
                 
                 
                 var name = inputCmp.get('v.name');
                 
                 if(name=='selectList1') {
                     
                     var value = inputCmp.get('v.value');
                     console.log('selectList1 ', value);
                     
                     if(value == undefined || value == 'None') {
                         
                         inputCmp.focus();
                         
                         inputCmp.set('v.validity', {valid:false, badInput :true});
                     }                
                 }
                 
                 if(name=='selectList2') {
                     
                     var value = inputCmp.get('v.value');
                     console.log('selectList2 ', value);
                     
                     if(value == undefined || value == 'None') {
                         
                         inputCmp.focus();
                         
                         inputCmp.set('v.validity', {valid:false, badInput :true});
                     }                
                 }
                 
                // return whether all fields are valid or not
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }
        
        console.log('allValid ', allValid);
        
        if(allValid){
           
            console.log('Validation successful ');
            var validateFieldSize = helper.checkInputFieldSize(component);
            
            if(validateFieldSize){
                
            	var  phone = helper.getPhoneFieldValue(component);
            
            
             /*if(selectevalue1 == 'Phone'){
               phone =  inputValue1;
            }
            
            if(selectevalue2 == 'Phone'){
               phone =  inputValue2;
            } */
            
            var whereCondition = helper.getFilterCriteriaString(component);
                
            console.log('whereCondition ', whereCondition);
            
            helper.callApexAction(component, 'getAccountList', {strWhereCondition:whereCondition,
                                                                phoneNumber:phone })
                
                .then(function (result) {
                    
                    console.log('customer@@@@', result);
                    
                    if (result.isSuccess) {
                        component.set("v.disableLeadCreateBtn", false);
                        component.set("v.accountList", result.data);
                        
                        component.set("v.isShowAccTable", true);
                        
                        console.log('accountList@@@@', component.get("v.accountList"));
                        helper.hideSpinner(component, event, helper);
                    }
                    else {
                        component.set("v.isShowAccTable", false);
                        helper.hideSpinner(component, event, helper);
                        helper.showMsg(component, event, 'Error', 'error', result.msg );
                    }
                });
            }
            else{
                console.log('In Showmsg');
                helper.hideSpinner(component, event, helper);
                helper.showMsg(component, event, 'Error', 'error', 'Please Enter Minimum 2 character' );
            }
            
            
        }else{
            helper.hideSpinner(component, event, helper);
        }
    },
    
    
})