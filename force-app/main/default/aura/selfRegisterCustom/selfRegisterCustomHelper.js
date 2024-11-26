({
	
    showSuccess : function(cmp){
        cmp.set('v.wasSuccessful', true);
    },
    
    validateContact : function(cmp, event){
        //check if the contact already exists
        //console.log("# validateContact");
        var aId = cmp.get('v.acnt.Id');
        var em = cmp.get('v.form.Point_of_Contact_Email__c');
        var action = cmp.get("c.searchContact");
        console.log("# aId: ", aId);
        console.log("# em: ", em);
        var parseForm = JSON.parse(JSON.stringify(cmp.get('v.form')));
        console.log("# parseForm: ", parseForm);
        action.setParams({
            email:em,
            acntId:aId,
            form: parseForm
        });
        action.setCallback(this, function(a){ 
            console.log("a.getState(): ", a.getState());
            console.log("a.getError", a.getError());
            if(a.getState() == "SUCCESS"){
                cmp.set('v.Spinner',false);
                var conId = a.getReturnValue();
                if(conId == 'existing'){
                    //contact was already provisioned
                    cmp.set('v.alreadyProv', true);
                    event.preventDefault();
                } else {
                    
                    if(conId.includes('a03')){
                        this.showSuccess(cmp);
                        this.deleteDuplicateForm(cmp, event);
                    }
                }
            } else {
                cmp.set('v.Spinner',false);
                var errorList = [];
                var fields = cmp.find('required');
                for(var i = 0; i < fields.length ; i++){
                    //console.log("field[i]: ", fields[i]);
                    //console.log("v.fieldName: ", fields[i].get('v.fieldName'));
                    if(fields[i].get('v.fieldName') == 'Point_of_Contact_Email__c'){
                        errorList[i] = 'true';
                    } else {
                        errorList[i] = 'false';
                    }
                }
                cmp.set('v.hasError', errorList);
                event.preventDefault();          
            }
        });
        $A.enqueueAction(action);
    },
        
        
        deleteDuplicateForm : function(cmp, event){
        var action2 = cmp.get("c.searchDuplicateForm");
            
        var aId = cmp.get('v.acnt.Id');
        var em = cmp.get('v.form.Point_of_Contact_Email__c');
        var parseForm = JSON.parse(JSON.stringify(cmp.get('v.form')));
            
            action2.setParams({
                email:em,
                acntId:aId,
                form: parseForm
            });
        action2.setCallback(this, function(a) {
            if(a.getState() == "SUCCESS"){
                cmp.set('v.Spinner',false);
                var formId = a.getReturnValue();
                console.log('Deleted Successfully',formId);
                } else {     
               console.log('Error Abi Check again');    
                }                  
        });

         $A.enqueueAction(action2);
    },
    
    setupErrorArray: function(cmp){
        var errorList = [];
        var fields = cmp.find('required');
        for(var i = 0; i < field.length; i++){
            errorList[i] = 'false';
        }
        
        cmp.set('v.hasError', errorList);
    }, 
    
    validateReqFields: function(cmp, event){
        var errorList = [];
        var didHaveError = false;
        var fields = cmp.find('required');
        for(var i = 0; i < fields.length ; i++){
            if(fields[i].get('v.value') == undefined || fields[i].get('v.value') == ''){
                errorList[i] = 'true';
                didHaveError = true;
            } else {
                errorList[i] = 'false';
                //didHaveError = false;
            }
        }
        
        cmp.set('v.hasError', errorList);
        if(didHaveError){
            event.preventDefault();
        }
        
        return didHaveError;
    },
    
    validateCustId: function(cmp, event){
        if($A.util.isUndefinedOrNull(cmp.find('customerIdNum')) &&
           (cmp.find('customerIdNum').get('v.value') == undefined || cmp.find('customerIdNum').get('v.value') == '')){
            cmp.set('v.idWasBlank', true);
        } else {
            cmp.set('v.idWasBlank', false);
        }
    },
    
    checkCustomerId: function(component, event,helper){
        
        this.validateCustId(component,event);
        if(component.get('v.idWasBlank')){
            return;
        }
        
        var cId = component.get('v.customerId');
        var action = component.get("c.checkIdValidity");
            action.setParams({customerId:cId});
            action.setCallback(this, function(a){ 
            var rtnValue = a.getReturnValue();
                console.log('rtnValue==',rtnValue);
                if(rtnValue.Id != undefined){
                    component.set('v.isValidId', 'true');
                    //setup account object
                    component.set('v.acnt', {
                        sobjectType: 'Account',
                        Id: rtnValue.Id,
                        
                    });
                    
                    component.set('v.acnt',rtnValue);
                    
                    //setup form object and prepopulate certain values
                    component.set('v.form', {
                        sobjectType: 'FTL_Dealer_Signup_Form__c',
                        Business_Address__c: rtnValue.ShippingStreet,
                        Business_City__c: rtnValue.ShippingCity,
                        Business_State__c: rtnValue.ShippingState,
                        Business_Zip_Code__c: rtnValue.ShippingPostalCode, 
                        Company_Name__c: rtnValue.Id
                        
                    }); 
                } else if(rtnValue.FTL_Eligibility__c == 'Ineligible'){
                    component.set('v.isValidId', 'false');
                } else {
                    component.set('v.isValidId', 'nonexistent')
                }
            });
            $A.enqueueAction(action);
        
        //before moving to next screen determine how many required fields there are and set up array
        helper.setupErrorArray(component);
    },
    
    setMaxLengthVals : function(component,evt){
        component.set('v.form.Point_of_Contact_First_Name__c',component.find('firstName').get('v.value'));
        component.set('v.form.Point_of_Contact_Last_Name__c', component.find('lastName').get('v.value'));
        //component.set('v.form.Point_of_Contact_Phone_Number__c', component.find('phone').get('v.value'));
    }
   
})