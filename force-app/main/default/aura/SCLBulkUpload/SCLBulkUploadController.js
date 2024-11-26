({
    init: function(cmp, evt, hlp) {
        cmp.set('v.columns', [
            {label: 'Store?', fieldName: 'Storea__c', type: 'text', editable: true, wrapText: true}, //Text[8]
            {label: 'New Store?', fieldName: 'Has_store_opened_in_last_12_months__c', type: 'text', editable: true, wrapText: true}, //picklist: Yes, No, N/A
            {label: 'Type of Request', fieldName: 'Typeofrequest__c', type: 'text', editable: true, wrapText: true}, //picklist: Do not stock, Forecaset update (of existing stock), Non-stock to stock, N/A
            {label: 'Reason for Request', fieldName: 'ReasonforRequest__c', type: 'text', editable: true, wrapText: true}, //Long Text Area[256]
            {label: 'Material', fieldName: 'Material__c', type: 'text', editable: true, wrapText: true}, //Text[20]
            {label: 'Product Division', fieldName: 'ProductDivision__c', type: 'text', editable: true, wrapText: true}, //picklist: Finished Goods, Parts & Supplies, N/A [NO RESTRICTION-- RESTRICT IN ORG?]
            {label: 'Material Description', fieldName: 'MaterialDescription__c', type: 'text', editable: true, wrapText: true}  //Text[100]
        ]);
    },

    onFileUploaded: function(cmp, evt, hlp){
        console.log('onFileUploaded');
        hlp.show(cmp,evt);
        var files = cmp.get("v.fileToBeUploaded");
        var recId = cmp.get("v.recordId");
        if (files && files.length > 0) {
             console.log('Check1',files.length);
            var file = files[0][0];
            console.log("### file: ", file);
            console.log("### file.size: ", file.size);
            console.log("### file.type: ", file.type);
            var reader = new FileReader();
            reader.onloadend = function() {
                let dataText = reader.result;
                let dataCopy = "";
                //var dataURL = reader.result;
                //var content = dataURL.match(/,(.*)$/)[1];
                let lines = dataText.split("\r\n");
                for(let line of lines){
                    //console.log("### line: ", line);
                    let cols = line.split(",");
                    if(cols[0]){
                        dataCopy = dataCopy + line + "\r\n";
                    }
                }
                //console.log("dataText: ", dataText);
                //console.log("dataCopy: ", dataCopy);
                let content = btoa(dataCopy);
                //console.log("content: ", content);
                hlp.upload(recId, cmp, file, content,
                    function(result) {
                        console.log('result', result);
                        cmp.set('v.result', result);

                        if (result.Errors && result.Errors.length > 0) {
                            console.log('processing errors');
                            console.log('result.Errors' , result.Errors);
                            var errors = { rows: {} }
                            result.Errors.forEach(
                                error => errors.rows[error.Id] = { title: error.Title, messages: [error.Messages], fieldNames: error.FieldNames }
                            );

                            console.log('Assigning errors...');
                            cmp.set('v.errors', errors);
                            console.log('assigned errors', errors);
                            console.log('completed processing errors');
                        }else{
                            //window.location.reload()
                        }
                        
                        //$A.get('e.force:refreshView').fire();
                        
                        hlp.hide(cmp,evt);
                    }
                );
            }
            //reader.readAsDataURL(file);
            reader.readAsText(file);
        }
        else{
            hlp.hide(cmp,evt);
        }
    },

    saveData:function (cmp, evt, hlp) {
        console.log('saveData BEGIN');
        console.log('draftValues', evt.getParam('draftValues'));
        console.log('result.skus', cmp.get('v.result.skus'));

        var draftVals =  evt.getParam('draftValues');

        var skus = cmp.get('v.result.skus');
        if (draftVals) {
            if (draftVals.length > 0) {
                hlp.show(cmp,evt);
                console.log('columns', columns);
                var columns = cmp.get('v.columns');
                var i;
                for (i = 0; i<draftVals.length; i++) {
                    console.log('processing draft row ' + i);
                    var row = draftVals[i];
                    console.log('row', row);
                    var index = row.Id.replace(/row-/, '');
                    console.log('index', index);

                    var j;
                    for(j = 0; j<columns.length; j++) {
                        var fld = columns[j].fieldName;
                        if (row[fld]) {
                            console.log('Updating field:', fld);
                            skus[index][fld] = row[fld];
                        }
                    }
                }

                console.log('Preparing to upload...')
                hlp.uploadRecs(cmp, cmp.get('v.result.Filename'), skus,
                    function(result) {
                        console.log('result', result);
                        cmp.set('v.result', result);

                        if (result.Errors && result.Errors.length > 0 ) {
                            console.log('processing errors');
                            console.log('result.Errors' , result.Errors);
                            
                            var errors = { rows: {} }
                            result.Errors.forEach(
                                error => errors.rows[error.Id] = { title: error.Title, messages: [error.Messages], fieldNames: error.FieldNames }
                            );

                            console.log('Assigning errors...');
                            cmp.set('v.errors', errors);
                            console.log('assigned errors', errors);
                            console.log('completed processing errors');
                        }else{
                            window.location.reload()
                        }
                         //$A.get('e.force:refreshView').fire();
                        hlp.hide(cmp,evt);
                    }
                );

                //cmp.set('v.result.skus', skus);
                //console.log('Updated result.skus', cmp.get('v.result.skus'));
            }
        }

        console.log('saveData END');
    }
});