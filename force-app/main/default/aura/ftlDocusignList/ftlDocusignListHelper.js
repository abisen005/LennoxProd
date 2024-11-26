/**
 * @File Name          : ftlDocusignListHelper.js
 * @Description        : 
 * @Author             : Ken@VentasConsulting.com <Ken Dickinson>
 * @Group              : 
 * @Last Modified By   : Ken@VentasConsulting.com <Ken Dickinson>
 * @Last Modified On   : 2/27/2020, 3:20:50 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/27/2020   Ken@VentasConsulting.com <Ken Dickinson>     Initial Version
**/
({
    fetchRecords : function(component) {  
        var action = component.get( "c.getDocusignDocuments" );  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === "SUCCESS" ) {  
                var listRecords = response.getReturnValue();
                listRecords.forEach(function(item) {
                    item['URL'] = '/feelthelove/s/contentdocument/' + item['documentId'];
                });
                component.set( "v.listRecords", listRecords );  
                component.set("v.numRecords", listRecords.length);
            }  
        });  

        $A.enqueueAction(action);  
          
    }})