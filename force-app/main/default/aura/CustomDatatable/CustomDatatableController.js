({
    init : function(component, event, helper) {
        
        var action = component.get("c.returnDefaultColumns");
        let ac= component.get("v.accName");
        console.log('!!!account Name' ,ac);
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
console.log('draw table called');

var obj=component.get('v.stringResponseRFC');
var flowOperation=component.get('v.searchName');
var jsonData=JSON.parse(obj);
console.log('!!!!',jsonData[0]);
if(jsonData[0]) component.set('v.orderHeader',jsonData[0]);

console.log('jsonData[0]--->',JSON.stringify(component.get('v.orderHeader')));

let headerObj = {
    Order_Document_Create_Date__c : jsonData[0].Order_Document_Create_Date__c,
    Purchase_Order_No__c : jsonData[0].Purchase_Order_No__c,
    Total_Value__c :  jsonData[0].Total_Value__c,
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
    console.log('!!',jsonData[0]);
}
let tempList1 = [];
if(flowOperation == 'OrderSearchItems'){
    
    var jsonData=JSON.parse(obj);
    let orderItemColumns;  
    for (var i=0; i<jsonData.length; i++) {
        
        orderItemColumns = {
            Item_Number__c : jsonData[i].Item_Number__c,
            Material_Number__c : jsonData[i].Material_Number__c,
            Material_Description__c : jsonData[i].Material_Description__c,
            Quantity__c : jsonData[i].Quantity__c,
            Sales_Price_per_Item__c : jsonData[i].Sales_Price_per_Item__c,
            Shipment_Date__c  : jsonData[i].Shipment_Date__c ,
            Shipment_Number__c : jsonData[i].Shipment_Number__c,
            Delivery_Number__c : jsonData[i].Delivery_Number__c,
            Order_Number__c : jsonData[i].Order_Number__c
        }
        tempList1.push(orderItemColumns);
    }    

    component.set("v.orderHeaderInfo",tempList1);
    component.set('v.mydata',tempList1);
    component.set('v.myOrderHeaderdataisTrue',false);
    
}if (flowOperation == 'WarrantySearchFlow'){
    console.log('!!!operation',flowOperation);
    component.set('v.mydata',jsonData);
    component.set('v.myOrderHeaderdataisTrue',false);
}

if(flowOperation == 'OrderSearchItems' || flowOperation == 'OrderSearchHeaders'){
    let accName = { AccountName :  component.get('v.accName'),CustomerNumber :  component.get('v.custNumber') }
    let obj3 = component.get('v.orderHeader');
    let headerObj2 = {
        Order_Document_Create_Date__c : obj3.Order_Document_Create_Date__c,
        Purchase_Order_No__c : obj3.Purchase_Order_No__c,
        Total_Value__c : obj3.Total_Value__c,
        Freight_charge__c : obj3.Freight_charge__c,
        Delivery_status__c : obj3.Delivery_status__c,
        Overall_Order_status__c  : obj3.Overall_Order_status__c ,
        Order_Number__c : obj3.Order_Number__c,
        CustomerNumber :  component.get('v.custNumber'),
        AccountName :  component.get('v.accName')
        
    }
    //console.log('!!!accountNumber',component.get('v.accName'));
    //console.log('!!!accountNumber',component.get('v.custNumber'));
    //console.log('OrderItemCheck' , JSON.stringify(obj3)); 

    let tempList = [];
    tempList.push(headerObj2);
    
    
    component.set("v.orderItemInfo",tempList);  
    component.set('v.navigateURL','/apex/OSDataTable?data='+JSON.stringify(tempList1)+'&data2='+JSON.stringify(tempList).replaceAll('&' , 'and')+'&Type=Items');
    console.log('url>>>>>>>>>>',component.get('v.navigateURL'));
    component.set('v.hideSelectableDT',true);
    component.set('v.showPrint',true);
}else{
    component.set('v.hideSelectableDT',false);
}

},
    updateSelectedText: function (cmp, event) {
        
        var selectedRows = event.getParam('selectedRows');
        console.log('1',selectedRows.length);
        console.log('2',JSON.stringify(selectedRows));
        
        cmp.set('v.selectedRows', selectedRows);
        var flowOperation=cmp.get('v.searchName');
        var selectedRows = event.getParam('selectedRows');
        if(selectedRows.length > 0){
            cmp.set('v.showPrint',true);
        }
        else{
            cmp.set('v.showPrint',false);
        }
        
        console.log('3',cmp.get('v.showPrint'));
        console.log('flowOperation---',flowOperation);
        if(flowOperation == 'OrderSearchFlow'){
            
            let accName = { AccountName :  cmp.get('v.accName'),CustomerNumber :  cmp.get('v.custNumber') }
            let accList = [];
            accList.push(accName);
            
            cmp.set('v.navigateURL', '/apex/OSDataTable?data='+JSON.stringify(selectedRows)+'&accName='+JSON.stringify(accList)+'&Type=Order');
            console.log('Ordercheck');
        }else
            if(flowOperation == 'WarrantySearchFlow'){
                console.log('!!!!!!!!!!!!!',cmp.get('v.accName'));
                console.log('!!!!!!!!!!!!!',cmp.get('v.custNumber'))
                let accName = {CustomerNumber :  cmp.get('v.custNumber') ,AccountName :  cmp.get('v.accName') }
                let accList = [];
                accList.push(accName);
                
                cmp.set('v.showPrint',true);
                cmp.set('v.navigateURL', '/apex/OSDataTable?data='+JSON.stringify(selectedRows).replaceAll('#' , 'TEMPORARYHASHTAG')+'&accName='+JSON.stringify(accList).replaceAll('&' , '%26')+'&Type=Warranty');
                console.log('Warrantycheck');
            }
        
    },
        onButtonPressed: function(cmp, event, helper) {
            // Figure out which action was called
            var actionClicked = event.getSource().getLocalId();
            // Fire that action
            var navigate = cmp.get('v.navigateFlow');
            navigate(actionClicked);
        },
            
            handleClick : function(component, event, helper) {
                console.log('Check1');
                //var message = component.get("v.navigateURL");
                var selectedHeaderData = component.get("v.mydata");
                var selectedItemData = component.get("v.orderItemInfo");
                //window.open(component.get("v.navigateURL"));
                var action = component.get("c.storeJSONIntoTempCache");
                action.setParams({jsonString1 : JSON.stringify(selectedHeaderData) , jsonString2 : JSON.stringify(selectedItemData) });
                
                action.setCallback(this,function(response){
                    let state = response.getState();
                    console.log(state);
                    if(state=='SUCCESS'){
                         var customLabel = $A.get("$Label.c.Mule_LennoxSiteURL");
                        component.set('v.navigateURL', customLabel+'/apex/OSDataTable?Type=Items');
                        console.log('url-->',component.get('v.navigateURL'));
                        window.open(component.get("v.navigateURL"));
                        console.log('Warrantycheck');
                    } else{
                        console.log(response.getError());
                    }
                });
                $A.enqueueAction(action);
            },
                
                print: function(cmp, event, helper) {
                    pwin = window.open(document.getElementById("iframe").src,"_blank");
                    pwin.onload = function () {window.print();}
                },
                    
                    downloadDocument : function(component, event, helper) {
                        window.print();
                    },
                        
})