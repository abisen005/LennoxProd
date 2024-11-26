({  
fetchSCLDetails : function(component, event, helper) {
        

        var tableColumns =[

               {
                "label": "Date",
                "fieldName": "Date__c",
                "type": "text",
                   "initialWidth":150,
                   "sortable":"true",
                   
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {
               
                "label": "Material",
                "fieldName": "Material_s__c",
                "type": "text",
                "wrapText":"true",
                  "initialWidth":200,
                "sortable":"true",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
                        {
               
                "label": "Description",
                "fieldName": "Description__c",
                "type": "text",
                "wrapText":"true",
                  "initialWidth":200,
                "sortable":"true",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
                           {
                "label": "Message",
                "fieldName": "Message1__c",
                "type": "text",
                               "sortable":"true",
                               "wrapText":"true",
                              
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
 }
        ];
        // set tableCol attribute with table columns
        component.set('v.tableCol', tableColumns);
        
        // call server side apex method to fetch account records
        var action = component.get("c.getSCL");
    action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               component.set("v.acctList", response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
                var records = response.getReturnValue();
                
                records.forEach(function(record){ 
                    if(typeof record.Id != 'undefined'){ 

                        if(record.PriorityMessage__c){
                            record.showClass = (record.PriorityMessage__c === true ? 'redcolor' : 'blackcolor');
                            record.displayIconName = 'utility:check';  
                        }
                        else{
                            record.showClass = (record.PriorityMessage__c === false ? 'blackcolor' : 'redcolor');
                            record.displayIconName = 'utility:close';     
                        }
                    }});
              

                component.set("v.SCLList", records);
            
            }                   });
    

        $A.enqueueAction(action);
        },

    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }}
)