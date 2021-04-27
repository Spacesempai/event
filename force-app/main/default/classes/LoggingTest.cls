@isTest
public class LoggingTest {
    @isTest static void test1() {
        // Create test event instance
       Logging__e  logEvent = new Logging__e(
        LogLevel__c='ERROR',
        Message__c = 'test',
        Record__c='test');
        Test.startTest();
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(logEvent);        
        Test.stopTest();
        // Perform validation here
        // Verify that the publish was successful
        System.assertEquals(true, sr.isSuccess());
        // Check that the case that the trigger created is present.
        List<Log__c> logs = [SELECT Logging_level__c FROM Log__c];
        // Validate that this case was found.
        // There is only one test case in test context.
        System.assertEquals(1, logs.size());
    }}