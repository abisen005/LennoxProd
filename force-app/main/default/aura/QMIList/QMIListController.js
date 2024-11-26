({
    init: function (cmp, event, helper) {
        
    var column1Label = cmp.get('v.column1_label');
    var column1FieldName = cmp.get('v.column1_fieldName');
    var column1Type = cmp.get('v.column1_type');
        
    var column2Label = cmp.get('v.column2_label');
    var column2FieldName = cmp.get('v.column2_fieldName');
    var column2Type = cmp.get('v.column2_type');
        
    var column3Label = cmp.get('v.column3_label');
    var column3FieldName = cmp.get('v.column3_fieldName');
    var column3Type = cmp.get('v.column3_type');
        
    var column4Label = cmp.get('v.column4_label');
    var column4FieldName = cmp.get('v.column4_fieldName');
    var column4Type = cmp.get('v.column4_type');
        
        
    cmp.set('v.mycolumns', [
        
            {label: column1Label, fieldName: column1FieldName, type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},   
        
        {label: column2Label, fieldName: column2FieldName, type: column2Type, sortable: true},
               {label: column3Label, fieldName: column3FieldName, type: column3Type, sortable: true},
               {label: column4Label, fieldName: column4FieldName, type: column4Type, sortable: true},
              
            ]);



        }})