@isTest
public class InvocableBusinessHoursAdd_Test {
    @isTest static void testSimpleAddition() {
        //Set up some parameters
        List<InvocableBusinessHoursAdd.BusinessHoursAddParameters> params = new List<InvocableBusinessHoursAdd.BusinessHoursAddParameters>();

        //Operation 1
        InvocableBusinessHoursAdd.BusinessHoursAddParameters p = new InvocableBusinessHoursAdd.BusinessHoursAddParameters();
        p.businessHoursId = null; //This should use the default hours
        p.dTime = DateTime.newInstance(Date.newInstance(2019, 6, 6), Time.newInstance(12,0,0,0)); //Thursday, June 6th 2019, 12:00:00
        p.minutes = 60; //Add 60 minutes
        params.add(p);

        //Operation 2
        p = new InvocableBusinessHoursAdd.BusinessHoursAddParameters();
        p.businessHoursId = null; //This should use the default hours
        p.dTime = DateTime.newInstance(Date.newInstance(2019, 6, 6), Time.newInstance(17,0,0,0)); //Thursday, June 6th 2019, 17:00:00
        p.minutes = 30; //Add 30 minutes
        params.add(p);

        //Execute the code
        List<DateTime> result = InvocableBusinessHoursAdd.addBusinessHours(params);

        //Check results
        System.assertEquals(DateTime.newInstance(Date.newInstance(2019, 6, 6), Time.newInstance(13,0,0,0)), result[0]);
        System.assertEquals(DateTime.newInstance(Date.newInstance(2019, 6, 7), Time.newInstance(9,30,0,0)), result[1]);
    }
}