({
   refreshListView : function(component) {
      let navigationItemAPI = component.find("navigationItemAPI");
      navigationItemAPI.getSelectedNavigationItem()
         .then((response) => {
            // Only refresh if viewing an object-page
            const objPage = 'Case';
            if (response.pageReference && 
                   response.pageReference.type === objPage) {
                // Do the refresh
                navigationItemAPI.refreshNavigationItem()
                    .catch(function(error) {
                        console.log('Error in auto-refresh', error);
                    });
            }
        });
    }
})