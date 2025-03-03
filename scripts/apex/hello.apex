// Anonymous Apex to test Contact creation and trigger execution
Contact testContact = new Contact(
    FirstName = 'NonQue',
    LastName = 'Timezone3',
    Zip_Code__c = '29577' // Use a valid zip code
);

insert testContact;

Contact createdContact = [SELECT Id, FirstName, LastName, Zip_Code__c FROM Contact WHERE Id = :testContact.Id ];
System.debug('Create Contact: ' + createdContact);

// Turn off any automations that might interfere with testing if needed
// Savepoint sp = Database.setSavepoint();

// try {
//     // Insert the contact which will trigger the afterInsert handler
//     insert testContact;
    
//     // Query back the contact to see if fields were updated
//     Contact updatedContact = [
//         SELECT Id, FirstName, LastName, Zip_Code__c /* Include other fields that should be populated */
//         FROM Contact 
//         WHERE Id = :testContact.Id
//     ];
    
//     System.debug('Created Contact: ' + updatedContact);
    
//     // Check Apex Jobs to see if our Queueable was executed
//     List<AsyncApexJob> jobs = [
//         SELECT Id, Status, JobType, ApexClassId, ApexClass.Name
//         FROM AsyncApexJob 
//         WHERE ApexClass.Name = 'GetContactTimeZoneQueueable'
//         ORDER BY CreatedDate DESC
//         LIMIT 5
//     ];
    
//     System.debug('Queueable Jobs Found: ' + jobs.size());
//     for(AsyncApexJob job : jobs) {
//         System.debug('Job Details: ' + job);
//     }
// } catch(Exception e) {
//     System.debug('Error: ' + e.getMessage());
//     // Database.rollback(sp); // Rollback if needed
// }
