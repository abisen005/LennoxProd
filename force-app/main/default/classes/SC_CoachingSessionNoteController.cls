public class SC_CoachingSessionNoteController {

    @AuraEnabled
    public static Object updateSessionNote(SC_Coaching_Session_Note__c sessionNote) {
        System.debug('note from controller: ' + sessionNote);
        return CoachingUtils.updateSessionNote(sessionNote);
    }

}