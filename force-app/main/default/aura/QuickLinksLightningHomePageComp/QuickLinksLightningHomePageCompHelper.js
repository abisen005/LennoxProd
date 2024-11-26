({
    setUserInformationAndPermissionObject : function(component, event) {
        
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue().isSuccess){
                    console.log('Success');
                    console.log(response.getReturnValue());
                    component.set('v.TabPermission', response.getReturnValue());
                    console.log('tabPermissionObject'+response.getReturnValue());
                    //this.setTabPermissions(component, TabPermission, response.getReturnValue());
                }
                else{
                    console.log('Fail');
                    console.log('userInfo'+response.getReturnValue());
                }
            }
            else{
                console.log('Exception');
            }
        });
        
        $A.enqueueAction(action);
    }
   
})