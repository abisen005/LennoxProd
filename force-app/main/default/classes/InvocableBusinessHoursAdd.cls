public with sharing class InvocableBusinessHoursAdd {
    @InvocableMethod(label='Add Business Hours' Description='Adds a certain amount of minutes to a date-time according to the business hours defined in Setup.')
    public static List<DateTime> addBusinessHours(List<BusinessHoursAddParameters> params) {
        List<DateTime> result = new List<DateTime>();
        Id defaultBusinessHours = null;

        //Iterate over all requests
        for (BusinessHoursAddParameters p : params) {
            //If no business hours were provided, use the default org hours
            if (p.businessHoursId == null) {
                //Check if we already know what the default hours are - if not, query for them
                if (defaultBusinessHours == null) {
                    //Query for default org business hours
                    List<BusinessHours> hours = [SELECT id FROM BusinessHours WHERE IsDefault = true LIMIT 1];
                    if (hours.size() > 0) {
                        //Default hours found, set them
                        defaultBusinessHours = hours.get(0).id;
                    }
                }

                p.businessHoursId = defaultBusinessHours;
            }

            //We multiply the minutes by 60,000 to get the millisecond value
            result.add(BusinessHours.add(p.businessHoursId, p.dTime, (p.minutes * 60000)));
        }

        return result;
    }

    public class BusinessHoursAddParameters {
        @InvocableVariable(label='Date-Time Value' required=true)
        public DateTime dTime;

        @InvocableVariable(label='Minutes to Add' required=true)
        public Long minutes;

        @InvocableVariable(label='Business Hours ID' required=false)
        public Id businessHoursId;
    }
}