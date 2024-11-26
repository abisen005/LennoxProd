function trackPageView(pageName) {
	var upv = new sforce.SObject('User_Page_View__c');
    upv.Page_Name__c = pageName;
    var result = sforce.connection.create([upv]);
    if(result[0].getBoolean('success')) {
        console.log('upv created');
    } else {
        console.log('failed: ' + result[0]);
    }
}