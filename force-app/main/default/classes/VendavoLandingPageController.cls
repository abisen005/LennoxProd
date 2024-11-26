public with sharing class VendavoLandingPageController {
    
    public Integer getDealCount() {
        String userId = UserInfo.getUserId();
        return [SELECT COUNT() 
                FROM Vendavo__Deal__c 
                WHERE OwnerId = :userId
                LIMIT 1000];
    }
    
    public Vendavo__Deal__c[] getDeals() {
        String userId = UserInfo.getUserId();
        return [SELECT Id, Vendavo__EndCustomer__c, Name, SAP_Sales_Group__c, 
                    SAP_Sales_Office__c, ProjectNumber__c, CDQ_Type__c, Vendavo__Status__c, 
                    Impact__c, Vendavo__TotalRevenue__c, Builder__c, Workflow_Owner__c, 
                    Vendavo__Description__c, Vendavo__StartDate__c, Vendavo__EndDate__c 
                FROM Vendavo__Deal__c
                WHERE OwnerId = :userId
                LIMIT 1000];
    }
    
    public Account_Opportunty__c[] getAccountOpps() {
        String userId = UserInfo.getUserId();
        return [SELECT Id, AccountId__c, isApproved__c, isRejected__c, Connected_to_Deal__c, 
         	Pending_Approval__c, Dealer_Account_Plan__r.Dealer__r.Id, 
         	Dealer_Account_Plan__r.Dealer__r.Vendavo__AgreementType__c, Name, 
         	Dealer__c, Opportunity_Status__c, Opportunity_Notes__c
         FROM Account_Opportunty__c 
         WHERE (isApproved__c = TRUE OR 
                Pending_Approval__c = TRUE OR 
                Opportunity_Status__c = 'Cancelled' OR 
                isRejected__c = TRUE) AND 
                Opportunity_Type__c = 'CDQ Request' AND 
                CreatedById = :userId];
    }
    
    public static Vendavo__Deal__c getDealToCopy(String agreementId) {
        return [SELECT OwnerId, Vendavo__VID__c, Vendavo__Channel_Label__c, Vendavo__ChannelID__c, Vendavo__Customer__c, Vendavo__CustomerID__c, Vendavo__DealType__c, Vendavo__Division_Label__c, Vendavo__DivisionID__c, Vendavo__EndCustomer__c, Vendavo__LastSynced__c, Vendavo__Opportunity__c, Vendavo__ParentId__c, Vendavo__Primary__c, Vendavo__SalesOrg_Label__c, Vendavo__SalesOrgID__c, Vendavo__VServiceError__c, Vendavo__VServiceMessage__c, Vendavo__VDealParentId__c, Vendavo__VSoldTo__c, Vendavo__workflowOwner__c FROM Vendavo__Deal__c WHERE Id = :agreementId LIMIT 1];
    }
    
    public static Vendavo__Deal__c createSalesforceDeal(Vendavo__Deal__c originalDeal) {
        Vendavo__Deal__c newDeal = new Vendavo__Deal__c();
        newDeal.Vendavo__Channel_Label__c = originalDeal.Vendavo__Channel_Label__c;
        newDeal.Vendavo__ChannelID__c = originalDeal.Vendavo__ChannelID__c;
        newDeal.Vendavo__CustomerID__c = originalDeal.Vendavo__CustomerID__c;
        newDeal.Vendavo__DealType__c = originalDeal.Vendavo__DealType__c;
        newDeal.Vendavo__Division_Label__c = originalDeal.Vendavo__Division_Label__c;
        newDeal.Vendavo__DivisionID__c = originalDeal.Vendavo__DivisionID__c;
        newDeal.Vendavo__EndCustomer__c = originalDeal.Vendavo__EndCustomer__c;
        newDeal.Vendavo__LastSynced__c = originalDeal.Vendavo__LastSynced__c;
        newDeal.Vendavo__Opportunity__c = originalDeal.Vendavo__Opportunity__c;
        newDeal.Vendavo__ParentId__c = originalDeal.Vendavo__ParentId__c;
        newDeal.Vendavo__Primary__c = originalDeal.Vendavo__Primary__c;
        newDeal.Vendavo__SalesOrg_Label__c = originalDeal.Vendavo__SalesOrg_Label__c;
        newDeal.Vendavo__SalesOrgID__c = originalDeal.Vendavo__SalesOrgID__c;
        newDeal.Vendavo__VServiceError__c = originalDeal.Vendavo__VServiceError__c;
        newDeal.Vendavo__VServiceMessage__c = originalDeal.Vendavo__VServiceMessage__c;
        newDeal.Vendavo__VDealParentId__c = originalDeal.Vendavo__VDealParentId__c;
        newDeal.Vendavo__VSoldTo__c = originalDeal.Vendavo__VSoldTo__c;
        newDeal.OwnerId = originalDeal.OwnerId;
        try {
            insert newDeal;
            return newDeal;
        } catch(DMLException e) {
            system.debug(e.getMessage());
            return null;
        }
    }
    
    @future(callout=true)
    public static void copyAndUpdateVendavoDeal(String VID, String newDealId, String ownerId) {
        String token = VendavoUtils.getAuthToken();
        Vendavo_API_Credentials__c vendavoSettings = Vendavo_API_Credentials__c.getOrgDefaults();
        String agreement = VendavoUtils.getAgreement(VID, token);
        system.debug(agreement);
        String vAgreementId = VendavoUtils.getJSONId(agreement);
        system.debug('agreementId: ' + vAgreementId);
        User agreementOwner = [SELECT Vendavo__VendavoID__c, VendavoUID__c FROM User WHERE Id = :ownerId LIMIT 1];
        system.debug(agreementOwner.Vendavo__VendavoID__c + ' ' + agreementOwner.VendavoUID__c);
        String userToken = VendavoUtils.getAuthToken(agreementOwner.Vendavo__VendavoID__c, agreementOwner.VendavoUID__c);
        String newAgreement = VendavoUtils.copyAgreement(vAgreementId, userToken);
        system.debug('newAgreement' + newAgreement);
        
        Integer VVersionNumber;
        JSONparser newAgreementParser = JSON.createParser(newAgreement);
        while (newAgreementParser.nextToken() != null) {
            if ((newAgreementParser.getCurrentName() == 'VVersionNumber')) {
                newAgreementParser.nextToken();
                system.debug(newAgreementParser.getText());
                system.debug('VVersionNumber ' + newAgreementParser.getIntegerValue());
                VVersionNumber = newAgreementParser.getIntegerValue();
            }
        }
        String newVAgreementId = VendavoUtils.getJSONId(newAgreement);
        
        //contruct the update body
        String updateBody = '{';
               updateBody +=   '"VVersionNumber": ' + VVersionNumber + ' ,';
               updateBody +=   '"VCRM": {"VCRMID": "'+ newDealId +'", "VCRMSystemID": "'+vendavoSettings.VCRMSystemId__c+'"}';
               //updateBody +=   '"VAgreement": { "VCRM": { "VCRMSystemId": "' + newDealId + '"}}';
               updateBody += '}';
        //String updateBody = '{"VVersionNumber": ' + VVersionNumber + ' , "VCRM": {"VCRMID": "'+ newDealId +'"}}';
        system.debug('updateBody ' + updateBody);
        system.debug('callout url: ' + '/rest/agreement/'+newVAgreementId);
        String resultBody = VendavoUtils.vRequest('/rest/agreement/'+newVAgreementId, 'PUT', userToken, updateBody);
        system.debug(resultBody);
    }
    
    
    @RemoteAction
    public static String copyAgreement(String agreementId) {
        
        String newAgreement;
        
        //1. get the deal we are going to copy
        Vendavo__Deal__c originalDeal = getDealToCopy(agreementId);
        system.debug('o deal: ' + originalDeal.Id);
        
        //2.  Create a copy in sf using the orginal deal
        Vendavo__Deal__c newDeal = createSalesforceDeal(originalDeal);
        system.debug('new deal: ' + newDeal.Id);
        
        //3. Using VID from originalDeal, create a copy on the Vendavo side and update it when new id
        copyAndUpdateVendavoDeal(originalDeal.Vendavo__VID__c, newDeal.Id, newDeal.OwnerId);
        system.debug('copyAndUpdateVendavoDeal(' + originalDeal.Vendavo__VID__c + ', ' + newDeal.Id + ', ' + newDeal.OwnerId + ')');
        
        //5. Return the new deal id
        return newDeal.Id;
        
    }
    
}