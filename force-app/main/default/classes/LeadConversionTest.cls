@isTest
public class LeadConversionTest {

    @testSetup
    static void setupTestData() {
        // Create test Lead with non-converted status
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // You don't need to insert a LeadStatus record because you cannot modify its MasterLabel
        // The system will already have a default converted LeadStatus, which will be queried during conversion
    }

    @isTest
    static void testLeadConversionInvocable() {
        // Get the Lead Id to be used for the test
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];

        // Prepare the lead ID for the Invocable method
        List<Id> leadIds = new List<Id>{testLead.Id};

        Test.startTest();
        LeadConversionInvocable.convertLead(leadIds);
        Test.stopTest();

        // Assert that the lead is converted
        Lead convertedLead = [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'The lead should be converted.');
    }

    @isTest
    static void testLeadConversionHandler() {
        // Get the Lead Id to be used for the test
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];

        Test.startTest();
        LeadConversionHandler.enqueueLeadConversion(testLead.Id);
        Test.stopTest();

        // Assert that the lead is converted
        Lead convertedLead = [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'The lead should be converted.');
    }

    @isTest
    static void testLeadConvertQueueable() {
        // Get the Lead Id to be used for the test
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];

        // Create an instance of the Queueable class
        LeadConvertQueueable leadConvertJob = new LeadConvertQueueable(testLead.Id);

        Test.startTest();
        System.enqueueJob(leadConvertJob);
        Test.stopTest();

        // Assert that the lead is converted
        Lead convertedLead = [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'The lead should be converted.');
    }

  /*  @isTest
    static void testAlreadyConvertedLead() {
        // Get the Lead Id to be used for the test
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];

        // Manually set the lead as converted
        testLead.IsConverted = true;
        update testLead;

        Test.startTest();
        LeadConversionInvocable.convertLead(new List<Id>{testLead.Id});
        Test.stopTest();

        // Assert that the lead remains converted and no errors occur
        Lead convertedLead = [SELECT IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(convertedLead.IsConverted, 'The lead should remain converted.');
    }

    @isTest
    static void testLeadConversionExceptionHandling() {
        // Create a fake lead Id (will cause an exception)
        Id fakeLeadId = '00QFakeLeadId';

        Test.startTest();
        LeadConversionInvocable.convertLead(new List<Id>{fakeLeadId});
        Test.stopTest();

        // Assert no uncaught exceptions during the test run
        System.assert(true, 'Test passed without uncaught exceptions.');
    }*/
}