// Anonymous Apex to test Contact creation and trigger execution
Contact testContact = new Contact(
    FirstName = 'Fritime',
    LastName = 'Zone2',
    Zip_Code__c = '29577' // Use a valid zip code
);

insert testContact;

Contact createdContact = [SELECT Id, FirstName, LastName, Zip_Code__c FROM Contact WHERE Id = :testContact.Id ];
System.debug('Create Contact: ' + createdContact);

// The following callout returns values
// String zipCode = '90210'; // Replace with one of your actual zip codes
// ZipCodeResponse response = ZipCodeService.getTimezoneDetail(zipCode);
// System.debug('Response: ' + response);
// if (response != null && response.timezone != null) {
//     System.debug('Timezone Identifier: ' + response.timezone.timezone_identifier);
//     System.debug('Timezone Abbr: ' + response.timezone.timezone_abbr);
//     System.debug('UTC Offset: ' + response.timezone.utc_offset_sec);
//     System.debug('DST: ' + response.timezone.is_dst);
// } else {
//     System.debug('No timezone data found');
// }