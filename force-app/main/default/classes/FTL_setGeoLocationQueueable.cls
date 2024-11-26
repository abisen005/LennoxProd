public class FTL_setGeoLocationQueueable implements Queueable{
private String recordsJson;
    public static Boolean jobEnqueued = false;

    public FTL_setGeoLocationQueueable(String recordsJson) {
        this.recordsJson = recordsJson;
    }

    public void execute(QueueableContext context) {
        // Call the method to perform geolocation updates
          // Check if the job has already been enqueued
        if (!jobEnqueued) {
        FTL_Program_Form_TrgrHandler.setGeoLocation(recordsJson);
        system.debug('recordsJson'+recordsJson);
                        jobEnqueued = true;

        }
    }
}