({
    /*
     *@purpose : This method will call to server 
     */
    callServerMethod : function(cmp, parameter, path, helper) {
        return new Promise(function(resolve, reject) {
            var action = cmp.get(path);
            action.setParams({ favRecordId : parameter });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal = response.getReturnValue();
                    if(retVal.isSuccess){
                        resolve(retVal);
                    }else{                        
                        reject(retVal);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },
 
    /*
     *@purpose : Show toast message
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
     *@purpose : Sort users
     */
    sortUsers : function(cmp, event, usersRecords){
        var newUsers = this.helperSortUsers(cmp, usersRecords);
        cmp.set("v.picklistValue", Object.getOwnPropertyNames(newUsers));
        cmp.set("v.defaultRecords", newUsers['Partner Users']);
        cmp.set("v.userJsonString", JSON.stringify(newUsers));
    },
    
    /*
     *@purpose : get the list of id
     */
    getStringofList : function(arrayString){
        var idList = [];
        idList = arrayString.split(';');
        return idList;
    },
    
    /*
     *@purpose : save default list by picklist value
     */
    saveDefaultList : function(cmp, defaultRecord, selectedValue, helper){
        var pickListValuestoCmpName = helper.getPickListValueToCmp();
        if(!selectedValue){
            cmp.set("v.partnerUserList", defaultRecord);
        }
        for(var picklistValue in pickListValuestoCmpName){
            if(pickListValuestoCmpName[picklistValue].value == selectedValue){
                console.log(pickListValuestoCmpName[picklistValue].cmpName, cmp.get(pickListValuestoCmpName[picklistValue].cmpName));
            }
        }
       
    },
    
    /*
     *@purpose : map of picklist value.  Created custom array which includes map
     */
    getPickListValueToCmp : function(){
        var pickListValuestoCmpName = [
            {value : 'Partner Users', preRecString : 'Partner User', cmpName : 'v.partnerUserList'},
            {value : 'Portal Roles', preRecString : 'Portal Role',cmpName : 'v.portalRolesList'},
            {value : 'Portal Roles and Subordinates', preRecString : 'Portal Role and Subordinate', cmpName : 'v.portalRolesSubordList'},
            {value : 'Public Groups', preRecString : 'Public Group', cmpName : 'v.publicGroupList'},
            {value : 'Roles', preRecString : 'Role', cmpName : 'v.rolesList'},
            {value : 'Roles and Internal Subordinates', preRecString : 'Role and Internal Subordinate', cmpName : 'v.rolesInterSubOdList'},
            {value : 'Roles, Internal and Portal Subordinates', preRecString : 'Role, Internal and Portal Subordinate', cmpName : 'v.rolesInterSubOdPortalList'},
            {value : 'Users', preRecString : 'User', cmpName : 'v.usersList'}
        ];
        return pickListValuestoCmpName;
    },
    
    /*
     *@purpose : push record in default list
     */
    pushRecordInDefaultList : function(cmp, recordPush, helper, pickListValuestoCmpName){
        var StringList = recordPush.label.split(':');
        for(var key in pickListValuestoCmpName){
            if(StringList[0] == pickListValuestoCmpName[key].preRecString){
                var currentList = cmp.get(pickListValuestoCmpName[key].cmpName);
                currentList.push(recordPush);
                cmp.set(pickListValuestoCmpName[key].cmpName, currentList);
            }
        }       
    },
    
    /*
     *@purpose : Show already shared records in datatable
     */
    showAlreadySharedRecords : function(cmp, event, records){
        var recordsLength = records.length;
        var ownerRecord;
        while(recordsLength--){
            if(records[recordsLength].reason == 'Owner'){
                records[recordsLength].accessLevel = 'Full'; 
                ownerRecord = records.splice(recordsLength,1);
            }else if(records[recordsLength].reason == 'Manual'){
                records[recordsLength].reason = 'Manual Sharing';
            }
        }
        cmp.set("v.ownerRecord",ownerRecord[0]);
        cmp.set("v.alreadySharedRecords", records);
    },
    
    /*
     *@purpose : toggle the spinner
     */
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    
    /*
     *@purpose : close quick action
     */
    closeQuickAction : function(cmp, event){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    /*
     *@purpose : sort users
     */
    helperSortUsers : function(cmp, usersRecords){
        var newUsers = new Object();
        var listSearch = [];
        newUsers = {
            'Partner Users': [],
            'Portal Roles' : [],
            'Portal Roles and Subordinates' : [],
            'Public Groups' : [],
            'Roles' : [],
            'Roles, Internal and Portal Subordinates' :[],
            'Users' : []
        };
        if(usersRecords != null){
            for(var key in usersRecords){
                if(key == 'User'){
                    for(var count = 0; count < usersRecords[key].length; count++){
                        if(usersRecords[key][count].isPortalEnabledUsr){
                            usersRecords[key][count].name = 'Partner User: ' + usersRecords[key][count].name;
                            newUsers['Partner Users'].push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                            listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                        }else if(!usersRecords[key][count].isPortalEnabledUsr){
                            usersRecords[key][count].name = 'User: ' + usersRecords[key][count].name;
                            newUsers['Users'].push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                            listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                        }
                    }
                }else if(key == 'UserRole'){
                    for(var count = 0; count < usersRecords[key].length; count++){
                        if(usersRecords[key][count].portalTypeUsrRole == 'Partner'){
                            usersRecords[key][count].name = 'Portal Role: ' + usersRecords[key][count].name;
                            newUsers['Portal Roles'].push({value : usersRecords[key][count].id , label : usersRecords[key][count].name, isRole : true });
                            listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name, isRole : true });
                        }else if(usersRecords[key][count].portalTypeUsrRole == 'None'){
                            usersRecords[key][count].name = 'Role: ' + usersRecords[key][count].name;
                            newUsers['Roles'].push({value : usersRecords[key][count].id , label : usersRecords[key][count].name, isRole : true });
                            listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name, isRole : true });
                        }
                    }
                }else if(key == 'RoleAndSubordinates'){
                    for(var count = 0; count < usersRecords[key].length; count++){
                        usersRecords[key][count].name = 'Portal Role and Subordinate: ' + usersRecords[key][count].name;
                        newUsers['Portal Roles and Subordinates'].push({value : usersRecords[key][count].id, label : usersRecords[key][count].name });
                        listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                    }
                }else if(key == 'RoleAndSubordinatesInternal'){
                    for(var count = 0; count < usersRecords[key].length; count++){
                        usersRecords[key][count].name = 'Role, Internal and Portal Subordinate: ' + usersRecords[key][count].name;
                        newUsers['Roles, Internal and Portal Subordinates'].push({value : usersRecords[key][count].id, label : usersRecords[key][count].name });
                        listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                    }
                }else if(key = 'PublicGroups'){
                    for(var count = 0; count < usersRecords[key].length; count++){
                        usersRecords[key][count].name = 'Public Group: ' + usersRecords[key][count].name;
                        newUsers['Public Groups'].push({value : usersRecords[key][count].id, label : usersRecords[key][count].name });
                        listSearch.push({value : usersRecords[key][count].id , label : usersRecords[key][count].name });
                    }
                }       
            }
        }	
        cmp.set("v.searchList", listSearch);
		return newUsers;
    },
    
    /*
     *@purpose : remove duplicates from search fields
     */
    removeduplicate : function(arr, prop){
        let obj = {};
        return Object.keys(arr.reduce((prev, next) => {
            if(!obj[next[prop]]) obj[next[prop]] = next; 
            return obj;
        }, obj)).map((i) => obj[i]);
    }

})