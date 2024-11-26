public class DTO {    
    // DTO For Reponse Class
    public class Response {
        @AuraEnabled
        public Boolean Success;
        
        @AuraEnabled
        public String Message;
        
        @AuraEnabled
        public Object Data;
        
        @AuraEnabled
        public Object Metadata;
        
        @AuraEnabled
        public String UiTheme;
        
        public Response () {
            // Empty Constructor - Means Empty Response
            this.Success = false;
            this.Message = 'Blank Response';
            this.Data = null; 
            this.UiTheme = UserInfo.getUiThemeDisplayed();
        }
    }
}