public with sharing class MonthRegion{
    public List<String> selectedValues { get; set; }
    public String iframeSource { get; set; }
    public String iframeSourceSales { get; set; }
    public String iframeSourcePrice { get; set; }
    public String iframeNewBusiness{ get; set; }
    public String iframeCurrentCustomerOverview{ get; set; }    
    public String iframeCurrentCustomer{ get; set; }
    public String iframeAttrition{ get; set; } 
    public String iframeAttritionOverview{ get; set; }     
    public String iframeParts{ get; set; }    
    public String iframeWillCall{ get; set; }    
    
    public List<String> selectedRegions { get; set; }
    
        
    public MonthRegion() {
        selectedValues = new List<String>();
        selectedRegions = new List<String>();
        iframeSource = 'https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=8852eea0-8d5b-46b7-8754-38556eb646d5&select=$::MonthName,1,2,3,4,5,6,7,8,9'; // Set initial iframe source here
        iframeSourceSales= 'https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=6a7b7e82-8aac-4e2a-a173-6eaa6224c3db&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeSourcePrice= 'https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=a44ed37c-ff3e-4e85-b024-72552aaa1000&select=$::MonthName,1,2,3,4,5,6,7,8,9,10';
        iframeNewBusiness='https://qlik.lennoxintl.com/aad/single/?appid=2b8dea67-a9f5-407c-8bfc-bc4b95ec91ea&sheet=c9ba2b51-5ad3-459f-bae7-9ec608f68b46&opt=noselections&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeCurrentCustomer='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=9be33666-daa3-4392-afc7-854cffe31313&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeAttrition='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=37e9d9a0-fd5d-4f38-830d-1bd3f19ddcc1&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeParts='https://qlik.lennoxintl.com/aad/single/?appid=613affb1-6be5-4f91-a998-ad66ea9c083b&sheet=69ab7ca5-deb5-4a9a-b5bb-2c7eed46c520&opt=noselections&select=$::Period,1,2,3,4,5,6,7,8,9,10';
        iframeCurrentCustomerOverview='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=b7a2b6db-abc9-412d-bb5f-6e58d0111a2d&opt=noselections&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeAttritionOverview='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=2d4335cb-cf33-4cc9-8e9d-2f1e568a2e39&opt=noselections&select=$::FISCAL_PERIOD_NAME,1,2,3,4,5,6,7,8,9,10';
        iframeWillCall='https://qlikdev.lennoxintl.com/aad/single/?appid=dbd20b11-7135-4e4d-a093-182ad48be7d8&sheet=e6fc5012-41a5-49c5-9124-777a4ec4461d&opt=noselections';
    }
    
    public List<SelectOption> getButtonValues() {
        List<SelectOption> options = new List<SelectOption>();
        String[] monthLabels = new String[]{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        for(Integer i = 1; i <= 12; i++) {
            // options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            options.add(new SelectOption(String.valueOf(i), monthLabels[i - 1]));
        }
        return options;
    }
    
    
    // Regions
    public List<SelectOption> regions {
        get {
            List<SelectOption> regns = new List<SelectOption>();
            regns.add(new SelectOption('North Central Region', 'North Central Region'));
            regns.add(new SelectOption('South Central Region', 'South Central Region'));
            regns.add(new SelectOption('Northeast Region', 'Northeast Region'));
            regns.add(new SelectOption('Southeast Region', 'Southeast Region'));
            regns.add(new SelectOption('West Region', 'West Region'));
            return regns;
        }
    }
    
     public void selectRegions() {
        // Add any processing logic here if needed
    }
    
    public PageReference updateIframeSource() {
        // Construct iframe source URL based on selected Month values
        String selectedValueString = '';
        for(String selectedValue : selectedValues) {
            selectedValueString += selectedValue + ',';
        }
        // Remove trailing comma
        if(selectedValueString.endsWith(',')) {
            selectedValueString = selectedValueString.removeEnd(',');
        }
        
        String selectedRegionString = '';     
        for(String selectedValue : selectedRegions) {
            selectedRegionString += selectedValue + ',';
        }
        
        //remove region and uppercase all letter becasue of the pricing app
        String selectedRegionStringPricing = '';  
        for(String selectedValue : selectedRegions) {
            if(selectedValue.endsWith(' Region')) {
                selectedValue = selectedValue.removeEnd(' Region').toUpperCase();
            }
        
            selectedRegionStringPricing += selectedValue + ',';
        }                
                
        // Remove trailing comma
        if(selectedRegionString.endsWith(',')) {
            selectedRegionString = selectedRegionString.removeEnd(',');
        }
        
        if(selectedRegionStringPricing.endsWith(',')) {
            selectedRegionStringPricing = selectedRegionStringPricing.removeEnd(',');
        }
        
        // Update iframe source URL with selected values
        iframeSource = 'https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=8852eea0-8d5b-46b7-8754-38556eb646d5&select=$::MonthName,' + selectedValueString+'&select=$::Region,'+selectedRegionStringPricing ;
        iframeSourceSales='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=6a7b7e82-8aac-4e2a-a173-6eaa6224c3db&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,'+ selectedValueString+'&select=$::SALES_DIST_DESC,'+selectedRegionString;
        iframeSourcePrice='https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=a44ed37c-ff3e-4e85-b024-72552aaa1000&select=$::MonthName,'+ selectedValueString+'&select=$::Region,'+selectedRegionStringPricing ;
        iframeNewBusiness='https://qlik.lennoxintl.com/aad/single/?appid=2b8dea67-a9f5-407c-8bfc-bc4b95ec91ea&sheet=c9ba2b51-5ad3-459f-bae7-9ec608f68b46&opt=noselections'+'&select=$::OwnerRegion,'+selectedRegionString;
        iframeCurrentCustomer='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=9be33666-daa3-4392-afc7-854cffe31313&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,'+ selectedValueString;
        iframeAttrition='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=37e9d9a0-fd5d-4f38-830d-1bd3f19ddcc1&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,'+ selectedValueString;
        iframeParts='https://qlik.lennoxintl.com/aad/single/?appid=613affb1-6be5-4f91-a998-ad66ea9c083b&sheet=69ab7ca5-deb5-4a9a-b5bb-2c7eed46c520&opt=noselections&select=$::Period,'+ selectedValueString+'&select=$::RegionDesc,'+selectedRegionString;
        iframeCurrentCustomerOverview='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=b7a2b6db-abc9-412d-bb5f-6e58d0111a2d&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,'+ selectedValueString+'&select=$::SALES_DIST_DESC,'+selectedRegionString;
        iframeAttritionOverview='https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=2d4335cb-cf33-4cc9-8e9d-2f1e568a2e39&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,'+ selectedValueString+'&select=$::SALES_DIST_DESC,'+selectedRegionString;
        iframeWillCall='https://qlikdev.lennoxintl.com/aad/single/?appid=dbd20b11-7135-4e4d-a093-182ad48be7d8&sheet=e6fc5012-41a5-49c5-9124-777a4ec4461d&opt=noselections&select=$::Will_Call_Region,'+selectedRegionString;
    
        return null; // Stay on the same page
    }
}