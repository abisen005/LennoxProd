trigger FeedThis on FeedComment(after insert, after update){

  Set<Id> caseIds = new Set<Id>();
  Set<Id> userList = new Set<Id>();
  Set<Id> feedItemList = new Set<Id>();
  Set<String> caseStatusSet = new Set<String>{'Closed - Child'};

  for(FeedComment fc: trigger.new){
      feedItemList.add(fc.FeedItemId);
      userList.add(fc.InsertedById);
  }

  Map<Id, FeedItem> feedMap = new Map<id, FeedItem>([select id,InsertedById,Visibility from feedItem where Id IN :feedItemList]);
  Map<Id, User> userMap = new Map<Id, User>([select id, usertype, name from user where ID IN :userList]);

  for(FeedComment fc: trigger.new){
    if (feedMap != null && feedMap.containsKey(fc.feedItemId) && fc.ParentId.getSObjectType() == Case.SObjectType ) {
      caseIds.add(fc.ParentId);      
    }
    
}

List<Case> casesToUpdate = [SELECT Status,Date_Time_Closed_Collab__c FROM Case WHERE Id IN :caseIds AND Status IN :caseStatusSet];

if(casesToUpdate != null && casesToUpdate.size() > 0) {
  for (Case caseRec : casesToUpdate) {
    caseRec.Status = 'In Progress';
    caseRec.Date_Time_Closed_Collab__c=null;
  }

  update casesToUpdate;
}

}