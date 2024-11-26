({
    showToast: function(title, message, type) {
        
        let toastEvent = $A.get("e.force:showToast");
            
        if (toastEvent) {

            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible"
            });

            toastEvent.fire();
        } else {

            alert(message);
        }
    }
})