({
    navigateToParticipantSearch : function(component, event, helper){
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__FT_Participant_Search',
            }
        }; 
        
        pageReference.state = {"c__recordId": component.get("v.recordId")};
        /*const navService = component.find('navService');
        const handleUrl = (url) => {
            window.open(url);
        };
        const handleError = (error) => {
            console.log(error);
        }; 
        navService.generateUrl(pageReference).then(handleUrl, handleError);*/
        
        var workspaceAPI = component.find("workspace");
        var navService = component.find("navService");
        
        workspaceAPI
        .isConsoleNavigation()
        .then(function(isConsole) {
            if (isConsole) {
                //  // in a console app - generate a URL and then open a subtab of the currently focused parent tab
                navService.generateUrl(pageReference).then(function(cmpURL) {
                    workspaceAPI
                    .getEnclosingTabId()
                    .then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            url: cmpURL,
                            focus: true
                        });
                    })
                    .then(function(subTabId) {
                        // the subtab has been created, use the Id to set the label
                        workspaceAPI.setTabLabel({
                            tabId: subTabId,
                            label: "Participant Search" 
                        });
                    });
                });
            } else {
                // this is standard navigation, use the navigate method to open the component
                navService.navigate(pageReference, false);
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})