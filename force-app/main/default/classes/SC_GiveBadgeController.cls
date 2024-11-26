public class SC_GiveBadgeController {

    @AuraEnabled
    public static Object getBadges() {
        return CoachingUtils.getBadges();
    }



    @AuraEnabled
    public static Object giveBadge(String badgeId, String recipientId, String thanksMsg) {
        return CoachingUtils.giveBadge(badgeId, recipientId, thanksMsg);
    }

}