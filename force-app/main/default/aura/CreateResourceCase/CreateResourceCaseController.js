({
	doInit: function(component, event, helper) {  
        helper.createCaseResourceRecord(component, event, helper);
    },
    hideMessageDiv : function(component, event, helper) {
            var x = document.getElementsByClassName("messageDiv");
            x[0].style.display = "none";
        }
})