({
    MAX_FILE_SIZE: 1500000,
	//generic action that calls an apex @AuraEnabled Function
    //accepts the function name in apexAction parameter and its parameters in params
    callApexAction: function (component, apexAction, params) {
        //set promise as server call is async call.
        var p = new Promise($A.getCallback(function (resolve, reject) {
            console.log( 'params-' , params);
            //set action
            var action = component.get("c." + apexAction + "");
            action.setParams(params);
            action.setCallback(this, function (callbackResult) {
                if (callbackResult.getState() === 'SUCCESS') {
                    resolve(callbackResult.getReturnValue());
                }
                if (callbackResult.getState() === 'ERROR') {
                    console.log('ERROR', callbackResult.getError());
                    reject(callbackResult.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    },
    
    createAttachments : function(component, helper, mailMessage, index, file){
        //var fileInput = component.find("fileId").get("v.files");
        var self = helper;
        if(file){
            if (file.size > self.MAX_FILE_SIZE) {
                component.set("v.showLoadingSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                return;
            }
            
            return getBase64(file);
        }
        
        function getBase64(file) {
            var reader = new FileReader();
            
            return new Promise((resolve, reject) => {
                const reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = () => resolve(reader.result);
                reader.onerror = error => reject(error);
            });
        } 
    },
    
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },
    
    hideSpinner: function (component) {
        setTimeout(function(){ component.set("v.isSpinner", false); }, 100);
    },
    uploadProcess: function(component, file, fileContents, lennoxFormRecordId, index) {
        //alert(lennoxFormRecordId);
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '' ,lennoxFormRecordId,index);
    }, 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, lennoxFormRecordId,index) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var filedetails = component.get('v.fileDetails');
        var filed = filedetails[index]
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: lennoxFormRecordId,
           // fileName: file.name,
            fileName: filed.name,
            base64Data: encodeURIComponent(fileContents),
            contentType: filed.type,
           // contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, lennoxFormRecord);
                } else {
                    //alert('your File is uploaded successfully');
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    showErrorToast : function(message) {
        console.log('Error -- ');
        this.showToast("error", message);
    }, 
    
    showToast : function(toastType, message) {
         console.log('Error -- ');
        var toastEvent = $A.get("e.force:showToast");
        var toastTitle = toastType == "success" ? "Success!" : "Error!";
        toastEvent.setParams({
            "type" : toastType,
            "title": toastTitle,            
            "message": message,
            "duration": 8000
        });
        toastEvent.fire();
    },
})