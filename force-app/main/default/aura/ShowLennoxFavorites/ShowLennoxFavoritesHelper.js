({
	/*
	 * @purpose : This event will show the toast message
	 */ 
    showToast : function(component, type, message, title) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    
    /*
	 * @purpose : This method handle the sorting.
	 */ 
    sorting : function(items){
        items.sort(function (a, b) {
            return a.sequence - b.sequence;
        });
        return items;
    },
})