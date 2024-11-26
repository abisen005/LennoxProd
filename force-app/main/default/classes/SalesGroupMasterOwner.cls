global class SalesGroupMasterOwner Implements Schedulable
{
    global void execute(SchedulableContext sc)       
    {
        SalesGroupMasterOwner();
    }
    
    public void SalesGroupMasterOwner()        
    {      
        Set<string> distNoSet = new Set<string>();
        Set<string> userSGSet = new Set<string>();
        Set<string> userSOSet = new Set<string>();
        Set<string> salesGpSet = new Set<string>();
        Set<String> salesGroupIdToUpdate = new Set<String>();
        Map<string, string> userMap = new Map<string, string>();
        Set<string> proTMIdSet = new Set<string>();
        Set<string> proDMIdSet = new Set<string>();
        List<Sales_Group_Master__c> sgmlist =[Select Sales_Group__c, District_Number__c from Sales_Group_Master__c];
        List<Profile> profileList = [select id, Name from Profile where Name like '%Res Sales TM%' OR Name like '%RES Sales DM%'];    
        //Integrated user Id
        Id integratedId = [Select Id from User where UserName like 'len.intuser@lennoxintl.com%' LIMIT 1].Id;
        
        for(Sales_Group_Master__c sgm : sgmlist)
        {
            if(sgm.Sales_Group__c != '' && sgm.Sales_Group__c != null)
            {
                salesGpSet.add(sgm.Sales_Group__c);
                salesGroupIdToUpdate.add(sgm.Id);           
            }
        }
        for(Profile p : profileList)
        {
            if(p.Name.contains('Res Sales TM'))
                proTMIdSet.add(p.Id);
            else
                proDMIdSet.add(p.Id);
        }
        List<User> userList = [SELECT SAP_Sales_Group__c, ProfileId, Id FROM User WHERE SAP_Sales_Group__c IN : salesGpSet AND ProfileId IN : proTMIdSet AND IsActive = True];
        for(User u : userList)
        {
            userSGSet.add(u.SAP_Sales_Group__c);
            userMap.put(u.SAP_Sales_Group__c, u.Id);
        }

        for(Sales_Group_Master__c s : sgmlist)
        {
            if(userSGSet.contains(s.Sales_Group__c) && userMap.containsKey(s.Sales_Group__c))
            {
                s.OwnerId = userMap.get(s.Sales_Group__c);
                salesGroupIdToUpdate.remove(s.Id);
            }
            else if(s.District_Number__c != null && s.District_Number__c != '')
                distNoSet.add(s.District_Number__c);
            else
            {
                //s.OwnerId = userInfo.getUserId();
                s.OwnerId = integratedId;
                salesGroupIdToUpdate.remove(s.Id);
            }
        }

        for(Sales_Group_Master__c s : sgmlist)
        {
            if(userSGSet.contains(s.Sales_Group__c) && userMap.containsKey(s.Sales_Group__c))
            {
                s.OwnerId = userMap.get(s.Sales_Group__c);
                salesGroupIdToUpdate.remove(s.Id);
            }
            else if(s.District_Number__c != null && s.District_Number__c != '')
                distNoSet.add(s.District_Number__c);
            else
            {
                //s.OwnerId = userInfo.getUserId();
                s.OwnerId = integratedId;
                salesGroupIdToUpdate.remove(s.Id);
            }
        }

        if(salesGroupIdToUpdate.size() > 0)
        {
            userList.clear();
            userMap.clear();
        }
        if(proDMIdSet.size() > 0 && distNoSet.size() > 0)
        {
            userList = [SELECT SAP_Sales_Office__c, ProfileId, Id FROM User WHERE SAP_Sales_Office__c IN : distNoSet and ProfileId IN : proDMIdSet AND IsActive = True];
        }
        for(User u : userList)
        {
            userSOSet.add(u.SAP_Sales_Office__c);
            userMap.put(u.SAP_Sales_Office__c, u.Id);
        }
        for(Sales_Group_Master__c s : sgmlist)
        {
            if(userSOSet.contains(s.District_Number__c) && userMap.containsKey(s.District_Number__c) && salesGroupIdToUpdate.contains(s.Id))
                s.OwnerId = userMap.get(s.District_Number__c);
            else if(salesGroupIdToUpdate.contains(s.Id))
            {
                //s.OwnerId = userInfo.getUserId();
                s.OwnerId = integratedId;
                salesGroupIdToUpdate.remove(s.Id);
            }
        }

        for(Sales_Group_Master__c s : sgmlist)
        {
            if(userSOSet.contains(s.District_Number__c) && userMap.containsKey(s.District_Number__c) && salesGroupIdToUpdate.contains(s.Id))
                s.OwnerId = userMap.get(s.District_Number__c);
            else if(salesGroupIdToUpdate.contains(s.Id))
            {
                //s.OwnerId = userInfo.getUserId();
                s.OwnerId = integratedId;
                salesGroupIdToUpdate.remove(s.Id);
            }
        }
        if(sgmlist.size() > 0)
            update sgmlist;
    }
}