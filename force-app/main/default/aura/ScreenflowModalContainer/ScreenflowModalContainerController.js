({
    doInit: function(component, event, helper){
        //alert(component.get('v.testAttr'));
        const flow = component.find("flowData");
        var inputVariables = [
            {
                name : "getAccountId",
                type : "SObject",
                value: component.get("v.recordId")
            }
        ];
        var inputVariables1 = [
            { name : "customerNumber", type : "String", value: component.get("v.customerNumber") }
        ];
        
        let rec = component.get("v.recordId");
        
        console.log('Record ID12345',component.get("v.customerNumber"));
        
        let flowname =  component.get("v.flowname");
        console.log('flowname ID123',flowname);
        
        if(flowname != 'Learning_Mulesoft'){
            flow.startFlow(flowname,inputVariables);//"Order_Search_Mulesoft_Screen_Flow");
        }else 
        {
            flow.startFlow(flowname,inputVariables1);//"Order_Search_Mulesoft_Screen_Flow");
            
        }
    },
    
});