public with sharing class SC_UserBadgesConroller {

    @AuraEnabled
    public static Object getUserBadges(String userId, Integer queryLimit, Integer offset) {
        return CoachingUtils.getUserBadges(userId, queryLimit, offset);
    }

}