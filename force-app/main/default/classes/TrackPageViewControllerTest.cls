@isTest
private class TrackPageViewControllerTest {
    public static testMethod void TrackPageViewTest() {
        String pageName = 'Test Page';
        TrackPageViewController.WURFLWrapper WURFL = new TrackPageViewController.WURFLWrapper();
        WURFL.complete_device_name = 'test';
        WURFL.form_factor = 'test';
        WURFL.is_mobile = false;
        TrackPageViewController.TrackPageView(pageName, WURFL);
    }
}