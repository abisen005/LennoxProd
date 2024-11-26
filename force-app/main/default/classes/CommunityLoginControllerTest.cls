@isTest
private class CommunityLoginControllerTest {
    @isTest
    static void testGetCommunityURL() {   
        Test.startTest();
        String communityURL = CommunityLoginController.getCommunityURL();
        Test.stopTest();
        // Verify the result
        //System.assertEquals('https://example.com', communityURL);
    }
    @isTest
    static void testAuthenticateUser() {
        // Create test data for Site and SiteDetail
        // Call the method under test
        Test.startTest();
        String result1 = CommunityLoginController.authenticateUser('testuser', 'testpassword');
        String result2 = CommunityLoginController.authenticateUser('testuser@gmail.com.lennox', 'testpassword');
        Test.stopTest();
          // Verify the result
        System.assertNotEquals('error', result1);
    }
}