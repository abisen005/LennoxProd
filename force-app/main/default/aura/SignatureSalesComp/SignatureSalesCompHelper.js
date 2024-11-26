({
    /*
     * @purpose : show toast msg
     * @param   : component - Componet
     *            type      - toast type
     *            title     - toast title
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
     * @purpose : titleMap which will render the title of the map
     * @param   : component - Componet
     *            type      - toast type
     *            title     - toast title
     */ 
    titleMap : function(){
        var titleMap = [
            {profilename : 'Lennox - Res Sales TM' , title :'TM'},
            
            {profilename : 'Lennox - Res Sales DM' , title : 'DM'},
           
            {profilename : 'Lennox - Res Sales ASM' , title :  'DM'},
            {profilename : 'Lennox - Res Sales AM' , title : 'AM'},
        
            {profilename : 'Lennox - Res Sales RBM' , title :  'AM'},
            {profilename : 'Lennox - Res Sales - Corporate User' , title :  'CU'},
            {profilename : 'Lennox Business Administrator Super' , title :  'BAS'},
            {profilename : 'Lennox Business Administrator' , title :  'BA'},
            {profilename : 'Lennox - Res Sales - EXE' , title :  'EXE'},
            {profilename : 'Lennox - Res Sales - BDM' , title :  'BDM'},
        ];
            return titleMap;
            }
})