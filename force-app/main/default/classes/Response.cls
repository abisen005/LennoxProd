public with sharing class Response {
    
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public Object data;
    @AuraEnabled
    public String message;
    
    public Response(){
        this.isSuccess = false;
        this.data = '';
        this.message = '';
    }
    
    public Response(Boolean isSuccess, Object data, String message){
        this.isSuccess = isSuccess;
        this.data = data;
        this.message = message;
    }

}