public class SC_DashboardReportsController {

    public Map<Integer, List<String>> reportIdsMap {get;set;}
    public List<String> reportIds {get;set;}
    public Integer reportIdsSize {get;set;}
    public String formFactor {get;set;}

    public SC_DashboardReportsController() {

        formFactor = ApexPages.currentPage().getParameters().get('formFactor');
        String reportIdParam = ApexPages.currentPage().getParameters().get('reportId');
        final Integer MAX_PER_GROUP = 3;
        reportIdsMap = new Map<Integer, List<String>>();
        System.debug('reportIdParam: ' + reportIdParam);
        if(!String.isEmpty(reportIdParam)) {
            Integer groupInt = 0;
            reportIds = new List<String>();
            reportIds = reportIdParam.split(',');
            reportIdsSize = reportIds.size();
            // System.debug(reportIds);
            // for(Integer i = 0; i < reportIds.size(); i++) {
            //     if(reportIdsMap.get(groupInt) == NULL) reportIdsMap.put(groupInt, new List<String>());
            //     if(reportIdsMap.get(groupInt).size() < MAX_PER_GROUP) {
            //         System.debug('groupInt ' + reportIdsMap.get(groupInt).size());
            //         System.debug('add report id to list: ' + reportIds[i]);
            //         reportIdsMap.get(groupInt).add(reportIds[i]);
            //         System.debug('after adding: ' + reportIdsMap);
            //     } else {
            //         groupInt++;
            //         reportIdsMap.put(groupInt, new List<String>());
            //         reportIdsMap.get(groupInt).add(reportIds[i]);
            //     }
            // }
        }



    }

}