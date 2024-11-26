public class SC_MyCoachingController {

    @AuraEnabled
    public static User getUser(String userId) {
        return [SELECT Name, FullPhotoUrl, SmallPhotoUrl, Title FROM User WHERE Id = :userId];
    }
}