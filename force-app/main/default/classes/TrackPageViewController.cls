public class TrackPageViewController {
    public TrackPageViewController() {}
    @RemoteAction
    public static Boolean TrackPageView(String pageName, WURFLWrapper WURFL) {
        User_Page_View__c upv = new User_Page_View__c();
        upv.Page_Name__c = pageName;
        upv.Device__C = WURFL.complete_device_name;
        upv.Form_Factor__c = WURFL.form_factor;
        upv.isMobile__c = WURFL.is_mobile;
        try {
            insert upv;
        } catch (DmlException e) {
            return false;
        }
        return true;
    }
    public class WURFLWrapper{
        public String complete_device_name;
        public String form_factor;
        public Boolean is_mobile;
    }
}