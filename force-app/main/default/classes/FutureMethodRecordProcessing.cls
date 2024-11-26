global class FutureMethodRecordProcessing
{
    @future
    public static void insertPermSet(Map<Id,Id> userAndPerm){   

        List<PermissionSetAssignment> permSets = New List<PermissionSetAssignment>();
            for(Id uId : userAndPerm.keySet()){
                PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = userAndPerm.get(uId), AssigneeId = uId);
                permSets.add(psa);
            }
            
            insert permSets;
        
    }
}