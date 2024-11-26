public with sharing class QlikFrameController {


    public String urlVal {get;set;}
    public String customerNumberVal {get;set;}

    public QlikFrameController() {}


    public String getInterpolatedUrl() {
        return String.format(urlVal, new List<String>{customerNumberVal, customerNumberVal});
    }

}