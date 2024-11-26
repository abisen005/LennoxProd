@isTest
private class QlikFrameControllerTest {

    @isTest
    static void testQlikFrameController() {

        QlikFrameController ctrl = new QlikFrameController();
        ctrl.urlVal = 'http://testurl.com/param={0}&param2={1}';
        ctrl.customerNumberVal = '1234';
        String interpolatedUrl = ctrl.getInterpolatedUrl();

        System.assertEquals(interpolatedUrl, 'http://testurl.com/param=1234&param2=1234');

    }
    
}