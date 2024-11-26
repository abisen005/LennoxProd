({
    init : function(c, e, h) {
        c.set('v.columns', [
            {label: 'State / Province', fieldName: 'StateProvince', type: 'text'},
            {label: 'Number of Nominations', fieldName: 'Total', type: 'number', cellAttributes: { alignment: 'left' }}
        ]);

        var action = c.get( "c.getAggregateData" );  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === "SUCCESS" ) {  
               c.set( "v.data", response.getReturnValue() );  
            }  
        });  

        $A.enqueueAction(action);  
    }
})