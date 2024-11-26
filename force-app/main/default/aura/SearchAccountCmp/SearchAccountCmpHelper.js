({
	//generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
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
    
    showSpinner: function (component, event, helper) {
       component.set("v.isSpinner", true);
       console.log('In Showspinner', component.get("v.isSpinner"));
    },
    
    hideSpinner: function (component, event, helper) {
        component.set("v.isSpinner", false);
        console.log('In hideSpinner', component.get("v.isSpinner"))
    },
    
    showMsg : function(component, event, title, type, message ) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    },
    
    checkInputFieldSize : function (component){
        
        let selectevalue1 = component.get("v.selectedValue1");
        let selectedVal2 = component.get("v.selectedValue2");
        let inputValue1 = component.get("v.inputValue1");
        let inputValue2 = component.get("v.inputValue2");
        let inputArr = [];
        var isValidate = true;
        
        inputArr.push(inputValue1);
        
        if(selectedVal2 && selectedVal2 != 'None'){
            
            inputArr.push(inputValue2);
        }
        
        let index = component.get("v.index");
        
        if(index > 0){
            
            for(let i = 0 ; i < index ; i++){
                
                let selectedVal = document.getElementById(i+1).value; 
                console.log('selectedVal ', selectedVal);
                
                if(selectedVal != 'None'){
                    
                    let inputVal = document.getElementById('input'+(i+1)).value;
                    
                    inputArr.push(inputVal);
                    
                }
            }
        }
        
        for(let j = 0 ; j < inputArr.length ; j++){
            
            if(inputArr[j] == null || inputArr[j].trim().length < 2){
                        
            	isValidate = false;  
                break;
            }
        }
        
        return isValidate;
    },
    
    
    createSelectList : function(component, event, helper, lessonRecordList) {
        var indexVal = component.get("v.index");
        var div = component.find("navigationDiv");
        // var arr = ["ank","sah","abc"];
        $A.createComponent( 
                "aura:HTML",
                { 
                    tag: "select",
                    HTMLAttributes:{"id": indexVal+1, "class": "componentDspl slds-select select uiInput--select ", "onchange": component.getReference("c.addSelectList")}
                },
           
            function(newSelectList, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body=div.get("v.body");
                    body.push(newSelectList);
                    div.set("v.body",body);
                    window.setTimeout(function(){    
                        helper.addSelectOption(component, indexVal+1, lessonRecordList);
                        component.set("v.index",indexVal+1);
                        //console.log('index',component.get("v.index"));
                    },100);
                    
                    $A.createComponent( 
                "aura:HTML",
                { 
                    tag: "input",
                    HTMLAttributes:{"id": "input"+(indexVal+1), "type": "text", "class": "slds-input"}
                },
           
            function(newSelectList2, status2, errorMessage2){
                //Add the new button to the body array
                if (status2 === "SUCCESS") {
                    var body=div.get("v.body");
                    body.push(newSelectList2);
                    div.set("v.body",body);
                    
                }
                else if (status2 === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    toastr.error('No response from server or client is offline.');
                    // Show offline error
                }
                    else if (status2 === "ERROR") {
                        console.log("Error: " + errorMessage2);
                        toastr.error(errorMessage2);
                        // Show error message
                    }
            }
        ); 
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    toastr.error('No response from server or client is offline.');
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        toastr.error(errorMessage);
                        // Show error message
                    }
            }
        ); 
    },
    
    addSelectOption : function(component, divName, optionList) {
        console.log('in addSelectOption ');
        var choices = ["one", "two"];
        //var newDiv = document.createElement('div');
        var selectHTML = "<select>" ;
        selectHTML += "<option class=uiInputSelectOption value='" + 'None' + "'>" + '-None-' + "</option>";
        for(var i = 0; i < optionList.length; i++) {
            selectHTML += "<option class=uiInputSelectOption value='" + optionList[i].value + "'>" + optionList[i].label + "</option>";
        }
        selectHTML += "</select>";
        //newDiv.innerHTML = selectHTML;
        document.getElementById(divName).innerHTML = selectHTML;
    },
    
    getRemainOptionList : function(component) {
        let selectevalue2 = component.get("v.selectedValue2");
        let selectevalue1 = component.get("v.selectedValue1");
        let index = component.get("v.index");
        let optionList = component.get("v.fields");
        let selectedOptionList = [];
        selectedOptionList.push(selectevalue1);
        selectedOptionList.push(selectevalue2);
        console.log('index ', index);
        if(index > 0){
            
            for(let i = 0 ; i < index ; i++){
                
                let selectedVal = document.getElementById(i+1).value; 
                console.log('selectedVal ', selectedVal);
                selectedOptionList.push(selectedVal);
            }
        }
        
        let remainedOptionList = [];
        
        for(let i = 0 ; i < optionList.length ; i++){
            
            if(!selectedOptionList.includes(optionList[i].value)){
                
                remainedOptionList.push(optionList[i]);
            }
        }
        
        return remainedOptionList;
    },
    
    getFilterCriteriaString : function(component) {
        let selectevalue1 = component.get("v.selectedValue1");
        let selectevalue2 = component.get("v.selectedValue2");
        let inputValue1 = component.get("v.inputValue1");
        let inputValue2 = component.get("v.inputValue2");
        let index = component.get("v.index");
        
        let whereCondition = selectevalue1 + ' LIKE \'%' + inputValue1.trim() + '%\'';
            
        if(selectevalue2 && selectevalue2 != 'None' ){
            whereCondition = whereCondition + ' AND ' + selectevalue2 + ' LIKE \'%' + inputValue2.trim() + '%\'';
        }
        
        if(index > 0){
            
            for(let i = 0 ; i < index ; i++){
                
                let selectedVal = document.getElementById(i+1).value; 
                console.log('selectedVal ', selectedVal);
                
                if(selectedVal != 'None'){
                    
                    let inputVal = document.getElementById('input'+(i+1)).value; 
                    whereCondition = whereCondition + ' AND ' + selectedVal + ' LIKE \'%' + inputVal.trim() + '%\'';
                }
            }
        }
        
        return whereCondition;
    },
    
    getPhoneFieldValue : function(component){
        let selectevalue1 = component.get("v.selectedValue1");
        let selectevalue2 = component.get("v.selectedValue2");
        let inputValue1 = component.get("v.inputValue1");
        let inputValue2 = component.get("v.inputValue2");
        let index = component.get("v.index");
        let phoneValue;
        
        if(selectevalue1 == 'Phone'){
            phoneValue =  inputValue1;
        }
        
        if(selectevalue2 == 'Phone'){
            phoneValue =  inputValue2;
        } 
        
        if(index > 0){
            
            for(let i = 0 ; i < index ; i++){
                
                let selectedVal = document.getElementById(i+1).value; 
                console.log('selectedVal ', selectedVal);
                
                if(selectedVal != 'None' && selectedVal == 'Phone'){
                    
                    phoneValue = document.getElementById('input'+(i+1)).value; 
                    
                }
            }
        }
        
        return phoneValue;
    },
    
    removeSelectList : function(component, indexStart, indexEnd) {
        var tempIndex = indexEnd ;
        // console.log('tempIndex before',tempIndex);
        for(var i=indexStart ; i<= indexEnd ; i++){
            var element = document.getElementById(i);
            var inputElement = document.getElementById('input'+i);
            // console.log('element',element);
            //cmp.destroy();
            element.parentNode.removeChild(element);
            inputElement.parentNode.removeChild(inputElement);
            tempIndex--;
        }
        //console.log('tempIndex after',tempIndex);
        component.set("v.index", tempIndex);
    },
})