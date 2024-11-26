({
	invokeServerAction: function(cmp, helper, methodOptions) {
        var action = cmp.get('c.' + methodOptions.name);

        if(methodOptions.params) {
            action.setParams(methodOptions.params);
        }

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === 'SUCCESS') {
                methodOptions.callback(cmp, helper, response.getReturnValue());
            } else if(cmp.isValid() && state === 'ERROR') {
                console.log(response.getError());
                helper.handleServerActionError(cmp, helper, methodOptions.name, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    handleServerActionError: function(cmp, helper, actionName, error) {}
})