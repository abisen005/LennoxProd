global class SetContactSyncToPardotFlagScheduleBatch implements Schedulable {
    global void execute(SchedulableContext ctx) {
        SetContactSyncToPardotFlag S = new SetContactSyncToPardotFlag();
        database.executeBatch(S);
    }
}