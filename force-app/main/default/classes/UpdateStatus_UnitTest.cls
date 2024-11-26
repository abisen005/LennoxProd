@isTest

private class UpdateStatus_UnitTest {

    static testMethod void testTrigger() {

        Test.StartTest();

        Case c = new Case(Subject='Test Case', Status = 'New');

        insert c;

        FeedItem f = new FeedItem();

        f.ParentId = c.id;

        f.body = 'test';

        insert f;

        FeedComment fc = new FeedComment();

        fc.CommentBody = 'legal test';

        // fc.RelatedRecordId =c.Id;

        fc.FeedItemId = f.Id;   // please add this

        //  fc.ParentId =c.id;

        insert fc;

       FeedComment fcQ = [Select Id ,CommentBody , FeedItemId ,ParentId from FeedComment ];

        System.assertEquals(fcQ.ParentId ,c.Id);

        Test.StopTest();

    }

}