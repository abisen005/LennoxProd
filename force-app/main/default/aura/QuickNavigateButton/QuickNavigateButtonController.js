({
    navigateToVisualforcePage: function (component, event, helper) {
        var url = component.get("v.url");
        window.open(url, '_blank');
    }
})