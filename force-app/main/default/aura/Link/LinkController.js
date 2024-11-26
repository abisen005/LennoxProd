({
    handleInit : function Init(cmp, e, h) {
        //Test Session
        console.log('cmp.get'+cmp.get('v.label'));
        if(cmp.get('v.label') == 'Test Session'){
            var routeChangeEvent = $A.get('e.c:routeChangeAttempt'),
                to = cmp.get('v.to'),
                label = cmp.get('v.label'),
                routerName = to.indexOf('/') > 0 ? to.split('/')[0] : '';
            console.log(routerName, to, label);
            routeChangeEvent.setParams({ routerName: routerName, path: to, label: label });
            routeChangeEvent.fire();  
        }
        
        
    },
        
	/*
 * linkClickHandler
 * @Description	Click handler for the anchor element in the Link component.
 *				This will fire the routeChangeAttempt event. Any existing Routers
 *				will listen for this event and determine if action should be taken.
 */
	linkClickHandler: function linkClickHandler(cmp, e, h) {
		e.preventDefault();
		var routeChangeEvent = $A.get('e.c:routeChangeAttempt'),
		    to = cmp.get('v.to'),
		    label = cmp.get('v.label'),
		    routerName = to.indexOf('/') > 0 ? to.split('/')[0] : '';
		console.log(routerName, to, label);
		routeChangeEvent.setParams({ routerName: routerName, path: to, label: label });
		routeChangeEvent.fire();
	}
});