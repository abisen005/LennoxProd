({
    getDocuments : function(component, event, helper) {
        helper.fetchRecords(component);
		component.set('v.columns', [
            {
                label: 'Document', 
                fieldName: 'URL',
                type: 'url', 
                typeAttributes: { 
                    label: {
                        fieldName: 'title'
                    }
                }
            }
        ]);
    }
})