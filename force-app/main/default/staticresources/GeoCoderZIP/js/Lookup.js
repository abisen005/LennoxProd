j$ = jQuery.noConflict();

var LookupWindow;

// this is used to block the page while an ajax request is pending
function BlockMe() {	        
	j$.blockUI();		        	         			
}

// this unblocks the page when an ajax request completes
function UnBlockMe() {	        
	j$.unblockUI();		        	         			
}		

// this overrides the salesforce function and prevents any field from having inital focus
function setFocusOnLoad() {} 	

// this is used to open the custom lookup window in a pop-up window instead of a new tab
function openLookupWindow(URL) {
	LookupWindow = window.open(URL,'lookup','height=500,width=680,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollbars=yes',true);
	LookupWindow.focus();
}

// this is called by the lookup window to close it after it update the field. 
// this is required due to security changes in browsers.  i.e. this function has to be in the parent page.
function closeLookupWindow() {
	if (!typeof LookupWindow === "undefined") {
		LookupWindow.close();		    	
	}		
} 
																
// this function resolves an issue with the way that Jquery and
// salesforce work with the : in the ID
function esc(myid) {
	return '#' + myid.replace(/(:|\.)/g,'\\\\$1');
}