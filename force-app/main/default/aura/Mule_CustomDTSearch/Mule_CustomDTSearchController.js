({
    init : function(component, event, helper) {
        
        var action = component.get("c.returnDefaultColumns");   
        action.setParams({table :  component.get("v.searchName")});
        action.setCallback(this,function(response){
            let state = response.getState();
            console.log(state);
            if(state=='SUCCESS'){
                console.log('return resoponse - ',response.getReturnValue());
                let returnWrapper  = response.getReturnValue();
                returnWrapper.sort((a, b) => {
                    return a.sortOrder - b.sortOrder;
                });
                console.log('returnWrapper-----',returnWrapper);
                let columns= [];
                returnWrapper.forEach(element=>{
                    let obj = {
                    label : element.Label , 
                    fieldName : element.FieldName,
                    type : element.Type
                }
                                      columns.push(obj);                 
                
            });
            console.log('!!!columns',columns);
            component.set('v.mycolumns',columns);
        }
                           else{
                           console.log(response.getError());
    }
});
$A.enqueueAction(action);

//returnDefaultColumns
//console.log('draw table called');

var obj=component.get('v.stringResponseRFC');
var flowOperation=component.get('v.searchName');
var jsonData=JSON.parse(obj);
//console.log('!!!!',jsonData[0]);
if(jsonData[0]) component.set('v.orderHeader',jsonData[0]);

//console.log('jsonData[0]--->',JSON.stringify(component.get('v.orderHeader')));

let headerObj = {
    Order_Document_Create_Date__c : jsonData[0].Order_Document_Create_Date__c,
    Purchase_Order_No__c : jsonData[0].Purchase_Order_No__c,
    Total_Value__c : jsonData[0].Total_Value__c,
    Freight_charge__c : jsonData[0].Freight_charge__c,
    Delivery_status__c : jsonData[0].Delivery_status__c
}

console.log('headerObj--',JSON.stringify(headerObj));


if(flowOperation == 'OrderSearchFlow'){
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
    
} if(flowOperation == 'OrderSearchHeaders'){
    
    component.set('v.orderNumber',jsonData[0].Order_Number__c);
    component.set('v.mydata',jsonData[0]);
    component.set('v.myOrderHeaderdataisTrue',true);
    //console.log('!!',jsonData[0]);
    //helper.callOrderItems(component, event, helper , 'OrderSearchItems');
}
if(flowOperation == 'OrderSearchItems'){
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
}if (flowOperation == 'WarrantySearchFlow'){
    //console.log('!!!operation',flowOperation);
    
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
}
if (flowOperation == 'EquipmentSearchFlow'){
    //console.log('!!!operation',flowOperation);
    component.set('v.serialNumber',jsonData[0].Serial_Number);
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
}
if (flowOperation == 'LearningSearchFlow'){
    //console.log('!!!operation',flowOperation);
    component.set('v.isDataSelected', true);
    component.set('v.showPrint',true);
    //component.set('v.serialNumber',jsonData[0].Serial_Number);
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
    
    let accName = { AccountName :  component.get('v.accName'),CustomerNumber :  component.get('v.custNumber') }
    let accList = [];
    accList.push(accName);
    
    var customLabel = $A.get("$Label.c.Mule_LennoxSiteURL");
    component.set('v.navigateURL', customLabel+'/apex/Mule_CustomDTSearchPage?accName='+JSON.stringify(accList)+'&Type=Learning');   
}
},
    
    updateSelectedText: function (cmp, event) {
        
        var selectedRows = event.getParam('selectedRows');
       // console.log('Length'+cmp.get('v.showPrint'));
        //console.log('Length '+selectedRows.length);
        //console.log('2'+JSON.stringify(selectedRows));
        cmp.set('v.selectedRows', selectedRows);
       // console.log('v.selectedRows',cmp.get('v.selectedRows'));
        var flowOperation=cmp.get('v.searchName');
        var selectedRows = event.getParam('selectedRows');
        if(selectedRows.length > 0){
            cmp.set('v.showPrint',true);
            
        }
        else{
            cmp.set('v.showPrint',false);
        }
        //console.log('flowOperation---',flowOperation);
        
        if(flowOperation == 'EquipmentSearchFlow'){
            //console.log('!!!!!!!!!!!!!',cmp.get('v.accName'));
            //console.log('!!!!!!!!!!!!!',cmp.get('v.custNumber'))
            let accName = { AccountName :  cmp.get('v.accName'),CustomerNumber :  cmp.get('v.custNumber') }
            let accList = [];
            accList.push(accName);
            //cmp.set('v.showPrint',true);
            var customLabel = $A.get("$Label.c.Mule_LennoxSiteURL");
            cmp.set('v.navigateURL', customLabel+'/apex/Mule_CustomDTSearchPage?Type=Equipment');
            
            
            // cmp.set('v.navigateURL', '/apex/OSDataTable?data='+JSON.stringify(selectedRows).replaceAll('#' , 'TEMPORARYHASHTAG')+'&accName='+JSON.stringify(accList)+'&Type=Equipment');
            console.log('Equipmentcheck');
        }
        else if(flowOperation == 'LearningSearchFlow'){
            /*console.log('!!!!!!!!!!!!!',cmp.get('v.accName'));
            console.log('!!!!!!!!!!!!!',cmp.get('v.custNumber'));
            console.log('!!!!!!!!!!!!!Learning Seach');*/
            cmp.set('v.isDataSelected', true);
            let accName = { AccountName :  cmp.get('v.accName'),CustomerNumber :  cmp.get('v.custNumber') }
            let accList = [];
            accList.push(accName);
            
            
            var jsonStr = JSON.stringify(selectedRows);
            cmp.set('v.selectedRowsData', jsonStr)
            
            var customLabel = $A.get("$Label.c.Mule_LennoxSiteURL");
            cmp.set('v.navigateURL', customLabel+'/apex/Mule_CustomDTSearchPage?Type=Learning');
            
        }
    },
        
        
        /*  onButtonPressed: function(cmp, event, helper) {
                debugger;
                var actionClicked = event.getSource().getLocalId();
                console.log('actionClicked--',actionClicked);
                var navigate = cmp.get('v.navigateFlow');
                console.log('navigate--',navigate);
                navigate(actionClicked);
            },*/
            onButtonPressed: function(cmp, event, helper) {
                
                debugger;
                var actionClicked = event.getSource().getLocalId();
                console.log('actionClicked--', actionClicked);
                
                // Ensure actionClicked is a supported navigation option
                if (actionClicked == 'BACK') {
                    var navigate = cmp.get('v.navigateFlow');
                    console.log('navigate--', navigate);
                    navigate(actionClicked);
                } else {
                    //console.warn('The BACK navigation option is not supported.');
                    $A.enqueueAction(action);
                    
                }
            },
                
                
                
                onButtonPressed2: function(cmp, event, helper) {
                    var showInputScreen = cmp.get('v.previousScreen');
                    console.log('showInputScreen--', showInputScreen);
                    
                    // Set the boolean value in the Flow
                    var navigate = cmp.get('v.navigateFlow');
                    navigate('NEXT', {
                        previousScreen: showInputScreen
                    });
                },                
                    
                    handleClick : function(component, event, helper) {
                        var flowOperation=component.get('v.searchName');
                        console.log('Checkpoint1');
                        var customLabel = $A.get("$Label.c.Mule_LennoxSiteURL");
                        console.log('Checkpoint2');
                        if(flowOperation == 'LearningSearchFlow'){
                            var selectedRowsData = component.get("v.stringResponseRFC");
                            console.log('JSONSTRING',selectedRowsData);}
                        else if(flowOperation == 'EquipmentSearchFlow'){
                            
                            var selectedRowsData = JSON.stringify(component.get('v.selectedRows'));}                 
                        
                        console.log('JSONSTRING',selectedRowsData);
                        //selectedRowsData = selectedRowsData.replaceAll( '\\s+', '');
                        //
                        let accName = { AccountName :  component.get('v.accName'),CustomerNumber :  component.get('v.custNumber') }
                        let accList = [];
                        accList.push(accName);
                        //selectedRowsData = selectedRowsData.concat(JSON.stringify(accList));
                        
                        //var selectedRowsData = selectedRowsData.putAll(JSON.stringify(accList);
                        // console.log('bingo',selectedRowsData )   ;                                                           
                        var action = component.get("c.storeJSONIntoTempCache");
                        
                        
                        action.setParams({jsonString1 : selectedRowsData,jsonString2 : JSON.stringify(accList)});
                        
                        action.setCallback(this,function(response){
                            let state = response.getState();
                            console.log(state);
                            if(state=='SUCCESS'){
                                //component.set('v.navigateURL', staticLabel+'/apex/MuleCustomReportDataTable?Type=Warranty');
                                //
                                
                                console.log('url-->',component.get('v.navigateURL'));
                                window.open(component.get("v.navigateURL"));
                                console.log('Learningcheck');
                            } else{
                                console.log(response.getError());
                            }
                        });
                        $A.enqueueAction(action);
                        
                        //var message = component.get("v.navigateURL");
                        
                        //window.open(component.get("v.navigateURL"));
                        
                    },
                        
                        
                        
                        sendToVF : function(component, event, helper) {
                            var message = component.get("v.selectedRows");
                            /* var vfOrigin = "https://" + component.get("v.vfHost");
                var vfWindow = component.find("vfFrame").getElement().contentWindow;
                vfWindow.postMessage(message, vfOrigin);*/
                        
                        /*var myEvent = $A.get("e.c:CustomDatatableEvt");
                myEvent.setParams({
                    CurrentRecDetails: component.get('v.selectedRows')
                });
                myEvent.fire();*/
                        /*
                component.set('v.mySelectedData', message);
                component.set('v.isDataSelected', true);*/
                        
                        /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": 'https://lennox--mule--c.visualforce.com/apex/OSDataTable?data=hello'
                });
                urlEvent.fire();*/
                        
                        component.set('v.navigateURL', '/apex/OSDataTable?data=hello');
                    },
                        
                        print: function(cmp, event, helper) {
                            pwin = window.open(document.getElementById("iframe").src,"_blank");
                            pwin.onload = function () {window.print();}
                        },
                            
                            downloadDocument : function(component, event, helper) {
                                window.print();
                            }

})