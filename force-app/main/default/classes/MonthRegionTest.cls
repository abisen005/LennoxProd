@isTest
private class MonthRegionTest {
    @isTest
    static void testGetButtonValues() {
        MonthRegion mr = new MonthRegion();
        List<SelectOption> options = mr.getButtonValues();
        
        // Assert that the number of options generated is correct
        System.assertEquals(12, options.size());
        
        // Assert that the labels match expected month labels
        List<String> expectedLabels = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        for (Integer i = 0; i < options.size(); i++) {
            System.assertEquals(expectedLabels[i], options[i].getLabel());
        }
    }
    
    @isTest
    static void testUpdateIframeSource() {
        // Create a new instance of MonthRegion
        MonthRegion mr = new MonthRegion();
        
        // Set selected regions
        mr.selectedRegions = new List<String>{'North Central Region', 'South Central Region'};
        
        // Set selected values
        mr.selectedValues = new List<String>{'1', '2', '3'};
        
        // Call the method to update iframe source
        mr.updateIframeSource();
        
        // Assert that the iframe sources have been updated correctly
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=8852eea0-8d5b-46b7-8754-38556eb646d5&select=$::MonthName,1,2,3&select=$::Region,NORTH CENTRAL,SOUTH CENTRAL', mr.iframeSource);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=6a7b7e82-8aac-4e2a-a173-6eaa6224c3db&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3&select=$::SALES_DIST_DESC,North Central Region,South Central Region', mr.iframeSourceSales);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=0502d616-cceb-476d-aa19-eed9867ca819&sheet=a44ed37c-ff3e-4e85-b024-72552aaa1000&select=$::MonthName,1,2,3&select=$::Region,NORTH CENTRAL,SOUTH CENTRAL', mr.iframeSourcePrice);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=2b8dea67-a9f5-407c-8bfc-bc4b95ec91ea&sheet=c9ba2b51-5ad3-459f-bae7-9ec608f68b46&opt=noselections&select=$::OwnerRegion,North Central Region,South Central Region', mr.iframeNewBusiness);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=9be33666-daa3-4392-afc7-854cffe31313&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3', mr.iframeCurrentCustomer);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=37e9d9a0-fd5d-4f38-830d-1bd3f19ddcc1&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3', mr.iframeAttrition);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=613affb1-6be5-4f91-a998-ad66ea9c083b&sheet=69ab7ca5-deb5-4a9a-b5bb-2c7eed46c520&opt=noselections&select=$::Period,1,2,3&select=$::RegionDesc,North Central Region,South Central Region', mr.iframeParts);
        System.assertEquals('https://qlikdev.lennoxintl.com/aad/single/?appid=dbd20b11-7135-4e4d-a093-182ad48be7d8&sheet=e6fc5012-41a5-49c5-9124-777a4ec4461d&opt=noselections&select=$::Will_Call_Region,North Central Region,South Central Region',mr.iframeWillCall);
         
     /* System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=b7a2b6db-abc9-412d-bb5f-6e58d0111a2d&opt=noselections&select=$::FISCAL_PERIOD_NAME,1,2,3&select=$::SALES_DIST_DESC,North Central Region,South Central Region', mr.iframeCurrentCustomerOverview);
        System.assertEquals('https://qlik.lennoxintl.com/aad/single/?appid=cdb5437b-4890-4875-a1ba-4fa4abaf8332&sheet=2d4335cb-cf33-4cc9-8e9d-2f1e568a2e39&opt=noselectionsl&select=$::FISCAL_PERIOD_NAME,1,2,3&select=$::SALES_DIST_DESC,North Central Region,South Central Region', mr.iframeAttritionOverview);
    */
    }
}


/*@isTest

public class monthRegionTest {

     @isTest
    static void testGetButtonValues() {
        MonthRegion monthRegion = new MonthRegion();
        List<SelectOption> options = monthRegion.getButtonValues();
        System.assertEquals(12, options.size(), 'Expected 12 options for each month');
        String[] expectedMonths = new String[]{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        for (Integer i = 0; i < 12; i++) {
            System.assertEquals(String.valueOf(i + 1), options[i].getValue(), 'Unexpected value for month');
            System.assertEquals(expectedMonths[i], options[i].getLabel(), 'Unexpected label for month');
        }
    }
    
    
    @isTest
    static void testregions() {
            MonthRegion monthRegion = new MonthRegion();
            List<SelectOption> regions = monthRegion.regions;

            System.assertNotEquals(0, regions.size(), 'Regions list should not be empty');
    

            Set<String> expectedRegions = new Set<String>{'North Central Region', 'South Central Region', 'Northeast Region', 'Southeast Region', 'West Region'};
            Set<String> actualRegions = new Set<String>();
            for (SelectOption option : regions) {
                actualRegions.add(option.getLabel());
            }
            System.assertEquals(expectedRegions, actualRegions, 'Regions list should contain expected options');
        
        
        
            
            

    }
    
    @isTest
    static void testSelectRegions() {
    }
    
    
    
    @isTest
    static void testUpdateIframeSource() {
        MonthRegion monthRegion = new MonthRegion();
        monthRegion.selectedValues = new List<String>{'1', '2', '3'};
        monthRegion.selectedRegions = new List<String>{'North Central Region', 'South Central Region'};
        
        Test.startTest();
        PageReference pageRef = monthRegion.updateIframeSource();
        Test.stopTest();
        
        String expectedIframeSource = 'https://qlikdev.lennoxintl.com/aad/single/?appid=9bdb3e5c-708c-4217-8779-7dd32ea5772b&sheet=04a24725-f829-4ef6-bf36-46715575622d&opt=noselections&select=$::MonthName,1,2,3&select=$::Region,NORTH CENTRAL,SOUTH CENTRAL';
        System.assertEquals(expectedIframeSource, monthRegion.iframeSource, 'Unexpected iframe source');
    }
}
*/