({
    doInit : function(cmp, event, helper) {
        //call server side method
        var action = cmp.get("c.getCurrentUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //check state of server side response
            if (state === "SUCCESS") {
                var d = new Date();
                
                var titleMap = helper.titleMap();
                var userObj = response.getReturnValue();
                //check current profile and set title
                for(var title in titleMap ){
                    if(userObj.Profile.Name == titleMap[title].profilename){
                        cmp.set("v.title", titleMap[title].title);
                    }
                }
                //get current year
                cmp.set("v.todaysYear",d.getFullYear());
                //assign user object to cmp attribute
                cmp.set("v.userInfo",userObj);
                //assign role hierarchy 
                if(userObj.Profile.Name == 'Lennox - Res Sales DM' ||
                   
                   userObj.Profile.Name == 'Lennox - Res Sales ASM'){
                    var childAction = cmp.get("c.getValidatedUserInfo");
                    childAction.setParams({ userRoleId : userObj.UserRoleId });
                    childAction.setCallback(this, function(response) {
                        var childState = response.getState();
                        if (childState === "SUCCESS") {
                            cmp.set("v.userList",response.getReturnValue());
                            console.log(response.getReturnValue());
                        }else if (childState === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log(errors[0].message);
                                    var errorString = 'Signature sale could not load caused: ' + errors[0].message+ ' Contact your Admin.';
                                    helper.showToast(cmp, 'error', errorString, 'Error');
                                }
                            } else {
                                // throw error
                                console.log("Unknown error");
                            }
                        }
                    });
                    $A.enqueueAction(childAction);
                } 
                //throw error
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        var errorString = 'Signature sale could not load caused: ' + errors[0].message+ ' Contact your Admin.';
                        // show toast msg
                        helper.showToast(cmp, 'error', errorString, 'Error');
                    }
                    //error msg
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //redirect new page not handle
    redirectToUrl: function(cmp, event, helper) { 
        var pageUrl = event.currentTarget.getAttribute('data-category');
        console.log(pageUrl);
        if(pageUrl != '' && pageUrl != null){
            window.open(pageUrl);
            /*var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                				 'url': pageUrl
                               });
            urlEvent.fire();*/
        }
    },
})