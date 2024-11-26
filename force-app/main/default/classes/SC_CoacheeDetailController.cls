public class SC_CoacheeDetailController {

    @AuraEnabled
    public static User getUser(String userId) {
        return [SELECT Name, SmallPhotoUrl FROM User WHERE Id = :userId];
    }
}