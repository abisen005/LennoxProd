({
    showToast : function(component, variant, title, message) {
        component.find('notifLib').showToast({
            "title": title,
            "variant": variant,
            "message": message
        });
    }
})