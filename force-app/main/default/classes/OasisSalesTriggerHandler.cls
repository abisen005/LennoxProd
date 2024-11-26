/*
  @description       : TriggerHandler for Oasis Sales 
                       (Updates Sales Group Master and OwnerID by fetching the input entered by users and comparing it with Group master Record)
  @author            : 
  @group             : 
  @last modified on  : 30/08/2024
  @last modified by  : Ventas Consulting - Abi
*/

public class OasisSalesTriggerHandler {
    
    public static void handleBeforeInsertBeforeUpdate(List<Oasis_Sales__c> newRecords, Map<Id, Oasis_Sales__c> oldMap) {
        Set<String> salesGroupSet = new Set<String>();
        Map<String, String> salGpOwnerMap = new Map<String, String>();
        Map<String, String> salGpIdMap = new Map<String, String>();

        // Collect Sales Groups from new records
        for (Oasis_Sales__c os : newRecords) {
            if (os.Sales_Group__c != null) {
                salesGroupSet.add(os.Sales_Group__c);
            }
        }

        // Fetch Sales Group Master records
        List<Sales_Group_Master__c> salesGroupMasterList = new List<Sales_Group_Master__c>();
         if (!salesGroupSet.isEmpty()) {
            try {
                salesGroupMasterList = [SELECT Sales_Group__c, OwnerId, Id 
                                        FROM Sales_Group_Master__c 
                                        WHERE Sales_Group__c IN :salesGroupSet];
            } catch (Exception e) {
                // Log the error and stop further processing
                System.debug('Error querying Sales_Group_Master__c: ' + e.getMessage());
                return;
            }
        }

        // Populate maps for Sales Group Owner and ID
        for (Sales_Group_Master__c sgm : salesGroupMasterList) {
            salGpOwnerMap.put(sgm.Sales_Group__c, sgm.OwnerId);
            salGpIdMap.put(sgm.Sales_Group__c, sgm.Id);
        }

        // Get Integrated User ID
        Id integratedId = [SELECT Id FROM User WHERE UserName LIKE 'len.intuser@lennoxintl.com%' LIMIT 1].Id;

        // Update Owner and Sales Group Master fields
        for (Oasis_Sales__c os : newRecords) {
            if ((Trigger.isInsert && salGpOwnerMap.containsKey(os.Sales_Group__c)) || 
                (Trigger.isUpdate && salGpOwnerMap.containsKey(os.Sales_Group__c) && 
                 os.Sales_Group__c != oldMap.get(os.Id).Sales_Group__c)) {
                 os.OwnerId = salGpOwnerMap.get(os.Sales_Group__c);
            } else {
                os.OwnerId = integratedId;
            }

            if (salGpIdMap.containsKey(os.Sales_Group__c)) {
                os.Sales_Group_Master__c = salGpIdMap.get(os.Sales_Group__c);
            }else
                 os.Sales_Group_Master__c =  null;
        }
    }
}