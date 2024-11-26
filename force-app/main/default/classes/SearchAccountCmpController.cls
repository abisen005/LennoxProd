public Without Sharing class SearchAccountCmpController {
    
    @AuraEnabled
    public static Response getOnloadData(){
        
        try{
            Id profileId=userinfo.getProfileId();
            
            String profileName=[Select Id,Name 
                                from Profile 
                                where Id=:profileId].Name;
            
            system.debug('ProfileName'+profileName);
            
            List<SearchAccountConfiguraton__c> searchAccountConfigList = [SELECT Id, Profile_Name__c 
                                                                          FROM SearchAccountConfiguraton__c
                                                                         ];
            
            if(searchAccountConfigList != null && !searchAccountConfigList.isEmpty()){
                for(SearchAccountConfiguraton__c accountConfig : searchAccountConfigList){
                    
                    if(accountConfig.Profile_Name__c == profileName){
                        return new Response(true, true, '');
                    }
                }
            }
            
            return new Response(true, false, '');
            
        }
        catch(Exception ex){
            return new Response(false, null, ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Response getAccountList(String strWhereCondition, String phoneNumber){
        List<Account> accountList = new List<Account>();
        String strQuery= 'SELECT Id, Name, SAP_Customer_Number__c, Owner.Name, Phone, ShippingCity, ShippingStreet, SAP_District__c,'+ 
            'ShippingState, ShippingPostalCode, SAP_Customer_Group__c, SAP_Customer_Group_Id__c FROM Account WHERE ';
        
        if(String.isNotBlank(strWhereCondition)){
            strQuery += strWhereCondition + ' LIMIT 25';
        }
        
        if(String.isNotBlank(strQuery)){
            try{
                accountList = Database.query(strQuery);
                System.debug('accountList '+ accountList);
                if(accountList != null && !accountList.isEmpty()){
                    
                    return new Response(true, accountList, '');
                }
                else{
                    if(String.isNotBlank(phoneNumber)){
                        
                        accountList = getAccountRelatedToContact(phoneNumber);
                        
                        if(accountList != null && !accountList.isEmpty()){
                            
                            return new Response(true, accountList, '');
                        }
                        else{
                            
                            return new Response(true, accountList, 'Account Record Not Found');
                        }
                    }
                    
                    return new Response(true, accountList, 'Account Record Not Found');
                }
            }
            catch(Exception ex){
                
                System.debug('Error: '+ex.getLineNumber()+' '+ex.getMessage());
                return new Response(false, null, ex.getMessage());
            }
            
        }
        return null;
    } 
    
    private static List<Account> getAccountRelatedToContact(String phoneNumber){
        List<Account> accountList = new List<Account>();
        
        Set<Id> accountIds = getAccountIds(phoneNumber);
        
        if(accountIds != null && !accountIds.isEmpty()){
            
            accountList = getAccountRelatedToId(accountIds);
        }
        
        return accountList;
    }
    
    private static Set<Id> getAccountIds(String phoneNumber){
        System.debug('To search contact');
        Set<Id> accountIds = new Set<Id>();
        
        String query = 'SELECT Id, AccountId FROM Contact WHERE Phone LIKE \'%' + phoneNumber + '%\'';
        
        List<Contact> contactList = Database.query(query);
        
        for(Contact con : contactList){
            accountIds.add(con.AccountId);
        }
        
        return accountIds;
    }
    
    private Static List<Account> getAccountRelatedToId(Set<Id> accountIds){
        List<Account> accountList = new List<Account>();
        
        accountList = [SELECT Id, Name, SAP_Customer_Number__c, Owner.Name, Phone, ShippingPostalCode, ShippingState,
                       ShippingCity, ShippingStreet, SAP_District__c, SAP_Customer_Group__c 
                       FROM Account 
                       WHERE ID IN : accountIds];
        
        return accountList;
    }
    
    
    Public class Response{
        @AuraEnabled
        Public String msg;
        @AuraEnabled
        Public Boolean isSuccess;
        @AuraEnabled
        Public Object data;
        
        public Response(Boolean isSuccess, Object data, String msg){
            this.isSuccess = isSuccess;
            this.data = data;
            this.msg = msg;
        }
    }
}