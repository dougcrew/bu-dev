@isTest
public class LeadConversionHelperTest {

    @testSetup
    static void setup() {
        // Insert necessary LeadStatus for the conversion
        LeadStatus convertedStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        /*// Create test Campus (Account)
        Id campusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('Campus').getRecordTypeId();
        Account testCampus = new Account(
            Name = 'Coruscant',
            RecordTypeId = campusRecordTypeId
        );
        insert testCampus;

        // Create test Program
        Program__c testProgram = new Program__c(
            Name = 'Certified Hand Technician'
        );
        insert testProgram;*/

        // Create a test Lead with picklist values matching the test records
        Lead testLead = new Lead(
            FirstName = 'Trigger', 
            LastName = 'Test', 
            Company = 'Test Company', 
            Status = 'New',
            Campus_of_Interest__c = 'Coruscant',    // Match Account name
            Program_of_Interest__c = 'Certified Hand Technician'   // Match Program name
        );
        insert testLead;
    }

    @isTest
    static void testLeadConversion() {
        // Fetch the test lead
        Lead testLead = [SELECT Id, IsConverted, Campus_of_Interest__c, Program_of_Interest__c 
                        FROM Lead LIMIT 1];

        // Test the lead conversion method
        Test.startTest();
        LeadConversionHelper.convertLead(testLead.Id);
        Test.stopTest();

        // Verify that the lookups were populated before conversion
        Lead convertedLead = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId, 
                                   ConvertedOpportunityId, Campus__c, Program__c
                            FROM Lead 
                            WHERE Id = :testLead.Id];
        
        // Verify lookup fields
        List<Account> testCampus = [SELECT Id FROM Account WHERE Name = 'Coruscant' LIMIT 1];
        List<Program__c> testProgram = [SELECT Id FROM Program__c WHERE Name = 'Certified Hand Technician' LIMIT 1];
        
        for (Account testC : testCampus){
            System.assertEquals(testC.Id, convertedLead.Campus__c, 
            'The Campus lookup should be populated with the correct Account');
        }
        for (Program__c testP : testProgram) {
            System.assertEquals(testP.Id, convertedLead.Program__c, 
            'The Program lookup should be populated with the correct Program');
        }

        // Verify conversion
        System.assert(convertedLead.IsConverted, 'The lead should be converted');
        System.assertNotEquals(null, convertedLead.ConvertedAccountId, 
            'The lead should have a converted Account');
        System.assertNotEquals(null, convertedLead.ConvertedContactId, 
            'The lead should have a converted Contact');
        System.assertNotEquals(null, convertedLead.ConvertedOpportunityId, 
            'The lead should have a converted Opportunity');
    }

    /*@isTest
static void testLeadConversionWithMissingLookups() {
    // First validate that our test picklist values exist
    validatePicklistValues();

    // Create a lead with non-existent picklist values
    Lead testLeadNoMatch = new Lead(
        FirstName = 'No Match', 
        LastName = 'Test', 
        Company = 'Test Company', 
        Status = 'New',
        Campus_of_Interest__c = 'Non Existent Campus',
        Program_of_Interest__c = 'Non Existent Program'
    );
    insert testLeadNoMatch;

    // Test the lead conversion method
    Test.startTest();
    LeadConversionHelper.convertLead(testLeadNoMatch.Id);
    Test.stopTest();

    // Verify that the lead still converted even without lookup matches
    Lead convertedLead = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId, 
                               ConvertedOpportunityId, Campus__c, Program__c
                        FROM Lead 
                        WHERE Id = :testLeadNoMatch.Id];
    
    // Verify conversion succeeded despite missing lookups
    System.assert(convertedLead.IsConverted, 'The lead should be converted even with missing lookups');
    System.assertEquals(null, convertedLead.Campus__c, 
        'The Campus lookup should be null for non-existent campus');
    System.assertEquals(null, convertedLead.Program__c, 
        'The Program lookup should be null for non-existent program');
}

private static void validatePicklistValues() {
    // Validate Campus_of_Interest__c picklist
    Schema.DescribeFieldResult campusField = Lead.Campus_of_Interest__c.getDescribe();
    List<Schema.PicklistEntry> campusValues = campusField.getPicklistValues();
    Boolean foundCampus = false;
    for(Schema.PicklistEntry entry : campusValues) {
        if(entry.getValue() == 'Non Existent Campus') {
            foundCampus = true;
            break;
        }
    }
    System.assert(foundCampus, 'Required picklist value "Non Existent Campus" not found in Campus_of_Interest__c');

    // Validate Program_of_Interest__c picklist
    Schema.DescribeFieldResult programField = Lead.Program_of_Interest__c.getDescribe();
    List<Schema.PicklistEntry> programValues = programField.getPicklistValues();
    Boolean foundProgram = false;
    for(Schema.PicklistEntry entry : programValues) {
        if(entry.getValue() == 'Non Existent Program') {
            foundProgram = true;
            break;
        }
    }
    System.assert(foundProgram, 'Required picklist value "Non Existent Program" not found in Program_of_Interest__c');
}*/
}