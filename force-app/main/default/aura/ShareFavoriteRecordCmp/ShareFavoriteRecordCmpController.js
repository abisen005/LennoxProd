({
	/*
	 * @purpose : This method will call on page load
	 */ 
    doInit : function(cmp, event, helper) {
        var currentPageId = cmp.get("v.recordId");
        console.log('currentPageId:',currentPageId);
        //call server method
        var getAllUsers = helper.callServerMethod(cmp, currentPageId, "c.getUserRecords", helper);
        getAllUsers.then(function(resolve){
            //sort users as per picklist
            helper.sortUsers(cmp, event, resolve.data.strToPicklistWrappers);
            //show already save records
            helper.showAlreadySharedRecords(cmp, event, resolve.data.shareRecordWrapperList);
            //spinner
            helper.toggle(cmp, event);
            var userJsonString = cmp.get("v.userJsonString");
            var userObject = JSON.parse(userJsonString);
            //get picklist values map
            var pickListValuestoCmpName = helper.getPickListValueToCmp();
            //set userobject list to maintain state
            for(var picklistValue in pickListValuestoCmpName){
                cmp.set(pickListValuestoCmpName[picklistValue].cmpName, userObject[pickListValuestoCmpName[picklistValue].value]);
            }
        },
        function(reject){//error occurers show error message
        	helper.showToast(cmp, 'error', reject.message);
            //close quick action
            helper.closeQuickAction(cmp, event);
        });
    },
    
    /*
	 * @purpose : after initial load.  Changing of picklist value it will set the list to dual list box
	 */ 
    getPicklistValue : function(cmp, event, helper){
        var newSelectedValue = cmp.find("mySelect").get("v.value");
        var userJsonString = cmp.get("v.userJsonString");
        var userObject = JSON.parse(userJsonString);
        cmp.set("v.defaultRecords", userObject[newSelectedValue]);
        var pickListValuestoCmpName = helper.getPickListValueToCmp();
        for(var picklistValue in pickListValuestoCmpName){
            if(pickListValuestoCmpName[picklistValue].value == newSelectedValue){
                var getCmpList = cmp.get(pickListValuestoCmpName[picklistValue].cmpName);
                if(getCmpList.length > 0){
                    cmp.set("v.defaultRecords", getCmpList);
                }
            }
        }
    },
    
    /*
	 * @purpose : This method will take the records from 'available' list and save into the 'share with' list
	 */ 
    selectRecord : function(cmp, event, helper){
        
        var selectedValue = cmp.find("mySelect").get("v.value");
        var selectedRecords = cmp.find("myAvailable").get("v.value");
        var idList = helper.getStringofList(selectedRecords);
        var getPreviousUsr = cmp.get("v.selectedRecords");
        var getDefaultRecord = cmp.get("v.defaultRecords");
        var newSelectedRecords = [];
        if(getPreviousUsr.length > 0){
            newSelectedRecords = getPreviousUsr;
        }
        if(getDefaultRecord.length > 0){
            var objectLength = getDefaultRecord.length;
            while(objectLength--){
                if(idList.includes(getDefaultRecord[objectLength].value)){
                    newSelectedRecords.push(getDefaultRecord[objectLength]);
                    getDefaultRecord.splice(objectLength,1);
                }
            }
        }
        cmp.set("v.defaultRecords", getDefaultRecord);
        cmp.set("v.selectedRecords", newSelectedRecords);
        helper.saveDefaultList(cmp, getDefaultRecord, selectedValue, helper);
        //set button disability
        if(cmp.get("v.selectedRecords").length > 0){
            cmp.set("v.isActive", false);
        }else{
            cmp.set("v.isActive", true);
        }
    },
    
    /*
	 * @purpose : This method will take the records from 'share with' list and save into the 'available' list
	 */ 
    deselectRecord : function(cmp, event, helper){
        var getSelectedList = cmp.get("v.selectedRecords");
        var selectedListLength = getSelectedList.length;
        //check share with list length
        if(selectedListLength > 0){
            //get picklist value
            var selectedPicklistValue = cmp.find("mySelect").get("v.value");
            //get share with list
            var selectedRecordStr = cmp.find("myShareWith").get("v.value");
            //get id list of selected records
            var idList = helper.getStringofList(selectedRecordStr);
            //if picklist value is blank then set partner user list
            if(!selectedPicklistValue){
                var getPartnerUserList = cmp.get("v.partnerUserList");
                while(selectedListLength--){
                    if(idList.includes(getSelectedList[selectedListLength].value)){
                        getPartnerUserList.push(getSelectedList[selectedListLength]);
                        getSelectedList.splice(selectedListLength,1);
                    }
                }
                cmp.set("v.defaultRecords", getPartnerUserList);
                cmp.set("v.partnerUserList", getPartnerUserList);
                cmp.set("v.selectedRecords", getSelectedList);
            }else{
                //get the picklist value and set the cmp list
                var pickListValuestoCmpName = helper.getPickListValueToCmp();
                while(selectedListLength--){
                    if(idList.includes(getSelectedList[selectedListLength].value)){
                        helper.pushRecordInDefaultList(cmp, getSelectedList[selectedListLength], helper, pickListValuestoCmpName);
                        getSelectedList.splice(selectedListLength,1);
                    }    
                }

                for(var key in pickListValuestoCmpName){
                    if(pickListValuestoCmpName[key].value == selectedPicklistValue ){
                        var getCurrentValueCmp = cmp.get(pickListValuestoCmpName[key].cmpName);
                        cmp.set("v.defaultRecords", getCurrentValueCmp);
                    }
                }
                cmp.set("v.selectedRecords", getSelectedList);
            }
        }
        //set button disability
        if(cmp.get("v.selectedRecords").length > 0){
            cmp.set("v.isActive", false);
        }else{
            cmp.set("v.isActive", true);
        }
    },
    
    /*
	 * @purpose : This method will call the server method and store the changes on server
	 */ 
    saveChangesOnServer : function(cmp, event, helper){
        helper.toggle(cmp, event);
        var getSelectedList = cmp.get("v.selectedRecords");
        var getAccessLevel = cmp.find("accessLevel").get("v.value");
        var currentPageId = cmp.get("v.recordId");
        var outputObj = {
            sfid : currentPageId,
            accessLevel : getAccessLevel,
            records : getSelectedList 
        }; 
        //create json string of user's selected record
        var jsonString = JSON.stringify(outputObj);
        var action = cmp.get("c.saveShareRecord");
        action.setParams({ resultJsonString : jsonString });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                if(retVal.isSuccess){
                    var getAllUsers = helper.callServerMethod(cmp, currentPageId, "c.getUserRecords");
                    	getAllUsers.then(function(resolve){
                        helper.showAlreadySharedRecords(cmp, event, resolve.data.shareRecordWrapperList);
                    	helper.showToast(cmp, 'success', 'Record Shared Successfully!');
                        helper.toggle(cmp, event);
                        helper.closeQuickAction(cmp, event);
                    },
                    function(reject){
                        helper.toggle(cmp, event);
                        helper.closeQuickAction(cmp, event);
                    	helper.showToast(cmp, 'error', reject.message);
                    });
                }else{
                    helper.toggle(cmp, event);
                    helper.closeQuickAction(cmp, event);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast(cmp, 'error', errors[0].message);
                        helper.closeQuickAction(cmp, event);
                    }
                }
                else {
                    helper.showToast(cmp, 'error', 'Unknown error. Please contact your administrator!!');
                    helper.closeQuickAction(cmp, event);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
	 * @purpose : Delete already share records by user
	 */
    deleteShareRecord : function(cmp, event, helper){
        helper.toggle(cmp, event);
        var getSharedRecordList = cmp.get("v.alreadySharedRecords");
        var shareRecordId =  event.target.id;
        var recordTodelete = [];
        var selectedPicklistvalue = cmp.find("mySelect").get("v.value");
        for(var key in getSharedRecordList){
            if(getSharedRecordList[key].id == shareRecordId){
                recordTodelete.push(getSharedRecordList[key]);
            }
        }
        //create json string to delte record
        var deleteRecJson = JSON.stringify(recordTodelete);
        if(recordTodelete.length > 0){
            var action = cmp.get("c.deleteShareRecordFrmServer");
            action.setParams({ deleteRecordJson : deleteRecJson });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal = response.getReturnValue();
                    if(retVal.isSuccess){
                        //get records after commiting into server
                        var newUsers = helper.helperSortUsers(cmp, retVal.data.strToPicklistWrappers);
                        var pickListValuestoCmpName = helper.getPickListValueToCmp();
                        for(var key in newUsers){
                            for(var picklistValue in pickListValuestoCmpName){
                                
                                if(pickListValuestoCmpName[picklistValue].value == key){
                                    cmp.set(pickListValuestoCmpName[picklistValue].cmpName, newUsers[key]);
                                }
                                
                                if(selectedPicklistvalue == pickListValuestoCmpName[picklistValue].value){
                                    cmp.set("v.defaultRecords", newUsers[key]);
                                }else{
                                    cmp.set("v.defaultRecords", newUsers['Partner Users']);
                                }
                            }
                        }
                        helper.showAlreadySharedRecords(cmp, event, retVal.data.shareRecordWrapperList);
                      //  helper.closeQuickAction(cmp, event);
                        helper.toggle(cmp, event);
                    }else{                        
                        helper.showToast(cmp, 'error', retVal.message);
                        helper.closeQuickAction(cmp, event);
                        helper.toggle(cmp, event);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.toggle(cmp, event);
                            helper.closeQuickAction(cmp, event);
                            helper.showToast(cmp, 'error', errors[0].message);
                        }
                    }
                    else {
                        helper.toggle(cmp, event);
                        helper.closeQuickAction(cmp, event); 
                        helper.showToast(cmp, 'error', 'Unknown Error.  Please contact your System Admin!!');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    /*
	 * @purpose : Search functionality
	 */
    searchResult: function(cmp, event, helper){
        var searchStr = cmp.find("mySearch").get("v.value");
        var searchList; 
        var searchStrList = searchStr.split(' ');
        var showSearchResult = [];
        var newSelectedValue = cmp.find("mySelect").get("v.value");
        var selectedList = cmp.get("v.selectedRecords");
        var newSelectedList = [];
        
        
        if(newSelectedValue){
            var pickListValuestoCmpName = helper.getPickListValueToCmp();
            for(var picklistValue in pickListValuestoCmpName){
                if(pickListValuestoCmpName[picklistValue].value == newSelectedValue){
                    searchList = cmp.get(pickListValuestoCmpName[picklistValue].cmpName);
                }
            }
        }else{
            searchList = cmp.get("v.partnerUserList");
        }
        
        if(selectedList.length > 0){
            searchList = cmp.get("v.defaultRecords");
        } 
        
                var secondString = searchStr.split(' ');
                var searchString = '';
                for(var index in secondString){
                    searchString = searchString + secondString[index].trim().charAt(0).toUpperCase() + secondString[index].trim().slice(1) + ' ';
                }
                
                searchString = searchString.replace(/\s+$/, '');
                searchString = searchString.replace(/  +/g, ' ');
        		searchString = searchString.trim();
            for(var recordStr in searchList){
                var userNameArray = searchList[recordStr].label.split(' ');
                var userName = userNameArray[1] + ' ' + userNameArray[2];
                if(userNameArray[3]){
                    userName += ' ' + userNameArray[3];
                }
                if(userName.includes(searchString)){
                    showSearchResult.push(searchList[recordStr]);
                }
            }
          
        
        if(showSearchResult.length > 0){
            showSearchResult = helper.removeduplicate(showSearchResult, 'value');
            cmp.set("v.defaultRecords", showSearchResult);
        }else{
           alert(searchString+ ' not found.');
        }
     
    },
    /*
     * @purpose : find button visibility
     */ 
    activatefindButton : function(cmp, event, helper){
        var searchBoxValue = cmp.find("mySearch").get("v.value");
        var reWhiteSpace = new RegExp(/^\s+$/);
        if(reWhiteSpace.test(searchBoxValue) || !searchBoxValue){
            cmp.set("v.findButton", true);
        }else{
            cmp.set("v.findButton", false);
        }
    }
})